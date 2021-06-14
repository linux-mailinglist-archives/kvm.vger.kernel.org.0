Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF143A6B8B
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 18:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhFNQXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 12:23:19 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:34539 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234626AbhFNQXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 12:23:18 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 420041940334;
        Mon, 14 Jun 2021 12:21:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 14 Jun 2021 12:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uKVU1s
        66+0tQ8fTEmxuWUNwMS4pSH8TgLhqUisUlk/4=; b=XXFN97XLt6deaKHDtN/f5m
        7YmJjgnpJA2kB8Xs8kMywB3nRipwqNHuDWuGt25KwjYRTFz9yrh6XQffv3+B6Htj
        8j9A9/Qx+XaZ2kL6msMp5jmsMCQC20qA3YrxfyyAB/Epp6YUzLUFYiJ6up0KRbXQ
        XSIcV6+vCeIgpspQrIx71AWJ/4pRRBL9NWxpvAaLwzl3aWTpY+UUGWdwh59L9glp
        SPx3pGPsj7wMrZh1GMdD3m2SF7hLsDjvZDPauvLFGvaHPtlFSVzx8jGOam6YdLhy
        miHc1MS2WIitVqhWGY6tgMBLXc7b1LRqWhw9rxzIRmWjBW2yNTGoG/ADeaC2IDDw
        ==
X-ME-Sender: <xms:-oHHYM_jyC3azcVzZOKkr41Jw5yLHnTiMHcpvK6AucTusjD0BL1O-Q>
    <xme:-oHHYEsV_8cCYEd3vIDU2uWyHPfnWKHPNl5IykPtBngY-xo-tNhY1E2BcD6M1i8DD
    TfGkGQr10uZWLXHNFQ>
X-ME-Received: <xmr:-oHHYCDLQfd8tQfJvIhvte4UGQhDC7O-Gys8zvBqrvLfbrpmhqcpNPK91Ki5U5VgjjQkvc9PpY5pW8mUFCJW974DTrWsYTks7ciJWv1999g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvhedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegumhgvsegumh
    gvrdhorhhg
X-ME-Proxy: <xmx:-oHHYMeo5akcnHl-tmAzrmjduREfDCpgTyRyNUURDGZa9jTlaxxfFw>
    <xmx:-oHHYBNrIxL7dET8c3WuKrT4-aN60fLnCg3reZCf3PhiEWJZ7CeLJA>
    <xmx:-oHHYGlFsjv0ZfDv01DoDM5ZI3lmqP14Wk9hoi-6R_3JMbR-pK2cvw>
    <xmx:-4HHYEeIVH7uzNxhfReP9hB3uFugSnb8KjWW8urrusVfSyvr6C1Sdw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Jun 2021 12:21:13 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 13ec9a44;
        Mon, 14 Jun 2021 16:21:12 +0000 (UTC)
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>
Subject: Re: [RFC PATCH 0/7] Support protection keys in an AMD EPYC-Milan VM
In-Reply-To: <330417d8-9e23-4c90-b825-24329d3e4c66@redhat.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
 <330417d8-9e23-4c90-b825-24329d3e4c66@redhat.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Mon, 14 Jun 2021 17:21:12 +0100
Message-ID: <cuno8c81kp3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-06-11 at 18:01:55 +02, Paolo Bonzini wrote:

> First of all, sorry for the delayed review.
>
> On 20/05/21 16:56, David Edmondson wrote:
>> AMD EPYC-Milan CPUs introduced support for protection keys, previously
>> available only with Intel CPUs.
>> 
>> AMD chose to place the XSAVE state component for the protection keys
>> at a different offset in the XSAVE state area than that chosen by
>> Intel.
>> 
>> To accommodate this, modify QEMU to behave appropriately on AMD
>> systems, allowing a VM to properly take advantage of the new feature.
>
> Uff, that sucks. :(
>
> If I understand correctly, the problem is that the layout of 
> KVM_GET_XSAVE/KVM_SET_XSAVE depends on the host CPUID, which in 
> retrospect would be obvious.  Is that correct?

Yes.

> If so, it would make sense and might even be easier to drop all usage
> of X86XSaveArea:
>
> * update ext_save_areas based on CPUID information in kvm_cpu_instance_init
>
> * make x86_cpu_xsave_all_areas and x86_cpu_xrstor_all_areas use the 
> ext_save_areas offsets to build pointers to XSaveAVX, XSaveBNDREG, etc.
>
> What do you think?

I will produce a patch and send it out.

> Paolo
>
>> Further, avoid manipulating XSAVE state components that are not
>> present on AMD systems.
>> 
>> The code in patch 6 that changes the CPUID 0x0d leaf is mostly dumped
>> somewhere that seemed to work - I'm not sure where it really belongs.
>> 
>> David Edmondson (7):
>>    target/i386: Declare constants for XSAVE offsets
>>    target/i386: Use constants for XSAVE offsets
>>    target/i386: Clarify the padding requirements of X86XSaveArea
>>    target/i386: Prepare for per-vendor X86XSaveArea layout
>>    target/i386: Introduce AMD X86XSaveArea sub-union
>>    target/i386: Adjust AMD XSAVE PKRU area offset in CPUID leaf 0xd
>>    target/i386: Manipulate only AMD XSAVE state on AMD
>> 
>>   target/i386/cpu.c            | 19 +++++----
>>   target/i386/cpu.h            | 80 ++++++++++++++++++++++++++++--------
>>   target/i386/kvm/kvm.c        | 57 +++++++++----------------
>>   target/i386/tcg/fpu_helper.c | 20 ++++++---
>>   target/i386/xsave_helper.c   | 70 +++++++++++++++++++------------
>>   5 files changed, 152 insertions(+), 94 deletions(-)
>> 

dme.
-- 
Oliver darling, call Mister Haney, I think our speakers are blown.
