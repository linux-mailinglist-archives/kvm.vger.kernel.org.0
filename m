Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EE52DD36B
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 15:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgLQO7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 09:59:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgLQO7W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 09:59:22 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHErpM5160201;
        Thu, 17 Dec 2020 09:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=EZ+sj+wL8v1cjWHtjnMPnL3jdyclrd8hqXl89L477jY=;
 b=jqtzLUBm0KXzNOT5nxkkUZvyharrlA4r1FGXpk81lys0sfx5mFh8uM6udPZ4a/FdjpDR
 BPeHa6+qJxQiYPcQ/n8mYPvqvQHE7Mji/5A6YLkZpcauvorplfVpxorxNclk1/VUjmrN
 AF/o2l4R1GrWv2X61Os2KBn7+Rv54cXEvKIeGPgGqjpEDvjYTk0hAhUHQgnVNbd1SPmw
 +PKeUiAH4Typ8SRlUQ6X99APgdjPq6KrYASG8Y0KMrGa6zDprIdy3mNETPrsHCY3XOSU
 WuSyF9hwXqjamR6GpW5at4GmNcEax9RwU5f4Y2XsJXFnYOhv/MGZBtsIBoXHIV6/TvDf VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g9gdg2rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:40 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHEsGVA161771;
        Thu, 17 Dec 2020 09:58:39 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g9gdg2qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:39 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEvNx2030902;
        Thu, 17 Dec 2020 14:58:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8g3qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 14:58:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEwYkQ27591090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:58:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9425BA405F;
        Thu, 17 Dec 2020 14:58:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 325A7A4054;
        Thu, 17 Dec 2020 14:58:34 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:58:34 +0000 (GMT)
Date:   Thu, 17 Dec 2020 13:54:59 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 4/8] s390x: Split assembly and move to
 s390x/asm/
Message-ID: <20201217135459.01a76f86@ibm-vm>
In-Reply-To: <20201211100039.63597-5-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
        <20201211100039.63597-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 05:00:35 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> I've added too much to cstart64.S which is not start related
> already. Now that I want to add even more code it's time to split
> cstart64.S. lib.S has functions that are used in tests. macros.S
> contains macros which are used in cstart64.S and lib.S

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile             |   8 +--
>  s390x/{ => asm}/cstart64.S | 119
> ++----------------------------------- s390x/asm/lib.S            |
> 65 ++++++++++++++++++++ s390x/asm/macros.S         |  77
> ++++++++++++++++++++++++ 4 files changed, 150 insertions(+), 119
> deletions(-) rename s390x/{ => asm}/cstart64.S (50%)
>  create mode 100644 s390x/asm/lib.S
>  create mode 100644 s390x/asm/macros.S
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b079a26..fb62e87 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -66,10 +66,10 @@ cflatobjs += lib/s390x/css_lib.o
>  
>  OBJDIRS += lib/s390x
>  
> -cstart.o = $(TEST_DIR)/cstart64.o
> +asmlib = $(TEST_DIR)/asm/cstart64.o $(TEST_DIR)/asm/lib.o
>  
>  FLATLIBS = $(libcflat)
> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(cstart.o)
> +%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
>  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
>  		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
> @@ -87,7 +87,7 @@ FLATLIBS = $(libcflat)
>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT)
> --no-verify --image $< -o $@ 
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d
> lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d
> lib/s390x/.*.d $(TEST_DIR)/asm/*.{o,elf,bin} $(TEST_DIR)/asm/.*.d 
>  generated-files = $(asm-offsets)
> -$(tests:.elf=.o) $(cstart.o) $(cflatobjs): $(generated-files)
> +$(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
> diff --git a/s390x/cstart64.S b/s390x/asm/cstart64.S
> similarity index 50%
> rename from s390x/cstart64.S
> rename to s390x/asm/cstart64.S
> index cc86fc7..ace0c0d 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/asm/cstart64.S
> @@ -3,14 +3,17 @@
>   * s390x startup code
>   *
>   * Copyright (c) 2017 Red Hat Inc
> + * Copyright (c) 2019 IBM Corp.
>   *
>   * Authors:
>   *  Thomas Huth <thuth@redhat.com>
>   *  David Hildenbrand <david@redhat.com>
> + *  Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <asm/asm-offsets.h>
>  #include <asm/sigp.h>
>  
> +#include "macros.S"
>  .section .init
>  
>  /*
> @@ -87,120 +90,7 @@ clear_bss_remainder:
>  memsetxc:
>  	xc 0(1,%r1),0(%r1)
>  
> -	.macro SAVE_REGS
> -	/* save grs 0-15 */
> -	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
> -	/* save crs 0-15 */
> -	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
> -	/* load a cr0 that has the AFP control bit which enables all
> FPRs */
> -	larl	%r1, initial_cr0
> -	lctlg	%c0, %c0, 0(%r1)
> -	/* save fprs 0-15 + fpc */
> -	la	%r1, GEN_LC_SW_INT_FPRS
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	std	\i, \i * 8(%r1)
> -	.endr
> -	stfpc	GEN_LC_SW_INT_FPC
> -	.endm
> -
> -	.macro RESTORE_REGS
> -	/* restore fprs 0-15 + fpc */
> -	la	%r1, GEN_LC_SW_INT_FPRS
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	ld	\i, \i * 8(%r1)
> -	.endr
> -	lfpc	GEN_LC_SW_INT_FPC
> -	/* restore crs 0-15 */
> -	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
> -	/* restore grs 0-15 */
> -	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
> -	.endm
> -
> -/* Save registers on the stack (r15), so we can have stacked
> interrupts. */
> -	.macro SAVE_REGS_STACK
> -	/* Allocate a stack frame for 15 general registers */
> -	slgfi   %r15, 15 * 8
> -	/* Store registers r0 to r14 on the stack */
> -	stmg    %r0, %r14, 0(%r15)
> -	/* Allocate a stack frame for 16 floating point registers */
> -	/* The size of a FP register is the size of an double word */
> -	slgfi   %r15, 16 * 8
> -	/* Save fp register on stack: offset to SP is multiple of
> reg number */
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	std	\i, \i * 8(%r15)
> -	.endr
> -	/* Save fpc, but keep stack aligned on 64bits */
> -	slgfi   %r15, 8
> -	efpc	%r0
> -	stg	%r0, 0(%r15)
> -	.endm
> -
> -/* Restore the register in reverse order */
> -	.macro RESTORE_REGS_STACK
> -	/* Restore fpc */
> -	lfpc	0(%r15)
> -	algfi	%r15, 8
> -	/* Restore fp register from stack: SP still where it was
> left */
> -	/* and offset to SP is a multiple of reg number */
> -	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> -	ld	\i, \i * 8(%r15)
> -	.endr
> -	/* Now that we're done, rewind the stack pointer by 16
> double word */
> -	algfi   %r15, 16 * 8
> -	/* Load the registers from stack */
> -	lmg     %r0, %r14, 0(%r15)
> -	/* Rewind the stack by 15 double word */
> -	algfi   %r15, 15 * 8
> -	.endm
> -
>  .section .text
> -/*
> - * load_reset calling convention:
> - * %r2 subcode (0 or 1)
> - */
> -.globl diag308_load_reset
> -diag308_load_reset:
> -	SAVE_REGS
> -	/* Backup current PSW mask, as we have to restore it on
> success */
> -	epsw	%r0, %r1
> -	st	%r0, GEN_LC_SW_INT_PSW
> -	st	%r1, GEN_LC_SW_INT_PSW + 4
> -	/* Load reset psw mask (short psw, 64 bit) */
> -	lg	%r0, reset_psw
> -	/* Load the success label address */
> -	larl    %r1, 0f
> -	/* Or it to the mask */
> -	ogr	%r0, %r1
> -	/* Store it at the reset PSW location (real 0x0) */
> -	stg	%r0, 0
> -	/* Do the reset */
> -	diag    %r0,%r2,0x308
> -	/* Failure path */
> -	xgr	%r2, %r2
> -	br	%r14
> -	/* Success path */
> -	/* load a cr0 that has the AFP control bit which enables all
> FPRs */ -0:	larl	%r1, initial_cr0
> -	lctlg	%c0, %c0, 0(%r1)
> -	RESTORE_REGS
> -	lhi	%r2, 1
> -	larl	%r0, 1f
> -	stg	%r0, GEN_LC_SW_INT_PSW + 8
> -	lpswe	GEN_LC_SW_INT_PSW
> -1:	br	%r14
> -
> -.globl smp_cpu_setup_state
> -smp_cpu_setup_state:
> -	xgr	%r1, %r1
> -	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
> -	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
> -	/* We should only go once through cpu setup and not for
> every restart */
> -	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
> -	larl	%r14, 0f
> -	lpswe	GEN_LC_SW_INT_PSW
> -	/* If the function returns, just loop here */
> -0:	j	0
> -
>  pgm_int:
>  	SAVE_REGS
>  	brasl	%r14, handle_pgm_int
> @@ -232,8 +122,6 @@ svc_int:
>  	lpswe	GEN_LC_SVC_OLD_PSW
>  
>  	.align	8
> -reset_psw:
> -	.quad	0x0008000180000000
>  initial_psw:
>  	.quad	0x0000000180000000, clear_bss_start
>  pgm_int_psw:
> @@ -246,6 +134,7 @@ io_int_psw:
>  	.quad	0x0000000180000000, io_int
>  svc_int_psw:
>  	.quad	0x0000000180000000, svc_int
> +.globl initial_cr0
>  initial_cr0:
>  	/* enable AFP-register control, so FP regs (+BFP instr) can
> be used */ .quad	0x0000000000040000
> diff --git a/s390x/asm/lib.S b/s390x/asm/lib.S
> new file mode 100644
> index 0000000..4d78ec6
> --- /dev/null
> +++ b/s390x/asm/lib.S
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * s390x assembly library
> + *
> + * Copyright (c) 2019 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <asm/asm-offsets.h>
> +#include <asm/sigp.h>
> +
> +#include "macros.S"
> +
> +/*
> + * load_reset calling convention:
> + * %r2 subcode (0 or 1)
> + */
> +.globl diag308_load_reset
> +diag308_load_reset:
> +	SAVE_REGS
> +	/* Backup current PSW mask, as we have to restore it on
> success */
> +	epsw	%r0, %r1
> +	st	%r0, GEN_LC_SW_INT_PSW
> +	st	%r1, GEN_LC_SW_INT_PSW + 4
> +	/* Load reset psw mask (short psw, 64 bit) */
> +	lg	%r0, reset_psw
> +	/* Load the success label address */
> +	larl    %r1, 0f
> +	/* Or it to the mask */
> +	ogr	%r0, %r1
> +	/* Store it at the reset PSW location (real 0x0) */
> +	stg	%r0, 0
> +	/* Do the reset */
> +	diag    %r0,%r2,0x308
> +	/* Failure path */
> +	xgr	%r2, %r2
> +	br	%r14
> +	/* Success path */
> +	/* load a cr0 that has the AFP control bit which enables all
> FPRs */ +0:	larl	%r1, initial_cr0
> +	lctlg	%c0, %c0, 0(%r1)
> +	RESTORE_REGS
> +	lhi	%r2, 1
> +	larl	%r0, 1f
> +	stg	%r0, GEN_LC_SW_INT_PSW + 8
> +	lpswe	GEN_LC_SW_INT_PSW
> +1:	br	%r14
> +
> +/* Sets up general registers and cr0 when a new cpu is brought
> online. */ +.globl smp_cpu_setup_state
> +smp_cpu_setup_state:
> +	xgr	%r1, %r1
> +	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
> +	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
> +	/* We should only go once through cpu setup and not for
> every restart */
> +	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
> +	larl	%r14, 0f
> +	lpswe	GEN_LC_SW_INT_PSW
> +	/* If the function returns, just loop here */
> +0:	j	0
> +
> +	.align	8
> +reset_psw:
> +	.quad	0x0008000180000000
> diff --git a/s390x/asm/macros.S b/s390x/asm/macros.S
> new file mode 100644
> index 0000000..37a6a63
> --- /dev/null
> +++ b/s390x/asm/macros.S
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * s390x assembly macros
> + *
> + * Copyright (c) 2017 Red Hat Inc
> + * Copyright (c) 2020 IBM Corp.
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *  David Hildenbrand <david@redhat.com>
> + */
> +#include <asm/asm-offsets.h>
> +	.macro SAVE_REGS
> +	/* save grs 0-15 */
> +	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
> +	/* save crs 0-15 */
> +	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
> +	/* load a cr0 that has the AFP control bit which enables all
> FPRs */
> +	larl	%r1, initial_cr0
> +	lctlg	%c0, %c0, 0(%r1)
> +	/* save fprs 0-15 + fpc */
> +	la	%r1, GEN_LC_SW_INT_FPRS
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	std	\i, \i * 8(%r1)
> +	.endr
> +	stfpc	GEN_LC_SW_INT_FPC
> +	.endm
> +
> +	.macro RESTORE_REGS
> +	/* restore fprs 0-15 + fpc */
> +	la	%r1, GEN_LC_SW_INT_FPRS
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	ld	\i, \i * 8(%r1)
> +	.endr
> +	lfpc	GEN_LC_SW_INT_FPC
> +	/* restore crs 0-15 */
> +	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
> +	/* restore grs 0-15 */
> +	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
> +	.endm
> +
> +/* Save registers on the stack (r15), so we can have stacked
> interrupts. */
> +	.macro SAVE_REGS_STACK
> +	/* Allocate a stack frame for 15 general registers */
> +	slgfi   %r15, 15 * 8
> +	/* Store registers r0 to r14 on the stack */
> +	stmg    %r0, %r14, 0(%r15)
> +	/* Allocate a stack frame for 16 floating point registers */
> +	/* The size of a FP register is the size of an double word */
> +	slgfi   %r15, 16 * 8
> +	/* Save fp register on stack: offset to SP is multiple of
> reg number */
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	std	\i, \i * 8(%r15)
> +	.endr
> +	/* Save fpc, but keep stack aligned on 64bits */
> +	slgfi   %r15, 8
> +	efpc	%r0
> +	stg	%r0, 0(%r15)
> +	.endm
> +
> +/* Restore the register in reverse order */
> +	.macro RESTORE_REGS_STACK
> +	/* Restore fpc */
> +	lfpc	0(%r15)
> +	algfi	%r15, 8
> +	/* Restore fp register from stack: SP still where it was
> left */
> +	/* and offset to SP is a multiple of reg number */
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	ld	\i, \i * 8(%r15)
> +	.endr
> +	/* Now that we're done, rewind the stack pointer by 16
> double word */
> +	algfi   %r15, 16 * 8
> +	/* Load the registers from stack */
> +	lmg     %r0, %r14, 0(%r15)
> +	/* Rewind the stack by 15 double word */
> +	algfi   %r15, 15 * 8
> +	.endm

