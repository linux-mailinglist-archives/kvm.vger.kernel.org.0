Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23749605BCD
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 12:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiJTKDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 06:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiJTKDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 06:03:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D01D066C
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 03:02:56 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K9ojXZ032401
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nlGlkYPHkqYVlVA//gr2MGe21PNTs/nrE4OjoLM5flE=;
 b=rwkMXsAEilD7BB8tqOQBlawZleKGHWwlB+bgxMnKaO/y4z7qqnFbTQEaBWFfEXp2vmVE
 6QHyYIVRLqimbu4ZKLC26eQFPrDvvYX7RwSHXQUAL84ztr7uR9RNRMel4xTrkN97IaqD
 Ce3vBL4bU0DYdjtNZ5zSnPa6Gj5CyGU9jTAnuGzqmlymkZr15/So/DhWH0MJ+9O9Yql+
 s4KoMf/epCrILO9Yf8L/iTUlhu4JZsxaNh6kwCQxYB03RmrP8gNEacOSyQ4+ZxiYHhq7
 wpqhUS/9JJ017tHMXYrxAY0pc+CT+DP/BIqv4w86GKtjUSBNzUdDNd7uf6asJ0eF6JC/ cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kayycg9h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:02:54 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K99mfB021681
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:02:54 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kayycg9g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 10:02:54 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K9pS3q000706;
        Thu, 20 Oct 2022 10:02:52 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3k7mg96h1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 10:02:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K9vk7c41550154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:57:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE0F2AE053;
        Thu, 20 Oct 2022 10:02:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A5F3AE045;
        Thu, 20 Oct 2022 10:02:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 10:02:48 +0000 (GMT)
Date:   Thu, 20 Oct 2022 12:02:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/7] s390x: Add a linker script to
 assembly snippets
Message-ID: <20221020120245.31f81eeb@p-imbrenda>
In-Reply-To: <20221020090009.2189-4-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
        <20221020090009.2189-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U1WD1ZIb-BytOkTnjw8WzbFg2jF6No5H
X-Proofpoint-ORIG-GUID: QkcbEarXZfmTkaPSXoRYXFi3DK_pb2fL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 09:00:05 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> A linker script has a few benefits:
> - We can easily define a lowcore and load the snippet from 0x0 instead
> of 0x4000 which makes asm snippets behave like c snippets
> - We can easily define an invalid PGM new PSW to ensure an exit on a
> guest PGM
> - We can remove a lot of the offset variables from lib/s390x/snippet.h
> 
> As we gain another step and file extension by linking, a comment
> explains which file extensions are generated and why.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/snippet.h         | 14 +++++---------
>  s390x/Makefile              | 18 ++++++++++++++----
>  s390x/mvpg-sie.c            |  2 +-
>  s390x/pv-diags.c            |  6 +++---
>  s390x/snippets/asm/flat.lds | 35 +++++++++++++++++++++++++++++++++++
>  5 files changed, 58 insertions(+), 17 deletions(-)
>  create mode 100644 s390x/snippets/asm/flat.lds
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> index b17b2a4c..fcd04081 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet.h
> @@ -32,8 +32,6 @@
>  
>  #define SNIPPET_PV_TWEAK0	0x42UL
>  #define SNIPPET_PV_TWEAK1	0UL
> -#define SNIPPET_OFF_C		0
> -#define SNIPPET_OFF_ASM		0x4000
>  
>  
>  /*
> @@ -57,15 +55,14 @@ static const struct psw snippet_psw = {
>   * @vm: VM that this function will populated, has to be initialized already
>   * @gbin: Snippet gbin data pointer
>   * @gbin_len: Length of the gbin data
> - * @off: Offset from guest absolute 0x0 where snippet is copied to
>   */
>  static inline void snippet_init(struct vm *vm, const char *gbin,
> -				uint64_t gbin_len, uint64_t off)
> +				uint64_t gbin_len)
>  {
>  	uint64_t mso = vm->sblk->mso;
>  
>  	/* Copy test image to guest memory */
> -	memcpy((void *)mso + off, gbin, gbin_len);
> +	memcpy((void *)mso, gbin, gbin_len);
>  
>  	/* Setup guest PSW */
>  	vm->sblk->gpsw = snippet_psw;
> @@ -87,23 +84,22 @@ static inline void snippet_init(struct vm *vm, const char *gbin,
>   * @hdr: Snippet SE header data pointer
>   * @gbin_len: Length of the gbin data
>   * @hdr_len: Length of the hdr data
> - * @off: Offset from guest absolute 0x0 where snippet is copied to
>   */
>  static inline void snippet_pv_init(struct vm *vm, const char *gbin,
>  				   const char *hdr, uint64_t gbin_len,
> -				   uint64_t hdr_len, uint64_t off)
> +				   uint64_t hdr_len)
>  {
>  	uint64_t tweak[2] = {SNIPPET_PV_TWEAK0, SNIPPET_PV_TWEAK1};
>  	uint64_t mso = vm->sblk->mso;
>  	int i;
>  
> -	snippet_init(vm, gbin, gbin_len, off);
> +	snippet_init(vm, gbin, gbin_len);
>  
>  	uv_create_guest(vm);
>  	uv_set_se_hdr(vm->uv.vm_handle, (void *)hdr, hdr_len);
>  
>  	/* Unpack works on guest addresses so we only need off */
> -	uv_unpack(vm, off, gbin_len, tweak[0]);
> +	uv_unpack(vm, 0, gbin_len, tweak[0]);
>  	uv_verify_load(vm);
>  
>  	/*
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 3b175015..0eaa72f4 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -124,6 +124,13 @@ else
>  snippet-hdr-obj =
>  endif
>  
> +# Each snippet will generate the following files (in order): \
> +  *.o is a snippet that has been compiled \
> +  *.ol is a snippet that has been linked \
> +  *.gbin is a snippet that has been converted to binary \
> +  *.gobj is the final format after converting the binary into a elf file again, \
> +  it will be linked into the tests
> +
>  # the asm/c snippets %.o have additional generated files as dependencies
>  $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> @@ -131,17 +138,20 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>  $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>  
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
> +$(SNIPPET_DIR)/asm/%.ol: $(SNIPPET_DIR)/asm/%.o
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
> +
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.ol
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
>  	truncate -s '%4096' $@

can't you do $(CC) and $(OBJCOPY) in one step like you do for C
snippets? then you don't need the .ol intermediate

>  
>  $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
>  	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
>  	truncate -s '%4096' $@
>  
>  $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
>  
>  $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>  	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 46a2edb6..17e209ad 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -87,7 +87,7 @@ static void setup_guest(void)
>  
>  	snippet_setup_guest(&vm, false);
>  	snippet_init(&vm, SNIPPET_NAME_START(c, mvpg_snippet),
> -		     SNIPPET_LEN(c, mvpg_snippet), SNIPPET_OFF_C);
> +		     SNIPPET_LEN(c, mvpg_snippet));
>  
>  	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>  	vm.sblk->eca = ECA_MVPGI;
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 9ced68c7..d472c994 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -28,7 +28,7 @@ static void test_diag_500(void)
>  
>  	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
>  			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +			size_gbin, size_hdr);
>  
>  	sie(&vm);
>  	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> @@ -83,7 +83,7 @@ static void test_diag_288(void)
>  
>  	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
>  			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +			size_gbin, size_hdr);
>  
>  	sie(&vm);
>  	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> @@ -124,7 +124,7 @@ static void test_diag_yield(void)
>  
>  	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
>  			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
> -			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +			size_gbin, size_hdr);
>  
>  	/* 0x44 */
>  	report_prefix_push("0x44");
> diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds
> new file mode 100644
> index 00000000..388d7d5d
> --- /dev/null
> +++ b/s390x/snippets/asm/flat.lds
> @@ -0,0 +1,35 @@
> +SECTIONS
> +{
> +	.lowcore : {
> +		 /* Restart new PSW for booting via PSW restart. */
> +		 . = 0x1a0;
> +		 QUAD(0x0000000180000000)
> +		 QUAD(0x0000000000004000)
> +		 /*
> +		  * Invalid PGM new PSW so we hopefully get a code 8
> +		  * intercept on a PGM for PV snippets.
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
> +	etext = .;
> +	. = ALIGN(16);
> +	.data : {
> +		*(.data)
> +		*(.data.rel*)
> +	}
> +	. = ALIGN(16);
> +	.rodata : { *(.rodata) *(.rodata.*) }
> +	. = ALIGN(16);

do you really need to ALIGN(16) right after ALIGN(64K) ?

> +	__bss_start = .;
> +	.bss : { *(.bss) }
> +	__bss_end = .;
> +	. = ALIGN(64K);

why align the end? and why 64K instead of e.g. 4K?

> +}

