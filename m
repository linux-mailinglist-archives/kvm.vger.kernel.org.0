Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF6C6A76C3
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 23:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjCAWZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 17:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCAWZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 17:25:48 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6878F51FB1;
        Wed,  1 Mar 2023 14:25:47 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 7C13F3200124;
        Wed,  1 Mar 2023 17:25:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 01 Mar 2023 17:25:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1677709542; x=
        1677795942; bh=moVaqVnd4I/VGYr1N+8sOAO6Nq3Mk9FWPoTWoynbfug=; b=A
        Q5bogiggGXmqAnv3KaRpbnbbBHYKEFpbpVREI66Uct9FylS/uaUr/Ft5V7PC+ZgW
        lNp2P5T8LM/uZn7ci4LULWPT4VROY1kcRwCBaDSk0welAQhLfVuB+RoS9LAuJTa7
        m2FhtqXz5BDO8UXflbn7Tf3lRx7QrQjzWYcr6mzHFclVrtTi9FQnWS+JbywWmwMI
        cy0FqSiU3smz0vdiKpM513YYgENID3j2hfN3nHu3TC4W0SyYFfAKG4TaI/7mZN/t
        6O+pq2k48qouho8Y4L1//gAk8MQ8m+RQOYdNM4fRNf0ALujfy9DTsj3SA2T2HfOp
        A0irzOZWzJWEi3asx29DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677709542; x=1677795942; bh=moVaqVnd4I/VGYr1N+8sOAO6Nq3M
        k9FWPoTWoynbfug=; b=odUqkecnAfDv9z5HQvRqd+JcWGhe3tvozwrLtV8qC6YJ
        u5fUYsaNjj25XVKkX2agx/RcKBVGSnkuiJR3t85LXbLF95ZNlCt+JlRGK9DivY9g
        DIct72DcDKg3Y2NyxdpbpDMJspsfBfzI4P7fhQqFz5yvdEaeXyLz2pn/WxeJhd+8
        Ml9xEv0fQXaBjBYLVZ2LCOcWDQIJroq/AAO97IE5bug2acaeRDrFm2Cwcnx8lxQQ
        7lrcMdZLuLa2K5DRlhKSJETiX9IDbkGFdraIOY4WKA1x5TT/aZ++VVEOD6siKFDE
        TEUnD5Fnq32Bq4ExuSWrqTGlA4EzDOxmyeVh3JUGqA==
X-ME-Sender: <xms:49D_Yz6zmNBA3CPGgfqneOLV03Cem8Tbat9FXcLdBLXFC8tnqiNqqg>
    <xme:49D_Y44hLEvkFgOCeTPqMKGJcQSg1upfIhjr4qPA93Y6PWTMY9Q6xtgSQ_w50zmlI
    K338jNJJsMIel-JK5U>
X-ME-Received: <xmr:49D_Y6c1OLKUx51bmg4yIqRzoMiz6hFfR9T0QahZ0Q4dTRpfz4WzQPXrqMI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelhedgudehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeflohhs
    hhcuvfhrihhplhgvthhtuceojhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgheqne
    cuggftrfgrthhtvghrnhepudeigeehieejuedvtedufeevtdejfeegueefgffhkefgleef
    teetledvtdfftefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepjhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgh
X-ME-Proxy: <xmx:49D_Y0JO-u6ekWsRUFa7yIFljo3zN5_8dw8EppENHkmqtlsdVXGeZg>
    <xmx:49D_Y3Ji_j85gP8Jov92f1te_cXS5Pv88pdyOAjU0EoIRDlQp2zwOQ>
    <xmx:49D_Y9zywOnwn-GJAqqefqqD6nlqP65Z9yFd5ILHX68yhe0Kn-B74A>
    <xmx:5tD_Yyfn2ce9KhoW-t-8jecefVMrr9isfP1iM6vlmfyscBUtuCwMAA>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Mar 2023 17:25:37 -0500 (EST)
Date:   Wed, 1 Mar 2023 14:25:36 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v12 07/11] x86/smpboot: Remove early_gdt_descr on 64-bit
Message-ID: <Y//Q4Mh6/65Keruu@localhost>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <20230226110802.103134-8-usama.arif@bytedance.com>
 <878rghmrn2.ffs@tglx>
 <96c0c723-9976-a222-8dc8-a5da6a1a558e@linux.intel.com>
 <Y/+2Wuunn1sIF8eT@localhost>
 <20230301221632.GI2948950@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301221632.GI2948950@paulmck-ThinkPad-P17-Gen-1>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 02:16:32PM -0800, Paul E. McKenney wrote:
> On Wed, Mar 01, 2023 at 12:32:26PM -0800, Josh Triplett wrote:
> > On Tue, Feb 28, 2023 at 01:02:33PM -0800, Arjan van de Ven wrote:
> >   Thomas Gleixner wrote:
> > > > 
> > > > Maybe we should enforce CONFIG_SMP=y first :)
> > > > 
> > > > Thanks,
> > > 
> > > for 64 bit I can see the point of removing the !SMP case entirely from arch/x86 .
> > > maybe even for 32 bit if it just makes the code simpler I suppose
> > 
> > As one of the folks keeping an eye on tinyconfig and kernel size, I
> > actually think we *should* make this change and rip out !CONFIG_SMP,
> > albeit carefully.
> > 
> > In particular, I would propose that we rip out !CONFIG_SMP, *but* we
> > allow building with CONFIG_NR_CPUS=1. (And we could make sure in that
> > case that the compiler can recognize that at compile time and optimize
> > accordingly, so that it might provide some of the UP optimizations for
> > us.)
> > 
> > Then, any *optimizations* for the "will only have one CPU, ever" case
> > can move to CONFIG_NR_CPUS=1 rather than !CONFIG_SMP. I think many of
> > those optimizations may be worth keeping for small embedded systems, or
> > for cases like Linux-as-bootloader or similar.
> > 
> > The difference here would be that code written for !CONFIG_SMP today
> > needs to account for the UP case for *correctness*, whereas code written
> > for CONFIG_SMP can *optionally* consider CONFIG_NR_CPUS=1 for
> > *performance*.
> 
> It certainly would not make much sense to keep Tiny RCU and Tiny SRCU
> around if there was no CONFIG_SMP=n.

On the contrary, I think it's entirely appropriate to keep them for
CONFIG_NR_CPUS=1; that's exactly the kind of simple optimization that
seems well worth having. (Ideal optimization: "very very simple for UP,
complex for SMP"; non-ideal optimization: "complex for SMP, differently
complex for UP".)

- Josh
