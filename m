Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AD535F3B7
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 14:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350898AbhDNMZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 08:25:53 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:43931 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230127AbhDNMZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 08:25:45 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7EFA01940C01;
        Wed, 14 Apr 2021 08:25:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 14 Apr 2021 08:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=peMn3b
        GHi1WbIZy2c9kwBJwQYy3D17/eXn3K+wzeHSM=; b=S+C98EjsHo22xiwKXPb9tm
        Xfmwqg1UwG+P2LhIutjoRwGVpRw4tHvZtNrNLBM+w+EUxahbQbchhS4O6ARDxQ2a
        dC60RqhXxVmcGVRyW/UrFnpxQF8q6iGFNLUvpgJk4XXFND+4oweu84Y+LrXjy1WK
        bW3TXz9h8PFJ28P8ACGjiXpoCgzN3EixAhLX48iTZ2szKaBiwO0xD7lqbk4USW8d
        E3i0cbATrqryoAo10hnRsYBTjXnXBa5yeIrhfU9aB8TGLN56UnL70f6dgMSUSost
        BGuPDdPpWzLBkXh+4om9eo2rKw6hEfPhv4v755/bHWUTPa6addMeO9sqRg+jrWFQ
        ==
X-ME-Sender: <xms:Lt92YHPMc7NL4DX_WMuOIhm4tTxKSwv565gjokivgjsI9vuI9XyUtg>
    <xme:Lt92YB979-3GezY6DNyIVFQvKKq_muVbpDaeaT-dDTSr4Kr5xQhaffqkNj6B2oJMv
    zXw3_6mAaImDwZ12O8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeluddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegurghvihgurdgvughmohhnughsohhnsehorhgrtghlvgdrtg
    homheqnecuggftrfgrthhtvghrnhepheelfeefudeiudegudelgfetgeetkeelveeuieet
    udelheejkeeileekveeukedtnecukfhppeekuddrudekjedrvdeirddvfeeknecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggrvhhiugdrvggu
    mhhonhgushhonhesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:Lt92YGSe8QTMoMtraLlBprpQCDjQ-ny6kFi5u9z1MG0YUM06v7QtXw>
    <xmx:Lt92YLu0QTBqkFyFsHvzdovQboOZl5yDU3h2hM6Qd8h4aH0pRGvbPw>
    <xmx:Lt92YPe5AZcI-Gn8C23QQB8GcsDMv2oKSfJr98lLGPN_Vt9UtVX-xw>
    <xmx:Mt92YF8YYrvsGBiVG1iZDjXB6GxYrZMBLOTwCo1lDW6SxvlRqy7fNHn6qo0>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64B6D108005C;
        Wed, 14 Apr 2021 08:25:17 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 9b99a0ff;
        Wed, 14 Apr 2021 12:25:15 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH 5/6] KVM: SVM: pass a proper reason in
 kvm_emulate_instruction()
In-Reply-To: <CAAAPnDGy2MZF2QVTTdNQgQC3Sh9mOjJx-cetn2nZ4cu6-h1Zvg@mail.gmail.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
 <20210412130938.68178-6-david.edmondson@oracle.com>
 <YHRvchkUSIeU8tRR@google.com> <cuno8eisbf9.fsf@oracle.com>
 <CAAAPnDGy2MZF2QVTTdNQgQC3Sh9mOjJx-cetn2nZ4cu6-h1Zvg@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <david.edmondson@oracle.com>
X-Now-Playing: Floating Points - Elaenia: Nespole
Date:   Wed, 14 Apr 2021 13:25:15 +0100
Message-ID: <cun8s5lrr2s.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 2021-04-13 at 11:45:52 -07, Aaron Lewis wrote:

>>
>> > Depending on what you're trying to do with the info, maybe there's a better
>> > option.  E.g. Aaron is working on a series that includes passing pass the code
>> > stream (instruction bytes) to userspace on emulation failure, though I'm not
>> > sure if he's planning on providing the VM-Exit reason.
>>
>> Having the instruction stream will be good.
>>
>> Aaron: do you have anything to share now? In what time frame do you
>> think you might submit patches?
>
> I should be able to have something out later this week.  There is no
> exit reason as Sean indicated, so if that's important it will have to
> be reworked afterwards.  For struct internal in kvm_run I use data[0]
> for flags to indicate what's contained in the rest of it, I use
> data[1] as the instruction size, and I use data[2,3] to store the
> instruction bytes.  Hope that helps.

Thanks. I'll hang on to look at the patches before doing anything else.

dme.
-- 
Tell me sweet little lies.
