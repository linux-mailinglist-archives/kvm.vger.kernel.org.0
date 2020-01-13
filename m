Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8C1397E3
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 18:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgAMRiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 12:38:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43794 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgAMRiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 12:38:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so9485491wre.10
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 09:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=eI/hjqguFIOdMUSo3q0+87ouKq6C8zjThus+1sH1VO0=;
        b=nqIxncL1yFiSxKpJfW7b03JH6kat4Dudfk5nBxAOSe9fy852eC0rgDnVwIWEsn77zM
         dE2aPjfeec9grIBn2D6TKVGWvlCbHoPkDREmeg0ugSwGl0uKWjOqlhz9PFubYFsQ8hJq
         8AHQ6VOa8ibgvSsql/4I74XQVotBz96ZolcljqE4cr4l+8cvTw7sEml7DFJSNlRp/B9+
         eVWnY0PZROjEhdpBdVDxSkNBYF88APTOPXCBepgcHORk1RgjGlFS/BVQMBIB13S3DoM4
         qS2qi++eAdhVtdEtzeRHg8B93xPXcGOz8lnvTcAHy50WvUnbCWZgk+TBfG75rYhImHj8
         +nrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=eI/hjqguFIOdMUSo3q0+87ouKq6C8zjThus+1sH1VO0=;
        b=EYxmOeRZBzZl0krez0nKY2pyo+VwWC9s7y9AN7ZjNvxJsDyCv20WKD2uaIevt3AJjh
         Zsk8LQEdCN0wFhaKRiV6f/7C7Z2M1T3xx49CG4wrX7/g9XJXlC2XDampD/YQhyoxYjUL
         md7Z+aUCUwZAJTkAaig8dIK+iGDvKZa9VR9+b+tT/rZY2U817iBEoIKRgoPD2pjUQ9JB
         dTthudEgZFDgM77GocCvV4jFjW+OLiGszwGC6kFnrBOMh99Wmh2P4aki6yLwjpPejspH
         nC5I2JOuxbn8zdNwCgrXMKi2u1K28JGUAEB1n4ejPvBe1n/9JZ5U23zHmnPFfs7amnOC
         9rdg==
X-Gm-Message-State: APjAAAXBgw35PB5qeQPgUQTHeQK3Ye2514rMLKFLmmrpJr+IkUEOTy0j
        J4OlNJvNivQ4oHrt5IgRrdLxS33RF+g=
X-Google-Smtp-Source: APXvYqyNWRIWYrBMrEZC8POMivYqJE726L4BZ9LWUi0lr76+NdJQGfH6a/xGkKlsVQXVJu8cb+LQmw==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr20201081wrt.367.1578937085286;
        Mon, 13 Jan 2020 09:38:05 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id x14sm14824060wmj.42.2020.01.13.09.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 09:38:04 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 7EF811FF87;
        Mon, 13 Jan 2020 17:38:03 +0000 (GMT)
References: <20200110160511.17821-1-alex.bennee@linaro.org>
 <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
User-agent: mu4e 1.3.6; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [kvm-unit-tests PATCH] arm: expand the timer tests
In-reply-to: <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
Date:   Mon, 13 Jan 2020 17:38:03 +0000
Message-ID: <871rs3ntok.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Hi,
>
> On 1/10/20 4:05 PM, Alex Benn=C3=A9e wrote:
>> This was an attempt to replicate a QEMU bug. However to trigger the
>> bug you need to have an offset set in EL2 which kvm-unit-tests is
>> unable to do. However it does exercise some more corner cases.
>>
>> Bug: https://bugs.launchpad.net/bugs/1859021
>
> I'm not aware of any Bug: tags in the Linux kernel. If you want people to=
 follow
> the link to the bug, how about referencing something like this:
>
> "This was an attempt to replicate a QEMU bug [1]. [..]
>
> [1] https://bugs.launchpad.net/qemu/+bug/1859021"

OK, I'll fix that in v2.

>
> Also, are launchpad bug reports permanent? Will the link still work in
> a years' time?

They should be - they are a unique id and we use them in the QEMU source
tree.

>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>  arm/timer.c | 27 ++++++++++++++++++++++++++-
>>  1 file changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/timer.c b/arm/timer.c
>> index f390e8e..ae1d299 100644
>> --- a/arm/timer.c
>> +++ b/arm/timer.c
>> @@ -214,21 +214,46 @@ static void test_timer(struct timer_info *info)
>>  	 * still read the pending state even if it's disabled. */
>>  	set_timer_irq_enabled(info, false);
>>=20=20
>> +	/* Verify count goes up */
>> +	report(info->read_counter() >=3D now, "counter increments");
>> +
>>  	/* Enable the timer, but schedule it for much later */
>>  	info->write_cval(later);
>>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>>  	isb();
>> -	report(!gic_timer_pending(info), "not pending before");
>> +	report(!gic_timer_pending(info), "not pending before 10s");
>> +
>> +	/* Check with a maximum possible cval */
>> +	info->write_cval(UINT64_MAX);
>> +	isb();
>> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX");
>> +
>> +	/* also by setting tval */
>
> All the comments in this file seem to start with a capital letter.
>
>> +	info->write_tval(time_10s);
>> +	isb();
>> +	report(!gic_timer_pending(info), "not pending before 10s (via tval)");
>
> You can remove the "(via tval)" part - the message is unique enough to fi=
gure out
> which part of the test it refers to.

I added it to differentiate with the message a little further above.

>> +	report_info("TVAL is %d (delta CVAL %ld) ticks",
>> +		    info->read_tval(), info->read_cval() - info->read_counter());
>
> I'm not sure what you are trying to achieve with this. You can transform =
it to
> check that TVAL is indeed positive and (almost) equal to cval - cntpct, s=
omething
> like this:
>
> +	s32 tval =3D info->read_tval();
> +	report(tval > 0 && tval <=3D info->read_cval() -
> info->read_counter(), "TVAL measures time to next interrupt");

Yes it was purely informational to say tval decrements towards the next
IRQ. I can make it a pure test.

>
>>=20=20
>> +        /* check pending once cval is before now */
>
> This comment adds nothing to the test.

dropped.

>
>>  	info->write_cval(now - 1);
>>  	isb();
>>  	report(gic_timer_pending(info), "interrupt signal pending");
>> +	report_info("TVAL is %d ticks", info->read_tval());
>
> You can test that TVAL is negative here instead of printing the value.

ok.

>
>>=20=20
>>  	/* Disable the timer again and prepare to take interrupts */
>>  	info->write_ctl(0);
>>  	set_timer_irq_enabled(info, true);
>>  	report(!gic_timer_pending(info), "interrupt signal no longer pending");
>>=20=20
>> +	/* QEMU bug when cntvoff_el2 > 0
>> +	 * https://bugs.launchpad.net/bugs/1859021 */
>
> This looks confusing to me. From the commit message, I got that kvm-unit-=
tests
> needs qemu to set a special value for CNTVOFF_EL2. But the comments seems=
 to
> suggest that kvm-unit-tests can trigger the bug without qemu doing anythi=
ng
> special. Can you elaborate under which condition kvm-unit-tests can
> trigger the bug?

It can't without some sort of mechanism to set the hypervisor registers
before running the test. The QEMU bug is an overflow when cval of UINT64_MAX
with a non-zero CNTVOFF_EL2.

Running under KVM the host kernel will have likely set CNTVOFF_EL2 to
some sort of value with:

	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());

>
>> +	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>> +	info->write_cval(UINT64_MAX);
>
> The order is wrong - you write CVAL first, *then* enable to timer. Otherw=
ise you
> might get an interrupt because of the previous CVAL value.
>
> The previous value for CVAL was now -1, so your change triggers an unwant=
ed
> interrupt after enabling the timer. The interrupt handler masks the timer
> interrupt at the timer level, which means that as far as the gic is conce=
rned the
> interrupt is not pending, making the report call afterwards useless.
>
>> +	isb();
>> +	report(!gic_timer_pending(info), "not pending before UINT64_MAX (irqs =
on)");
>
> This check can be improved. You want to check the timer CTL.ISTATUS here,=
 not the
> gic. A device (in this case, the timer) can assert the interrupt, but the=
 gic does
> not sample it immediately. Come to think of it, the entire timer test is =
wrong
> because of this.

Is it worth still checking the GIC or just replacing everything with
calls to:

  static bool timer_pending(struct timer_info *info)
  {
          return info->read_ctl() & ARCH_TIMER_CTL_ISTATUS;
  }

>
> Thanks,
> Alex
>> +	info->write_ctl(0);
>> +
>>  	report(test_cval_10msec(info), "latency within 10 ms");
>>  	report(info->irq_received, "interrupt received");
>>=20=20


--=20
Alex Benn=C3=A9e
