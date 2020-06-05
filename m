Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEB21EF0E2
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 07:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgFEF2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 01:28:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:53954 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFEF2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 01:28:37 -0400
IronPort-SDR: 86Rdj9+9oNVf+GJ+pFlp4JwpuZw0icTrPgomEO4PKbvjb75aBKFGnc7tgqvg4Aqn2aVlguDVuT
 0L3O9dOeQidg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 22:28:36 -0700
IronPort-SDR: pN9jXbrqreLPPzqVaq6579ivo3BNGw+0474VgHEZeNIqsBeMX6KQ+f/uT0VaZ1ySzQTmnWiJEz
 5viEeRJqKQ7A==
X-IronPort-AV: E=Sophos;i="5.73,475,1583222400"; 
   d="scan'208";a="417160467"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.141]) ([10.238.4.141])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 22:28:32 -0700
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIXVt2Nl0gS1ZNOiBYODY6IHN1cHBvcnQg?=
 =?UTF-8?Q?APERF/MPERF_registers?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        "like.xu@intel.com" <like.xu@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "xiaoyao.li@intel.com" <xiaoyao.li@intel.com>,
        "wei.huang2@amd.com" <wei.huang2@amd.com>
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <be39b88c-bfb7-0634-c53b-f00d8fde643c@intel.com>
 <c21c6ffa19b6483ea57feab3f98f279c@baidu.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <3a88bd63-ff51-ad70-d92e-893660c63bca@linux.intel.com>
Date:   Fri, 5 Jun 2020 13:28:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <c21c6ffa19b6483ea57feab3f98f279c@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/6/5 12:23, Li,Rongqing wrote:
> 
> 
>> -----邮件原件-----
>> 发件人: Xu, Like [mailto:like.xu@intel.com]
>> 发送时间: 2020年6月5日 10:32
>> 收件人: Li,Rongqing <lirongqing@baidu.com>
>> 抄送: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; x86@kernel.org;
>> hpa@zytor.com; bp@alien8.de; mingo@redhat.com; tglx@linutronix.de;
>> jmattson@google.com; wanpengli@tencent.com; vkuznets@redhat.com;
>> sean.j.christopherson@intel.com; pbonzini@redhat.com; xiaoyao.li@intel.com;
>> wei.huang2@amd.com
>> 主题: Re: [PATCH][v6] KVM: X86: support APERF/MPERF registers
>>
>> Hi RongQing,
>>
>> On 2020/6/5 9:44, Li RongQing wrote:
>>> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo, this is
>>> confused to user when turbo is enable, and aperf/mperf can be used to
>>> show current cpu frequency after 7d5905dc14a
>>> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
>>> so guest should support aperf/mperf capability
>>>
>>> This patch implements aperf/mperf by three mode: none, software
>>> emulation, and pass-through
>>>
>>> None: default mode, guest does not support aperf/mperf
>> s/None/Note
>>>
>>> Software emulation: the period of aperf/mperf in guest mode are
>>> accumulated as emulated value
>>>
>>> Pass-though: it is only suitable for KVM_HINTS_REALTIME, Because that
>>> hint guarantees we have a 1:1 vCPU:CPU binding and guaranteed no
>>> over-commit.
>> The flag "KVM_HINTS_REALTIME 0" (in the Documentation/virt/kvm/cpuid.rst)
>> is claimed as "guest checks this feature bit to determine that vCPUs are never
>> preempted for an unlimited time allowing optimizations".
>>
>> I couldn't see its relationship with "1:1 vCPU: pCPU binding".
>> The patch doesn't check this flag as well for your pass-through purpose.
>>
>> Thanks,
>> Like Xu
> 
> 
> I think this is user space jobs to bind HINT_REALTIME and mperf passthrough, KVM just do what userspace wants.
> 

That's fine for user space to bind HINT_REALTIME and mperf passthrough，
But I was asking why HINT_REALTIME means "1:1 vCPU: pCPU binding".

As you said, "Pass-though: it is only suitable for KVM_HINTS_REALTIME",
which means, KVM needs to make sure the kvm->arch.aperfmperf_mode value
could "only" be set to KVM_APERFMPERF_PT when the check
kvm_para_has_hint(KVM_HINTS_REALTIME) is passed.

Specifically, the KVM_HINTS_REALTIME is a per-kvm capability
while the kvm_aperfmperf_mode is a per-vm capability. It's unresolved.

KVM doesn't always do what userspace wants especially
you're trying to expose some features about
power and thermal management in the virtualization context.

> and this gives user space a possibility, guest has passthrough mperfaperf without HINT_REALTIME, guest can get coarse cpu frequency without performance effect if guest can endure error frequency occasionally
> 


> 
> -Li
> 

