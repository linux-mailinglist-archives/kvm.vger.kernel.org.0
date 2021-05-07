Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C83837629B
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 11:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhEGJGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 05:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhEGJGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 05:06:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310E1C061574;
        Fri,  7 May 2021 02:05:35 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620378331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wiNZhgNtdVWskIOQqlZ//nz/pviSlraqX/NCbWN5P4k=;
        b=ohu10kUFW/33dp6ljK9m/sWPSCL43uSkjBXuiJ8D45AGp8AXmxuw+DfLdr0X25Td5vfSiO
        M0WQF1qIoSFgMy7+rqPtZtK/FbdHmqNJSD+ufzBb5gUQoRKmRmBJQQrgrq1tkN+KKBDiAj
        6Y0ATUEQLmN76F0/twd9FyHT5zbtZorUuh1mdFyw77G2KHK9T1ePZwaTHotVgD2dxX4TZp
        iuKxZoqK0p3gDrqWpj6Vz2w0o3xNJK0F9w16qUD/o/3eyv3xuMxTtvvsX4FI4+wDHfHtdz
        CxeHy4cq4xUHpna/qP5jfnaLpkdJUALmvJs1p2XjTeyW8Z97qBUo4K37Q7xowQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620378331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wiNZhgNtdVWskIOQqlZ//nz/pviSlraqX/NCbWN5P4k=;
        b=/gqNc3dMAo7xS0wurbqxAzs5L8hTyLRoBpv3NoRh0Tw75X9HRAxXbPemGh9K7lmVuSzoM0
        W1k7hED1pNwzf0Bw==
To:     Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        mgorman@suse.de, bristot@redhat.com, bsingharora@gmail.com,
        pbonzini@redhat.com, maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
In-Reply-To: <20210505105940.190490250@infradead.org>
References: <20210505105940.190490250@infradead.org>
Date:   Fri, 07 May 2021 11:05:31 +0200
Message-ID: <87zgx6ncbo.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05 2021 at 12:59, Peter Zijlstra wrote:
> Due to:
>
>   https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
>
> and general principle, delayacct really shouldn't be using ktime (pvclock also
> really shouldn't be doing what it does, but that's another story). This lead me
> to looking at the SCHED_INFO, SCHEDSTATS, DELAYACCT (and PSI) accounting hell.
>
> The rest of the patches are an attempt at simplifying all that a little. All
> that crud is enabled by default for distros which is leading to a death by a
> thousand cuts.
>
> The last patch is an attempt at default disabling DELAYACCT, because I don't
> think anybody actually uses that much, but what do I know, there were no ill
> effects on my testbox. Perhaps we should mirror
> /proc/sys/kernel/sched_schedstats and provide a delayacct sysctl for runtime
> frobbing.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
