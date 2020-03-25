Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B02D191E41
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 01:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCYAnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 20:43:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:50926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgCYAnH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 20:43:07 -0400
IronPort-SDR: alN7Zp/saue5gOkOyX1Ba3Tg524duSalNTbPCMbr8bPqTl8Twum4p2HOGF0palRj/DLbtLWssV
 yvVnrKVlB3Bg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 17:43:06 -0700
IronPort-SDR: 5x9pluvj3vih6iam46DUyNlA84aL25H7zFoleAvJSJQXRW2uzeJq6xIWhww3X5E7Nr8FaVNC95
 PuubS928RoYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,302,1580803200"; 
   d="scan'208";a="446454348"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.170.28]) ([10.249.170.28])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2020 17:43:02 -0700
Subject: Re: [PATCH v5 3/9] x86/split_lock: Re-define the kernel param option
 for split_lock_detect
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
 <20200315050517.127446-4-xiaoyao.li@intel.com>
 <87r1xjov3a.fsf@nanos.tec.linutronix.de>
 <e708f6d2-8f96-903c-0bce-2eeecc4a237d@intel.com>
 <87r1xidoj1.fsf@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <54b2b9b5-2307-b5da-6b63-319e9626bcc1@intel.com>
Date:   Wed, 25 Mar 2020 08:43:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87r1xidoj1.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2020 6:40 PM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>> On 3/24/2020 1:10 AM, Thomas Gleixner wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> Change sld_off to sld_disable, which means disabling feature split lock
>>>> detection and it cannot be used in kernel nor can kvm expose it guest.
>>>> Of course, the X86_FEATURE_SPLIT_LOCK_DETECT is not set.
>>>>
>>>> Add a new optioin sld_kvm_only, which means kernel turns split lock
>>>> detection off, but kvm can expose it to guest.
>>>
>>> What's the point of this? If the host is not clean, then you better fix
>>> the host first before trying to expose it to guests.
>>
>> It's not about whether or not host is clean. It's for the cases that
>> users just don't want it enabled on host, to not break the applications
>> or drivers that do have split lock issue.
> 
> It's very much about whether the host is split lock clean.
> 
> If your host kernel is not, then this wants to be fixed first. If your
> host application is broken, then either fix it or use "warn".
> 

My thought is for CSPs that they might not turn on SLD on their product 
environment. Any split lock in kernel or drivers may break their service 
for tenants.

