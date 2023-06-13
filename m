Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E7072E365
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbjFMMzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242497AbjFMMzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 08:55:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC22F10D9
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 05:55:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-652d1d3e040so4140319b3a.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 05:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686660908; x=1689252908;
        h=to:references:message-id:cc:date:in-reply-to:from:subject
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N9+J5pkzNukUkC+uqb2tz8DIK3px0ww4xZnjqp8unR0=;
        b=bKuxr4gjk2PMj61xfuW+ebHXU8+iCXVxu3jnqjg+5fgtRsnA2us+DfnrHaM2rka0Fj
         AqpYG7fycKc80sFo4JRtHu+kRafFlBnTmFHR0R96zVr9wnQUKyFpMk2lFvmD7/36FJH6
         CPMryp9EuBngD8qVgoxwVMLCmtRas9uT7yV+LfGliL0JZeFSHJumKgbWgqbcd26aGmVE
         YVRyvV6u9K1uA6DXLLJsZ9FO9siuFNSXpRj9vJxOIqGZVD0+A+RllTpNrQjJaK38c7LA
         soMcmByTGygWFzo+1JVOZSH7WR4m/7mXhmIix1SR8OFrEgeB7t+l/8aKXsw1lm1HfoCB
         Lnag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686660908; x=1689252908;
        h=to:references:message-id:cc:date:in-reply-to:from:subject
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9+J5pkzNukUkC+uqb2tz8DIK3px0ww4xZnjqp8unR0=;
        b=l1KwdQoXKBydOi0So1LyMRurR5OwYr+APWHIik2jbWgNZNgrnfUqmkO/FhgYIBIF3h
         yVBkhs2iN7WRzuAnHmSRrdF6CoilbQrQEl5XZXKagwNuDxOHN4cncYW/zzWCGflID/2o
         O+OkD0rpMUf9ps0V6/kMMbzsYwAjfKc8HAXwMnNxfPTImmDozcImzyrwfLKWtT7OMoc+
         JqODflGy+BvXsKkym0QIGEkE5xiA3HP72VoiCQEOQfr1Dnka0RczOJeLTSskpEAmnwMw
         pqILEzLtL4lTFi7gdypueQM8lhPVAeaRV2kUgyFEnv7/ID4gjUPPUqDqUt6Vaj+Wmu5J
         SwvQ==
X-Gm-Message-State: AC+VfDxHbX727k01VaExpc0JehPjW7EDU7YkB7BeKTIQIHbWMvY45wFd
        VPfkd0PWUPGNVRTZgRx7SoY=
X-Google-Smtp-Source: ACHHUZ7MfQ83oeDmCKmmF5IR2/dUBT3Uiq0Q33EsEyZFdNt5EmdBPOC7p+P3Sv0wyKFxK0zN35mfmA==
X-Received: by 2002:a05:6a20:3d17:b0:10c:41a6:ac1f with SMTP id y23-20020a056a203d1700b0010c41a6ac1fmr13360873pzi.16.1686660907717;
        Tue, 13 Jun 2023 05:55:07 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902d68300b001b243a5a5e1sm3553874ply.298.2023.06.13.05.55.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jun 2023 05:55:07 -0700 (PDT)
Content-Type: multipart/signed;
        boundary="Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230613-6b1cb3080babea45f2542c49@orel>
Date:   Tue, 13 Jun 2023 05:54:53 -0700
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Message-Id: <D24DE2A5-2655-41C8-8320-69E1AD67823D@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
 <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
 <de16e445-b119-d908-a4dc-c0d7cf942413@arm.com>
 <20230613-6b1cb3080babea45f2542c49@orel>
To:     Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Jun 13, 2023, at 4:21 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
> On Mon, Jun 12, 2023 at 10:53:56PM +0100, Nikos Nikoleris wrote:
>> On 12/06/2023 16:59, Nadav Amit wrote:>
>>> Thanks. I am still struggling to run the tests on my environment. =
Why the
>>> heck frame-pointers are disabled on arm64? Perhaps I=E2=80=99ll send =
my patch to
>>> enable them (and add one on exception handling).
>>>=20
>>=20
>> I am afraid I don't know why it's omitted. It seems that x86 and arm =
keep
>> it:
>=20
> The support was first added to x86 and then I ported it to arm and =
gave
> porting it to arm64 a small effort too, but it didn't work off the =
bat.
> I wrote it down on my TODO, but it eventually fell off the bottom=E2=80=A6=


Thanks. Don=E2=80=99t worry. I=E2=80=99ll send my implementation.



--Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmSIZx0ACgkQHaAqSaba
D1pJTA//eDphpaaagDgAqhCvKZmAzI6/Jg7kihKfKAiRy/p29ZfD1r4hHcE/X4XC
qWvyvFVc3qkKUhUayGW7w3+XsJibZ7mbUzoWZFIu1IL+C5SpLJOvbaVObu05j3pV
aZicJ1JLXoo2HM6mMvz4Y5hYRlHnyQes2qvOmqtQ8Z2vI2NWS0PJI9tsQW7R08pQ
mgeyjjnOudh0MjMGIB+FlmFRnfM4wRaxAT/3WibqR36u7Lupaz8OHa81t0JjPNku
+GxztEiMkJZDNB5O6H/QXfnOn2GiFwIVxpXKnP0lM+IowLKDDCxijcodVkdsm6ON
Gvye3w8r2A2aSGb83XWZqy09FlWlMq0asUKLIIhk0pyUEvxeOnQpPnKyCqFT2jVY
gNzeKi3ZfpxeKkWwYLqZworaGuBbkt4iKPWm8KVBZo0kQzefIU534a9GfZUzyHvk
IKLWpzip7/rsXBWXOXcivcenizEYCuNJlc25DKtzOPbFvU3gJF6dafq7LcZb9yRq
biQwQrXtCnFZNlSs0Uzb7BQM6hNJyDeJ8KwjCs8rnBXf7Al+zGGT5V/8CyR1Kvbw
prfjIRvEd85aJOrqQYWmcX1WbfU8rTze+jImsDYN74U/Wix42j4jiFZCp8/uxKQx
omMbG4ddTbY+gsL150AWfKQKAVCDO2T3ZwjdMbH4CjOXmUP/Jfg=
=L0j+
-----END PGP SIGNATURE-----

--Apple-Mail=_2916A246-24B3-4374-86EF-1037BF8708A3--
