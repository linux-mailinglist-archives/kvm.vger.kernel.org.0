Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0BC36D6FC
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 14:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhD1MH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 08:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhD1MHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 08:07:55 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5E1C061574
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 05:07:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a4so62789502wrr.2
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 05:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=EOOU8pYthgPf7utb7CYoUc60xCQM7rwCYX3vaXiEcTY=;
        b=F4GdgxcmXXhLc3/XBCKHrYL27+JBaWB8OxsWPWRpQRp2glFiKJ+OfMnMINqT95sIUF
         FcOUF37ihPPvyvrZ5V6f8GD0wbQV3ho3clkhffwW+IHs1XzhvvbDaoUdslKfxrwJHFfv
         NJEYWDeHLHOkM7goak1Oe9i6ktoufCft4HMCkFXTIrHJ7JOfphu77MtyB+5iCf4CZujB
         4er7AajJ5R1PWCg3RKDKbBqxZ9kEo2hX2j4js8IZME8mrXK/EoJbyXW5Y9In3nwIb68W
         wp+GhyTop/Xn7hx1D9xWeDEAHmMpRLFTGA07gvVXRpyPo0/2s/U5tEl85ErX1+qrZQhw
         kzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=EOOU8pYthgPf7utb7CYoUc60xCQM7rwCYX3vaXiEcTY=;
        b=ud5p2+WcDAIWFLDpeyCPyt1SwEE2XXA3xpmQxHL0AYmw91cGYT3DjIFKyOyBXXRDiH
         Tt0zERQVQe26objjCpdCQw0iDR/JBQra06eR/clY9TNjCpCFcDVNF99NeLjlielqKdF0
         DzU7u2OVIcdjBt7Xza4xMKhlBT+++E2uD82eAe/uF6WcTdZz8HFzlVDb6WP0p98A8lNP
         mYuDqjUa6V3mDdvmGusu7Mp5krAEdyHv4A48k3ieTiBi6hD92SzkGiZPzwZykj4/JwuZ
         vZJsqlK1LB6iK5IWM2ZsAV3DOh/InPmvY/x+t1Ut3tSV6L0m87K5lAc3rxBKG/WU0q+Y
         47zQ==
X-Gm-Message-State: AOAM5310mWAMcBYHtBpixtXh5L4WN/ehsryzVyva7zFMWgmU3to264pH
        vCkBfUtsDnYHehMUbU0t7Xx0Iw==
X-Google-Smtp-Source: ABdhPJyMSCceZ77YJwhl0z1r0OY0A22a0uOCG55/fGlq8eYfKoD8tFH0GLGzFe4gBYmNj6SvelIxjw==
X-Received: by 2002:adf:ec82:: with SMTP id z2mr26141037wrn.214.1619611629386;
        Wed, 28 Apr 2021 05:07:09 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id z18sm8011759wrh.16.2021.04.28.05.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:07:08 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B1ADC1FF7E;
        Wed, 28 Apr 2021 13:07:07 +0100 (BST)
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org>
User-agent: mu4e 1.5.12; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, shashi.mallela@linaro.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test
 into KVM and TCG variants
Date:   Wed, 28 Apr 2021 13:06:18 +0100
In-reply-to: <eaed3c63988513fe2849c2d6f22937af@kernel.org>
Message-ID: <87fszasjdg.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Marc Zyngier <maz@kernel.org> writes:

> On 2021-04-28 11:18, Alex Benn=C3=A9e wrote:
>> A few of the its-trigger tests rely on IMPDEF behaviour where caches
>> aren't flushed before invall events. However TCG emulation doesn't
>> model any invall behaviour and as we can't probe for it we need to be
>> told. Split the test into a KVM and TCG variant and skip the invall
>> tests when under TCG.
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Cc: Shashi Mallela <shashi.mallela@linaro.org>
>> ---
>>  arm/gic.c         | 60 +++++++++++++++++++++++++++--------------------
>>  arm/unittests.cfg | 11 ++++++++-
>>  2 files changed, 45 insertions(+), 26 deletions(-)
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 98135ef..96a329d 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -36,6 +36,7 @@ static struct gic *gic;
>>  static int acked[NR_CPUS], spurious[NR_CPUS];
>>  static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
>>  static cpumask_t ready;
>> +static bool under_tcg;
>>  static void nr_cpu_check(int nr)
>>  {
>> @@ -734,32 +735,38 @@ static void test_its_trigger(void)
>>  	/*
>>  	 * re-enable the LPI but willingly do not call invall
>>  	 * so the change in config is not taken into account.
>> -	 * The LPI should not hit
>> +	 * The LPI should not hit. This does however depend on
>> +	 * implementation defined behaviour - under QEMU TCG emulation
>> +	 * it can quite correctly process the event directly.
>
> It looks to me that you are using an IMPDEF behaviour of *TCG*
> here. The programming model mandates that there is an invalidation
> if you change the configuration of the LPI.

But does it mandate that the LPI cannot be sent until the invalidation?

>
>         M.


--=20
Alex Benn=C3=A9e
