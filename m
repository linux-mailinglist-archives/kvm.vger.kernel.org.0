Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAF1374B3E
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 00:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhEEWap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 18:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhEEWao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 18:30:44 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499B5C061574;
        Wed,  5 May 2021 15:29:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k3-20020a17090ad083b0290155b934a295so2030670pju.2;
        Wed, 05 May 2021 15:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=znkSlKiu5G4Hhz1MTty3vtN5arr0IksFQo0x+yCPNiQ=;
        b=A06CrOWSPs6ckpXv/wQSHMTR3zY8KGTeP8ajN3gPgEXLAnD4baUlbo2tOmbst/P6zB
         YJ9z87LdCXVkKL8K9516HUr1ourWZ7hlB80DWGDuCwUX0lSItL/wgqCv9Sr5VSzlifJQ
         Q3xYzcyD9N/3LQ+C4zSnl/x+sHzNtM88N/e2mqv9zAtbErimtL9e1PTacXA0GaLnY667
         pSunaCRyx8ZOnmgssvUTKaRGxCOmqnsXDVRKOGC5IbcC+Ey+iKPota/d+gZentrNo0V1
         ZEswHrYFF86CkZiUK8s9zJtZghvMn0PVpRpsV8Ykw16OnUpcjalz8M9fezu6ny9qwBIR
         ceVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=znkSlKiu5G4Hhz1MTty3vtN5arr0IksFQo0x+yCPNiQ=;
        b=YEuFpTunhAdoiTsTP5OSrEHFcesQ0f5ecNyumyfYqUab7VX0pupqlhh391TCMQ+4XH
         QhTihvDViy3N/sCMZ9YnnSQw9agjghI+pzRzdRHA/F6rWsYjy2ByP9Qj6M/D1R4NReCl
         xUDRi/dJxa+cHUBNOXGPYY2foymAAslhFVIhgzG7FVFUx2ZdetHuKWJOuXdCzvyvBEcD
         iv3ufKLJHY6ORx4NimhQQVyPw61ID6gIyrW4Pa0UZK3fgfod/fyxUy8kGZDGGlIT0LBu
         P6EAvJs4xaB/jTudVz42pAii2WrZPukXmF4rPX3XSkdnztm34/gGv9NXkiCMvtVnE2hr
         d7aw==
X-Gm-Message-State: AOAM530dz5xfctPJz0Xm82xddGdswZbFegXyWqBmkvT9fNMLcZP6Bw3b
        Bw6NmgUS4EUFYnELbrVaP5oGhp8sJ8tTTQNouhw=
X-Google-Smtp-Source: ABdhPJznH2+IA2bFYDzVaGRKaWpOyUl5ObnhphhBf1Q+pjimtm+Ke/a5BKVRSEdB+0iwYKrM7XeZ1w==
X-Received: by 2002:a17:902:c3c5:b029:ed:3ff4:70f3 with SMTP id j5-20020a170902c3c5b02900ed3ff470f3mr1415607plj.12.1620253785609;
        Wed, 05 May 2021 15:29:45 -0700 (PDT)
Received: from localhost ([203.87.99.126])
        by smtp.gmail.com with ESMTPSA id z16sm8080223pjq.42.2021.05.05.15.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 15:29:44 -0700 (PDT)
Date:   Thu, 6 May 2021 08:29:40 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <20210505222940.GA4236@balbir-desktop>
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505105940.190490250@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:40PM +0200, Peter Zijlstra wrote:
> Hi,
> 
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
>

There are tools like iotop that use delayacct to display information. When the
code was checked in, we did run SPEC* back in the day 2006 to find overheads,
nothing significant showed. Do we have any date on the overhead your seeing?

I'll look at the patches

Balbir Singh. 
