Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C01369839
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhDWRYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:24:25 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:43783 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhDWRYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 13:24:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0F5FD19404C5;
        Fri, 23 Apr 2021 13:23:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 23 Apr 2021 13:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kHVNLz
        WVTKEmUDZ7J3mrS8zQY4Nzk/Jv3noigt/lu4k=; b=LyDRnDYy1leaK2aOjLd3ut
        tOAa9kWRDZR2Hojb7D1aUI7+gFXNzyQId8gxgalaAocCakKVj9N1XdxchDqkUH1b
        HzcZN5wDT4ZtyF6dyX6PQiTcpnRm64UmM+oLqo66+1CoVoGhmTS7Va+SGjlVLiTg
        Ldb+AY+bio6F3bE9PLu9raAdl/Nl68mK2UNiVbwGVRjJp6XXsASTgaaxGnido78N
        boiZYU7Ln1Sm5R6c4UwV9jCcCOinBmW/ryXvxVRh6wYmg14XMfBg+c6N8m2z6GNq
        ZrZpiruR+U1QoOugHpexfcvv4Kqe90NSoMj4EGLzAI4OHGHPLO2iQmL1k99r2RAw
        ==
X-ME-Sender: <xms:oAKDYJpuT_3kiapydQRHAjAd4qwNl7F-AxQ6Xx6jLtTlF7AIVSpP4g>
    <xme:oAKDYLqPHgIXbr9FWocgw-EEXrB8kDfMaLRYdiIJU00W5IWT1WsFE16DRQu74foR4
    pX8t7yu4Urzx5w4OnM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdduvddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecu
    kfhppeekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepughmvgesughmvgdrohhrgh
X-ME-Proxy: <xmx:oAKDYGOm_B7pnhQTrv-SE6yDcC1RmbDnUh6IQF51Go1FmftE3qw1bg>
    <xmx:oAKDYE42N7FSgjpyAiN_RdBeLbt8pfdsXrokl7shkMM7y6RieYdrzw>
    <xmx:oAKDYI73d__wkZkWono73YEo5RnVr4cBKfeQTVLbhJQY3csxrKFw7w>
    <xmx:oQKDYGkutVNePzS1so805tdc1kJHne7wXZtdEssYrizY5jwX4XB47w>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 26F6D240054;
        Fri, 23 Apr 2021 13:23:44 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id a2303c6e;
        Fri, 23 Apr 2021 17:23:42 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
In-Reply-To: <YILo26WQNvZNmtX0@google.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org>
 <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org>
 <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org> <YILo26WQNvZNmtX0@google.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Fri, 23 Apr 2021 18:23:42 +0100
Message-ID: <cunbla4ncdd.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-04-23 at 15:33:47 GMT, Sean Christopherson wrote:

> On Thu, Apr 22, 2021, David Edmondson wrote:
>> On Wednesday, 2021-04-21 at 12:01:21 -07, Aaron Lewis wrote:
>> 
>> >> >
>> >> > I don't think this is a problem because the instruction bytes stream
>> >> > has irrelevant bytes in it anyway.  In the test attached I verify that
>> >> > it receives an flds instruction in userspace that was emulated in the
>> >> > guest.  In the stream that comes through insn_size is set to 15 and
>> >> > the instruction is only 2 bytes long, so the stream has irrelevant
>> >> > bytes in it as far as this instruction is concerned.
>> >>
>> >> As an experiment I added[1] reporting of the exit reason using flag 2. On
>> >> emulation failure (without the instruction bytes flag enabled), one run
>> >> of QEMU reported:
>> >>
>> >> > KVM internal error. Suberror: 1
>> >> > extra data[0]: 2
>> >> > extra data[1]: 4
>> >> > extra data[2]: 0
>> >> > extra data[3]: 31
>> >> > emulation failure
>> >>
>> >> data[1] and data[2] are not indicated as valid, but it seems unfortunate
>> >> that I got (not really random) garbage there.
>> >>
>> >> Admittedly, with only your patches applied ndata will never skip past
>> >> any bytes, as there is only one flag. As soon as I add another, is it my
>> >> job to zero out those unused bytes? Maybe we should be clearing all of
>> >> the payload at the top of prepare_emulation_failure_exit().
>> >>
>> >
>> > Clearing the bytes at the top of prepare_emulation_failure_exit()
>> > sounds good to me.  That will keep the data more deterministic.
>> > Though, I will say that I don't think that is required.  If the first
>> > flag isn't set the data shouldn't be read, no?
>> 
>> Agreed. As Jim indicated in his other reply, there should be no new data
>> leaked by not zeroing the bytes.
>> 
>> For now at least, this is not a performance critical path, so clearing
>> the payload doesn't seem too onerous.
>
> I feel quite strongly that KVM should _not_ touch the unused bytes.

I'm fine with that, but...

> As Jim pointed out, a stream of 0x0 0x0 0x0 ... is not benign, it will
> decode to one or more ADD instructions.  Arguably 0x90, 0xcc, or an
> undending stream of prefixes would be more appropriate so that it's
> less likely for userspace to decode a bogus instruction.

...I don't understand this position. If the user-level instruction
decoder starts interpreting bytes that the kernel did *not* indicate as
valid (by setting insn_size to include them), it's broken.

> I don't see any reason why unused insn bytes should be treated any differently
> than unused mmio.data[], or unused internal.data[], etc... 
>
> IMO, the better option is to do nothing and let userspace initialize vcpu->run
> before KVM_RUN if they want to avoid consuming stale data.  

dme.
-- 
I've still got sand in my shoes.
