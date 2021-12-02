Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B72466C13
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 23:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244299AbhLBW2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 17:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbhLBW2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 17:28:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562F0C06174A;
        Thu,  2 Dec 2021 14:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YzlwnEmcfYbtnzNUum0o+VRyYI920zQ3LuKGzGlBnSQ=; b=npnVOU0wp5tOnXfBeYcfkJNuoG
        SP+qCqYliDrrpDETPR/6TL2zYsi1w2S7jSFGu4uWdJL9ttxPFSMlT2qXiyhlRyX5TnU42IVlgwscN
        lIzfdj6EBX7el+h/9wuAD0xX6x/v/ggvLNR+4vuVBLNhVXlKqZCdk5YJABpgxiCYUYYmDZOKuF6eM
        CCkDAgBT3HvV8r0+1ocf6uaAQQQflJct4c/pUCCs/yx4wfhWhzy3PeNwd6iD2veCwgTTRFKCcJO1I
        6YKcP23bWuWekI5O0I1P//PvhscI8GoYia6MQ+vvvt/G3xbKQKThW/YG9Y6uLnRXLjKU765IIkaAf
        ZWp5INzQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1msuVu-005sBR-U1; Thu, 02 Dec 2021 22:25:15 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2CE849810D4; Thu,  2 Dec 2021 23:25:14 +0100 (CET)
Date:   Thu, 2 Dec 2021 23:25:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     tglx@linutronix.de, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/2] x86/cpu: Introduce x86_get_cpufreq_khz()
Message-ID: <20211202222514.GD16608@worktop.programming.kicks-ass.net>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
 <20211201024650.88254-2-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201024650.88254-2-pizhenwei@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021 at 10:46:49AM +0800, zhenwei pi wrote:
> Wrapper function x86_get_cpufreq_khz() to get frequency on a x86
> platform, hide detailed implementation from proc routine.
> 
> Also export this function for the further use, a typical case is that
> kvm module gets the frequency of the host and tell the guest side by
> kvmclock.

This function was already complete crap, and now you want to export it,
*WHY* ?!

What possible use does KVM have for this random number generator?
