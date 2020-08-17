Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6FF2466C0
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgHQM4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 08:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgHQM4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 08:56:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC552072E;
        Mon, 17 Aug 2020 12:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597669009;
        bh=ERpMAdayk233Labrw+Lu7muZTEwuPknh19NdvGNHSMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q5my1Mwo8/rP50v751943fs0FGAFtFae1A+Dz+biD7l+GcRGAiMRNkn8qGgI7zspP
         cEpukEBSMsw3z7ejoG8++F6AGY8JyrdeuevwPlIHFlvr6yP17ft7SPLeS6htKMEAqd
         XXVaERjnM8M8XvIYIw2P3xjXzpyt9obh8PR2A21U=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7egy-003ZLe-9G; Mon, 17 Aug 2020 13:56:48 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Aug 2020 13:56:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
In-Reply-To: <20200817122415.6568-3-zhukeqian1@huawei.com>
References: <20200817122415.6568-1-zhukeqian1@huawei.com>
 <20200817122415.6568-3-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <b37f6cf6a660f51690f0689509650eed@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steven.price@arm.com, drjones@redhat.com, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-17 13:24, Keqian Zhu wrote:
> ARM virtual counter supports event stream, it can only trigger an event
> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 
> changes,
> so the actual period of event stream is 2^(cntkctl_evnti + 1). For 
> example,
> when the trigger bit is 0, then virtual counter trigger an event for 
> every
> two cycles.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I have never given you this tag, you are making it up. Please read
Documentation/process/submitting-patches.rst to understand what
tag you can put by yourself.

At best, put "Suggested-by" tag, as this is different from what
I posted anyway.

Thanks,

         M.

> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index 6e11c60..4140a37 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -794,10 +794,14 @@ static void arch_timer_configure_evtstream(void)
>  {
>  	int evt_stream_div, pos;
> 
> -	/* Find the closest power of two to the divisor */
> -	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
> +	/*
> +	 * Find the closest power of two to the divisor. As the event
> +	 * stream can at most be generated at half the frequency of the
> +	 * counter, use half the frequency when computing the divider.
> +	 */
> +	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
>  	pos = fls(evt_stream_div);
> -	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> +	if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>  		pos--;
>  	/* enable event stream */
>  	arch_timer_evtstrm_enable(min(pos, 15));

-- 
Jazz is not dead. It just smells funny...
