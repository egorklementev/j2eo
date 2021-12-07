package eotree

import java.util.stream.Collectors

/**
 * EBNF representation:
 * `
 * [ license ] [ metas ] { object eol }
` *
 */
class EOProgram(var license: EOLicense, var metas: EOMetas, var bnds: List<EOBnd>) : EONode() {
    override fun generateEO(indent: Int): String =
        """${license.generateEO(indent)}
${metas.generateEO(indent)}

${bnds.joinToString("\n\n") { bnd: EOBnd -> bnd.generateEO(indent) }}"""
}