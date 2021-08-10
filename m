Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3993E7BE5
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbhHJPPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240486AbhHJPPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 11:15:21 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B09C0613C1;
        Tue, 10 Aug 2021 08:14:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628608497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5VHtrxPZLcB/JXYGXZ9XsVaH6NsptGo1uKorbERZf4=;
        b=vRUWocfFQ8otX0W5W17G/cHWKpNS3WYuzolmRH5LkMKB33iEIP6sSjqiVFaAYWT2o8tqiY
        /HB3WOLDkUH0UI+UyStNo3dyg1DKfrg7nVQVXoa6x0Bxa48VaGmjYSeVPdiXRvjXb+La30
        I7emfFnfY8B2vqS/FUJ2LNBSmS9Y1KKT/KPofvA4poNMvWnisLrfpiZEfM+u/2xuosSpt/
        glq9zrvzd0Rhl793vWZB9BAtiE7R9+QO+Vnu1VAQvyzDRJ3pAphOGXQWwYliYkPsCjV1Hj
        PzjnkWATm2n7zkQmtsKScv+SW4HEYSzSmoEX7RQx/Z0Na8GVg4uNlKpictKqyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628608497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5VHtrxPZLcB/JXYGXZ9XsVaH6NsptGo1uKorbERZf4=;
        b=fFCmow4rYk45QWkm4fsXGsSV5olnwUpoXmgcDQRaPmLzkT00hEq8eFnhoyhtS29dsHAJ5N
        iIDSziABjQZHgeBQ==
To:     Hikaru Nishida <hikalium@chromium.org>,
        linux-kernel@vger.kernel.org, dme@dme.org, mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Steve Wahl <steve.wahl@hpe.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: Re: [v2 PATCH 2/4] x86/kvm: Add definitions for virtual suspend
 time injection
In-Reply-To: <20210806190607.v2.2.I6e8f979820f45e38370aa19180a33a8c046d0fa9@changeid>
References: <20210806100710.2425336-1-hikalium@chromium.org>
 <20210806190607.v2.2.I6e8f979820f45e38370aa19180a33a8c046d0fa9@changeid>
Date:   Tue, 10 Aug 2021 17:14:57 +0200
Message-ID: <87tujxqqku.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06 2021 at 19:07, Hikaru Nishida wrote:

> Add definitions of MSR, KVM_FEATURE bit, IRQ and a structure called
> kvm_suspend_time that are used by later patchs to support the
> virtual suspend time injection mechanism.

Why does this need to include kvm_host.h in the timekeeping core?

> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -22,6 +22,7 @@
>  #include <linux/pvclock_gtod.h>
>  #include <linux/compiler.h>
>  #include <linux/audit.h>
> +#include <linux/kvm_host.h>
>  
>  #include "tick-internal.h"
>  #include "ntp_internal.h"

Thanks,

        tglx
