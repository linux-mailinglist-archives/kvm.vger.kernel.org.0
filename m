Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A9D55394F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiFUSAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 14:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353090AbiFUSAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 14:00:01 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453BC22BFB
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:59:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d5so13185899plo.12
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OFlAbsvpGwxKC8v9hcxNHeeToeoSLQTFfbixtor1asE=;
        b=k18+wrY6BPrHu7s+c3MAiZve3MKiPu1tFg8myfBwNap03HiXzxDIcQSx4uELC5WLUV
         +EQRKVER6Gxi411v3Jjl9eEr3Ff+O1gzo/1SXgvKeAD7/GFwyQtSpcDdftR9Cz51ojGW
         tY+0h37qKGyMOG8jvX/kPczlVCKSGz/mrkaH3Hlcogj7ToqvjtfGVsc52Wpp9K+ZANKe
         8CJLLlxKBgj1zbybmmmLFj8oiLgL8fc5lV3T1IMHwmeRYCMRjdTftkk8ImIemctvVTEG
         wEqK0tXMDufOxiBqbgGG9sSfHzRiTLj/LE49geRDAm/gZjVWXRC+0EIePMnP0uM4+bnl
         JgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OFlAbsvpGwxKC8v9hcxNHeeToeoSLQTFfbixtor1asE=;
        b=VENTrxRDplTTMuIeHycUD4nKZ70TsZJIeeqC9ULfIkUPZ2678LBy9O4jU4zwdaO8ef
         SHemBX29kZnWSXa11BpfN+2S23p1VpE+2M1d1CdAnBTXy3vQlVrRWKTGejoTo54sxltm
         mf+eODEY8H87k4tqgviYmQ3hdJPQ57mQi/6P9jDgb4YVI6R4dSaDKs20NSTDbItyFFK5
         oI++30x0nqyMQKpPwvwJdVwJ34iIVxgXAEDJNOMSZuCbf//z9vkIhoyUDkf5CNBaGN7P
         SC7Q6IhiaujrWBp/pN13PwN/vLPB8FWlu+o2tWECSdUoqsMTinSSeQLIVxW/u/glavKi
         cuzg==
X-Gm-Message-State: AJIora/9RcwLeUgEnspauUYFZw3xZgjXKqcWdi1rvxA1TWQUIvlKzSFW
        mOf4DCTpgSJgUmPHcJ6eFHwhzA==
X-Google-Smtp-Source: AGRyM1tSSCafU7Vxohem8QAV6z+b9PtjEV98SClT0W+H+3Vdi/nlDW3HxJmV38c5XPeq1hamq42XHA==
X-Received: by 2002:a17:902:d2c1:b0:16a:4028:4748 with SMTP id n1-20020a170902d2c100b0016a40284748mr2138865plc.37.1655834398514;
        Tue, 21 Jun 2022 10:59:58 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id d21-20020a056a0010d500b005251c3e7ac5sm5582086pfu.166.2022.06.21.10.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 10:59:57 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:59:54 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 17/23] arm64: Copy code from GNU-EFI
Message-ID: <YrIHGlx1OmswclFa@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-18-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-18-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:59PM +0100, Nikos Nikoleris wrote:
> This change adds unmodified dependencies that we need from GNU-EFI in
> order to build arm64 EFI apps.
> 
> GNU-EFI sources from  https://git.code.sf.net/p/gnu-efi/code v3.0.14
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/efi/elf_aarch64_efi.lds |  63 +++++++++++++++++
>  arm/efi/crt0-efi-aarch64.S  | 130 ++++++++++++++++++++++++++++++++++++
>  arm/efi/reloc_aarch64.c     |  97 +++++++++++++++++++++++++++
>  3 files changed, 290 insertions(+)
>  create mode 100644 arm/efi/elf_aarch64_efi.lds
>  create mode 100644 arm/efi/crt0-efi-aarch64.S
>  create mode 100644 arm/efi/reloc_aarch64.c
> 
> diff --git a/arm/efi/elf_aarch64_efi.lds b/arm/efi/elf_aarch64_efi.lds
> new file mode 100644
> index 0000000..836d982
> --- /dev/null
> +++ b/arm/efi/elf_aarch64_efi.lds
> @@ -0,0 +1,63 @@
> +OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
> +OUTPUT_ARCH(aarch64)
> +ENTRY(_start)
> +SECTIONS
> +{
> +  .text 0x0 : {
> +    _text = .;
> +    *(.text.head)
> +    *(.text)
> +    *(.text.*)
> +    *(.gnu.linkonce.t.*)
> +    *(.srodata)
> +    *(.rodata*)
> +    . = ALIGN(16);
> +  }
> +  _etext = .;
> +  _text_size = . - _text;
> +  .dynamic  : { *(.dynamic) }
> +  .data : ALIGN(4096)
> +  {
> +   _data = .;
> +   *(.sdata)
> +   *(.data)
> +   *(.data1)
> +   *(.data.*)
> +   *(.got.plt)
> +   *(.got)
> +
> +   /* the EFI loader doesn't seem to like a .bss section, so we stick
> +      it all into .data: */
> +   . = ALIGN(16);
> +   _bss = .;
> +   *(.sbss)
> +   *(.scommon)
> +   *(.dynbss)
> +   *(.bss)
> +   *(COMMON)
> +   . = ALIGN(16);
> +   _bss_end = .;
> +  }
> +
> +  .rela.dyn : { *(.rela.dyn) }
> +  .rela.plt : { *(.rela.plt) }
> +  .rela.got : { *(.rela.got) }
> +  .rela.data : { *(.rela.data) *(.rela.data*) }
> +  . = ALIGN(512);
> +  _edata = .;
> +  _data_size = . - _data;
> +
> +  . = ALIGN(4096);
> +  .dynsym   : { *(.dynsym) }
> +  . = ALIGN(4096);
> +  .dynstr   : { *(.dynstr) }
> +  . = ALIGN(4096);
> +  .note.gnu.build-id : { *(.note.gnu.build-id) }
> +  /DISCARD/ :
> +  {
> +    *(.rel.reloc)
> +    *(.eh_frame)
> +    *(.note.GNU-stack)
> +  }
> +  .comment 0 : { *(.comment) }
> +}
> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> new file mode 100644
> index 0000000..d50e78d
> --- /dev/null
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -0,0 +1,130 @@
> +/*
> + * crt0-efi-aarch64.S - PE/COFF header for AArch64 EFI applications
> + *
> + * Copright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice and this list of conditions, without modification.
> + * 2. The name of the author may not be used to endorse or promote products
> + *    derived from this software without specific prior written permission.
> + *
> + * Alternatively, this software may be distributed under the terms of the
> + * GNU General Public License as published by the Free Software Foundation;
> + * either version 2 of the License, or (at your option) any later version.
> + */
> +
> +	.section	.text.head
> +
> +	/*
> +	 * Magic "MZ" signature for PE/COFF
> +	 */
> +	.globl	ImageBase
> +ImageBase:
> +	.ascii	"MZ"
> +	.skip	58				// 'MZ' + pad + offset == 64
> +	.long	pe_header - ImageBase		// Offset to the PE header.
> +pe_header:
> +	.ascii	"PE"
> +	.short 	0
> +coff_header:
> +	.short	0xaa64				// AArch64
> +	.short	2				// nr_sections
> +	.long	0 				// TimeDateStamp
> +	.long	0				// PointerToSymbolTable
> +	.long	0				// NumberOfSymbols
> +	.short	section_table - optional_header	// SizeOfOptionalHeader
> +	.short	0x206				// Characteristics.
> +						// IMAGE_FILE_DEBUG_STRIPPED |
> +						// IMAGE_FILE_EXECUTABLE_IMAGE |
> +						// IMAGE_FILE_LINE_NUMS_STRIPPED
> +optional_header:
> +	.short	0x20b				// PE32+ format
> +	.byte	0x02				// MajorLinkerVersion
> +	.byte	0x14				// MinorLinkerVersion
> +	.long	_data - _start			// SizeOfCode
> +	.long	_data_size			// SizeOfInitializedData
> +	.long	0				// SizeOfUninitializedData
> +	.long	_start - ImageBase		// AddressOfEntryPoint
> +	.long	_start - ImageBase		// BaseOfCode
> +
> +extra_header_fields:
> +	.quad	0				// ImageBase
> +	.long	0x1000				// SectionAlignment
> +	.long	0x200				// FileAlignment
> +	.short	0				// MajorOperatingSystemVersion
> +	.short	0				// MinorOperatingSystemVersion
> +	.short	0				// MajorImageVersion
> +	.short	0				// MinorImageVersion
> +	.short	0				// MajorSubsystemVersion
> +	.short	0				// MinorSubsystemVersion
> +	.long	0				// Win32VersionValue
> +
> +	.long	_edata - ImageBase		// SizeOfImage
> +
> +	// Everything before the kernel image is considered part of the header
> +	.long	_start - ImageBase		// SizeOfHeaders
> +	.long	0				// CheckSum
> +	.short	EFI_SUBSYSTEM			// Subsystem
> +	.short	0				// DllCharacteristics
> +	.quad	0				// SizeOfStackReserve
> +	.quad	0				// SizeOfStackCommit
> +	.quad	0				// SizeOfHeapReserve
> +	.quad	0				// SizeOfHeapCommit
> +	.long	0				// LoaderFlags
> +	.long	0x6				// NumberOfRvaAndSizes
> +
> +	.quad	0				// ExportTable
> +	.quad	0				// ImportTable
> +	.quad	0				// ResourceTable
> +	.quad	0				// ExceptionTable
> +	.quad	0				// CertificationTable
> +	.quad	0				// BaseRelocationTable
> +
> +	// Section table
> +section_table:
> +	.ascii	".text\0\0\0"
> +	.long	_data - _start		// VirtualSize
> +	.long	_start - ImageBase	// VirtualAddress
> +	.long	_data - _start		// SizeOfRawData
> +	.long	_start - ImageBase	// PointerToRawData
> +
> +	.long	0		// PointerToRelocations (0 for executables)
> +	.long	0		// PointerToLineNumbers (0 for executables)
> +	.short	0		// NumberOfRelocations  (0 for executables)
> +	.short	0		// NumberOfLineNumbers  (0 for executables)
> +	.long	0x60000020	// Characteristics (section flags)
> +
> +	.ascii	".data\0\0\0"
> +	.long	_data_size		// VirtualSize
> +	.long	_data - ImageBase	// VirtualAddress
> +	.long	_data_size		// SizeOfRawData
> +	.long	_data - ImageBase	// PointerToRawData
> +
> +	.long	0		// PointerToRelocations (0 for executables)
> +	.long	0		// PointerToLineNumbers (0 for executables)
> +	.short	0		// NumberOfRelocations  (0 for executables)
> +	.short	0		// NumberOfLineNumbers  (0 for executables)
> +	.long	0xc0000040	// Characteristics (section flags)
> +
> +	.align		12
> +_start:
> +	stp		x29, x30, [sp, #-32]!
> +	mov		x29, sp
> +
> +	stp		x0, x1, [sp, #16]
> +	mov		x2, x0
> +	mov		x3, x1
> +	adr		x0, ImageBase
> +	adrp		x1, _DYNAMIC
> +	add		x1, x1, #:lo12:_DYNAMIC
> +	bl		_relocate
> +	cbnz		x0, 0f
> +
> +	ldp		x0, x1, [sp, #16]
> +	bl		efi_main
> +
> +0:	ldp		x29, x30, [sp], #32
> +	ret
> diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
> new file mode 100644
> index 0000000..0867279
> --- /dev/null
> +++ b/arm/efi/reloc_aarch64.c
> @@ -0,0 +1,97 @@
> +/* reloc_aarch64.c - position independent x86 ELF shared object relocator
> +   Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
> +   Copyright (C) 1999 Hewlett-Packard Co.
> +	Contributed by David Mosberger <davidm@hpl.hp.com>.
> +
> +    All rights reserved.
> +
> +    Redistribution and use in source and binary forms, with or without
> +    modification, are permitted provided that the following conditions
> +    are met:
> +
> +    * Redistributions of source code must retain the above copyright
> +      notice, this list of conditions and the following disclaimer.
> +    * Redistributions in binary form must reproduce the above
> +      copyright notice, this list of conditions and the following
> +      disclaimer in the documentation and/or other materials
> +      provided with the distribution.
> +    * Neither the name of Hewlett-Packard Co. nor the names of its
> +      contributors may be used to endorse or promote products derived
> +      from this software without specific prior written permission.
> +
> +    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
> +    CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
> +    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> +    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> +    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
> +    BE LIABLE FOR ANYDIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
> +    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
> +    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
> +    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> +    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
> +    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
> +    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> +    SUCH DAMAGE.
> +*/
> +
> +#include <efi.h>
> +#include <efilib.h>
> +
> +#include <elf.h>
> +
> +EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
> +		      EFI_HANDLE image EFI_UNUSED,
> +		      EFI_SYSTEM_TABLE *systab EFI_UNUSED)
> +{
> +	long relsz = 0, relent = 0;
> +	Elf64_Rela *rel = 0;
> +	unsigned long *addr;
> +	int i;
> +
> +	for (i = 0; dyn[i].d_tag != DT_NULL; ++i) {
> +		switch (dyn[i].d_tag) {
> +			case DT_RELA:
> +				rel = (Elf64_Rela*)
> +					((unsigned long)dyn[i].d_un.d_ptr
> +					 + ldbase);
> +				break;
> +
> +			case DT_RELASZ:
> +				relsz = dyn[i].d_un.d_val;
> +				break;
> +
> +			case DT_RELAENT:
> +				relent = dyn[i].d_un.d_val;
> +				break;
> +
> +			default:
> +				break;
> +		}
> +	}
> +
> +	if (!rel && relent == 0)
> +		return EFI_SUCCESS;
> +
> +	if (!rel || relent == 0)
> +		return EFI_LOAD_ERROR;
> +
> +	while (relsz > 0) {
> +		/* apply the relocs */
> +		switch (ELF64_R_TYPE (rel->r_info)) {
> +			case R_AARCH64_NONE:
> +				break;
> +
> +			case R_AARCH64_RELATIVE:
> +				addr = (unsigned long *)
> +					(ldbase + rel->r_offset);
> +				*addr = ldbase + rel->r_addend;
> +				break;
> +
> +			default:
> +				break;
> +		}
> +		rel = (Elf64_Rela*) ((char *) rel + relent);
> +		relsz -= relent;
> +	}
> +	return EFI_SUCCESS;
> +}
> -- 
> 2.25.1
> 

Reviewed-by: Ricardo Koller <ricarkol@google.com>
