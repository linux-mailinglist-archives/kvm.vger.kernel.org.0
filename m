Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6E3BC188
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 07:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407912AbfIXFzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 01:55:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405904AbfIXFzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 01:55:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O5rwlE067218;
        Tue, 24 Sep 2019 05:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=3DwGyk1cHNOQCOYOwh2RebDqfDeuNIWCxx2/UfWmAyA=;
 b=rQ/WP+zcUM/7NP6G1HxVUd2WPgyZbqR5zmvzAzp7n2bT4fwTuIJUTmW1voksKHbDq7GP
 MrTF8kuMGg20Um1QWrlhjgtYq7LmFDaBg3Q8d6Sf2ta0vKMBNMckACnGmXWGBAOcbfgE
 ucB/aJaDGKhGVD6TYg3zZ169vuINiXk8gAe3enEo1z5mY9peUKreJtzzaOAp2X8XCTIR
 5m2LcE2BzZp9PDm2OMC88UI3jF4VMpmZnoiCxvNIq8gOHLjl2JGQgzncLiyJgJ1Z7PqT
 NutR0wCTYTgy47sYNFZqQMSaiER5q3DuisyeuNxshxfCsNEGxUgCM5vLnvb01/5ibMF6 OQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9tkk7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 05:55:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O5rVtN141231;
        Tue, 24 Sep 2019 05:55:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v6yvjgr3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 05:55:39 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8O5tdZ9015301;
        Tue, 24 Sep 2019 05:55:39 GMT
Received: from localhost.localdomain (/10.159.232.154)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 22:55:39 -0700
Subject: Re: [kvm-unit-tests PATCH v2] kvm-unit-test: x86: Add RDPRU test
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20190920230805.111064-1-jmattson@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1fcb41a4-eab3-3d5b-471c-d292da630b36@oracle.com>
Date:   Mon, 23 Sep 2019 22:55:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190920230805.111064-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/20/19 4:08 PM, Jim Mattson wrote:
> When running in a VM, ensure that support for RDPRU is not enumerated
> in the guest's CPUID and that the RDPRU instruction raises #UD.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>   lib/x86/processor.h |  2 ++
>   x86/Makefile.x86_64 |  1 +
>   x86/rdpru.c         | 27 +++++++++++++++++++++++++++
>   x86/unittests.cfg   |  5 +++++
>   4 files changed, 35 insertions(+)
>   create mode 100644 x86/rdpru.c
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index b1c579b..fe72c13 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -131,6 +131,7 @@ static inline u8 cpuid_maxphyaddr(void)
>   #define	X86_FEATURE_XSAVE		(CPUID(0x1, 0, ECX, 26))
>   #define	X86_FEATURE_OSXSAVE		(CPUID(0x1, 0, ECX, 27))
>   #define	X86_FEATURE_RDRAND		(CPUID(0x1, 0, ECX, 30))
> +#define	X86_FEATURE_HYPERVISOR		(CPUID(0x1, 0, ECX, 31))
>   #define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
>   #define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
>   #define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
> @@ -150,6 +151,7 @@ static inline u8 cpuid_maxphyaddr(void)
>   #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
>   #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
>   #define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
> +#define	X86_FEATURE_RDPRU		(CPUID(0x80000008, 0, EBX, 4))
>   
>   /*
>    * AMD CPUID features
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index 51f9b80..010102b 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -19,6 +19,7 @@ tests += $(TEST_DIR)/vmx.flat
>   tests += $(TEST_DIR)/tscdeadline_latency.flat
>   tests += $(TEST_DIR)/intel-iommu.flat
>   tests += $(TEST_DIR)/vmware_backdoors.flat
> +tests += $(TEST_DIR)/rdpru.flat
>   
>   include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>   
> diff --git a/x86/rdpru.c b/x86/rdpru.c
> new file mode 100644
> index 0000000..87a517e
> --- /dev/null
> +++ b/x86/rdpru.c
> @@ -0,0 +1,27 @@
> +/* RDPRU test */
> +
> +#include "libcflat.h"
> +#include "processor.h"
> +#include "desc.h"
> +
> +static int rdpru_checking(void)
> +{
> +	asm volatile (ASM_TRY("1f")
> +		      ".byte 0x0f,0x01,0xfd \n\t" /* rdpru */
> +		      "1:" : : "c" (0) : "eax", "edx");
> +	return exception_vector();
> +}
> +
> +int main(int ac, char **av)
> +{
> +	setup_idt();
> +
> +	if (this_cpu_has(X86_FEATURE_HYPERVISOR)) {
> +		report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
> +		report("RDPRU raises #UD", rdpru_checking() == UD_VECTOR);
> +	} else {
> +		report_skip("Not in a VM");
> +	}
> +
> +	return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d..9764e18 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -221,6 +221,11 @@ file = pcid.flat
>   extra_params = -cpu qemu64,+pcid
>   arch = x86_64
>   
> +[rdpru]
> +file = rdpru.flat
> +extra_params = -cpu host
> +arch = x86_64
> +
>   [umip]
>   file = umip.flat
>   extra_params = -cpu qemu64,+umip
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
