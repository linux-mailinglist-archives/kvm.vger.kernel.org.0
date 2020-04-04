Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2716319E202
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 02:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgDDA61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 20:58:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34104 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDDA60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 20:58:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0340vxCh054966;
        Sat, 4 Apr 2020 00:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AUOoCEr8maoYNjNVwB7f4TeT0WpxutYk9SOwhLZTUqQ=;
 b=VFe4WHje6JxT2AWuxtdMoHuSTIq2muQXZA+W0Qz/gcUMxF22bd0/MMNH15Mmk2CvBHQ2
 KyQJCOLw1xhX5eS2g3h2zip5Ni5zupQ0nKUhE0Fz2sLQ5XfkkErX/lY5GzZE1WGXcrp8
 0V9XD/+aW3NktIRKfWP9360oDvmfgTKGbVOC2fm3LRWGokh3GTcxSJDl7IdNWKHGKbAc
 9lL+acUMCyulXNjm1Auj66BIarvq6iG51cqioAti3mGkqimcIkQMIpyqtF2T+KR0XvOC
 zAKBUauYCk5JpdC9577eflFQ54IpBAQHrI3X3s7cE8aHVUWMiuWd/SAd1wtZ+y5BYytd eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yunpae6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Apr 2020 00:57:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0340r8Bx028325;
        Sat, 4 Apr 2020 00:55:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 306fbr3jnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Apr 2020 00:55:58 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0340tsk8018532;
        Sat, 4 Apr 2020 00:55:55 GMT
Received: from localhost.localdomain (/10.159.159.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 17:55:54 -0700
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c5977ca2-2fbd-8c71-54dc-b978da05a16e@oracle.com>
Date:   Fri, 3 Apr 2020 17:55:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004040006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004040007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:23 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Reset the host's page encryption bitmap related to kernel
> specific page encryption status settings before we load a
> new kernel by kexec. We cannot reset the complete
> page encryption bitmap here as we need to retain the
> UEFI/OVMF firmware specific settings.


Can the commit message mention why host page encryption needs to be 
reset ? Since the theme of these patches is guest migration in-SEV 
context, it might be useful to mention why the host context comes in here.

>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 8fcee0b45231..ba6cce3c84af 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -34,6 +34,7 @@
>   #include <asm/hypervisor.h>
>   #include <asm/tlb.h>
>   #include <asm/cpuidle_haltpoll.h>
> +#include <asm/e820/api.h>
>   
>   static int kvmapf = 1;
>   
> @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>   	 */
>   	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>   		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
> +	/*
> +	 * Reset the host's page encryption bitmap related to kernel
> +	 * specific page encryption status settings before we load a
> +	 * new kernel by kexec. NOTE: We cannot reset the complete
> +	 * page encryption bitmap here as we need to retain the
> +	 * UEFI/OVMF firmware specific settings.
> +	 */
> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
> +		(smp_processor_id() == 0)) {
> +		unsigned long nr_pages;
> +		int i;
> +
> +		for (i = 0; i < e820_table->nr_entries; i++) {
> +			struct e820_entry *entry = &e820_table->entries[i];
> +			unsigned long start_pfn, end_pfn;
> +
> +			if (entry->type != E820_TYPE_RAM)
> +				continue;
> +
> +			start_pfn = entry->addr >> PAGE_SHIFT;
> +			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
> +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
> +
> +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +				entry->addr, nr_pages, 1);
> +		}
> +	}
>   	kvm_pv_disable_apf();
>   	kvm_disable_steal_time();
>   }
