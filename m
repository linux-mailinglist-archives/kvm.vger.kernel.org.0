Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1905635F93
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbiKWN3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiKWN23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:28:29 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D6112AE5;
        Wed, 23 Nov 2022 05:07:46 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANB619i034162;
        Wed, 23 Nov 2022 13:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+taBR1hvFuCQil/WOtzGtQE2ijdDnZrf4aF1gGoVGHs=;
 b=GBWrK7bleTD1gl2bMYjIc9uwm9Z9nxX9jtYsfenvayztg6ySH8EBWtW6tGkyLFL5sYy7
 5NSWOQCv+qbM+hM5vS3oMHdzKeFbepkIiuTZexPaVJIu1ZZkDPn6ZKTp7FQVokjcNfmm
 /DkPu2OFdQpx07iddVZCAtRdMmgddqydZSGzV+EcSAus4nWiAvxE3YNA8F2ku/kZ9ipl
 RW7XPUZdERzH0JRLS/tXrHSsdeIi9MKd6kv/lQIiLLHdN+K3w1XwL4SKNoyjUOdrasqz
 rM0Z4jvZxz6IjPFSDER8UHRGVWph6B7Dj/x8HY10Z/QNb9rUG0/0dqDY7XKzwyySRABm 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1da3hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:45 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANCmGwS016151;
        Wed, 23 Nov 2022 13:07:45 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1da3gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AND6emI004628;
        Wed, 23 Nov 2022 13:07:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3kxps946st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:43 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AND8LjN48300414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:08:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 124B5A405C;
        Wed, 23 Nov 2022 13:07:40 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5D30A4054;
        Wed, 23 Nov 2022 13:07:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:07:39 +0000 (GMT)
Date:   Wed, 23 Nov 2022 13:45:23 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add a linker script to
 assembly snippets
Message-ID: <20221123134523.5af2b5ab@p-imbrenda>
In-Reply-To: <20221123084656.19864-2-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
        <20221123084656.19864-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VHIUI7TdKQkhLKLvbua2QUQ0hhxUmAei
X-Proofpoint-ORIG-GUID: f8OAfI_T4QmobjKf8GLoY6gS5b7_MGrP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 08:46:52 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> A linker script has a few benefits:
> - Random data doesn't end up in the binary breaking tests
> - We can easily define a lowcore and load the snippet from 0x0 instead
> of 0x4000 which makes asm snippets behave like c snippets
> - We can easily define an invalid PGM new PSW to ensure an exit on a
> guest PGM
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

looks good in general, but I have a few questions

> ---
>  lib/s390x/snippet.h         |  3 +--
>  s390x/Makefile              |  5 +++--
>  s390x/mvpg-sie.c            |  2 +-
>  s390x/pv-diags.c            |  6 +++---
>  s390x/snippets/asm/flat.lds | 43 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 51 insertions(+), 8 deletions(-)
>  create mode 100644 s390x/snippets/asm/flat.lds
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> index b17b2a4c..57045994 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet.h
> @@ -32,8 +32,7 @@
>  
>  #define SNIPPET_PV_TWEAK0	0x42UL
>  #define SNIPPET_PV_TWEAK1	0UL
> -#define SNIPPET_OFF_C		0
> -#define SNIPPET_OFF_ASM		0x4000
> +#define SNIPPET_UNPACK_OFF	0
>  
>  
>  /*
> diff --git a/s390x/Makefile b/s390x/Makefile
> index bf1504f9..bb0f9eb8 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -135,7 +135,8 @@ $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>  
>  $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $(patsubst %.gbin,%.o,$@)

I think you can simply use $< instead of the patsubst expression

> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>  	truncate -s '%4096' $@
>  
>  $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> @@ -144,7 +145,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>  	truncate -s '%4096' $@
>  
>  $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>  
>  $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>  	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 46a2edb6..99f4859b 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -87,7 +87,7 @@ static void setup_guest(void)
>  
>  	snippet_setup_guest(&vm, false);
>  	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
> -		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
> +		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_UNPACK_OFF);
>  
>  	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>  	vm.sblk->eca = ECA_MVPGI;
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 9ced68c7..5165937a 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -28,7 +28,7 @@ static void test_diag_500(void)
>  
>  	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
>  			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	sie(&vm);
>  	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> @@ -83,7 +83,7 @@ static void test_diag_288(void)
>  
>  	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
>  			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	sie(&vm);
>  	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> @@ -124,7 +124,7 @@ static void test_diag_yield(void)
>  
>  	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
>  			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	/* 0x44 */
>  	report_prefix_push("0x44");
> diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds
> new file mode 100644
> index 00000000..366d2d78
> --- /dev/null
> +++ b/s390x/snippets/asm/flat.lds
> @@ -0,0 +1,43 @@
> +SECTIONS
> +{
> +	.lowcore : {
> +		/*
> +		 * Initial short psw for disk boot, with 31 bit addressing for
> +		 * non z/Arch environment compatibility and the instruction
> +		 * address 0x4000.
> +		 */
> +		. = 0;
> +		 LONG(0x00080000)
> +		 LONG(0x80004000)
> +		 /* Restart new PSW for booting via PSW restart. */
> +		 . = 0x1a0;
> +		 QUAD(0x0000000180000000)
> +		 QUAD(0x0000000000004000)
> +		 /*
> +		  * Invalid PGM new PSW so we hopefully get a code 8
> +		  * intercept on a PGM
> +		  */
> +		 . = 0x1d0;
> +		 QUAD(0x0008000000000000)
> +		 QUAD(0x0000000000000001)
> +	}
> +	. = 0x4000;
> +	.text : {
> +		*(.text)
> +		*(.text.*)
> +	}
> +	. = ALIGN(64K);

any reason to align to 64k? (instead of e.g. 4k)

> +	etext = .;
> +	. = ALIGN(16);

do you need the ALIGN? I would think we are already aligned here

> +	.data : {
> +		*(.data)
> +		*(.data.rel*)
> +	}
> +	. = ALIGN(16);
> +	.rodata : { *(.rodata) *(.rodata.*) }
> +	. = ALIGN(16);
> +	__bss_start = .;
> +	.bss : { *(.bss) }
> +	__bss_end = .;
> +	. = ALIGN(64K);

same question as above regarding 64k

> +}

