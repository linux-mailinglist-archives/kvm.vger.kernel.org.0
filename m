Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02395625D11
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 15:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiKKOcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 09:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbiKKOcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 09:32:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48666391CF;
        Fri, 11 Nov 2022 06:32:14 -0800 (PST)
Date:   Fri, 11 Nov 2022 15:32:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668177132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sM3ULtPmMNa5Zsc2BrAAlowvN2+aHTb9kTu2ikkknUo=;
        b=VWAKqxoJrY9vNNwzf41tyM+ukCdpZeV5ss+lVBEXPQeB+D0kKLB9pUllUigOkp4eSXxB1D
        RvfC22wjGc1/QTNEjVfazYbqdKDNDDe4s5H9nfDE2AsKrt5M3pLN06rPu6wH9FmxXljTHl
        yjiFVqoUeQzhDqOaosmi6RqDNyFb3bKeqxxjvD0YV+u0lPvJwgdBoZFoDoRl50Qtth9UmO
        B50vpkimDeg7qASjqJARGce+mBUi1HvapsyPx9LVEvsx5A304NYc+F+L65S2Brh2nUckZN
        tYfHuyAY71Skw/aBSDgaMSsSDKMZUFX3TmjWjDUqfSaDtDsvcyIuuxWqwpY8tA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668177132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sM3ULtPmMNa5Zsc2BrAAlowvN2+aHTb9kTu2ikkknUo=;
        b=wBUQ8gsFyLG0esu/hMevTdnNN+Z/7s4k8ky59jFt1g+rppPJOejgcoJKQmQETQWFwm+5Wt
        yl8VkdyamIZdKDAQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Conor.Dooley@microchip.com, jszhang@kernel.org
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, anup@brainfault.org, atishp@atishpatra.org,
        tglx@linutronix.de, rostedt@goodmis.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 0/5] riscv: add PREEMPT_RT support
Message-ID: <Y25c626x6UPRtscs@linutronix.de>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <4488b1ec-aa34-4be5-3b9b-c65f052f5270@microchip.com>
 <YxIAmT2X9TU1CZhC@xhacker>
 <ea5cdba4-7a79-56b3-f8d7-7785569dedd6@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ea5cdba4-7a79-56b3-f8d7-7785569dedd6@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-02 13:29:23 [+0000], Conor.Dooley@microchip.com wrote:
> I'll give it a run through tonight or tomorrow & give you a full log
> of what I saw. There's some splats all over the place for me, but I
> can't tell if that's just knock-on from the other issues.

Is there an update to this or the series as a whole?

> Thanks,
> Conor.

Sebastian
