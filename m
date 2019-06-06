Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A2837C38
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfFFS01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 14:26:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51726 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbfFFS00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 14:26:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56IIgbA124084;
        Thu, 6 Jun 2019 18:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=yH8UdEOX5vJy/PhnJC24dl5WASO00fx3wXRpFZxmMHU=;
 b=dyc25b5zZhxR1Nqv2Nr4Av1tPaI5ssnnGCKfnXRfZIqSVkRhi6S8nutiPl/JgqmMrzxk
 AsyklV+kGbe4Qxy62nnSXQ4Akc4BT9In70ioQTt17sgSoXWl3gaG17weBfykXF4uAVF9
 F8HaNNSPl2QJ5JyykBmTUZOu/U/gz8trVfEqXh760glSLnYGAwztYDmUdG6ZaL9QWp4Y
 8tSvlKfcO9dBKDBXcTfjuX9PrBmHX3L7miy2XIjUsDs05e5/n9j0seXF2XURtJ9/Pn6a
 h6D8lnKNLz56Ksn8o5f2cVvqorxj/7srvFhD/tcJGbJjY/JPZbgvjOWpeSlRKo+ScfoS dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2suevdtexk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 18:25:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56IOZY1119435;
        Thu, 6 Jun 2019 18:25:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2swnhawqyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 18:25:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x56IPXA0009661;
        Thu, 6 Jun 2019 18:25:33 GMT
Received: from [10.175.215.95] (/10.175.215.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 11:25:32 -0700
Subject: Re: [patch v2 3/3] cpuidle-haltpoll: disable host side polling when
 kvm virtualized
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.360289262@amt.cnet> <20190604122404.GA18979@amt.cnet>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
Date:   Thu, 6 Jun 2019 19:25:28 +0100
MIME-Version: 1.0
In-Reply-To: <20190604122404.GA18979@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/19 1:24 PM, Marcelo Tosatti wrote:
> 
> When performing guest side polling, it is not necessary to 
> also perform host side polling. 
> 
> So disable host side polling, via the new MSR interface, 
> when loading cpuidle-haltpoll driver.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> ---
> 
> v2: remove extra "}"
> 
>  arch/x86/Kconfig                        |    7 +++++
>  arch/x86/include/asm/cpuidle_haltpoll.h |    8 ++++++
>  arch/x86/kernel/kvm.c                   |   40 ++++++++++++++++++++++++++++++++
>  drivers/cpuidle/cpuidle-haltpoll.c      |    9 ++++++-
>  include/linux/cpuidle_haltpoll.h        |   16 ++++++++++++
>  5 files changed, 79 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/cpuidle_haltpoll.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/arch/x86/include/asm/cpuidle_haltpoll.h	2019-06-03 19:38:42.328718617 -0300
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ARCH_HALTPOLL_H
> +#define _ARCH_HALTPOLL_H
> +
> +void arch_haltpoll_enable(void);
> +void arch_haltpoll_disable(void);
> +
> +#endif
> Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:38:12.376619124 -0300
> +++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:38:42.328718617 -0300
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/timekeeping.h>
>  #include <linux/sched/idle.h>
> +#include <linux/cpuidle_haltpoll.h>
>  #define CREATE_TRACE_POINTS
>  #include "cpuidle-haltpoll-trace.h"
>  
> @@ -157,11 +158,17 @@
>  
>  static int __init haltpoll_init(void)
>  {
> -	return cpuidle_register(&haltpoll_driver, NULL);
> +	int ret = cpuidle_register(&haltpoll_driver, NULL);
> +
> +	if (ret == 0)
> +		arch_haltpoll_enable();
> +
> +	return ret;
>  }
>  
>  static void __exit haltpoll_exit(void)
>  {
> +	arch_haltpoll_disable();
>  	cpuidle_unregister(&haltpoll_driver);
>  }
>  
> Index: linux-2.6.git/include/linux/cpuidle_haltpoll.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/include/linux/cpuidle_haltpoll.h	2019-06-03 19:41:57.293366260 -0300
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _CPUIDLE_HALTPOLL_H
> +#define _CPUIDLE_HALTPOLL_H
> +
> +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> +#include <asm/cpuidle_haltpoll.h>
> +#else
> +static inline void arch_haltpoll_enable(void)
> +{
> +}
> +
> +static inline void arch_haltpoll_disable(void)
> +{
> +}
> +#endif
> +#endif
> Index: linux-2.6.git/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/Kconfig	2019-06-03 19:38:12.376619124 -0300
> +++ linux-2.6.git/arch/x86/Kconfig	2019-06-03 19:42:34.478489868 -0300
> @@ -787,6 +787,7 @@
>  	bool "KVM Guest support (including kvmclock)"
>  	depends on PARAVIRT
>  	select PARAVIRT_CLOCK
> +	select ARCH_CPUIDLE_HALTPOLL
>  	default y
>  	---help---
>  	  This option enables various optimizations for running under the KVM
> @@ -795,6 +796,12 @@
>  	  underlying device model, the host provides the guest with
>  	  timing infrastructure such as time of day, and system time
>  
> +config ARCH_CPUIDLE_HALTPOLL
> +        def_bool n
> +        proUmpt "Disable host haltpoll when loading haltpoll driver"
> +        help
> +	  If virtualized under KVM, disable host haltpoll.
> +
>  config PVH
>  	bool "Support for running PVH guests"
>  	---help---
> Index: linux-2.6.git/arch/x86/kernel/kvm.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/kvm.c	2019-06-03 19:38:12.376619124 -0300
> +++ linux-2.6.git/arch/x86/kernel/kvm.c	2019-06-03 19:40:14.359024312 -0300
> @@ -853,3 +853,43 @@
>  }
>  
>  #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
> +
> +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> +
> +void kvm_disable_host_haltpoll(void *i)
> +{
> +	wrmsrl(MSR_KVM_POLL_CONTROL, 0);
> +}
> +
> +void kvm_enable_host_haltpoll(void *i)
> +{
> +	wrmsrl(MSR_KVM_POLL_CONTROL, 1);
> +}
> +
> +void arch_haltpoll_enable(void)
> +{
> +	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
> +		return;
> +

Perhaps warn the user when failing to disable host poll e.g.:

if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
	pr_warn_once("haltpoll: Failed to disable host halt polling\n");
	return;
}

But I wonder whether we should fail to load cpuidle-haltpoll when host halt
polling can't be disabled[*]? That is to avoid polling in both host and guest
and *possibly* avoid chances for performance regressions when running on older
hypervisors?

[*] with guest still able load with lack of host polling control via modparam

> +	preempt_disable();
> +	/* Enabling guest halt poll disables host halt poll */
> +	kvm_disable_host_haltpoll(NULL);
> +	smp_call_function(kvm_disable_host_haltpoll, NULL, 1);
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL_GPL(arch_haltpoll_enable);
> +
> +void arch_haltpoll_disable(void)
> +{
> +	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
> +		return;
> +
> +	preempt_disable();
> +	/* Enabling guest halt poll disables host halt poll */
> +	kvm_enable_host_haltpoll(NULL);
> +	smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
> +	preempt_enable();
> +}
> +
> +EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
> +#endif
> 
