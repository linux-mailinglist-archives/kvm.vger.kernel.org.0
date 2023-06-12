Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493EB72CADE
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbjFLQAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239932AbjFLP74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 11:59:56 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C58CA
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 08:59:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b3c3f2d71eso8997375ad.2
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 08:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686585593; x=1689177593;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c2me08iLiC6XwS+//ZtbN/tFK1hxSnmX2rBu9RUTLZE=;
        b=ON8sblzASTTO0L9SA0XYkgsRvCVpPWhzw8Gja+FZ6x0irF8PZd7T0aU6CGVbcLmwlt
         V8dMrM628wSMidxsj44ukrjjU4WPaukz7/1o2SO48sBnn6XItthszJoRRhNaqxU6H3zW
         PiWYz6zj79vi5TQBmkh5a5F4QqZn0b76GGaGReqpz+z7ktAOzuwxh20nhwFns8qeX/zF
         jRkXDr/J6yXFlAbzy+xHCnW6faWfbAXZv5ukw8EgXwzItGHdFirgnPfEHWAabxpimzTU
         ozp4pql64fSnrrpADeSulBGV87tC059S9JSNUwWD+Gt20AE7dajBi9JRgA+41CnDPEMj
         TzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686585593; x=1689177593;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2me08iLiC6XwS+//ZtbN/tFK1hxSnmX2rBu9RUTLZE=;
        b=hVqaV9DvkCw/4FxrRpn5tGtyp9YG39YZGLp+QDMxCFFk4L33kOMdl8mdaxsC1cEzLc
         9sp3+ifsIqTFuPdTaZ1PKnZHCgYk4GCOCPytRYwaYFQyQQuQjCCbWVwRvMcsxj/KKS0J
         jP+fsFmtMkeaFXDBlzrg3cwOwM/iza/KtjYDyohZ5/iJ1zmDL7/TH4EKuvEnxMNqh/2y
         yEIWb5dqIFypC8j6tf2dcNeFZlkciQM0EEaQaOnHtIZpwTa5X3RvmMi++QAYPZ9nEPoz
         FkuKX5stpEt3FTp/VRWilJXflGIUHbKgL6YDOpLUqxCzgs/5nruam39oP7JflKFiYK+S
         OPUA==
X-Gm-Message-State: AC+VfDy5VhhAV3JlIDde8fK6quwZforvauuse8uTbon7W+llD6vLmcF1
        bqoXmc+3s3qsfhmBli2iz8o=
X-Google-Smtp-Source: ACHHUZ7EmtqzUQhh3Au1lL6u6ocYtXsqDFbxhA3BNW6Ps/j+IX4e9u4O7P6Md0Yk4jzLzYx7mJubEA==
X-Received: by 2002:a17:903:2301:b0:1b0:36ad:fe13 with SMTP id d1-20020a170903230100b001b036adfe13mr7998999plh.16.1686585592597;
        Mon, 12 Jun 2023 08:59:52 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b001b045c9ababsm8422380plx.264.2023.06.12.08.59.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:59:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
Date:   Mon, 12 Jun 2023 08:59:40 -0700
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE9170FC-8229-4D93-AD98-35394494CE61@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
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



> On Jun 12, 2023, at 2:52 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> On 12/06/2023 08:52, Andrew Jones wrote:
>> On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
>>>=20
>>>> On May 30, 2023, at 9:08 AM, Nikos Nikoleris =
<nikos.nikoleris@arm.com> wrote:
>>>>=20
>>>> Hello,
>>>>=20
>>>> This series adds initial support for building arm64 tests as EFI
>>>> apps and running them under QEMU. Much like x86_64, we import =
external
>>>> dependencies from gnu-efi and adapt them to work with types and =
other
>>>> assumptions from kvm-unit-tests. In addition, this series adds =
support
>>>> for enumerating parts of the system using ACPI.
>>>=20
>>> Just an issue I encountered, which I am not sure is arm64 specific:
>>>=20
>>> All the printf=E2=80=99s in efi_main() are before =
current_thread_info() is
>>> initialized (or even memset=E2=80=99d to zero, as done in =
setup_efi).
>>>=20
>>> But printf() calls puts() which checks if mmu_enabled(). And
>>> mmu_enabled() uses is_user() and current_thread_info()->cpu, both
>>> of which read uninitialized data from current_thread_info().
>>>=20
>>> IOW: Any printf in efi_main() can cause a crash.
>>>=20
>> Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi =
and
>> put a zero_range call, similar to the one in arm/cstart64.S which =
zero's
>> the thread-info area, in arm/efi/crt0-efi-aarch64.S?
>=20
> While I haven't run into any problems with this in this series, I had =
in a previous version and back then the solution was this patch:
>=20
> 993c37be - arm/arm64: Zero BSS and stack at startup
>=20
> So I agree we should drop the memset and call some macro like =
zero_range in arm/efi/crt0-efi-aarch64.S.
>=20
> Let me know if you want me to send a patch for this.

Thanks. I am still struggling to run the tests on my environment. Why =
the
heck frame-pointers are disabled on arm64? Perhaps I=E2=80=99ll send my =
patch to
enable them (and add one on exception handling).

Anyhow, I was wondering, since it was not clearly mentioned in the
cover-letter: which tests were run on what environment? Did they all =
pass
or are there still some open issues?

[ I ask for my enabling efforts. Not blaming or anything. ]

Thanks again for the hard work, Nikos (and Andrew).

