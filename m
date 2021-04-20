Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736FF365E1A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 19:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhDTRC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 13:02:57 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:51953 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233305AbhDTRC4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 13:02:56 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 13:02:56 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B0C833BD4;
        Tue, 20 Apr 2021 12:53:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 20 Apr 2021 12:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cKp2Xd
        ce/YCF6NXRThqermvCsoe8zQNNncSOXUjnO24=; b=fi8qzmh8mDtZveNTxx7EyO
        yvDMYjXGTAuOXnsrMRKTvEhCBvBdlszsYtmgFqP/naLnrKrmiJVihMwLobeuA7iC
        hESESxGmFVwOQGM1tsO22pHYeFs3alKXiSMWrsadbQyW9OmdfciNWgHHbYjkW7CP
        Wx1YzwRodkXbCL0enq4wdXWPb6OfyF7bRSAcu9oQLAdOne1HTKdPHPJtMxLaa3/r
        RpSTOXg+gTAtIfOLYFnwBLALI8xlcFm4IaH8STm8v0jNbV5O+ZTh1ZrbYgLk5RWO
        ixNiW4rZLHsOybeWvq4gMwmIWbSxTpkJta7cLA+PVDXtm15OSA6NRVFEY8sOPXsg
        ==
X-ME-Sender: <xms:FQd_YGPc6rj4P_pGGiqVMhCEdIXq8_0e7l-LnLwwjwOyY-zx68phsw>
    <xme:FQd_YE_kOgtcFYsHDnl3qtYUy23qS-auSa34yW3q-wmS8Tq1SO3jcNkyzyD1mZen6
    U9ETnK4iPi8dDP09ow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtiedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihgu
    ucfgughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecu
    kfhppeekuddrudekjedrvdeirddvfeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepughmvgesughmvgdrohhrgh
X-ME-Proxy: <xmx:FQd_YNSHZqO8MkAEycowcPAXGH3o3fBkDcHT0pvYL6Am6oF4NHccCw>
    <xmx:FQd_YGu5AwWtSObNmhr2H8KtpRyChCqdGaq565gq5ylWgVvhjXOBXA>
    <xmx:FQd_YOfYE3DafP5kIhA_r7h0x9WSUGumpIeztI_IK9Z6YSQjYQBFhQ>
    <xmx:Fgd_YO5uci9fvY7yo0DriK5huLCEVgFc9tp5_8j__ho0ank7dnMpxYlMYgI>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5653A24005B;
        Tue, 20 Apr 2021 12:53:41 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 31cc8f06;
        Tue, 20 Apr 2021 16:53:40 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
In-Reply-To: <CAAAPnDGnY76C-=FppsiL=OFY-ei8kHeJhfK_tNV8of3JHBZ0FA@mail.gmail.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <cunblaaqwe0.fsf@dme.org>
 <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
 <cunzgxtctgj.fsf@dme.org>
 <CAAAPnDGnY76C-=FppsiL=OFY-ei8kHeJhfK_tNV8of3JHBZ0FA@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Tue, 20 Apr 2021 17:53:40 +0100
Message-ID: <cunbla8c2y3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, 2021-04-20 at 07:57:27 -07, Aaron Lewis wrote:

>> >> Why not add a new exit reason, particularly given that the caller has to
>> >> enable the capability to get the relevant data? (It would also remove
>> >> the need for the flag field and any mechanism for packing multiple bits
>> >> of detail into the structure.)
>> >
>> > I considered that, but I opted for the extensibility of the exiting
>> > KVM_EXIT_INTERNAL_ERROR instead.  To me it was six of one or half a
>> > dozen of the other.  With either strategy I still wanted to provide
>> > for future extensibility, and had a flags field in place.  That way we
>> > can add to this in the future if we find something that is missing
>> > (ie: potentially wanting a way to mark dirty pages, possibly passing a
>> > fault address, etc...)
>>
>> How many of the flag based optional fields do you anticipate needing for
>> any one particular exit scenario?
>>
>> If it's one, then using the flags to disambiguate the emulation failure
>> cases after choosing to stuff all of the cases into
>> KVM_EXIT_INTERNAL_ERROR / KVM_INTERNAL_ERROR_EMULATION would be odd.
>>
>> (I'm presuming that it's not one, but don't understand the use case.)
>>
>
> The motivation was to allow for maximum flexibility in the future, and
> not be tied down to something we potentially missed now.  I agree the
> flags aren't needed if we are only adding to what's currently there,
> but they are needed if we want to remove something or pack something
> differently.  I didn't see how I could achieve that without adding a
> flags field.  Seemed like low overhead to be more future proof.

With what you have now, the ndata field seems unnecessary - I should be
able to determine the contents of the rest of the structure based on the
flags. That also suggests to me that using something other than
KVM_INTERNAL_ERROR_EMULATION would make sense.

This comment:

>> >> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
>> >> > + * to describe what is contained in the exit struct.  The flags are used to
>> >> > + * describe it's contents, and the contents should be in ascending numerical
>> >> > + * order of the flag values.  For example, if the flag
>> >> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
>> >> > + * length and instruction bytes would be expected to show up first because this
>> >> > + * flag has the lowest numerical value (1) of all the other flags.

originally made me think that the flag-indicated elements were going to
be packed into the remaining space of the structure at a position
depending on which flags are set.

For example, if I add a new flag
KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_CODE, value 2, and then want to
pass back an exit code but *not* instruction bytes, the comment appears
to suggest that the exit code will appear immediately after the flags.

This is contradicted by your other reply:

>> > Just add the fields you need to
>> > the end of emulation_failure struct, increase 'ndata' to the new
>> > count, add a new flag to 'flags' so we know its contents.

Given this, the ordering of flag values does not seem significant - the
structure elements corresponding to a flag value will always be present,
just not filled with relevant data.

dme.
-- 
When you were the brightest star, who were the shadows?
