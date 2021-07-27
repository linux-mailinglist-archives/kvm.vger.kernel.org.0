Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A0B3D75B1
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 15:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhG0NSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 09:18:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62716 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232214AbhG0NSG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 09:18:06 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RD43qo191024;
        Tue, 27 Jul 2021 09:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bQsZdHvGO0NE0jeW1JcPo5Z5PmPmtwv6Ai/9AJpx4H4=;
 b=VOv03WpSBIoI84aCPjxhY+RloqKXM6l+jO47W2xJPNC4O2CemaPe94vcCgcPZGqGTQVM
 x7Sss5IwrsT0miXElLXquF4E33bIjpw98MJH8dR5IAC4B6qqR9QWTZaeXE3JkWqmVpei
 zSPtn6RDhgT/kqqEMMauY43LDcqVuByYY//8mCZQ9XO6VIX0HymGwGHe8o34B4rnABSi
 3QDDmkuvIb0HMnU9pMA3xbv3aWFyzqRHF9JHwdQfTRBWpZq1t3r9AZhlcId+8sTtMj02
 WXvhVdmwW8/mczwdBxk1Nfg8jtDE+dlmlAVAs41dSdVW4IDO+EPzP6+0irOwEcf4yVSz mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hhnugb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 09:18:06 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16RD4DRe192386;
        Tue, 27 Jul 2021 09:18:05 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a2hhnugab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 09:18:05 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16RDI4NU025331;
        Tue, 27 Jul 2021 13:18:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3a235m0edg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 13:18:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16RDI0Dg27918724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 13:18:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74D6CAE055;
        Tue, 27 Jul 2021 13:18:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 108C7AE045;
        Tue, 27 Jul 2021 13:18:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.110])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jul 2021 13:17:59 +0000 (GMT)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210706115724.372901-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Add specification exception
 interception test
Message-ID: <673f24d5-a857-be92-7614-4910ef0934cb@linux.ibm.com>
Date:   Tue, 27 Jul 2021 15:17:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706115724.372901-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4v05S5Yt2Pghy8Lm4HGOyxKTQy4L-0MT
X-Proofpoint-ORIG-GUID: fifqazmiH730XaznQD9UZDuc0WEFE35R
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_07:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/6/21 1:57 PM, Janis Schoetterl-Glausch wrote:
> Check that specification exceptions cause intercepts when
> specification exception interpretation is off.
> Check that specification exceptions caused by program new PSWs
> cause interceptions.
> We cannot assert that non program new PSW specification exceptions
> are interpreted because whether interpretation occurs or not is
> configuration dependent.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> The patch is based on the following patch sets by Janosch:
> [kvm-unit-tests PATCH 0/5] s390x: sie and uv cleanups
> [kvm-unit-tests PATCH v2 0/3] s390x: Add snippet support
> 
>  s390x/Makefile             |  2 +
>  lib/s390x/sie.h            |  1 +
>  s390x/snippets/c/spec_ex.c | 13 ++++++
>  s390x/spec_ex-sie.c        | 91 ++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg        |  3 ++
>  5 files changed, 110 insertions(+)
>  create mode 100644 s390x/snippets/c/spec_ex.c
>  create mode 100644 s390x/spec_ex-sie.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 07af26d..b1b6536 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -24,6 +24,7 @@ tests += $(TEST_DIR)/mvpg.elf
>  tests += $(TEST_DIR)/uv-host.elf
>  tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
> +tests += $(TEST_DIR)/spec_ex-sie.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> @@ -84,6 +85,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>  # perquisites (=guests) for the snippet hosts.
>  # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>  $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
> +$(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>  
>  $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>  	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 6ba858a..a3b8623 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -98,6 +98,7 @@ struct kvm_s390_sie_block {
>  	uint8_t		fpf;			/* 0x0060 */
>  #define ECB_GS		0x40
>  #define ECB_TE		0x10
> +#define ECB_SPECI	0x08
>  #define ECB_SRSI	0x04
>  #define ECB_HOSTPROTINT	0x02
>  	uint8_t		ecb;			/* 0x0061 */
> diff --git a/s390x/snippets/c/spec_ex.c b/s390x/snippets/c/spec_ex.c
> new file mode 100644
> index 0000000..f2daab5
> --- /dev/null
> +++ b/s390x/snippets/c/spec_ex.c
> @@ -0,0 +1,13 @@
> +#include <stdint.h>
> +#include <asm/arch_def.h>
> +
> +__attribute__((section(".text"))) int main(void)
> +{
> +	uint64_t bad_psw = 0;
> +	struct psw *pgm_new = (struct psw *)464;
> +
> +	pgm_new->mask = 1UL << (63 - 12); //invalid program new PSW
> +	pgm_new->addr = 0xdeadbeef;
> +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
> +	return 0;
> +}
> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
> new file mode 100644
> index 0000000..7aa2f49
> --- /dev/null
> +++ b/s390x/spec_ex-sie.c
> @@ -0,0 +1,91 @@
> +#include <libcflat.h>
> +#include <sclp.h>
> +#include <asm/page.h>
> +#include <asm/arch_def.h>
> +#include <alloc_page.h>
> +#include <vm.h>
> +#include <sie.h>
> +
> +static struct vm vm;
> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_start[];
> +extern const char _binary_s390x_snippets_c_spec_ex_gbin_end[];
> +
> +static void setup_guest(void)
> +{
> +	char *guest;
> +	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_end -
> +			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
> +
> +	setup_vm();
> +
> +	/* Allocate 1MB as guest memory */
> +	guest = alloc_pages(8);
> +	/* The first two pages are the lowcore */
> +
> +	vm.sblk = alloc_page();
> +
> +	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
> +	vm.sblk->prefix = 0;
> +	/*
> +	 * Pageable guest with the same ASCE as the test program, but
> +	 * the guest memory 0x0 is offset to start at the allocated
> +	 * guest pages and end after 1MB.
> +	 *
> +	 * It's not pretty but faster and easier than managing guest ASCEs.
> +	 */
> +	vm.sblk->mso = (u64)guest;
> +	vm.sblk->msl = (u64)guest;
> +	vm.sblk->ihcpu = 0xffff;
> +
> +	vm.sblk->crycbd = (uint64_t)alloc_page();
> +
> +	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
> +}
> +
> +static void reset_guest(void)
> +{
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;

Remind me to add that to arch_def.h...

> +}
> +
> +static void test_spec_ex_sie(void)
> +{
> +	setup_guest();
> +
> +	report_prefix_push("spec ex interpretation off");
> +	reset_guest();
> +	sie64a(vm.sblk, &vm.save_area);
> +	//interpretation off -> initial exception must cause interception
> +	report(vm.sblk->icptcode == ICPT_PROGI
> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION
> +	       && vm.sblk->gpsw.addr != 0xdeadbeef,
> +	       "Received specification exception intercept for non program new PSW");
> +	report_prefix_pop();
> +
> +	report_prefix_push("spec ex interpretation on");
> +	vm.sblk->ecb |= ECB_SPECI;
> +	reset_guest();
> +	sie64a(vm.sblk, &vm.save_area);
> +	// interpretation on -> configuration dependent if initial exception causes
> +	// interception, but invalid new program PSW must

Multi line comments are usually done via /* */
Generally // is not really used as a comment in the s390 part of this
project.

> +	report(vm.sblk->icptcode == ICPT_PROGI
> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
> +	       "Received specification exception intercept");
> +	if (vm.sblk->gpsw.addr == 0xdeadbeef)
> +		report_info("Interpreted non program new PSW specification exception");
> +	else
> +		report_info("Did not interpret non program new PSW specification exception");
> +	report_prefix_pop();
> +}
> +
> +int main(int argc, char **argv)
> +{

Is there a reason you didn't push a prefix here?
"spec ex sie"

and then:
"interpretation off"
and
"interpretation on"

Only minor nits, we hopefully should only need one more version :)


> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto out;
> +	}
> +
> +	test_spec_ex_sie();
> +out:
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 9e1802f..3b454b7 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -109,3 +109,6 @@ file = edat.elf
>  
>  [mvpg-sie]
>  file = mvpg-sie.elf
> +
> +[spec_ex-sie]
> +file = spec_ex-sie.elf
> 
> base-commit: bc6f264386b4cb2cadc8b2492315f3e6e8a801a2
> prerequisite-patch-id: 17697772b67d510e0e60108671c0dc2815973dca
> prerequisite-patch-id: 5501a7902745c87349c05ebd88b709c7ac82557e
> prerequisite-patch-id: 8377cf56402b62f5684b8c4113237b31e3373523
> prerequisite-patch-id: cb9fd55b0ee96866d685616af914cfa752ea0cd3
> prerequisite-patch-id: aed25b2421e37aba8786f65ef0ef10ac192d3098
> prerequisite-patch-id: c50347e3942c594532d639fa4071c39b8e5e5415
> prerequisite-patch-id: 116a357c74b3973d972ec206f066add611ce55ce
> prerequisite-patch-id: c4f9f65f5fd25ca35cc04f16a21ef3653d59fc8f
> 

