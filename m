Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356E8190359
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 02:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCXBig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 21:38:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:28454 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgCXBif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 21:38:35 -0400
IronPort-SDR: fptz7yYNEIC+i9q+pRreHWp5nBmNGQ80F8E60IJjFq5VjceYcMNeBXD2OEjV4OqX3I5/8nzzom
 T0cRm0fYCOVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 18:38:35 -0700
IronPort-SDR: Fp1vKMVheC0S+iVbmeEbtCgRPQYmeZ6Q4gBmT7xJ1Z6eA3qxqgXym6lxe3arpUuN6y/M6jSVHp
 0qNSGsz04L3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,298,1580803200"; 
   d="scan'208";a="270169232"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.31.120]) ([10.255.31.120])
  by fmsmga004.fm.intel.com with ESMTP; 23 Mar 2020 18:38:31 -0700
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
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <e708f6d2-8f96-903c-0bce-2eeecc4a237d@intel.com>
Date:   Tue, 24 Mar 2020 09:38:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87r1xjov3a.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/24/2020 1:10 AM, Thomas Gleixner wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> Change sld_off to sld_disable, which means disabling feature split lock
>> detection and it cannot be used in kernel nor can kvm expose it guest.
>> Of course, the X86_FEATURE_SPLIT_LOCK_DETECT is not set.
>>
>> Add a new optioin sld_kvm_only, which means kernel turns split lock
>> detection off, but kvm can expose it to guest.
> 
> What's the point of this? If the host is not clean, then you better fix
> the host first before trying to expose it to guests.

It's not about whether or not host is clean. It's for the cases that 
users just don't want it enabled on host, to not break the applications 
or drivers that do have split lock issue.

> Thanks,
> 
>          tglx
> 

