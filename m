Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196551CCF01
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 03:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgEKBL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 May 2020 21:11:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:27119 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgEKBLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 May 2020 21:11:25 -0400
IronPort-SDR: Zk0CEAEfjn6BNluyu8sqM0Ju6CXo80bSthddHLNH60/C4eZQpHJ6rwv348qBAunm5Ct4KrizEY
 5Yi2SiBoy3GQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2020 18:11:25 -0700
IronPort-SDR: X1/b1LE/U4qllNa2jBZFNJAbMsIdFQTycsEsOUqOOjIQGgLAHcsMbjAGD0Lk3ZbPp42Ta4VbID
 VGInyfJkGKdQ==
X-IronPort-AV: E=Sophos;i="5.73,377,1583222400"; 
   d="scan'208";a="436487699"
Received: from unknown (HELO [10.239.13.122]) ([10.239.13.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2020 18:11:22 -0700
Subject: Re: [PATCH v9 8/8] x86/split_lock: Enable split lock detection
 initialization when running as an guest on KVM
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
 <20200509110542.8159-9-xiaoyao.li@intel.com>
 <CALCETrWJGyyyvsgryvro45WNNpnSZ2k_QEjm95-+5rvREztOYA@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <0f7b29e5-bf12-36f9-3b92-5fea8accf037@intel.com>
Date:   Mon, 11 May 2020 09:11:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWJGyyyvsgryvro45WNNpnSZ2k_QEjm95-+5rvREztOYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/2020 1:15 PM, Andy Lutomirski wrote:
> On Fri, May 8, 2020 at 8:04 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> When running as guest, enumerating feature split lock detection through
>> CPU model is not easy since CPU model is configurable by host VMM.
>>
>> If running upon KVM, it can be enumerated through
>> KVM_FEATURE_SPLIT_LOCK_DETECT,
> 
> This needs crystal clear documentation.  What, exactly, is the host
> telling the guest if it sets this flag?
> 
>> and if KVM_HINTS_SLD_FATAL is set, it
>> needs to be set to sld_fatal mode.
> 
> 
> This needs much better docs.  Do you mean:
> 
> "If KVM_HINTS_SLD_FATAL is set, then the guest will get #AC if it does
> a split-lock regardless of what is written to MSR_TEST_CTRL?"
> 

Hi Andy,

KVM_FEATURE_SPLIT_LOCK_DETECT, KVM_HINTS_SLD_FATAL and their docs are 
introduced in Patch 5. Do I still need to explain them in detail in this 
patch?
