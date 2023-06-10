Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A6572A761
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjFJBON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 21:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjFJBOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 21:14:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FDD30EE
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 18:14:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b24ff03400so11802445ad.3
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 18:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686359649; x=1688951649;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1B2w267TBCpz92wei44eed0BDmkFzEc8WfjYSUeJWY=;
        b=pOkS+1cUL/DduypY42nMmK3lNjDJ+GeQ5pALl3myXwrO+rCqZuLcYWfjy98/fwcSLd
         +wY7TNweVbPKfcNXEe4xNkh8Ujsrs9JYLNvLB+B/1cP0w18bs0N/7isSt/Z2e5yib42e
         OY2BF0dPafRK6zFn5xVd6kXgG7wc3q5WwgEm+Qo738Fv7NrzVF0ZdqR/2IHTUU1U1Umt
         iVcvCBNXp+RNtTA7jv6xJ4KNIKbywnB+TMktzS4wZ7Hhqb2JiWoWUcqiCjxHCAfZslP8
         TLs0BEysTRX41eaQlxVxkxgB4DOppfX8joxGmBx8Up/AijfGjxkKGEAwgbLIlm4ieat2
         Aopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686359649; x=1688951649;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A1B2w267TBCpz92wei44eed0BDmkFzEc8WfjYSUeJWY=;
        b=BthFagzr01Fy5ehBbAeWRO2MKub/ALZYmXXH6dLYzApfcwleMToqdD8TyreCoRtuRt
         N7ulBcgDa9t1Tf7hoLSUczD+wgwDGJ5vYrSPCwIT4cLZ4k7p3xYoLAp741Es8l+vpkx8
         +OJCrI01H69xlSK4jXmvQmw+87MQcx5knj3YTmIi3MYaQdTWuo6NDlhKV6idBXRcnFMs
         4mh50/n+BJFQq8oHhvZGNmfBMFl8QTBRTa1UhdFcIUzexC/F2J9c+7iaayFhm8GtNaxm
         s2vEAc0WswMRimKMV48fez6QpdwzJESdZfGgWveaCfyH8x+/JZFGNPAuD8Q93SwV5lsj
         rq6w==
X-Gm-Message-State: AC+VfDwwdeVt8l0hijA+A2yDh0eM8OiedN0sevumUK+uO5N/oNFHSTSI
        LT6BTxgvLnP9D0SnaVuUIQkFYQrgIxE=
X-Google-Smtp-Source: ACHHUZ5miKsOO7rBQH9H6kc23iz/1w1MSHKF/Gf8yINgPpepEMwQCOyr7zNC9ZWZsPGldKgfO2/h/w==
X-Received: by 2002:a17:902:e812:b0:1b0:4a63:3099 with SMTP id u18-20020a170902e81200b001b04a633099mr448095plg.50.1686359648681;
        Fri, 09 Jun 2023 18:14:08 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001a4fecf79e4sm3842314plh.49.2023.06.09.18.14.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2023 18:14:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230609-a490dc451a2b45a60dbe9e13@orel>
Date:   Fri, 9 Jun 2023 18:13:55 -0700
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A6D2DF32-8129-4955-943B-C9FBBA767196@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
 <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
 <20230609-2ef801d526b6f0256720cf24@orel>
 <32f41722-2941-55b5-d11b-200e43319c8e@arm.com>
 <20230609-a490dc451a2b45a60dbe9e13@orel>
To:     Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 9, 2023, at 7:31 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
> On Fri, Jun 09, 2023 at 03:06:36PM +0100, Nikos Nikoleris wrote:
>> On 09/06/2023 08:21, Andrew Jones wrote:
>>> On Thu, Jun 08, 2023 at 10:24:11AM -0700, Nadav Amit wrote:
>>>>=20
>>>>=20
>>>>> On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>>>=20
>>>>>=20
>>>>> On May 30, 2023, at 9:09 AM, Nikos Nikoleris =
<nikos.nikoleris@arm.com> wrote:
>>>>>=20
>>>>>>=20
>>>>>> +static void uart0_init_acpi(void)
>>>>>> +{
>>>>>> + struct spcr_descriptor *spcr =3D =
find_acpi_table_addr(SPCR_SIGNATURE);
>>>>>> +
>>>>>> + assert_msg(spcr, "Unable to find ACPI SPCR");
>>>>>> + uart0_base =3D ioremap(spcr->serial_port.address, =
spcr->serial_port.bit_width);
>>>>>> +}
>>>>>=20
>>>>> Is it possible as a fallback, is SPCR is not available, to =
UART_EARLY_BASE as
>>>>> address and bit_width as bit-width?
>>>>>=20
>>>>> I would appreciate it, since it would help my setup.
>>>>>=20
>>>>=20
>>>> Ugh - typo, 8 as bit-width for the fallback (ioremap with these =
parameters to
>>>> make my request clear).
>>>>=20
>>>=20
>>> That sounds reasonable to me. Nikos, can you send a fixup! patch? =
I'll
>>> squash it in.
>>>=20
>>=20
>> I am not against this idea, but it's not something that we do when we =
setup
>> the uart through FDT. Should ACPI behave differently? Is this really =
a
>> fixup? Either ACPI will setup things differently or we'll change the =
FDT and
>> ACPI path.
>=20
> Yeah, you're right. It's not really a fixup and I forgot that we abort
> when the DT doesn't have a uart node too. Let's leave this as is for =
now.
> We can do a follow patch which adds a config that says "use the early
> uart and don't bother looking for another" which we'd apply to both =
ACPI
> and DT.

Ok. I=E2=80=99ll add some option later to force it, perhaps if =
UART_EARLY_BASE is
different than the default.

