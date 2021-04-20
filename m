Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316C1365321
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 09:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhDTHVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 03:21:35 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57171 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229763AbhDTHVe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 03:21:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 041E31940A99;
        Tue, 20 Apr 2021 03:21:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 20 Apr 2021 03:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1HXd7o
        6qRyET34NshJ/o0HaQujmE6n8sajMkZ0L+2xI=; b=LPefViur9+fE/45nV1Q3yv
        lIJP3gmAnRV0wlfqRv1KRyYAcmhsSQmb3a3Ty66VaIXcATTx6HXpJVy9GhYGaHYo
        +JD2mGiqJcYnkwBPnhE7EfgLOndQlDT/lVVGEAmeQMLJJD/RnVwV8vBTkGjgUjSn
        FcAX/uqaOtH0+x1sSP08H0XFZSazmaAXIwtkxtzi7g5dOZzw2Zp6AOFVrM9OBHRd
        WG3Xw9y/5f1pskfXAr+mzMx5FehJtIAAGPGV4nBx0JSpxaaTgJ8HDgkUIFp3a9b8
        gUT7vsGFoBxkWmwSLzjP/RBFZoN5+p7eWUeXd+w6bLkPVmVhoSKLNalr+YTsj97Q
        ==
X-ME-Sender: <xms:3oB-YF9hnkx_l8N7v0YTlUCQhxcv8AyjMopxUgxqdcrsZbLPVJJl3Q>
    <xme:3oB-YJvrdFhxD454P38OtoTFjqcbtOmCVvYJgzk1cNbu659OJRtFGsQEogLVEVzdo
    mT2vXukamybeQiJbr8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddthedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdfotddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    epgfdvudfhgfeuheejffeigffgveevudfgteegkedvlefggfeklefgtdeugfdvueegnecu
    kfhppeekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepughmvgesughmvgdrohhrgh
X-ME-Proxy: <xmx:3oB-YDDruUkvofAa2EmCWzCTNk7UIWfYFbaOqDTKmQaHBCuPZOPzDg>
    <xmx:3oB-YJevmSKpqFKZ8hx96D75eRjPO74PEEpMW8iBy4d3dnLE9GvNaQ>
    <xmx:3oB-YKMxqdzVVFG1dhSeU7TX205L49bk9CO-HDIxd2eimyLROAfCZw>
    <xmx:34B-YHqUG1bBvYadLrjKRBVzEsjTqbZR1qIlEKZRMPJAMRTS_1IVSw>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id D19F3108005B;
        Tue, 20 Apr 2021 03:21:01 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 1c027af2;
        Tue, 20 Apr 2021 07:21:00 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
In-Reply-To: <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <cunblaaqwe0.fsf@dme.org>
 <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Tue, 20 Apr 2021 08:21:00 +0100
Message-ID: <cunzgxtctgj.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-04-19 at 09:47:19 -07, Aaron Lewis wrote:

>> > Add a fallback mechanism to the in-kernel instruction emulator that
>> > allows userspace the opportunity to process an instruction the emulator
>> > was unable to.  When the in-kernel instruction emulator fails to process
>> > an instruction it will either inject a #UD into the guest or exit to
>> > userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
>> > not know how to proceed in an appropriate manner.  This feature lets
>> > userspace get involved to see if it can figure out a better path
>> > forward.
>>
>> Given that you are intending to try and handle the instruction in
>> user-space, it seems a little odd to overload the
>> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION exit reason/sub
>> error.
>>
>> Why not add a new exit reason, particularly given that the caller has to
>> enable the capability to get the relevant data? (It would also remove
>> the need for the flag field and any mechanism for packing multiple bits
>> of detail into the structure.)
>
> I considered that, but I opted for the extensibility of the exiting
> KVM_EXIT_INTERNAL_ERROR instead.  To me it was six of one or half a
> dozen of the other.  With either strategy I still wanted to provide
> for future extensibility, and had a flags field in place.  That way we
> can add to this in the future if we find something that is missing
> (ie: potentially wanting a way to mark dirty pages, possibly passing a
> fault address, etc...)

How many of the flag based optional fields do you anticipate needing for
any one particular exit scenario?

If it's one, then using the flags to disambiguate the emulation failure
cases after choosing to stuff all of the cases into
KVM_EXIT_INTERNAL_ERROR / KVM_INTERNAL_ERROR_EMULATION would be odd.

(I'm presuming that it's not one, but don't understand the use case.)

>> > +/*
>> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
>> > + * to describe what is contained in the exit struct.  The flags are used to
>> > + * describe it's contents, and the contents should be in ascending numerical
>> > + * order of the flag values.  For example, if the flag
>> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
>> > + * length and instruction bytes would be expected to show up first because this
>> > + * flag has the lowest numerical value (1) of all the other flags.
>> > + */
>> > +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
>> > +
>> >  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>> >  struct kvm_run {
>> >       /* in */
>> > @@ -382,6 +393,14 @@ struct kvm_run {
>> >                       __u32 ndata;
>> >                       __u64 data[16];
>> >               } internal;
>> > +             /* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
>> > +             struct {
>> > +                     __u32 suberror;
>> > +                     __u32 ndata;
>> > +                     __u64 flags;
>> > +                     __u8  insn_size;
>> > +                     __u8  insn_bytes[15];
>> > +             } emulation_failure;
>> > +/*
>> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
>> > + * to describe what is contained in the exit struct.  The flags are used to
>> > + * describe it's contents, and the contents should be in ascending numerical
>> > + * order of the flag values.  For example, if the flag
>> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
>> > + * length and instruction bytes would be expected to show up first because this
>> > + * flag has the lowest numerical value (1) of all the other flags.
>>
>> When adding a new flag, do I steal bytes from insn_bytes[] for my
>> associated payload? If so, how many do I have to leave?
>>
>
> The emulation_failure struct mirrors the internal struct, so if you
> are just adding to what I have, you can safely add up to 16 __u64's.
> I'm currently using the size equivalent to 3 of them (flags,
> insn_size, insn_bytes), so there should be plenty of space left for
> you to add what you need to the end.  Just add the fields you need to
> the end of emulation_failure struct, increase 'ndata' to the new
> count, add a new flag to 'flags' so we know its contents.

My apologies, I mis-read the u8 as u64, so figured that you'd eaten all
of the remaining space.

dme.
-- 
I walk like a building, I never get wet.
