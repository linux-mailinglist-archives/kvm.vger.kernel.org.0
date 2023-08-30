Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5072878E35A
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 01:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344522AbjH3Xju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 19:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbjH3Xjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 19:39:49 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB442C9;
        Wed, 30 Aug 2023 16:39:45 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 9DB6C32008FB;
        Wed, 30 Aug 2023 19:39:40 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 30 Aug 2023 19:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1693438780; x=1693525180; bh=M9
        gCOekIM2huAR+ziQ0XQjqHbftSph1uDZZYkRIXuOY=; b=h0nbIFQABAhkUtYLOb
        Nc80hXI+gmNKqPcCnLnMjBtZq38DP3F7i1vexStaKEZtfIl0l0X4JJ7jLPZf4CWp
        RrYIbrwHVosg+gMbqdOFjoi/HpXZSgXAbYRfWfQnp9sXkxcGwRFe+hSjkOi5agDO
        4pcMR6WRbtzbtH0r9BJ8lLBtrfUBWPls5LdOEYPwuBJ7FPJkswg5Y0A+k40RbRjl
        GgK0xD3yx8j+iVu13aZImwLK0pZO+CVOk3I1zQSb99e5L+7fKTieHfCfSkxMBmby
        mUvB8wnqOTYDolIXih7WcxLG6jqiSwBXsnCUt4WeJDZ3/hRvil1yMyQYTNiVVppM
        SEmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1693438780; x=1693525180; bh=M9gCOekIM2huA
        R+ziQ0XQjqHbftSph1uDZZYkRIXuOY=; b=QEKf/B1hGP+3+lNgIbPPHKf6dWjAv
        Kl3cKbpGmMeyoz1x39J42uhNWzDtFm86wco3daCRHL5X1YJkdPCQg+sJWQQFsHOG
        XEzju8k85UTDZaiG+HB69EI5g6cLpVBSCQ0tq5lnJfiFnOrVch9v5NPiHAtgpyJ8
        0/uergth478HofL+FedcUigFE9Ykbqk8F3BEYaxI3eH/wuHlaRmqT29W/80I70vn
        Y+7Bd9DyacXJSbZ7+NTNuTiZ5nIbDGQMTOF/h0XdX5pOs5I2HsQgPDEmCYNxfL3M
        3L5ADpyteoc67NJRZnq/c+h2gms0EueCAIfdjTSTPOq8EAyg0KpZChpaQ==
X-ME-Sender: <xms:O9PvZOqOKu1IV6AEth8ocsibmTvUGjaTopAfD6P9AzWfyxjjwEVcXw>
    <xme:O9PvZMoxMys15V9ewrjpNPKjLqvAb0Fiwv4EeszY18XziVeNvLY8l-WKzfhqAwVho
    VzRRTsA5dcBGlYEzCc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrudefledgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:O9PvZDMHIG2lbMPjEE-g_PZeLNcOEKbzKnDTBTN8ltDWAaanw9Q8xw>
    <xmx:O9PvZN5OAl8OhVR1-o53t5KivDGBF0969OiI5lu86ko1b8f1rkHxfQ>
    <xmx:O9PvZN7MwvvntaIA6F2pcUpiYYS1T3ThbNKk8RK4u5fVrBARqPzBsg>
    <xmx:PNPvZL59z4MU1L3Z1URriTzvOKkfUzUeNgZKIsrxaY4yuxbr8u4G1A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 27699B60089; Wed, 30 Aug 2023 19:39:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-701-g9b2f44d3ee-fm-20230823.001-g9b2f44d3
Mime-Version: 1.0
Message-Id: <1697efce-665a-43d5-b0be-7c03c0a4d850@app.fastmail.com>
In-Reply-To: <82416797-01aa-471a-a737-471297e37c4c@amazon.de>
References: <64e7cbf7.050a0220.114c7.b70dSMTPIN_ADDED_BROKEN@mx.google.com>
 <2023082506-enchanted-tripping-d1d5@gregkh>
 <c26ad989dcc6737dd295e980c78ef53740098810.camel@amazon.com>
 <20230823024500.GA25462@skinsburskii.>
 <e0ed9fb9-8e7a-44ad-976a-27362f6e537a@amazon.de>
 <20230829220740.GA26605@skinsburskii.>
 <82416797-01aa-471a-a737-471297e37c4c@amazon.de>
Date:   Wed, 30 Aug 2023 19:39:18 -0400
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Alexander Graf" <graf@amazon.de>,
        "Stanislav Kinsburskii" <skinsburskii@linux.microsoft.com>
Cc:     "Gowans, James" <jgowans@amazon.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mike Rapoport" <rppt@kernel.org>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>,
        "steven.sistare@oracle.com" <steven.sistare@oracle.com>,
        "Stanislav Kinsburskii" <stanislav.kinsburskii@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Wei Liu" <wei.liu@kernel.org>,
        "anrayabh@linux.microsoft.com" <anrayabh@linux.microsoft.com>,
        "dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
        "jinankjain@linux.microsoft.com" <jinankjain@linux.microsoft.com>,
        "derek.kiernan@amd.com" <derek.kiernan@amd.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        kexec@lists.infradead.org, iommu@lists.linux.dev,
        kvm <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] Introduce persistent memory pool
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023, at 03:20, Alexander Graf wrote:
> On 30.08.23 00:07, Stanislav Kinsburskii wrote:
>> On Mon, Aug 28, 2023 at 10:50:19PM +0200, Alexander Graf wrote:

>> Device tree or ACPI are options indeed. However AFAIU in case of DT user
>> space has to involved into the picture to modify and complie it, while
>> ACPI isn't flexible or easily extendable.
>> Also, AFAIU both these standards were designed with passing
>> hardware-specific data in mind from bootstrap software to an OS kernel
>> and thus were never really intended to be used for creating a persistent
>> state accross kexec.
>> To me, an attempt to use either of them to pass kernel-specific data looks
>> like an abuse (or misuse) excused by the simplicity of implementation.
>
>
> What I was describing above is that the Linux boot protocol already has 
> natural ways to pass a DT (arm) or set of ACPI tables (x86) to the 
> target kernel. Whatever we do here should either piggy back on top of 
> those natural mechanisms (e.g. /chosen node in DT) or be on the same 
> level (e.g. pass DT in one register, pass metadata structure in another 
> register).
>
> When it comes to the actual content of the metadata, I'm personally also 
> leaning towards DT. We already have libfdt inside the kernel. It gives 
> is a very simple, well understood structured file format that you can 
> extend, version, etc etc. And the kernel has mechanisms to modify fdt 
> contents.

Agreed. This also makes a lot of sense since the fdt format was
originally introduced for this exact purpose, to be a key-value
store to pass data from the running kernel to the next one after
kexec when the original source of the data (originally open
firmware) is gone. It only turned into the generic way to
describe embedded systems later on, but both the fdt binary
format and the kexec infrastructure for manipulating and
passing the blob should be easy to reuse for additional purposes
as long as the contents are put into appropriate namespaces that
don't clash with existing usage.

       Arnd
