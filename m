Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D637654D
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhEGMjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 08:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbhEGMjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 08:39:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85A0C061574;
        Fri,  7 May 2021 05:38:16 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c17so7520523pfn.6;
        Fri, 07 May 2021 05:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HbTfMG7PaRcYRfEBJTiMnp+DCXk7lKJen9XHFnDTLes=;
        b=dzMUTd2XjmwRlnJs6kSo/gIkbtflzIYAM6JTQwIo6WFDO4cU8PGLGIcUufENBq6S0z
         uYLMXhyU5H8/dANo71rdftHZNYFNFnsufIurt6jI5K4H4KvituiT+cRvL8SeTryNKcKX
         bVGfM6QD7U99IwE5sZ63eUSOzHGHqQr8q8YGxuNQnjoFEwx4M6V1Xc6SE4xI7Ruu3Abc
         8CF1lisevCcbW5hzOWeK9ziqR63azOBolttjisaj2KLklD7+oWoEhXkfVYcJYRKIB5rM
         jWeubEI4yEMCpfgU/CVVO8Dgfpc5VLQA7FROAWk+KM13HhTVc8kIbSGcL39V29RzbOJe
         8lIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HbTfMG7PaRcYRfEBJTiMnp+DCXk7lKJen9XHFnDTLes=;
        b=TS7fU8W5VrCQ9S3BC0fgzXv93Ld41fADIYQc0sOWSPqBR9U5txGcnNmPwMYsfHLNmC
         FExoZww8jWknS7tf6OOiEufBEbIT/8yv3n/S5s2PMHeNb2/GFwl2kYXmQp6yNzmwaWwk
         oUW8qCi4mcqmm7V/iphezLXjLpfVOwPNPjaZ3WRQ2rJZDndG8AuYarlWR7AOJh+gUHWh
         BxmMfCmtq4idtrsV/JTJofrOQkKwESudogycxccMgjAJfjCazelNQc9oiojwuZuBoKyN
         1DFflYKmrFRwcgEnPjLRzeGbkfLqXLkr4DgMgUpUyOGNb2p9vyUddl8Eh9QypkIU4kPL
         a+Sw==
X-Gm-Message-State: AOAM532y4SIAC8x3C2bNsoQ7BdYdcrs2pseKXReksD3fFmlMt0EpaKO1
        5NWA2hrmseIwD9EIa283ERM=
X-Google-Smtp-Source: ABdhPJyt2cVnictWgbwCqteQUrgyc7LKU04Xea7LKszx7Do38hM+TYTXDBD4KUFQ7OnuWAVjoEe8Cw==
X-Received: by 2002:a62:8895:0:b029:283:f725:6a7 with SMTP id l143-20020a6288950000b0290283f72506a7mr10135656pfd.79.1620391096247;
        Fri, 07 May 2021 05:38:16 -0700 (PDT)
Received: from localhost ([203.87.99.126])
        by smtp.gmail.com with ESMTPSA id 14sm4580022pfl.1.2021.05.07.05.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:38:13 -0700 (PDT)
Date:   Fri, 7 May 2021 22:38:10 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <20210507123810.GB4236@balbir-desktop>
References: <20210505105940.190490250@infradead.org>
 <20210505222940.GA4236@balbir-desktop>
 <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 11:13:52AM +0200, Peter Zijlstra wrote:
> On Thu, May 06, 2021 at 08:29:40AM +1000, Balbir Singh wrote:
> > On Wed, May 05, 2021 at 12:59:40PM +0200, Peter Zijlstra wrote:
> > > Hi,
> > > 
> > > Due to:
> > > 
> > >   https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
> > > 
> > > and general principle, delayacct really shouldn't be using ktime (pvclock also
> > > really shouldn't be doing what it does, but that's another story). This lead me
> > > to looking at the SCHED_INFO, SCHEDSTATS, DELAYACCT (and PSI) accounting hell.
> > > 
> > > The rest of the patches are an attempt at simplifying all that a little. All
> > > that crud is enabled by default for distros which is leading to a death by a
> > > thousand cuts.
> > > 
> > > The last patch is an attempt at default disabling DELAYACCT, because I don't
> > > think anybody actually uses that much, but what do I know, there were no ill
> > > effects on my testbox. Perhaps we should mirror
> > > /proc/sys/kernel/sched_schedstats and provide a delayacct sysctl for runtime
> > > frobbing.
> > >
> > 
> > There are tools like iotop that use delayacct to display information. 
> 
> Right, but how many actual people use that? Does that justify saddling
> the whole sodding world with the overhead?
>

Not sure I have that data.
 
> > When the
> > code was checked in, we did run SPEC* back in the day 2006 to find overheads,
> > nothing significant showed. Do we have any date on the overhead your seeing?
> 
> I've not looked, but having it disabled saves that per-task allocation
> and that spinlock in delayacct_end() for iowait wakeups and a bunch of
> cache misses ofcourse.
> 
> I doubt SPEC is a benchmark that tickles those paths much if at all.
> 
> The thing is; we can't just keep growing more and more stats, that'll
> kill us quite dead.


I don't disagree, we've had these around for a while and I know of users
that use these stats to find potential starvation. I am OK with default
disabled. I suspect distros will have the final say.

Balbir Singh.
