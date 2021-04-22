Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D998F367BBC
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhDVIIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:08:14 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35745 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235189AbhDVIIN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 04:08:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0AA431940904;
        Thu, 22 Apr 2021 04:07:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 22 Apr 2021 04:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/HUHh8
        49Z/kHRCGfql9FhjDE8mgm/I1eaS7Hb7jJaHk=; b=ErX4iOpgy4dKWqQKApWn9g
        7bs984ZVdiOGwS72mXCBPhiBTGR5mYora9DZttm6HR4WhmwnYHDyiAtdRaSUs09o
        rLf/1LDSrN8MuZf30rBeE/N4MaN4qzeotKpCQq8MTzLIw8pZfWbyKXDWfo09V9YS
        8b9sM567UJ5bpfmgh2ah8emo9TlPYiEFGkN4cjFpvs175/VPV8svYA0MjUUAvBFO
        YLEfzH942H1NE6zeMuEbebwQa3GtqhJ3LMPfU2ksyYbh2okEwam1RHmLXpGFMtPC
        2NMc1ZJQRD8M8ytazbgNH1f0YLPikZfT22vmbNK/tYMWcsuu1GGTD9yiSbk5ZIIQ
        ==
X-ME-Sender: <xms:yi6BYLRSyaIsMwrPAthHsv5HZUAY7Y4VpyYGgfZpBgbGJGITC6Kj6w>
    <xme:yi6BYMwK7M17QWS4jhN_JVmbdBfFTvvDOopq3j7XfA08Pf7DzS7iwcnorYmp7pBoC
    oZQt7cosNxbl_DIQMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutdcutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfgughm
    ohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnhephefhje
    fgheevvdetudfgheevudeghedtffejgedtgfetvdfhheekgeefkeetkefhnecuffhomhgr
    ihhnpehslhgvughjrdhnvghtnecukfhppeekuddrudekjedrvdeirddvfeeknecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvgesughmvgdr
    ohhrgh
X-ME-Proxy: <xmx:yi6BYA05pJIeOtALTU0k_i26hwmC0Aud4oF6FSRxZ99kaYKV5m4atw>
    <xmx:yi6BYLBkDR6J3p4DbM4039xyv4A2BRSkZuPogZK1dhFcvmlFxJU-IA>
    <xmx:yi6BYEjDrYJbQ4l9s84vrDNwpo3ialbTO9s-y3ymyJmkeOrc2p_lkA>
    <xmx:yy6BYNtc-CUEXPYr_wzWAs_gA4bUqKszBiqXE1vNKyawHY0g4siUIA>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id 462221080064;
        Thu, 22 Apr 2021 04:07:38 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id f950ba56;
        Thu, 22 Apr 2021 08:07:36 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] kvm: x86: Allow userspace to handle emulation
 errors
In-Reply-To: <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
References: <20210421122833.3881993-1-aaronlewis@google.com>
 <cunsg3jg2ga.fsf@dme.org>
 <CAAAPnDH1LtRDLCjxdd8hdqABSu9JfLyxN1G0Nu1COoVbHn1MLw@mail.gmail.com>
 <cunmttrftrh.fsf@dme.org>
 <CAAAPnDHsz5Yd0oa5z15z0S4vum6=mHHXDN_M5X0HeVaCrk4H0Q@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Thu, 22 Apr 2021 09:07:36 +0100
Message-ID: <cunk0oug2t3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wednesday, 2021-04-21 at 12:01:21 -07, Aaron Lewis wrote:

>> >
>> > I don't think this is a problem because the instruction bytes stream
>> > has irrelevant bytes in it anyway.  In the test attached I verify that
>> > it receives an flds instruction in userspace that was emulated in the
>> > guest.  In the stream that comes through insn_size is set to 15 and
>> > the instruction is only 2 bytes long, so the stream has irrelevant
>> > bytes in it as far as this instruction is concerned.
>>
>> As an experiment I added[1] reporting of the exit reason using flag 2. On
>> emulation failure (without the instruction bytes flag enabled), one run
>> of QEMU reported:
>>
>> > KVM internal error. Suberror: 1
>> > extra data[0]: 2
>> > extra data[1]: 4
>> > extra data[2]: 0
>> > extra data[3]: 31
>> > emulation failure
>>
>> data[1] and data[2] are not indicated as valid, but it seems unfortunate
>> that I got (not really random) garbage there.
>>
>> Admittedly, with only your patches applied ndata will never skip past
>> any bytes, as there is only one flag. As soon as I add another, is it my
>> job to zero out those unused bytes? Maybe we should be clearing all of
>> the payload at the top of prepare_emulation_failure_exit().
>>
>
> Clearing the bytes at the top of prepare_emulation_failure_exit()
> sounds good to me.  That will keep the data more deterministic.
> Though, I will say that I don't think that is required.  If the first
> flag isn't set the data shouldn't be read, no?

Agreed. As Jim indicated in his other reply, there should be no new data
leaked by not zeroing the bytes.

For now at least, this is not a performance critical path, so clearing
the payload doesn't seem too onerous.

>> Footnotes:
>> [1]  https://disaster-area.hh.sledj.net/tmp/dme-581090/
>>
>> dme.
>> --
>> Music has magic, it's good clear syncopation.

dme.
-- 
Don't you know you're never going to get to France.
