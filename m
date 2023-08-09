Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA6776724
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 20:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjHIS0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 14:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjHIS0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 14:26:40 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE949A3;
        Wed,  9 Aug 2023 11:26:39 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 304795C00A2;
        Wed,  9 Aug 2023 14:26:39 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 09 Aug 2023 14:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1691605599; x=1691691999; bh=PM
        oRv0SQqsc5MGIHtzgFAHhMEbqQtwxjg5aA9DqRinA=; b=M20E5QWg40a54/qD0n
        wl9H2+xs3ff/4Wytyp2Wwp+DlzoxE4CuYExuUfT5BV7ILYSbb5tYcOIKtg3FcFjI
        hTfumlaqkQcBX/EB3VHEGkiXevnhN9WMeSjyPSNigxpyfQyZg4/eWWrJk4zpwm2x
        v/oEqCPTS5MN2jHdUiO+W2FFigzFjXWgDG1Cbwl3Pt7ZutaGeCtCfD7nIKiRpr+y
        bplqY4BDFxdBN6GtVLkTseK8fZlbDkVDpQwafzxb2r5g8K0qkdGu29p38nlHPTxr
        P1+17Z0HkngNmBPXhD68Q6bDj91/Y974SwQgPztclBt9GUSBAZ53kDUb5jyg8VrL
        jNjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1691605599; x=1691691999; bh=PMoRv0SQqsc5M
        GIHtzgFAHhMEbqQtwxjg5aA9DqRinA=; b=h4cOz7VyD3EyvNrMWIQ89W+cuhFqe
        KObaAPT8gDWm+mtqMl2bg93oopjpCsSsG252FkuNnJuB4h9Rq7PzcuTZUrpaXXeZ
        oyWFrKKdskzPCRePpiCSupmcBQAvW4+g3Ha3tWQ0LQitc1OTKvCPonPskHdMfP53
        siyBw3mJ31rnzUJ8OovjZwUootOaXII8+nLYhRmYVfzkaAZa2H8rE+R2iDP5cliU
        mhjQG6IO1a2+KdVciC5YlUEOCC/4AXDREGXcghX95YEL63OH5V6DmDPjXexTqIKb
        UFmC4eK+LP/r7j5hQr3Mi3WbUOqQdg6CYDBO/2zN6GxBbSVOxzR/rRWOw==
X-ME-Sender: <xms:XtrTZKR3Q_ZrJkbnvLvkq2Xu6rmn2rgWwyKsTNtk0d3YBKiYsBoylg>
    <xme:XtrTZPxkXUM0tfMYxQ0ptEdQ5QjHpYMRIUjOaZ7_PWett5XNiL5yZD6yTs01mA0SU
    L_Mkn6xhnRxzeo00yY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrleeggdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:XtrTZH2_Li_hoJZYWkP-L44FLIH3ccmAaBCZ0PxwN_J3yV_9G7IQBA>
    <xmx:XtrTZGBCEUm3I_VqSX1IZMWsZo36d7aJpBQkWrcS8vKlkun-dSnvtw>
    <xmx:XtrTZDhHv0qoT7ia2RT4ffL_E7YUb_4H1hfZirhMTeuqdvHs6_Rb4g>
    <xmx:X9rTZOQfgyB-3azZCvI90aypnaAV_Bt3jVQtO80aI7n5fWItyzmqNA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 4621AB60089; Wed,  9 Aug 2023 14:26:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-624-g7714e4406d-fm-20230801.001-g7714e440
Mime-Version: 1.0
Message-Id: <c67fa35a-590f-404c-8104-5afbf14ad282@app.fastmail.com>
In-Reply-To: <f66ef6d0-18f7-ebef-0297-ad2f2d578aff@linux.intel.com>
References: <20230809130530.1913368-1-arnd@kernel.org>
 <20230809130530.1913368-2-arnd@kernel.org>
 <f66ef6d0-18f7-ebef-0297-ad2f2d578aff@linux.intel.com>
Date:   Wed, 09 Aug 2023 20:26:17 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Daniel Sneddon" <daniel.sneddon@linux.intel.com>,
        "Arnd Bergmann" <arnd@kernel.org>, x86@kernel.org,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@kernel.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Maxim Levitsky" <mlevitsk@redhat.com>,
        "Michal Luczaj" <mhal@rbox.co>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: move gds_ucode_mitigated() declaration to header
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 9, 2023, at 18:54, Daniel Sneddon wrote:
> HI Arnd,
>
> On 8/9/23 06:05, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> The declaration got placed in the .c file of the caller, but that
>> causes a warning for the definition:
>> 
>> arch/x86/kernel/cpu/bugs.c:682:6: error: no previous prototype for 'gds_ucode_mitigated' [-Werror=missing-prototypes]
>
> When I build with gcc 9.4 and the x86_64_defconfig I don't see this warning even
> without this patch. I'm curious why you're seeing it and I'm not. Any ideas?

The warning is currently disabled by default, unless you build with
'make W=1'. I'm in the process of getting my last patches out to
change this so the warning is enabled by default though, so I was
phrasing this based on the future behavior. Sorry if this was confusing.

    Arnd
