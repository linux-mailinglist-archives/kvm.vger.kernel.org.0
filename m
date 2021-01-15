Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF112F752D
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbhAOJXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbhAOJXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 04:23:44 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3CDC061794;
        Fri, 15 Jan 2021 01:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LrJG/1orjdUo6w8aRSCvysSJq7gF6RZtVnTtika1jcc=; b=HSgSaSX+kvU7ktks1f+Hhm8KPv
        KE8BhYgZNf+viYyHPk/hGi5zi4CF1f1BJ/1eqyU4vdbKskbjY22I8FomvDOQ3s6SOSryhnhlX4kj2
        5m/lfTn6wf8l5Y6dR56RmgOK9z8J3o6MijEg6iTZu2UsOPkHmwFdiDkbKGviP5MIGrXINmRxZfzpD
        Ib1Bp28gTjuovT8Y/u1pFjYm/KJFp0WXocgq1JBkK5IPxA9RfjffzCm2l/MusodBVqAH7sAxeYrSg
        Z0DAMYhfUGlADVdPB9Kyrg76iEBt0hGNebejAvSrCQiDpTWhG+4iQJ4p/T3Zu5713W+UKshFRfRPt
        f8JfMpFg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l0LJk-0001li-TU; Fri, 15 Jan 2021 09:22:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 36E37305815;
        Fri, 15 Jan 2021 10:22:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0B385200E0BD2; Fri, 15 Jan 2021 10:22:50 +0100 (CET)
Date:   Fri, 15 Jan 2021 10:22:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jason Baron <jbaron@akamai.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: append vmx/svm prefix to additional
 kvm_x86_ops functions
Message-ID: <YAFe6b/sSdDvXSM3@hirez.programming.kicks-ass.net>
References: <cover.1610680941.git.jbaron@akamai.com>
 <ed594696f8e2c2b2bfc747504cee9bbb2a269300.1610680941.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed594696f8e2c2b2bfc747504cee9bbb2a269300.1610680941.git.jbaron@akamai.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Thu, Jan 14, 2021 at 10:27:54PM -0500, Jason Baron wrote:

> -static void update_exception_bitmap(struct kvm_vcpu *vcpu)
> +static void svm_update_exception_bitmap(struct kvm_vcpu *vcpu)

Just to be a total pendant: s/append/Prepend/ on $Subject
