Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84517CFF2
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 21:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgCGUJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 15:09:01 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55853 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgCGUJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 15:09:01 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAfkn-0007yO-4D; Sat, 07 Mar 2020 21:08:57 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7B520104088; Sat,  7 Mar 2020 21:08:56 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
In-Reply-To: <CALCETrXpW5TYRNu2hMXt=fGC8EOh7WVqffCzS5GrwApC1inTzw@mail.gmail.com>
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de> <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com> <87r1y4a3gw.fsf@nanos.tec.linutronix.de> <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com> <87d09o9n7y.fsf@nanos.tec.linutronix.de> <CALCETrXpW5TYRNu2hMXt=fGC8EOh7WVqffCzS5GrwApC1inTzw@mail.gmail.com>
Date:   Sat, 07 Mar 2020 21:08:56 +0100
Message-ID: <8736ak9bc7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:
> On Sat, Mar 7, 2020 at 7:52 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> WHAT? That's fundamentally broken. Can you point me to the code in
>> question?
>
> I think Paolo said so in a different thread, but I can't Let me see if
> I can find it:
>
> kvm_pv_enable_async_pf()
>   kvm_clear_async_pf_completion_queue()
>
> but that doesn't actually seem to send #PF.  So maybe I'm wrong.
>
> I will admit that, even after reading the host code a few times, I'm
> also not convinced that wakeups don't get swallowed on occasion if
> they would have been delivered at times when it's illegal.

I gave up trying to decode it. I wait for the kvm wizards to answer all
our nasty questions :)

Thanks,

        tglx
