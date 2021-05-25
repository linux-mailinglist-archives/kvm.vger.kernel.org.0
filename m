Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E7D3907F1
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 19:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhEYRjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 13:39:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231338AbhEYRjb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 13:39:31 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PHWiwO182948;
        Tue, 25 May 2021 13:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ejoggBpdPTPxH0SzIrgFCji7J5mNRkzx9C9gLy2ObhA=;
 b=Jsk01LS78TAv2W7HZjoXsrItm5yn7TCRAwXvzt5LxjsDmTp3zii3Y1w6gEU8qSK2Smtm
 1Zfmps2ad/8TBnW/51uBe6WNk2ZCngbG74Ar6JEjg6Fg8DHRr/4+O3O9BZpQ3TaYPBz2
 Kyz3XNkR/VKTmgXF2NNIaQupqjJIEOqT+QtXsoLScKXdV43qM9c3Zy/g+mKj5jAFkLdF
 OZjSyk4t3alcmEWcAPFi4ibAVltOIg84lH55l6BBjrNcPGTA9s0eRGvWFuHqRBV5kO/F
 LttsqOZWoC2/Ed8eMThPz86p9Y3SyWR4edObleARK0/IQ6p4FOvzOD+QN5zJVAOWo+oH oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38s4tmhrq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 13:38:00 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14PHX0Cl183589;
        Tue, 25 May 2021 13:38:00 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38s4tmhrpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 13:38:00 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14PHbwOl004882;
        Tue, 25 May 2021 17:37:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 38s1ssr2h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 17:37:58 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14PHbt7q27722076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:37:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF962A4055;
        Tue, 25 May 2021 17:37:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91556A404D;
        Tue, 25 May 2021 17:37:55 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.7.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 May 2021 17:37:55 +0000 (GMT)
Date:   Tue, 25 May 2021 18:44:54 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests RFC 1/2] s390x: Add guest snippet support
Message-ID: <20210525184454.2d0693ef@ibm-vm>
In-Reply-To: <20210520094730.55759-2-frankja@linux.ibm.com>
References: <20210520094730.55759-1-frankja@linux.ibm.com>
        <20210520094730.55759-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U2rInXmXfEpsqL5RJbAgbtWWyaOtXJSc
X-Proofpoint-GUID: 0K7aOhS0W7QiATUl5pO21ojuhZZHsUx8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_08:2021-05-25,2021-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 May 2021 09:47:29 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Snippets can be used to easily write and run guest (SIE) tests.
> The snippet is linked into the test binaries and can therefore be
> accessed via a ptr.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  .gitignore                |  2 ++
>  s390x/Makefile            | 28 ++++++++++++++++++---
>  s390x/snippets/c/cstart.S | 13 ++++++++++
>  s390x/snippets/c/flat.lds | 51
> +++++++++++++++++++++++++++++++++++++++ 4 files changed, 91
> insertions(+), 3 deletions(-) create mode 100644
> s390x/snippets/c/cstart.S create mode 100644 s390x/snippets/c/flat.lds
>=20
> diff --git a/.gitignore b/.gitignore
> index 784cb2dd..29d3635b 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -22,3 +22,5 @@ cscope.*
>  /api/dirty-log
>  /api/dirty-log-perf
>  /s390x/*.bin
> +/s390x/snippets/*/*.bin
> +/s390x/snippets/*/*.gbin
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 8de926ab..fe267011 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -75,11 +75,33 @@ OBJDIRS +=3D lib/s390x
>  asmlib =3D $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
> =20
>  FLATLIBS =3D $(libcflat)
> -%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
> +
> +SNIPPET_DIR =3D $(TEST_DIR)/snippets
> +
> +# C snippets that need to be linked
> +snippets-c =3D
> +
> +# ASM snippets that are directly compiled and converted to a *.gbin
> +snippets-a =3D
> +
> +snippets =3D $(snippets-a)$(snippets-c)
                          =E2=86=91=E2=86=91
I'm not a Makefile expert, but, don't you need a space between the two
variable expansions?

> +snippets-o +=3D $(patsubst %.gbin,%.o,$(snippets))
> +
> +$(snippets-a): $(snippets-o) $(FLATLIBS)
> +	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
> +
> +$(snippets-c): $(snippets-o) $(SNIPPET_DIR)/c/cstart.o  $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds \
> +		$(filter %.o, $^) $(FLATLIBS)
> +	$(OBJCOPY) -O binary $@ $@
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
> +
> +%.elf: $(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)

I would keep the %.o as the first in the list

>  	$(CC) $(CFLAGS) -c -o $(@:.elf=3D.aux.o) \
>  		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=3D\"$@\"
>  	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
> -		$(filter %.o, $^) $(FLATLIBS) $(@:.elf=3D.aux.o)
> +		$(filter %.o, $^) $(FLATLIBS) $(snippets)

so all the snippets are always baked in every test?

> $(@:.elf=3D.aux.o) $(RM) $(@:.elf=3D.aux.o)
>  	@chmod a-x $@
> =20
> @@ -93,7 +115,7 @@ FLATLIBS =3D $(libcflat)
>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT)
> --no-verify --image $< -o $@=20
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d
> lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin}
> $(SNIPPET_DIR)/c/*.{o,elf,bin,gbin} $(SNIPPET_DIR)/.*.d
> $(TEST_DIR)/.*.d lib/s390x/.*.d generated-files =3D $(asm-offsets)
>  $(tests:.elf=3D.o) $(asmlib) $(cflatobjs): $(generated-files)
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> new file mode 100644
> index 00000000..02a3338b
> --- /dev/null
> +++ b/s390x/snippets/c/cstart.S
> @@ -0,0 +1,13 @@
> +#include <asm/sigp.h>
> +
> +.section .init
> +	.globl start
> +start:
> +	/* XOR all registers with themselves to clear them fully. */
> +	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
> +	xgr \i,\i
> +	.endr
> +	/* 0x3000 is the stack page for now */
> +	lghi	%r15, 0x4000
> +	brasl	%r14, main
> +	sigp    %r1, %r0, SIGP_STOP
> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
> new file mode 100644
> index 00000000..5e707325
> --- /dev/null
> +++ b/s390x/snippets/c/flat.lds
> @@ -0,0 +1,51 @@
> +SECTIONS
> +{
> +	.lowcore : {
> +		/*
> +		 * Initial short psw for disk boot, with 31 bit
> addressing for
> +		 * non z/Arch environment compatibility and the
> instruction
> +		 * address 0x10000 (cstart64.S .init).
> +		 */
> +		. =3D 0;
> +		 LONG(0x00080000)
> +		 LONG(0x80004000)
> +		 /* Restart new PSW for booting via PSW restart. */
> +		 . =3D 0x1a0;
> +		 QUAD(0x0000000180000000)
> +		 QUAD(0x0000000000004000)
> +	}
> +	. =3D 0x4000;
> +	.text : {
> +		*(.init)
> +		*(.text)
> +		*(.text.*)
> +	}
> +	. =3D ALIGN(64K);
> +	etext =3D .;
> +	.opd : { *(.opd) }
> +	. =3D ALIGN(16);
> +	.dynamic : {
> +		dynamic_start =3D .;
> +		*(.dynamic)
> +	}
> +	.dynsym : {
> +		dynsym_start =3D .;
> +		*(.dynsym)
> +	}
> +	.rela.dyn : { *(.rela*) }
> +	. =3D ALIGN(16);
> +	.data : {
> +		*(.data)
> +		*(.data.rel*)
> +	}
> +	. =3D ALIGN(16);
> +	.rodata : { *(.rodata) *(.rodata.*) }
> +	. =3D ALIGN(16);
> +	__bss_start =3D .;
> +	.bss : { *(.bss) }
> +	__bss_end =3D .;
> +	. =3D ALIGN(64K);
> +	edata =3D .;
> +	. +=3D 64K;
> +	. =3D ALIGN(64K);
> +}

