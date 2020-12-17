Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8926B2DD395
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 16:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgLQPB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 10:01:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725871AbgLQPB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 10:01:58 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEXoco107705;
        Thu, 17 Dec 2020 10:01:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=68QYcY/DTrmUb4YiFnPFmsi5O5kNtFa1sA1b9ZEWef8=;
 b=lJe+vL+sSTXN9UpSIRQpmm36Sn1ls4yfxi4iJcMa93mwShQMnqaMiHz6jOO7M758stZy
 02IOmmgz5IOlJvgurWixO8hGZZ07J+4Q1q2OvEAcU2by6vPU1/fgySBLIFiZQOrrDVQ4
 qTRK8hw4FQGa6vGTIs8iKFPW0V+on8PJYsBLqh39wmgOLT3hWIbA9QzRmi1pORdbuDdH
 f8PMDJux4DgCNjLC7o84mOvtu4S9xvQ4XR0sXjzKFgABAs2yVE4YPgjGPnXXNGSmhAPS
 lL5LxcQhUuoE6bHIFa2HrLlyo24l2rI5jd90DP2MsFPM44XixC52a+qyw1eu7pwtepPA ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g7vauraf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:01:16 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BHEYuEo112296;
        Thu, 17 Dec 2020 10:01:16 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35g7vaur8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:01:16 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BHEv82W030866;
        Thu, 17 Dec 2020 15:01:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8g3vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 15:01:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BHEwfCp31326710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 14:58:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDDB1A405F;
        Thu, 17 Dec 2020 14:58:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 636C1A4060;
        Thu, 17 Dec 2020 14:58:41 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.12.102])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Dec 2020 14:58:41 +0000 (GMT)
Date:   Thu, 17 Dec 2020 15:48:15 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: sie: Add first SIE test
Message-ID: <20201217154815.2b961dc9@ibm-vm>
In-Reply-To: <20201211100039.63597-7-frankja@linux.ibm.com>
References: <20201211100039.63597-1-frankja@linux.ibm.com>
        <20201211100039.63597-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_09:2020-12-15,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 05:00:37 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if we get the correct interception data on a few
> diags. This commit is more of an addition of boilerplate code than a
> real test.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sie.c         | 113
> ++++++++++++++++++++++++++++++++++++++++++++ s390x/unittests.cfg |
> 3 ++ 3 files changed, 117 insertions(+)
>  create mode 100644 s390x/sie.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index fb62e87..8e1b4e9 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -19,6 +19,7 @@ tests += $(TEST_DIR)/smp.elf
>  tests += $(TEST_DIR)/sclp.elf
>  tests += $(TEST_DIR)/css.elf
>  tests += $(TEST_DIR)/uv-guest.elf
> +tests += $(TEST_DIR)/sie.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/sie.c b/s390x/sie.c
> new file mode 100644
> index 0000000..cfc746f
> --- /dev/null
> +++ b/s390x/sie.c
> @@ -0,0 +1,113 @@
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/arch_def.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <alloc_page.h>
> +#include <vmalloc.h>
> +#include <asm/facility.h>
> +#include <mmu.h>
> +#include <sclp.h>
> +#include <sie.h>
> +
> +static u8 *guest;
> +static u8 *guest_instr;
> +static struct vm vm;
> +
> +static void handle_validity(struct vm *vm)
> +{
> +	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
> +}
> +
> +static void sie(struct vm *vm)
> +{
> +	while (vm->sblk->icptcode == 0) {
> +		sie64a(vm->sblk, &vm->save_area);
> +		if (vm->sblk->icptcode == ICPT_VALIDITY)
> +			handle_validity(vm);
> +	}
> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> +}
> +
> +static void sblk_cleanup(struct vm *vm)
> +{
> +	vm->sblk->icptcode = 0;
> +}
> +
> +static void test_diag(u32 instr)
> +{
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_INST &&
> +	       vm.sblk->ipa == instr >> 16 && vm.sblk->ipb == instr
> << 16,
> +	       "Intercept data");
> +	sblk_cleanup(&vm);
> +}
> +
> +static struct {
> +	const char *name;
> +	u32 instr;
> +} tests[] = {
> +	{ "10", 0x83020010 },
> +	{ "44", 0x83020044 },
> +	{ "9c", 0x8302009c },
> +	{ NULL, 0 }
> +};
> +
> +static void test_diags(void)
> +{
> +	int i;
> +
> +	for (i = 0; tests[i].name; i++) {
> +		report_prefix_push(tests[i].name);
> +		test_diag(tests[i].instr);
> +		report_prefix_pop();
> +	}
> +}
> +
> +static void setup_guest(void)
> +{
> +	setup_vm();
> +
> +	/* Allocate 1MB as guest memory */
> +	guest = alloc_pages(8);
> +	/* The first two pages are the lowcore */
> +	guest_instr = guest + PAGE_SIZE * 2;
> +
> +	vm.sblk = alloc_page();
> +
> +	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
> +	vm.sblk->prefix = 0;
> +	/*
> +	 * Pageable guest with the same ASCE as the test programm,
> but
> +	 * the guest memory 0x0 is offset to start at the allocated
> +	 * guest pages and end after 1MB.
> +	 *
> +	 * It's not pretty but faster and easier than managing guest
> ASCEs.
> +	 */
> +	vm.sblk->mso = (u64)guest;
> +	vm.sblk->msl = (u64)guest;
> +	vm.sblk->ihcpu = 0xffff;
> +
> +	vm.sblk->crycbd = (uint64_t)alloc_page();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("sie");
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto done;
> +	}
> +
> +	setup_guest();
> +	test_diags();
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3feb8bc..2298be6 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -96,3 +96,6 @@ smp = 2
>  
>  [uv-guest]
>  file = uv-guest.elf
> +
> +[sie]
> +file = sie.elf

