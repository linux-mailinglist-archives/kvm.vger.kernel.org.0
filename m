Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6522A3CE4
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 07:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgKCGjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 01:39:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:58006 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCGjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 01:39:37 -0500
IronPort-SDR: S3koBqzRcXec5ttgu4tG+5FJrp76Dd3gPqSuCLX0koK4+cDhAaZWLUBiTtHxDeWwfZkKoZQr2a
 2s8cwQ54G5pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="148862341"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="148862341"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 22:39:36 -0800
IronPort-SDR: 6lkR3ZW/8tjkAqo80ALm8oSLHurpDG7odCSNga5o9RSrrcu8HwE9ZJRrFXmqIOCKNEFsfd2q8r
 ppdFrrxigaMQ==
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="470673893"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.118]) ([10.239.13.118])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 22:39:32 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <20201102173130.GC21563@linux.intel.com>
 <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
 <8e41101c-6278-3773-8754-ffe0763eaeea@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <06dbea28-4b4a-4f73-2ad2-9b76a8ca4704@intel.com>
Date:   Tue, 3 Nov 2020 14:39:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <8e41101c-6278-3773-8754-ffe0763eaeea@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/2020 2:25 AM, Paolo Bonzini wrote:
> On 02/11/20 19:01, Andy Lutomirski wrote:
>> What's the point?  Surely the kernel should reliably mitigate the
>> flaw, and the kernel should decide how to do so.
> 
> There is some slowdown in trapping #DB and #AC unconditionally.  Though
> for these two cases nobody should care so I agree with keeping the code
> simple and keeping the workaround.

OK.

> Also, why would this trigger after more than a few hundred cycles,
> something like the length of the longest microcode loop?  HZ*10 seems
> like a very generous estimate already.
> 

As Sean said in another mail, 1/10 tick should be a placeholder.
Glad to see all of you think it should be smaller. We'll come up with 
more reasonable candidate once we can test on real silicon.

