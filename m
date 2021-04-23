Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE5A3698B5
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 19:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhDWRzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 13:55:40 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:33005 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231684AbhDWRzk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 13:55:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C83821940836;
        Fri, 23 Apr 2021 13:55:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 23 Apr 2021 13:55:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=i3uV8a
        LA8ehOGhQIUDWM9t6kXfawL4hwrxc5/HF4rgA=; b=DrvoVNVcd5LQL5lxH6IBgy
        PmarIE9kD+HgeA7LIU+19srPDoApKxPbWf84l6O1CXkJ6JElaF00w8scgfNfcaiv
        wrP/plmJLcecgbGzBLHPiyw75yU9R3EUQ+b07fqY0GUrQVzbTAU+lfTMkS/MuXT9
        1cmBPBp9MUIIFFR/BXkA+KbMSN4eDAmDHHyHehTU8iNeC58MQeDoXMmBBRMOcR7q
        TIUEbKWM7kN3/6/25u3lE9NtYWjNAB9Z4Xx4m0iXbqr4L+IJIKAZ3G9qvz57p7UN
        ZQW+KRDTraGRxR9rn6lbxwj6FDGrj1fsN55AOdEpmwLCCKGsqAsjd984SfHRGM6w
        ==
X-ME-Sender: <xms:9gmDYIaLVNAEJzpL4VYj3rJqP_Gi7Rb7q9fGc16Ocu4r_5fY654tjg>
    <xme:9gmDYDbo18RBfwfDCptiWJQt-ooY7GEdCC6X4V2t0uiEBVLAqmnciVGj1QqXZYaD-
    3-Y6Ur1RMavnsmd508>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdduvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecu
    kfhppeekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepughmvgesughmvgdrohhrgh
X-ME-Proxy: <xmx:9gmDYC-7tqdT3iYcmCKipAjOcJ0PFYDsGklzQa46MYps-9iwkCQfrQ>
    <xmx:9gmDYCpZMSui5BYDn3asQ43aJMxv8qJ1e1g9F1Am-m4KR23QY-VW2g>
    <xmx:9gmDYDp3GpUJZv3cwgsKKx2jgSg-C2RpmAxwiuvcurH7V93dmS8Beg>
    <xmx:9gmDYCXeM6wN-j1BYhuWxgwXBz2PbJuCc3rrkWIr-hcqQVaBdQMgUQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65B30240054;
        Fri, 23 Apr 2021 13:55:01 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id ee94bade;
        Fri, 23 Apr 2021 17:55:00 +0000 (UTC)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
In-Reply-To: <YIMF8b2jD3b8IfPP@google.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org>
 <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org>
 <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
 <cunk0oug2t3.fsf@dme.org> <YILo26WQNvZNmtX0@google.com>
 <cunbla4ncdd.fsf@dme.org> <YIMF8b2jD3b8IfPP@google.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Fri, 23 Apr 2021 18:55:00 +0100
Message-ID: <cun8s58nax7.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-04-23 at 17:37:53 GMT, Sean Christopherson wrote:

> On Fri, Apr 23, 2021, David Edmondson wrote:
>> On Friday, 2021-04-23 at 15:33:47 GMT, Sean Christopherson wrote:
>> 
>> > On Thu, Apr 22, 2021, David Edmondson wrote:
>> >> Agreed. As Jim indicated in his other reply, there should be no new data
>> >> leaked by not zeroing the bytes.
>> >> 
>> >> For now at least, this is not a performance critical path, so clearing
>> >> the payload doesn't seem too onerous.
>> >
>> > I feel quite strongly that KVM should _not_ touch the unused bytes.
>> 
>> I'm fine with that, but...
>> 
>> > As Jim pointed out, a stream of 0x0 0x0 0x0 ... is not benign, it will
>> > decode to one or more ADD instructions.  Arguably 0x90, 0xcc, or an
>> > undending stream of prefixes would be more appropriate so that it's
>> > less likely for userspace to decode a bogus instruction.
>> 
>> ...I don't understand this position. If the user-level instruction
>> decoder starts interpreting bytes that the kernel did *not* indicate as
>> valid (by setting insn_size to include them), it's broken.
>
> Yes, so what's the point of clearing the unused bytes?

Given that it doesn't prevent any known leakage, it's purely aesthetic,
which is why I'm happy not to bother.

> Doing so won't magically fix a broken userspace.  That's why I argue
> that 0x90 or 0xcc would be more appropriate; there's at least a
> non-zero chance that it will help userspace avoid doing something
> completely broken.

Perhaps an invalid instruction would be more useful in this respect, but
INT03 fills a similar purpose.

> On the other hand, userspace can guard against a broken _KVM_ by initializing
> vcpu->run with a known pattern and logging if KVM exits to userspace with
> seemingly bogus data.  Crushing the unused bytes to zero defeats userspace's
> sanity check, e.g. if the actual memcpy() of the instruction bytes copies the
> wrong number of bytes, then userspace's magic pattern will be lost and debugging
> the KVM bug will be that much harder.
>
> This is very much not a theoretical problem, I have debugged two separate KVM
> bugs in the last few months where KVM completely failed to set
> vcpu->run->exit_reason before exiting to userspace.  The exit_reason is a bit of
> a special case because it's disturbingly easy for KVM to get confused over return
> values and unintentionally exit to userspace, but it's not a big stretch to
> imagine a bug where KVM provides incomplete data.

Understood.

So is the conclusion that KVM should copy only insn_size bytes rather
than the full 15?

dme.
-- 
But they'll laugh at you in Jackson, and I'll be dancin' on a Pony Keg.
