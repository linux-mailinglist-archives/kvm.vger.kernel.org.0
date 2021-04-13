Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4437635DD19
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 13:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbhDMLBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 07:01:30 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:33815 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344356AbhDMLB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 07:01:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 07:01:28 EDT
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CC3531940903;
        Tue, 13 Apr 2021 06:54:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 13 Apr 2021 06:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nYS1mA
        zCp2YtcTMjHCRKhhzeV2J92kIDnXr4neGXktk=; b=TDTBsTdxMzg6bBVi7TqYer
        0DiW0XQ2lPr8gTYCfUJmjHyh0G3/IbFZ/iSMs5glMUidDD3jiTtwFN0cEFzUiyI2
        mNuGR5Tg00icmUi3YBF7868ldmf4e9OLD2cAfqe184fp5Q2b39Q4yxeENAs36qKe
        DuVmwcgHjExF1pk9n4votO+qu4bCMAKy94p+XHe4lm87KQbmFKTwVyImTRzR0lKp
        yV1onAkLx9vKf0xgG4TBhb2vyDAxnWek5Y6jnZDX1pVkXJDgslsMNyzeS+JocR7K
        IyRLWgq/3aBNF5tweavqcOfbzX0xjLn0mQF+71QRD3m3paFOni7NOFlO+eVtKbTQ
        ==
X-ME-Sender: <xms:ZHh1YE-Z6ytB5OV209cw4IVpfPhJgTRlfspWa6MxdpLvlhAu7AoAfA>
    <xme:ZHh1YMtc132ApvaPGAFJaoKFx4gpDIKdbMrT1-gcE1BQm39mTVPVB1KzUecLmngu9
    _vg33hsKQeSa3jEuew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekledgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:ZHh1YKA8lZ6spgRuGqhDQSUCaD3V7bc4ZEYJ2YeufmqPbtz7CVy4BA>
    <xmx:ZHh1YEf8ZYKV-RhV0l_2Kfws_e_3L0pzwmgdXxIDE047Ou0s5JDjSg>
    <xmx:ZHh1YJP4y4UNPwX24gNMMziYr59XEZFUw0WaYwEFzpnvGa2DdntQIw>
    <xmx:ZXh1YPs0p-YqVbYmr5UcLO4ftZ6ifb0IKHF17qrPbAvDjHBpepgnT_YsmwE>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7575108005C;
        Tue, 13 Apr 2021 06:54:26 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id bf0b8dca;
        Tue, 13 Apr 2021 10:54:25 +0000 (UTC)
To:     Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 0/6] KVM: x86: Make the cause of instruction emulation
 available to user-space
In-Reply-To: <CALMp9eRTy-m6DkXRSGNU=r7xmrzFFQU60DB2asUDZLCgw93wRQ@mail.gmail.com>
References: <20210412130938.68178-1-david.edmondson@oracle.com>
 <CALMp9eRTy-m6DkXRSGNU=r7xmrzFFQU60DB2asUDZLCgw93wRQ@mail.gmail.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
X-Now-Playing: Dido - Life for Rent: Stoned
Date:   Tue, 13 Apr 2021 11:54:25 +0100
Message-ID: <cunk0p6sbdq.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-04-12 at 11:34:33 -07, Jim Mattson wrote:

> On Mon, Apr 12, 2021 at 6:09 AM David Edmondson
> <david.edmondson@oracle.com> wrote:
>>
>> Instruction emulation happens for a variety of reasons, yet on error
>> we have no idea exactly what triggered it. Add a cause of emulation to
>> the various originators and pass it upstream when emulation fails.
>
> What is userspace going to do with this information? It's hard to say
> whether or not this is the right ABI without more context.

Logging for debug purposes, see reply to Sean.

dme.
-- 
You make me feel like a natural woman.
