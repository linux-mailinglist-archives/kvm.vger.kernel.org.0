Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0AF2DC1F2
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgLPONd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 09:13:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLPONd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 09:13:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGE3ubL138592
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 14:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : subject :
 in-reply-to : references : sender : from : date : message-id :
 mime-version : content-type; s=corp-2020-01-29;
 bh=N4wjANjmfE2a7+49veZsvEOQSRU5VRo0eEtWYAaPMUU=;
 b=s5ytJrHFZT0XZQCO63GXbJAGdAOjwZD7etqQLrZMuZbDXRDpiFNsI6Cw2P0szJJwu9zo
 ERdA6gEoknLIw3wQ9cQtid0F66mFwOLYguDodZz31THGSsi70h9xQRUJljyd4+s0LcYA
 DELDtKK1UALWfsiTnq1f7A51gKe67QYTSxudAwLPqOTomIVC57J60O7fu5oSyQsYzQHe
 4hNoxNlRsj32FmdX5qIQ+RSMntOe1giVPc97v14TpcMJ5Mwxqs+A8P7967cFLFqBY/A/
 fpWGROVKbyws0GXd3zIT7sN/5dyGaVjutKnzZ9Rzuh8KsRd+c7KnFJU5A2UrOv7zU7dj BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35cntm8d7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 14:12:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGEADMN150490
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 14:10:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35d7sxubuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 14:10:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BGEAoCb025450
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 14:10:50 GMT
Received: from disaster-area.hh.sledj.net (/81.187.26.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 06:10:50 -0800
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id ed935a7e;
        Wed, 16 Dec 2020 14:10:48 +0000 (UTC)
To:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/1] x86: check that clflushopt of an
 MMIO address succeeds
In-Reply-To: <20201118121129.6276-2-david.edmondson@oracle.com>
References: <20201118121129.6276-1-david.edmondson@oracle.com>
 <20201118121129.6276-2-david.edmondson@oracle.com>
X-HGTTG: zarquon
Sender: david.edmondson@oracle.com
From:   David Edmondson <david.edmondson@oracle.com>
Date:   Wed, 16 Dec 2020 14:10:48 +0000
Message-ID: <cuno8itu9hz.fsf@zarquon.hh.sledj.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping, any chance of a review?

I'm happy to rework this or merge it with existing tests if required.

On Wednesday, 2020-11-18 at 12:11:29 GMT, David Edmondson wrote:

> Verify that the clflushopt instruction succeeds when applied to an
> MMIO address at both cpl0 and cpl3.
>
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  x86/Makefile.common   |  3 ++-
>  x86/clflushopt_mmio.c | 45 +++++++++++++++++++++++++++++++++++++++++++
>  x86/unittests.cfg     |  5 +++++
>  3 files changed, 52 insertions(+), 1 deletion(-)
>  create mode 100644 x86/clflushopt_mmio.c
>
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index b942086..e11666a 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -62,7 +62,8 @@ tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
>                 $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
>                 $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
>                 $(TEST_DIR)/hyperv_connections.flat \
> -               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
> +               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat \
> +               $(TEST_DIR)/clflushopt_mmio.flat
>  
>  test_cases: $(tests-common) $(tests)
>  
> diff --git a/x86/clflushopt_mmio.c b/x86/clflushopt_mmio.c
> new file mode 100644
> index 0000000..f048f58
> --- /dev/null
> +++ b/x86/clflushopt_mmio.c
> @@ -0,0 +1,45 @@
> +#include "libcflat.h"
> +#include "usermode.h"
> +#include "pci.h"
> +#include "x86/asm/pci.h"
> +
> +static volatile int ud;
> +static void *memaddr = (void *)0xfed00000; /* HPET */
> +
> +static void handle_ud(struct ex_regs *regs)
> +{
> +	ud = 1;
> +	regs->rip += 4;
> +}
> +
> +static void try_clflushopt(const char *comment)
> +{
> +	int expected = !this_cpu_has(X86_FEATURE_CLFLUSHOPT);
> +
> +	ud = 0;
> +	/* clflushopt (%rbx): */
> +	asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (memaddr));
> +
> +	report(ud == expected, comment, expected ? "ABSENT" : "present");
> +}
> +
> +static uint64_t user_clflushopt(void)
> +{
> +	try_clflushopt("clflushopt-mmio@cpl3 (%s)");
> +
> +	return 0;
> +}
> +
> +int main(int ac, char **av)
> +{
> +	bool raised;
> +
> +	setup_vm();
> +
> +	handle_exception(UD_VECTOR, handle_ud);
> +
> +	(void) run_in_user(user_clflushopt, false, 0, 0, 0, 0, &raised);
> +	try_clflushopt("clflushopt-mmio@cpl0 (%s)");
> +
> +	return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 872d679..35bedf8 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -359,3 +359,8 @@ extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=o
>  file = tsx-ctrl.flat
>  extra_params = -cpu host
>  groups = tsx-ctrl
> +
> +[clflushopt_mmio]
> +file = clflushopt_mmio.flat
> +extra_params = -cpu host
> +arch = x86_64
> -- 
> 2.29.2

dme.
-- 
It's alright, we told you what to dream.
