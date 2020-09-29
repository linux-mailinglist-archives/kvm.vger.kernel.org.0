Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D47E27C057
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgI2JCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI2JCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 05:02:00 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04E6C061755;
        Tue, 29 Sep 2020 02:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5KNvUcSgp+Lvmv+qjj1zdke2aHNUW1BUoc+MUCQvxjE=; b=AP96ceqOEmxM6wO0nh0hPUEoLX
        vIuH8jJzPpEMRoYZhYdPHgc7RELo0PtBxCUr2X/RF/P5ug/JntAt+8VbA6OJd4rFHtV+nRYqg0oXU
        Z5JclqfAGLldmR9TFhIcxHeEphbifT9CnMCHNxIYe8+mFmTVyycb34p98cQd4kSX4ylTGsqjcAZO7
        wcApx2C0OSQpd0KgJLrQuHzUoG/6vZvaQalO0krGZRcnKPJQ2X5lW3mgAulfWewKsIEPRPd17HYjS
        hAOotp947BHDwE3i3S+MS2QIog8GuQYXIXQEUwyiOFFAGGCFKpdu1BkW2jMqAcsQepkGHBFoDDz9K
        /hJSeU/A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNBVv-0006Db-Ou; Tue, 29 Sep 2020 09:01:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 36211300F7A;
        Tue, 29 Sep 2020 11:01:33 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E0E2520115B18; Tue, 29 Sep 2020 11:01:33 +0200 (CEST)
Date:   Tue, 29 Sep 2020 11:01:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     lihaiwei.kernel@gmail.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH] KVM: x86: Add tracepoint for dr_write/dr_read
Message-ID: <20200929090133.GI2611@hirez.programming.kicks-ass.net>
References: <20200929085515.24059-1-lihaiwei.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929085515.24059-1-lihaiwei.kernel@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 04:55:15PM +0800, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> Add tracepoint trace_kvm_dr_write/trace_kvm_dr_read for x86 kvm.

This is a changelog in the: i++; /* increment i */, style. Totally
inadequate.
