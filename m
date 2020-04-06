Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F0219FD51
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 20:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgDFSiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 14:38:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33798 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDFSiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 14:38:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IXhuq008182;
        Mon, 6 Apr 2020 18:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=x7jn857T6+XVh/cUUNt5yuCqvNHZ55iH/LHch72QhQY=;
 b=GVSDdydPTYMLD1Hytn0OvUzmaqgrr4pgN35tAcAQQABYSEts0E0lDc5tYke+l2g5RaHX
 8UwXJxSjYEDrD4dd9m/5S61klBEOuqHoEuV2p8rUP24976wtmBw/3x1umBWXy1hjasq4
 6w9E8AHhyLxmTGREDKhSeM/YoDBIXfdobUYHtPGO58xgx2pw+U3Jw4yHjEfz6hH4Ar28
 ULtpVa6+bYaMlAAZ0dksVSfwxugLEe8LaXG2QfVaeymJJybgHEXlKD6fZ4HQzhORzRn5
 Uf/A1Ltnic2ONcEeFRbIhieW8jiqlKsy32LLCzz2YYKGoV+bRTsLUnlpOJO1h8dIyoJd 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 306j6m8myn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:37:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IWdsc041373;
        Mon, 6 Apr 2020 18:37:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3073sqedu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:37:54 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036Ibo4I009211;
        Mon, 6 Apr 2020 18:37:50 GMT
Received: from localhost.localdomain (/10.159.148.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:37:49 -0700
Subject: Re: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live
 Migration.
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
 <c5977ca2-2fbd-8c71-54dc-b978da05a16e@oracle.com>
 <20200404215741.GA29918@ashkalra_ubuntu_server>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <07da6b9a-29c5-59cc-518c-0356126f2181@oracle.com>
Date:   Mon, 6 Apr 2020 11:37:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200404215741.GA29918@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060145
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/4/20 2:57 PM, Ashish Kalra wrote:
> The host's page encryption bitmap is maintained for the guest to keep the encrypted/decrypted state
> of the guest pages, therefore we need to explicitly mark all shared pages as encrypted again before
> rebooting into the new guest kernel.
>
> On Fri, Apr 03, 2020 at 05:55:52PM -0700, Krish Sadhukhan wrote:
>> On 3/29/20 11:23 PM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Reset the host's page encryption bitmap related to kernel
>>> specific page encryption status settings before we load a
>>> new kernel by kexec. We cannot reset the complete
>>> page encryption bitmap here as we need to retain the
>>> UEFI/OVMF firmware specific settings.
>>
>> Can the commit message mention why host page encryption needs to be reset ?
>> Since the theme of these patches is guest migration in-SEV context, it might
>> be useful to mention why the host context comes in here.
>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>    arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
>>>    1 file changed, 28 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index 8fcee0b45231..ba6cce3c84af 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -34,6 +34,7 @@
>>>    #include <asm/hypervisor.h>
>>>    #include <asm/tlb.h>
>>>    #include <asm/cpuidle_haltpoll.h>
>>> +#include <asm/e820/api.h>
>>>    static int kvmapf = 1;
>>> @@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
>>>    	 */
>>>    	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>>>    		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
>>> +	/*
>>> +	 * Reset the host's page encryption bitmap related to kernel
>>> +	 * specific page encryption status settings before we load a
>>> +	 * new kernel by kexec. NOTE: We cannot reset the complete
>>> +	 * page encryption bitmap here as we need to retain the
>>> +	 * UEFI/OVMF firmware specific settings.
>>> +	 */
>>> +	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
>>> +		(smp_processor_id() == 0)) {
>>> +		unsigned long nr_pages;
>>> +		int i;
>>> +
>>> +		for (i = 0; i < e820_table->nr_entries; i++) {
>>> +			struct e820_entry *entry = &e820_table->entries[i];
>>> +			unsigned long start_pfn, end_pfn;
>>> +
>>> +			if (entry->type != E820_TYPE_RAM)
>>> +				continue;
>>> +
>>> +			start_pfn = entry->addr >> PAGE_SHIFT;
>>> +			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
>>> +			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
>>> +
>>> +			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
>>> +				entry->addr, nr_pages, 1);
>>> +		}
>>> +	}
>>>    	kvm_pv_disable_apf();
>>>    	kvm_disable_steal_time();
>>>    }

Thanks for the explanation. It will certainly help one understand the 
context better if you add it to the commit message.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

