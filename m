Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DE9377F7B
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 11:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEJJip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 05:38:45 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36717 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhEJJio (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 05:38:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CCD391940A35;
        Mon, 10 May 2021 05:37:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 10 May 2021 05:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aRO0Ec
        xntHwMa3vDf1DdoswAVSXpNANYNvPw2YSoKNE=; b=wlHiqXi9skfmYQeLeA5urq
        U0m/iWRkyPdQXIwqzGeREMusQkxlrYMfiuJR8MAchLbmKmUqYUzDkX5VaZSVM6HI
        161k+92V9FNLCXowmpw5ziIXYDPGtYTdwGXHKsfztrXF14QldiDKqqeYhHzHEB3t
        of/WILHjCvtcY6rkRdq9dp0gQE2TTgCuP2j0rMOPs0yfaI7h6gJxYMz4genXP84+
        /MpE26tAMAfSxrxFF5jFO3O71IlTkGfJCrQg3e7vlKccx5rl2H+fNpt1hQM6LcPW
        2xR/3y9s1W7v8hG9vQdqkQH5QAAJj8QF4BVV6aO1BpYXwLwDAFVEgwrdhXBNPZYw
        ==
X-ME-Sender: <xms:4v6YYLzUItVo-3Jf0zlwA3OZpRhBOePKG-gI58Yik2pe-tNwl6aJ6Q>
    <xme:4v6YYDSYO3gvTJdvy1BZVSyZ4WM6JtxvQjI_QNlPCUb1uzpQi2ezTpwFbPZpVRf_H
    y2hXJAV0mPC1Ljn1Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:4v6YYFXebht_aYVCS9za7ocAL7FRiwByJfTCAcF5o2RcHL6OKkojhQ>
    <xmx:4v6YYFh0NDtCwe9shGeQE7BBdDfrgjVeMq1tGQZ25TSx_N5fBEUmvw>
    <xmx:4v6YYNBdQCPk0AW7dfb4DbUW3f3SO9KqTeT7eSFHK0p-glsP1QiA8g>
    <xmx:4v6YYMPt1hBDMnAIYdjdullYPbymx45EQIEsvA3G5cj98beyOBvuOg>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 05:37:37 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id ead2cabc;
        Mon, 10 May 2021 09:37:36 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] kvm: x86: Allow userspace to handle emulation
 errors
In-Reply-To: <CAAAPnDFVR9xXEF_3_rEDhNhbe7r7QCEEiJ399Zv6h+ZUX=EfWA@mail.gmail.com>
References: <20210430143751.1693253-1-aaronlewis@google.com>
 <20210430143751.1693253-2-aaronlewis@google.com>
 <cuneeel4avw.fsf@oracle.com>
 <CAAAPnDFVR9xXEF_3_rEDhNhbe7r7QCEEiJ399Zv6h+ZUX=EfWA@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Mon, 10 May 2021 10:37:36 +0100
Message-ID: <cunim3r2alb.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, 2021-05-07 at 07:27:07 -07, Aaron Lewis wrote:

>> > +7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
>> > +--------------------------------------
>> > +
>> > +:Architectures: x86
>> > +:Parameters: args[0] whether the feature should be enabled or not
>> > +
>> > +When this capability is enabled the in-kernel instruction emulator packs
>> > +the exit struct of KVM_INTERNAL_ERROR with the instruction length and
>> > +instruction bytes when an error occurs while emulating an instruction.  This
>> > +will also happen when the emulation type is set to EMULTYPE_SKIP, but with this
>> > +capability enabled this becomes the default behavior regarless of how the
>>
>> s/regarless/regardless/
>>
>> > +emulation type is set unless it is a VMware #GP; in that case a #GP is injected
>> > +and KVM does not exit to userspace.
>> > +
>> > +When this capability is enabled use the emulation_failure struct instead of the
>> > +internal struct for the exit struct.  They have the same layout, but the
>> > +emulation_failure struct matches the content better.  It also explicitly defines
>> > +the 'flags' field which is used to describe the fields in the struct that are
>> > +valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set in the
>> > +'flags' field then 'insn_size' and 'insn_bytes' has valid data in them.)
>>
>> Starting both paragraphs with "With this capability enabled..." would
>> probably cause me to stop reading if I didn't enable the capability, but
>> as the first paragraph goes on to say, EMULTYPE_SKIP will also cause the
>> instruction to be provided.
>>
>
> What about this instead?

Reads better to me, thanks.

> When this capability is enabled, an emulation failure will result in an exit
> to userspace with KVM_INTERNAL_ERROR (except when the emulator was invoked
> to handle a VMware backdoor instruction). Furthermore, KVM will now provide up
> to 15 instruction bytes for any exit to userspace resulting from an emulation
> failure.  When these exits to userspace occur use the emulation_failure struct
> instead of the internal struct.  They both have the same layout, but the
> emulation_failure struct matches the content better.  It also explicitly
> defines the 'flags' field which is used to describe the fields in the struct
> that are valid (ie: if KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is
> set in the 'flags' field then both 'insn_size' and 'insn_bytes' have valid data
> in them.)
>
> I left out the part about EMULTYPE_SKIP because that behavior is not
> affected by setting KVM_CAP_EXIT_ON_EMULATION_FAILURE, so I thought it
> wasn't needed in the documentation here.

dme.
-- 
We're up all night to get lucky.
