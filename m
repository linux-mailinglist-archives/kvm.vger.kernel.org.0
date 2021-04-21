Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2193670D3
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244429AbhDURCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 13:02:13 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:43407 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238561AbhDURCM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 13:02:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5602F19405F2;
        Wed, 21 Apr 2021 13:01:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 21 Apr 2021 13:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UoMkny
        mZx4NvQd9TodeVgpKOTMmJXzw8dSn0ToCN5hI=; b=FeApdzinKKsfQcgLwTg9Cq
        I7QG7gSFQFw4JiFYbapLWfsKw/JB/xHbLbCRy19JlvTfu7lLi1FtOnxk6Jj8v2aG
        JdUbGG85biGFvytgZ3NgLp+VIQPXTtsytE3G3p+o2kf/tt3myP+j6Eqh8VDyXugu
        x29FjlGdlLkTPSzXGQALtNdxCsrjA3E4W+M8IeeT5FmzBforIr2JIW8sxo5efmFM
        3e6k4168e/DHtTcR3rZc0vwRXvEuGnjmWGN0XO8kwCJVZVJ2aspVrhe573G2+9dE
        g1iNJmPJXtWWad2JUUNtjntqu8vctQX47Leh+cUXdf+1URQfnLqrz3Is4HEFkh2w
        ==
X-ME-Sender: <xms:cFqAYIRcKHq1P-cgb0HIcGeg8QilGDIVg-p9H24hX30ViYaEuseVrg>
    <xme:cFqAYFwY9E_3j7oiRuj3TF0ScY9un5_yw--u3HsNxuESnURnwjW89msKh7C62tF3m
    yz4puPxVqDG8k_eg3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtkedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecu
    kfhppeekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepughmvgesughmvgdrohhrgh
X-ME-Proxy: <xmx:cFqAYF1fAY1Ya4YzjKsuEvZ5YXtgo7mpT23BGw0_b0BzkYQ52IlO-g>
    <xmx:cFqAYMCU4hkslSp5QWR4cyOjZOd5HVLwIMaANPmUxIeOZOodBA9W9w>
    <xmx:cFqAYBiaYXQA66kK4VqXLfiuLc_NCDijksOst2IKm1hktvSleKG_QA>
    <xmx:cVqAYGv1BwygwQB3lHiqSLlJldI1uMUJesFx4j023BD8-XZTftqrJw>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 613291080066;
        Wed, 21 Apr 2021 13:01:36 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id ceaa5d8a;
        Wed, 21 Apr 2021 17:01:35 +0000 (UTC)
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
In-Reply-To: <CALMp9eQZLe_8esohDqt_0eLffOrAeC0vS1RSVw152z2RhmPntw@mail.gmail.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <YH8eyGMC3A9+CKTo@google.com> <m2sg3kt4jc.fsf@dme.org>
 <CALMp9eQZLe_8esohDqt_0eLffOrAeC0vS1RSVw152z2RhmPntw@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Wed, 21 Apr 2021 18:01:35 +0100
Message-ID: <cunpmynfu6o.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-04-21 at 09:26:34 -07, Jim Mattson wrote:

> On Wed, Apr 21, 2021 at 1:39 AM David Edmondson <dme@dme.org> wrote:
>>
>> On Tuesday, 2021-04-20 at 18:34:48 UTC, Sean Christopherson wrote:
>>
>> > On Fri, Apr 16, 2021, Aaron Lewis wrote:
>> >> +                    KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>> >> +            vcpu->run->emulation_failure.insn_size = insn_size;
>> >> +            memcpy(vcpu->run->emulation_failure.insn_bytes,
>> >> +                   ctxt->fetch.data, sizeof(ctxt->fetch.data));
>> >
>> > Doesn't truly matter, but I think it's less confusing to copy over insn_size
>> > bytes.
>
>> And zero out the rest?
>
> Why zero? Since we're talking about an instruction stream, wouldn't
> 0x90 make more sense than zero?

I'm not sure if you are serious or not.

Zero-ing out the rest was intended to be to avoid leaking any previous
emulated instruction stream. If the user-level code wants to start
looking for instructions after insn_bytes[insn_size], they get what they
deserve.

dme.
-- 
We're deep in discussion, the party's on mute.
