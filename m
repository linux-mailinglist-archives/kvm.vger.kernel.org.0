Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F5F46D3DC
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhLHNBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:01:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233894AbhLHNBT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:01:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Clf1m031048;
        Wed, 8 Dec 2021 12:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gqXkzrO2iTpj6rkKruyLjifXxVOdes5nrQp6fsWrpK0=;
 b=SglXJjs6QWIlw3wd+vRYN0Gjcy+X3ZVK2yMopWVQ19BSp4ui5t70jY0qVMMz8cKoeCzT
 qVU2dBq7mqdVZtuFKNpXooH9IVB+e9y/ndmf4gowXlnAJ7yMrt0eYbZoMHdirm8U+V/E
 iLSGseuQwqgSmXLRDtQdsU3fS3Wgd5/1iPWYOmOYeNpnQNQPVxuskwmQbA54OfR9nZiF
 unDCMgQMca1jjNa5UruGHJRYq3UBGbTLoLaKOUIjYPQM6REg3YoUbjkMELzwCr9c1d5D
 TsZWVeHWdc3ewXyK6xSsgiHVjK8+TqNk8JK9sNdwH7K0MqpJj3tjguXCGvqso3d9aJ1F 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cttd1kdsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:47 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8Cp0Ow009573;
        Wed, 8 Dec 2021 12:57:46 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cttd1kdsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:46 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CrIa0029150;
        Wed, 8 Dec 2021 12:57:44 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyayqy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8Cvfeh33030522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 12:57:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B48611C052;
        Wed,  8 Dec 2021 12:57:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD4AA11C054;
        Wed,  8 Dec 2021 12:57:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 12:57:40 +0000 (GMT)
Date:   Wed, 8 Dec 2021 13:57:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 07/10] s390x: snippets: Add PV support
Message-ID: <20211208135733.74adced1@p-imbrenda>
In-Reply-To: <20211207160005.1586-8-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
        <20211207160005.1586-8-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JLWXOX38dujQ0EK916Gv3d23ShIYHJYC
X-Proofpoint-GUID: siFF392p7EVy8NjhrcKcbaWbgmPHo1uI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 16:00:02 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> To create a pv-snippet we need to generate an se-header. This can be
> done using a currently not released tool. This tool creates a
> se-header similar to `genprotimg` with the difference that the image
> itself will not be encrypted.
> 
> The image for which we want to create a header must be a binary and
> padded to 4k. Therefore, we convert the compiled snippet to a binary,
> padd it to 4k, generate the header and convert it back to s390-64bit
> elf.
> 
> The name of the tool can be specified using the config argument
> `--gen-se-header=`. The pv-snipptes will only be built when this
> option is specified. Furthermore, the Hostkey-Document must be
> specified. If not the build will be skipped.
> 
> The host-snippet relation can be specified using the `pv-snippets`
> variable in s390x/Makefile, similar to the non-pv-snippets in
> 2f6fdb4a (s390x: snippets: Add snippet compilation, 2021-06-22)
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

it looks ok and I guess it works because otherwise the new tests would
not build.

> ---
>  .gitignore          |  2 ++
>  configure           |  8 ++++++
>  lib/s390x/snippet.h |  7 +++++
>  s390x/Makefile      | 67 +++++++++++++++++++++++++++++++++++++--------
>  4 files changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 3d5be622..28a197bf 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -25,3 +25,5 @@ cscope.*
>  /api/dirty-log-perf
>  /s390x/*.bin
>  /s390x/snippets/*/*.gbin
> +/s390x/snippets/*/*.hdr
> +/s390x/snippets/*/*.*obj
> \ No newline at end of file
> diff --git a/configure b/configure
> index 1d4d855e..9210912f 100755
> --- a/configure
> +++ b/configure
> @@ -26,6 +26,7 @@ target=
>  errata_force=0
>  erratatxt="$srcdir/errata.txt"
>  host_key_document=
> +gen_se_header=
>  page_size=
>  earlycon=
>  
> @@ -54,6 +55,9 @@ usage() {
>  	    --host-key-document=HOST_KEY_DOCUMENT
>  	                           Specify the machine-specific host-key document for creating
>  	                           a PVM image with 'genprotimg' (s390x only)
> +	    --gen-se-header=GEN_SE_HEADER
> +	                           Provide an executable to generate a PV header
> +				   requires --host-key-document. (s390x-snippets only)
>  	    --page-size=PAGE_SIZE
>  	                           Specify the page size (translation granule) (4k, 16k or
>  	                           64k, default is 64k, arm64 only)
> @@ -127,6 +131,9 @@ while [[ "$1" = -* ]]; do
>  	--host-key-document)
>  	    host_key_document="$arg"
>  	    ;;
> +	--gen-se-header)
> +	    gen_se_header="$arg"
> +	    ;;
>  	--page-size)
>  	    page_size="$arg"
>  	    ;;
> @@ -341,6 +348,7 @@ U32_LONG_FMT=$u32_long
>  WA_DIVIDE=$wa_divide
>  GENPROTIMG=${GENPROTIMG-genprotimg}
>  HOST_KEY_DOCUMENT=$host_key_document
> +GEN_SE_HEADER=$gen_se_header
>  EOF
>  if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      echo "TARGET=$target" >> config.mak
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> index 8e4765f8..6b77a8a9 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet.h
> @@ -14,10 +14,17 @@
>  	_binary_s390x_snippets_##type##_##file##_gbin_start
>  #define SNIPPET_NAME_END(type, file) \
>  	_binary_s390x_snippets_##type##_##file##_gbin_end
> +#define SNIPPET_HDR_START(type, file) \
> +	_binary_s390x_snippets_##type##_##file##_hdr_start
> +#define SNIPPET_HDR_END(type, file) \
> +	_binary_s390x_snippets_##type##_##file##_hdr_end
> +
>  
>  /* Returns the length of the snippet */
>  #define SNIPPET_LEN(type, file) \
>  	((uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file))
> +#define SNIPPET_HDR_LEN(type, file) \
> +	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
>  
>  /*
>   * C snippet instructions start at 0x4000 due to the prefix and the
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f95f2e61..55e6d962 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -26,12 +26,20 @@ tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
>  tests += $(TEST_DIR)/spec_ex-sie.elf
>  
> +ifneq ($(HOST_KEY_DOCUMENT),)
> +ifneq ($(GEN_SE_HEADER),)
> +tests += $(pv-tests)
> +endif
> +endif
> +
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
>  else
>  tests_pv_binary =
> +GEN_SE_HEADER =
>  endif
> +snippets-obj = $(patsubst %.gbin,%.gobj,$(snippets))
>  
>  all: directories test_cases test_cases_binary test_cases_pv
>  
> @@ -82,26 +90,59 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>  FLATLIBS = $(libcflat)
>  
>  SNIPPET_DIR = $(TEST_DIR)/snippets
> -snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o lib/auxinfo.o
> +snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
> +snippet_lib = $(snippet_asmlib) lib/auxinfo.o
>  
>  # perquisites (=guests) for the snippet hosts.
>  # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>  $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>  $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>  
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
> -	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> -	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
> +ifneq ($(GEN_SE_HEADER),)
> +snippets += $(pv-snippets)
> +tests += $(pv-tests)
> +snippet-hdr-obj = $(patsubst %.gbin,%.hdr.obj,$(pv-snippets))
> +else
> +snippet-hdr-obj =
> +endif
> +
> +# the asm/c snippets %.o have additional generated files as dependencies
> +$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
> +	truncate -s '%4096' $@
> +
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_lib) $(FLATLIBS)
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
> +	truncate -s '%4096' $@
> +
> +$(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> +
> +$(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> +
> +.SECONDARY:
> +%.gobj: %.gbin
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> +
> +.SECONDARY:
> +%.hdr.obj: %.hdr
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>  
> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/c/flat.lds $(patsubst %.gbin,%.o,$@) $(snippet_asmlib) $(FLATLIBS)
> -	$(OBJCOPY) -O binary $@ $@
> -	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $@ $@
>  
>  .SECONDEXPANSION:
> -%.elf: $$(snippets) %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
> +%.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
>  	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
> -	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds $(filter %.o, $^) $(FLATLIBS) $(snippets) $(@:.elf=.aux.o)
> +	@$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
> +		$(filter %.o, $^) $(FLATLIBS) $(snippets-obj) $(snippet-hdr-obj) $(@:.elf=.aux.o) || \
> +		{ echo "Failure probably caused by missing definition of gen-se-header executable"; exit 1; }
>  	$(RM) $(@:.elf=.aux.o)
>  	@chmod a-x $@
>  
> @@ -114,8 +155,12 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_asmlib) $(FLATLIBS)
>  %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
>  	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
>  
> +$(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d $(SNIPPET_DIR)/c/*.{o,gbin} $(SNIPPET_DIR)/c/.*.d lib/s390x/.*.d
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d
>  
>  generated-files = $(asm-offsets)
>  $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)

