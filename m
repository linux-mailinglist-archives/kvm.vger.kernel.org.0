Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6C24DAF4C
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 13:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355534AbiCPMBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 08:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345168AbiCPMBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 08:01:21 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D16353F
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 05:00:04 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E4D695C0189
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 08:00:01 -0400 (EDT)
Received: from imap47 ([10.202.2.97])
  by compute3.internal (MEProxy); Wed, 16 Mar 2022 08:00:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lmb.io; h=cc
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to; s=fm3; bh=5
        POMU7yML0Nh4qLroA9UtykAS/VRGtoAN15fSpCxa9M=; b=f1FzBwB9331r6Cund
        R/tFP87o6ne46olGApYUcY/bijeZ1LqmeUR3SnmnITsadQ5HHPEPtPXLV4wSBGha
        uiMdLOeuHv6fc8B7kBsn94ZU1KeD7EssKnKOXD2S+EnE1YhlB4PaUkxWc5QyGPhq
        HHaMB/vCO41QHmuRvoEJ1kqUbejynVBUian30uMpiEqXKnykS/ectcnGQd8JMXE1
        Ggpj2F+0L0OeFDcdNLRNJXUTIGg7LaRHNKVJ4Iaxma00uBybN2vOCV+xuUCq6q8c
        c05OO/pt+0vul711UcVShTAzu2HVHfDOJT5uInMPu+TlAdvqWAqrimZNVpT8iqLT
        wORuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=5POMU7yML0Nh4qLroA9UtykAS/VRGtoAN15fSpCxa
        9M=; b=N1AhUxPgJw4MFAdTiZ1by5tslkDMPjOBuQ0grZOjeE4AoAzwHwMdwbzW6
        30LQIBVuL1dBy73vYGzvy96wZw3/bFuBGoOognkZREwehExXrIHxbAu2JUc2UxSJ
        zmgyTSoRMR7Y29nFtx8fZAGzFyl7U0WqwqpPAFQ6Ejen3twwlU5cO1bh0Gndtdxb
        sXrWOj5P/X8nDT5X010ezmGc8BnKWWraT7Za8z7npNx3eqY9br3+2ybDi3h5Qc0h
        /9joqxMfxJiMcz15W70cz7LXR1+7y8qENmY362tPXzzBNPCYw4rqO0AKI8gmXGMG
        fGA8kVxmwESjKkkW5WgYHuqnZLQlA==
X-ME-Sender: <xms:QdExYiYwEuYk8wzt8It5FWDJ_Lte4tlJZQesLM0OZns1T3BIvTJWZg>
    <xme:QdExYlbA_uu4x2dHb94J7eR9h0DRjloIvM8LtZSdj1z5_FyNepXbokP7yLOVXhRuY
    iwXgEYu6vVXOSuVfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefvddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehttdertd
    erredtnecuhfhrohhmpedfnfhorhgvnhiiuceurghuvghrfdcuoehoshhssehlmhgsrdhi
    oheqnecuggftrfgrthhtvghrnhepteefveelheeuveevgfdtgfejffdtgeehffffieejge
    efudejffeutdefgfekheetnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpshgvmhgr
    phhhohhrvggtihdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehoshhssehlmhgsrdhioh
X-ME-Proxy: <xmx:QdExYs-A7TbTehQ5D5VKAvIdcSAnH1fgeImwRqdl_JWc-1PCRcYOLg>
    <xmx:QdExYko-kUr9UCywu_dKQU-l_SNjocD8Qytv3oj7qK0czCEEU-hk3w>
    <xmx:QdExYtrFSRKDOWdxIMJyH9kGlNcdMk02ag20pnS3nGsbk9P63gsQYA>
    <xmx:QdExYq05DhBjQLZNSeAdxP074j3UFtUXQvpg99njQhJcgMUQVzABOw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A04B5274051B; Wed, 16 Mar 2022 08:00:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4907-g25ce6f34a9-fm-20220311.001-g25ce6f34
Mime-Version: 1.0
Message-Id: <95c1dc01-4aa0-46a6-95b1-bbc62588ac6e@www.fastmail.com>
Date:   Wed, 16 Mar 2022 11:59:39 +0000
From:   "Lorenz Bauer" <oss@lmb.io>
To:     kvm@vger.kernel.org
Subject: Intel nested KVM exits L2 due to TRIPLE_FAULT
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi list,

I use qemu to run short lived Linux VMs as part of a CI pipeline, using nested KVM on Intel CPUs. With good probability, one of the qemu processes managing the VMs exits without any output. I've been able to track the behaviour to L1 qemu receiving KVM_EXIT_SHUTDOWN from KVM_RUN ioctl:

    ...
    15268@1647341556.924605:kvm_run_exit cpu_index 0, reason 2
    15268@1647341556.928341:kvm_run_exit cpu_index 0, reason 8

    on QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.21)

Digging deeper, I managed to capture the following trace from the L1 kernel (via perf record -a -e "kvm:*"):

    ...
    [001]   770.850287:                      kvm:kvm_entry: vcpu 0, rip 0x100146
    [001]   770.850307:                       kvm:kvm_exit: vcpu 0 reason TRIPLE_FAULT rip 0x100146 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
    [001]   770.850313:                        kvm:kvm_fpu: unload
    [001]   770.850316:             kvm:kvm_userspace_exit: reason KVM_EXIT_SHUTDOWN (8)

   on Linux 5.13.0-30-generic #33~20.04.1-Ubuntu SMP Mon Feb 7 14:25:10 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

Immediately prior to the triple fault there are a bunch of EXTERNAL_INTERRUPT and reads / writes of MSRs and CRs. The crash seems independent of the Linux version running in L2, I see it across a bunch of LTS kernels. Unfortunately I don't know which version of Linux is in L0.

I've tried to reproduce on other machines I have access to, without much luck. I've also tried to make sense of rip 0x100146 on my own, but I don't understand x86 / qemu boot enough. Finally, I've tried looking at commits to KVM between 5.13 and master that mention TRIPLE_FAULT, but nothing rang a bell.

Basically, I'm out of ideas what to try next, maybe some of you can give me a pointer?

I've put traces from two failed executions + lscpu at https://gist.github.com/lmb/c36479bb67f397ba08319b5e0f752386
For completeness sake, you can see the failing CI runs at https://ebpf.semaphoreci.com/branches/317c3f18-4de0-488b-af6d-2a1fa0967f87

Thanks!
Lorenz
