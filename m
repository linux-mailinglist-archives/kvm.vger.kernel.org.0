Return-Path: <kvm+bounces-4554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CEC814423
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 10:07:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73F0C1F2348B
	for <lists+kvm@lfdr.de>; Fri, 15 Dec 2023 09:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8291B28D;
	Fri, 15 Dec 2023 09:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MR1BJh1S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B501A710;
	Fri, 15 Dec 2023 09:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40c317723a8so5051915e9.3;
        Fri, 15 Dec 2023 01:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702631248; x=1703236048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dCB/Ho7uAkTd2udyIh4uiQfCkhgIrChr0Q/E8CeXzB0=;
        b=MR1BJh1SAkutx2pwn+vPi7qU5U3CnaJ/FkM4LGVPBGatb/jHSMSWblAbOGqx+xd6sm
         /IeT30a5y1AxBqbwr8bcF396Z0V0XsmGqZrntbxr9+bo+o0KAsyvX11+fGZ4iewYkfnP
         aICt+HihFPaHuo+89WAci8Xj9mTlXKDFOCsbxPPQn6vYo1mdLwhp8U0pWsonspKsmzuA
         FqHx5lnQUXfcfoL+tAtkAcXmcpBtrvOdEldjduiU6r2UN8wLHLfVI+U0/Ry7UJlq2NgU
         0qP63BHKgvbeT863rDXmb5i1GpuyipPvoMszgwwMFVTXsit4qw8qqUt0nGiFWf7XgVFy
         C76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702631248; x=1703236048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dCB/Ho7uAkTd2udyIh4uiQfCkhgIrChr0Q/E8CeXzB0=;
        b=TY0EBTk7bK7ci8o1+i9cWUJEJL0aVl/AFJ//Dgo844y+s+VVY1Yu/j08gXAetX9pS0
         r/6KeVadywTwGmRXzbxK427i6p/RPF5s6Rg1O6BJkL722jDSW4SYK1oyjt9lkLzbYv6O
         GwsJodcg6wbmSRmpq0fY0m4fL+J3YSzKiQVzOmdrQ1B4HPAojysXSQVt88HW+CPfVIo0
         7w9ZbiGRLWQRIkmmXMBoinZ0N1Ktkdt/wEglcglMvlhoE4JYY0fvw0aQx8svZKtu/TYn
         wPBErXWg2tBm2kKWu8c2S+xKQGl4p5qjxReKHbV5NWt8AStIZhLWTXYuvpyZfW5gxZT4
         n6Mg==
X-Gm-Message-State: AOJu0Yx5c8Vj0VVc/e34GDo2thLyCbQVzxcxVLpw7bhCfQdGxlyRIgxo
	oaCsl+7Jd3wmUa1BW/PrcDA=
X-Google-Smtp-Source: AGHT+IEcAWWWvrPRTlp2uRL/FzdOScVbLSSaOj/MblGriLKyfJxflbC0gUz6ETYhMFnmtEtIsSsz8A==
X-Received: by 2002:a05:600c:19c9:b0:40c:6d4b:2fa5 with SMTP id u9-20020a05600c19c900b0040c6d4b2fa5mr110088wmq.63.1702631247860;
        Fri, 15 Dec 2023 01:07:27 -0800 (PST)
Received: from [192.168.2.124] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id h2-20020a05600c350200b0040c6b2c8fa9sm1415680wmq.41.2023.12.15.01.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Dec 2023 01:07:27 -0800 (PST)
Message-ID: <f80753b3-2e68-487c-8304-fe801534748a@gmail.com>
Date: Fri, 15 Dec 2023 09:07:25 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3] KVM: x86/xen: improve accuracy of Xen timers
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
References: <afc496b886bc46b956ede716d8db6f208e7bab0a.camel@infradead.org>
Content-Language: en-US
From: "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <afc496b886bc46b956ede716d8db6f208e7bab0a.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/12/2023 16:54, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> A test program such as http://david.woodhou.se/timerlat.c confirms user
> reports that timers are increasingly inaccurate as the lifetime of a
> guest increases. Reporting the actual delay observed when asking for
> 100µs of sleep, it starts off OK on a newly-launched guest but gets
> worse over time, giving incorrect sleep times:
> 
> root@ip-10-0-193-21:~# ./timerlat -c -n 5
> 00000000 latency 103243/100000 (3.2430%)
> 00000001 latency 103243/100000 (3.2430%)
> 00000002 latency 103242/100000 (3.2420%)
> 00000003 latency 103245/100000 (3.2450%)
> 00000004 latency 103245/100000 (3.2450%)
> 
> The biggest problem is that get_kvmclock_ns() returns inaccurate values
> when the guest TSC is scaled. The guest sees a TSC value scaled from the
> host TSC by a mul/shift conversion (hopefully done in hardware). The
> guest then converts that guest TSC value into nanoseconds using the
> mul/shift conversion given to it by the KVM pvclock information.
> 
> But get_kvmclock_ns() performs only a single conversion directly from
> host TSC to nanoseconds, giving a different result. A test program at
> http://david.woodhou.se/tsdrift.c demonstrates the cumulative error
> over a day.
> 
> It's non-trivial to fix get_kvmclock_ns(), although I'll come back to
> that. The actual guest hv_clock is per-CPU, and *theoretically* each
> vCPU could be running at a *different* frequency. But this patch is
> needed anyway because...
> 
> The other issue with Xen timers was that the code would snapshot the
> host CLOCK_MONOTONIC at some point in time, and then... after a few
> interrupts may have occurred, some preemption perhaps... would also read
> the guest's kvmclock. Then it would proceed under the false assumption
> that those two happened at the *same* time. Any time which *actually*
> elapsed between reading the two clocks was introduced as inaccuracies
> in the time at which the timer fired.
> 
> Fix it to use a variant of kvm_get_time_and_clockread(), which reads the
> host TSC just *once*, then use the returned TSC value to calculate the
> kvmclock (making sure to do that the way the guest would instead of
> making the same mistake get_kvmclock_ns() does).
> 
> Sadly, hrtimers based on CLOCK_MONOTONIC_RAW are not supported, so Xen
> timers still have to use CLOCK_MONOTONIC. In practice the difference
> between the two won't matter over the timescales involved, as the
> *absolute* values don't matter; just the delta.
> 
> This does mean a new variant of kvm_get_time_and_clockread() is needed;
> called kvm_get_monotonic_and_clockread() because that's what it does.
> 
> Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> v3:
>    • Rebase and repost.
> 
> v2:
>    • Fall back to get_kvmclock_ns() if vcpu-arch.hv_clock isn't set up
>      yet, with a big comment explaining why that's actually OK.
>    • Fix do_monotonic() *not* to add the boot time offset.
>    • Rename do_monotonic_raw() → do_kvmclock_base() and add a comment
>      to make it clear that it *does* add the boot time offset. That
>      was just left as a bear trap for the unwary developer, wasn't it?
> 
>   arch/x86/kvm/x86.c |  61 +++++++++++++++++++++--
>   arch/x86/kvm/x86.h |   1 +
>   arch/x86/kvm/xen.c | 121 ++++++++++++++++++++++++++++++++++-----------
>   3 files changed, 149 insertions(+), 34 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


