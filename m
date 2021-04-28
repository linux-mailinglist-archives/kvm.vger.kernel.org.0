Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF28A36DD0A
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 18:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbhD1Qdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 12:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbhD1Qdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 12:33:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD9CC061573
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:32:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x7so63693220wrw.10
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=vMvP7yT7h0EJmqJtDWRQoTiz4uSh0TU3K6GL9MOqQzg=;
        b=rNnMJW8MV/b+T1qXUq5CprIbKb3o5zKrUNQnUSN6zt+H57dBz+5m4Dka/+/gQZ8+oP
         xU6Cp3yy8PUGARwnsQiTdLZLPXFXfVxFbHSdUKDzvKcBvraC31szfWCiNSb5yXOkXvxY
         df6xjOOqXLRcIdEkSWgqRRMEZ8gPKW/L/yaj50kp7MJAywFAqjvK+xWWa74U98jAlwG3
         mEEjQ/nhs3U7v1+tPzGFBDsO3seUZMBJyBDXZDfxZc9d7VxSESZ+ZblMkVallHGStxUH
         FZD6iLH7tMs82vbr3DXtrwEhx3XRlzeLLYDJ72awnFyMCiypeptgla2+J+ejeBgVEgTQ
         Ezmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=vMvP7yT7h0EJmqJtDWRQoTiz4uSh0TU3K6GL9MOqQzg=;
        b=KuikJD4vxtPYKgS//6GODLztL6i/G+movlNQefJ5bMRMhYj4m2x+an5UAwPch0bdPH
         zki/AoAnA6yPOriBQPVj2lfGwv/xBZ3PzlCaPGn3PgTgflSxp0tqzRbGWjTsnuHUBBC4
         A1Jf0MY1Ohr/cXr8ItCRxhtsrSy8xJBrI4FhD+uHD+kFUy3YNHlrAW9XTJMObJo3VqJ/
         J6qDRJQrP8aUaPU5z7oGv78/JWtcE17rF5QzZMoBJWLSd49oVTn50i+xRI/kJMaGTSB1
         Tl+H5qNY5NWTgWgGLiSa8GX3Zkup96K2fvcwGio8P6wbYqS6No/6OOh9pnLf6dSK21R6
         ja4A==
X-Gm-Message-State: AOAM532/ciBhmPa3uSzjgBf+5E4y6/HRDqIx6kONbpGKLJIBL+lWrXtb
        5ih8ucEVNnbn1CUS5kc6Nqev+A==
X-Google-Smtp-Source: ABdhPJzOUG0QIk3RFE1BxF3PoLYlTmc5Oy+854AX6CAz9G5nz1e/tyUANGyEiZRCxDXLPZZK94u1hQ==
X-Received: by 2002:a5d:68c3:: with SMTP id p3mr38833351wrw.62.1619627570577;
        Wed, 28 Apr 2021 09:32:50 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id u17sm6548332wmq.30.2021.04.28.09.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:32:49 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id E47051FF7E;
        Wed, 28 Apr 2021 17:32:48 +0100 (BST)
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org> <87fszasjdg.fsf@linaro.org>
 <996210ae-9c63-54ff-1a65-6dbd63da74d2@arm.com>
 <87k0omo4rr.wl-maz@kernel.org> <87czues90k.fsf@linaro.org>
User-agent: mu4e 1.5.12; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        shashi.mallela@linaro.org, eric.auger@redhat.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test
 into KVM and TCG variants
Date:   Wed, 28 Apr 2021 17:31:27 +0100
In-reply-to: <87czues90k.fsf@linaro.org>
Message-ID: <877dkms72n.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> Marc Zyngier <maz@kernel.org> writes:
>
>> On Wed, 28 Apr 2021 15:00:15 +0100,
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>=20
>>> I interpret that as that an INVALL guarantees that a change is
>>> visible, but it the change can become visible even without the
>>> INVALL.
>>
>> Yes. Expecting the LPI to be delivered or not in the absence of an
>> invalidate when its configuration has been altered is wrong. The
>> architecture doesn't guarantee anything of the sort.
>
> Is the underlying hypervisor allowed to invalidate and reload the
> configuration whenever it wants or should it only be driven by the
> guests requests?
>
> I did consider a more nuanced variant of the test that allowed for a
> delivery pre-inval and a pass for post-inval as long as it had been
> delivered one way or another:
>
> --8<---------------cut here---------------start------------->8---
> modified   arm/gic.c
> @@ -36,6 +36,7 @@ static struct gic *gic;
>  static int acked[NR_CPUS], spurious[NR_CPUS];
>  static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
>  static cpumask_t ready;
> +static bool under_tcg;
>=20=20
>  static void nr_cpu_check(int nr)
>  {
> @@ -687,6 +688,7 @@ static void test_its_trigger(void)
>  	struct its_collection *col3;
>  	struct its_device *dev2, *dev7;
>  	cpumask_t mask;
> +	bool before, after;
>=20=20
>  	if (its_setup1())
>  		return;
> @@ -734,15 +736,17 @@ static void test_its_trigger(void)
>  	/*
>  	 * re-enable the LPI but willingly do not call invall
>  	 * so the change in config is not taken into account.
> -	 * The LPI should not hit
> +	 * The LPI should not hit. This does however depend on
> +	 * implementation defined behaviour - under QEMU TCG emulation
> +	 * it can quite correctly process the event directly.
>  	 */
>  	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>  	stats_reset();
>  	cpumask_clear(&mask);
>  	its_send_int(dev2, 20);
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask, -1, -1),
> -			"dev2/eventid=3D20 still does not trigger any LPI");
> +	before =3D check_acked(&mask, -1, -1);
> +	report_xfail(under_tcg, before, "dev2/eventid=3D20 still may not trigge=
r any LPI");
>=20=20
>  	/* Now call the invall and check the LPI hits */
>  	stats_reset();
> @@ -750,8 +754,8 @@ static void test_its_trigger(void)
>  	cpumask_set_cpu(3, &mask);
>  	its_send_invall(col3);
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask, 0, 8195),
> -			"dev2/eventid=3D20 pending LPI is received");
> +	after =3D check_acked(&mask, 0, 8195);
> +	report(before !=3D after, "dev2/eventid=3D20 pending LPI is
>  	received");

Actually that should be:

         report(after || !before, "dev2/eventid=3D20 pending LPI is receive=
d");

so either the IRQ arrives after the flush or it had previously.

--=20
Alex Benn=C3=A9e
