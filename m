Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFDA6A755E
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 21:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCAUcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 15:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjCAUcf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 15:32:35 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC5A498AA;
        Wed,  1 Mar 2023 12:32:34 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 037E43200495;
        Wed,  1 Mar 2023 15:32:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 01 Mar 2023 15:32:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1677702751; x=
        1677789151; bh=lpaY3yzktxWgStVHIEgSVgb+C52QCTyL8Dy+xs3UsQw=; b=Q
        3gNNqwQ0h7Aq89bRhvI/QKiYr54LRSw5EQuwYLHqLgHea6XoUoz32MCGb2vlg6MN
        G1SF4chdujmu6jIzqznkcCzxoGE/0/ylQj1pcu50DPnpNkuW1Cd9DgWeNhonkd4y
        3h1bti9SFI10qj7GjE3Tzta/ZAr6HNbbUDM1wgGlDPiNOLNz87GUneMq4J/WIR8N
        C1MaXe5QdoYc+H7ICG01KwM0PsuzKJr5bxI49iYLN74Z7MqHWGkJAmXQmLwu0pL7
        UMpIU7kE7t4eDfnhW7LPmD4KtZgkOXbTwVE2rVh2gPE2NBU4aFzjtiBzazSDi6oX
        Hnzf09Ae6Ldy9hBU6/AeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677702751; x=1677789151; bh=lpaY3yzktxWgStVHIEgSVgb+C52Q
        CTyL8Dy+xs3UsQw=; b=YMa1sLm/8gdh7SGlUJFKQM+xbElReZ0btKaucvqRMcno
        +FvExCANi/GwCz8ijlgySgcjfHxknhybjOfgFqpr15Yu9DqlHWNkk6kbAU63BRR1
        Rhu7cLVm6OGqBnuGjLo1wAwYTuIWwQbZAkUfre8scVAyYG+Q2FdvzPeQiogYip/z
        o2xg6ZYkt1RD+2GR0yi4UAGg8nd4g8sRpTLVSunRz+wb/BzBB6KwJmd8r9z9UcZ4
        zTKEtAiQHq7aLIr3DaVoP4cns5BuGhMNEOITKwFobA2VecpLHSBo6fbZZmwVhcvN
        wetrA+22bh0SyfYh/Fv0fkJN6IZ8IR1YeZbNTX1fcQ==
X-ME-Sender: <xms:Xbb_Y5_jV3vPEVJVpDbOGxI-sJNFbY5gmfGAx3Q7ZrQVFJxoKgX1Ng>
    <xme:Xbb_Y9vgdnunKPnfE9w3GsZTYLr6Vi_Dpu4DUOCXNNIbhNrcZprLO09yKCh62vKvJ
    ytQwYSimgQ5rdEsMQQ>
X-ME-Received: <xmr:Xbb_Y3DX5ooB2aQ9OR1NxdLaQp3opbx931AX_R0fbQ0RB0NZGQdpimGHYyk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelhedgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeflohhs
    hhcuvfhrihhplhgvthhtuceojhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgheqne
    cuggftrfgrthhtvghrnhepudeigeehieejuedvtedufeevtdejfeegueefgffhkefgleef
    teetledvtdfftefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepjhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgh
X-ME-Proxy: <xmx:Xbb_Y9fG-4kDF5XUn6St4udhfZRRc7Eh3xMegAsrzH2h7TYEUS0llQ>
    <xmx:Xbb_Y-OXUPGbgFBkAC5TD31lcdkn5Q6zhfU-S1598CoiIeHEjfU9lA>
    <xmx:Xbb_Y_k58YcJGvySzupe-cjqiFNdeb8V4tKqLQ2xGGpFA6n-i7baNg>
    <xmx:X7b_YxipEDIbmTuvN7pA8Ryi5KrEXJgJIli9o7b6bkymxhuAanvSHw>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Mar 2023 15:32:26 -0500 (EST)
Date:   Wed, 1 Mar 2023 12:32:26 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Arjan van de Ven <arjan@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
Message-ID: <Y/+2Wuunn1sIF8eT@localhost>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com>
 <878rghmrn2.ffs@tglx>
 <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 01:02:33PM -0800, Arjan van de Ven wrote:
  Thomas Gleixner wrote:
> > 
> > Maybe we should enforce CONFIG_SMP=y first :)
> > 
> > Thanks,
> 
> for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
> maybe even for 32 bit if it just makes the code simpler I suppose

As one of the folks keeping an eye on tinyconfig and kernel size, I
actually think we *should* make this change and rip out !CONFIG_SMP,
albeit carefully.

In particular, I would propose that we rip out !CONFIG_SMP, *but* we
allow building with CONFIG_NR_CPUS=1. (And we could make sure in that
case that the compiler can recognize that at compile time and optimize
accordingly, so that it might provide some of the UP optimizations for
us.)

Then, any *optimizations* for the "will only have one CPU, ever" case
can move to CONFIG_NR_CPUS=1 rather than !CONFIG_SMP. I think many of
those optimizations may be worth keeping for small embedded systems, or
for cases like Linux-as-bootloader or similar.

The difference here would be that code written for !CONFIG_SMP today
needs to account for the UP case for *correctness*, whereas code written
for CONFIG_SMP can *optionally* consider CONFIG_NR_CPUS=1 for
*performance*.
