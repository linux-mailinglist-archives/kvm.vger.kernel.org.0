Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA4B97E1
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 21:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfITTg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 15:36:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfITTg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 15:36:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KJYL1C124340;
        Fri, 20 Sep 2019 19:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Km+aqpU5lP4VPP7FXKwz2u3/15mHPHDPg8vuW01Y4C0=;
 b=CYn6hH2/MeR1fh0CMwC6OH5/0RuAg6H3Lowifc+EYDo9w+LnuH9LgXF5BDUTwMI9etBm
 NG6WnGIsbabyKx4eD5X5irrudxtFm/3YErr9HGr2yGvs0l0VL+OR7Ek0Qlm3NkCEGEXv
 G/bs/u+CliJK+E8UJawiXVcT9/Ys2Zhv/v86VAREH51NFMv8iA0VrDMyU3PgmkUCeCIy
 xA0iQtV6PIqa2oSL7ogI2bqSPLfTw9kkK7X6BUDDxBDSuIAMMfZvMNx9FNh+u0+JY46C
 c8SjHqrkS3V4NsTB9gkTXoBBP5Vy82X+jEVlljF5hDqX6dD/UpmciaTLquQymIBYv69L EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v3vb54fep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 19:36:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KJX3qC159277;
        Fri, 20 Sep 2019 19:36:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2v4vpmutq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 19:36:53 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8KJaq73032519;
        Fri, 20 Sep 2019 19:36:53 GMT
Received: from localhost.localdomain (/10.159.151.167)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 12:36:52 -0700
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20190919230225.37796-1-jmattson@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
Date:   Fri, 20 Sep 2019 12:36:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190919230225.37796-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/19/19 4:02 PM, Jim Mattson wrote:
> Ensure that support for RDPRU is not enumerated in the guest's CPUID
> and that the RDPRU instruction raises #UD.


The AMD spec says,

         "When the CPL>0 with CR4.TSD=1, the RDPRUinstruction will 
generate a #UD fault."

So we don't need to check the CR4.TSD value here ?


>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>   lib/x86/processor.h |  1 +
>   x86/Makefile.x86_64 |  1 +
>   x86/rdpru.c         | 23 +++++++++++++++++++++++
>   x86/unittests.cfg   |  5 +++++
>   4 files changed, 30 insertions(+)
>   create mode 100644 x86/rdpru.c
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index b1c579b..121f19c 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -150,6 +150,7 @@ static inline u8 cpuid_maxphyaddr(void)
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
> index 0000000..a298960
> --- /dev/null
> +++ b/x86/rdpru.c
> @@ -0,0 +1,23 @@
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
> +	report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
> +	report("RDPRU raises #UD", rdpru_checking() == UD_VECTOR);
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
