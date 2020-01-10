Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1709C136F12
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgAJOM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:12:58 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58092 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgAJOM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 09:12:57 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ipv1w-0005OX-Jp; Fri, 10 Jan 2020 15:12:52 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 2EF6C105BE5; Fri, 10 Jan 2020 15:12:52 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, kvm <kvm@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v2] sched/nohz: Optimize get_nohz_timer_target()
In-Reply-To: <CANRm+Cw1eTNgB1r79J7U__ynio7pMSR4Xa35XuQuj-JKAQGxmg@mail.gmail.com>
Date:   Fri, 10 Jan 2020 15:12:52 +0100
Message-ID: <87a76v8knv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng,

Wanpeng Li <kernellwp@gmail.com> writes:

> Hi Thomas,
> On Wed, 23 Oct 2019 at 16:29, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> On Wed, 23 Oct 2019, Wanpeng Li wrote:
>> > I didn't see your refactor to get_nohz_timer_target() which you
>> > mentioned in IRC after four months, I can observe cyclictest drop from
>> > 4~5us to 8us in kvm guest(we offload the lapic timer emulation to
>> > housekeeping cpu to avoid timer fire external interrupt on the pCPU
>> > which vCPU resident incur a vCPU vmexit) w/o this patch in the case of
>> > there is no busy housekeeping cpu. The score can be recovered after I
>> > give stress to create a busy housekeeping cpu.
>> >
>> > Could you consider applying this patch for temporary since I'm not
>> > sure when the refactor can be ready.
>>
>> Yeah. It's delayed (again).... Will pick that up.
>
> I didn't find WIP tag for this work after ~half year since v4 was
> posted https://lkml.org/lkml/2019/6/28/231 Could you apply this patch
> for temporary because the completion time of refactor is not
> deterministic.

Could you please repost it?

Thanks,

        tglx
