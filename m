Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910F972AA4F
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 10:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjFJIdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 04:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjFJIdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 04:33:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E095B30ED
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:33:12 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2565a9107d2so1361383a91.0
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 01:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686385992; x=1688977992;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYoHCJVN5Ws4WOWwh0nDBJ62B543NnoGs0VnfPoL2AE=;
        b=OarbgxLj+wBHWXNQl/kUWGyZLvdQikw3cGvbVjqyavaLHQPyHru6Op4yKHyaklO7Iy
         dI+9Y4vlpp5qoDkZVO7JozeMTBgzhyfP7q5859TNXKGsAhVKFe7PS41b1M0A+jGKIqgb
         clxmh2NoCiLJdeVd2PpOkqgHlXdHAfD4sE9tHCqNxs4uXNjw8MzvNF/TtfCjvBG833C0
         KB7Tv1ojfsY5Xq63i8/6wnE5vdVA9znWEUIIzvzCZAMM2tojx1DoRXTy2Cdz7ZLkNPow
         s/aTpPbr+ll7GF4JVatzdVrGipPhwY1nTq7bHzJsTASO6nnLgMXg61+UANfpxHu9XG5R
         TtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686385992; x=1688977992;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYoHCJVN5Ws4WOWwh0nDBJ62B543NnoGs0VnfPoL2AE=;
        b=jCBgwXur/IqLwN/iDbdsvXiy14VDEUgcUYbUMRr6zN1PGCOtmdU8qwcY9p80SmW9KA
         IsFzw0kLSvv+7Wk222wbg90OlFA/Tv1APKGkkAblFHuEMHqCVv3stOnrSUitDTIwe+jy
         bR3EFweHlIn7dfCJFEGRKHnbxeggQryQ+w34D024pCGPJmsAPsOw3nnXLq5kZfnbFg5X
         RPlNvmRYNeo4QMk1Hj/dXk8KD08Je0/zz4yzT4ueYOmoSt0iVRwK79fPY9cAHtssoasQ
         vBtTN7vD52H3jZK/IzbXl4TlB22juADb1FSfh8nzdGAEB0dHoCL8gKaBEuLPxyJTfiFl
         rt+Q==
X-Gm-Message-State: AC+VfDzrpnWzFZqd4ncbZtAHl3TUwOlfOrKCoOst+e8j18jTPGcLRcnP
        ExkC2diel0yPvkLwll8itz8=
X-Google-Smtp-Source: ACHHUZ684F1hJ5dJXKAerRauMVuPEsNirNwFulp07Uv6rNCgaT4y3BcN9JXQfx/9bXl6VQTXSEw+pA==
X-Received: by 2002:a17:90b:4b91:b0:255:2dde:17cc with SMTP id lr17-20020a17090b4b9100b002552dde17ccmr3411605pjb.47.1686385991971;
        Sat, 10 Jun 2023 01:33:11 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id b15-20020a17090a010f00b00256799877ffsm4262532pjb.47.2023.06.10.01.33.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jun 2023 01:33:11 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
Date:   Sat, 10 Jun 2023 01:32:59 -0700
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
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


> On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> Hello,
>=20
> This series adds initial support for building arm64 tests as EFI
> apps and running them under QEMU. Much like x86_64, we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.

Just an issue I encountered, which I am not sure is arm64 specific:

All the printf=E2=80=99s in efi_main() are before current_thread_info() =
is
initialized (or even memset=E2=80=99d to zero, as done in setup_efi).

But printf() calls puts() which checks if mmu_enabled(). And
mmu_enabled() uses is_user() and current_thread_info()->cpu, both
of which read uninitialized data from current_thread_info().

IOW: Any printf in efi_main() can cause a crash.

