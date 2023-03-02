Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8416A8C2F
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 23:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjCBWuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 17:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCBWuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 17:50:18 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9EC457C5
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 14:50:15 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id a1so622480iln.9
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 14:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677797414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x338600Q7VIX0cVgTZIiqK+j8XOSNURHeS+9aau97o4=;
        b=fYzDI7YEGJzsMcYSlufZAbcr4q7PjjLLjd/TjIzIxwzc+274KkH32RMirrp6xRwzWa
         nrcM6oWMUUYpj0BgQosXGRqWER18ZxlPoeCbSOfEuTjEKiV2Tqykd4kqgaLwt1dUG340
         nzHshtEVoy9SszbLC8uOvLMheWKMe3bKb0uVRVmCLy9Y0I0NLCxLhvigKkG22hsunVYN
         mbfc4SnSr2Nx9PrAP5xPucpEiivhBCmi/JcwevNb6LQKaUO1t3eUMVoTTtUw89lVrSGw
         R9j0Gj6qcmZnGe4kij2OQ0YJY9fybpHUXS9VTzS9Ab3+5oCQxolcsuiIiEr6Jv6mVfSQ
         MeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677797414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x338600Q7VIX0cVgTZIiqK+j8XOSNURHeS+9aau97o4=;
        b=f3wjrMAX//vzV5t4XJLqdXNxquzZu1UqNx4LSHuYF3K/q4j3hUhUgHvJLcnozjfHsy
         9fI01dZyndtdeYg0z/2Tomu5739cObQRb+Dkh6x9BT+ddaF+1aTmTN1iBK799KFG3Ozr
         Yr08dpUKTO+1mDhObr5nxBQOJRHSVJ5WX4zGRCt3p2053wx441JX+4yAwwdNpSgOErRW
         dcMyU2t9TXXCFOcJnew8yVdOrkT2f7pNUNtz4MH1dZrPgLH3bkUcVHDWkBaWKSdQi6lJ
         iI939Nb/M4Lz3Gawv45LXJOXnc8W93Dy7nkTof/+7eoIkzhbR1RnA/SJN9FHN3K5kp5d
         2FiA==
X-Gm-Message-State: AO0yUKUg7H2L1pOgR9aAqzgM08ZPz+HOMKA2/BIpvevXWjZPAWUEnFhJ
        0oaSfr1J7k761jQZm+ACukgm1ihNrPwc6QNGT/si4A==
X-Google-Smtp-Source: AK7set9Gz+L6bBFx0FCaiTRMVO266S9Eb5sIaFu9FBHZEnKh9iKHp20FB1hIr361REJb3krbTInmUSSwe3KwLqcM2f4=
X-Received: by 2002:a05:6e02:928:b0:316:6c3a:88a1 with SMTP id
 o8-20020a056e02092800b003166c3a88a1mr34134ilt.6.1677797414374; Thu, 02 Mar
 2023 14:50:14 -0800 (PST)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-9-aaronlewis@google.com> <ZAEIPm05Ev12Mr0l@google.com>
In-Reply-To: <ZAEIPm05Ev12Mr0l@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 2 Mar 2023 22:50:03 +0000
Message-ID: <CAAAPnDF=upv3Un4VTrTsGsVY6-0Q9TkOEwjwhE0j0OewYKMx_w@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] KVM: selftests: Add XCR0 Test
To:     Mingwei Zhang <mizhang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 2, 2023 at 8:34=E2=80=AFPM Mingwei Zhang <mizhang@google.com> w=
rote:
>
> On Fri, Feb 24, 2023, Aaron Lewis wrote:
> > Check both architectural rules and KVM's own software-defined rules to
> > ensure the supported xfeatures[1] don't violate any of them.
> >
> > The architectural rules[2] and KVM's rules ensure for a given
> > feature, e.g. sse, avx, amx, etc... their associated xfeatures are
> > either all sets or none of them are set, and any dependencies
> > are enabled if needed.
> >
> > [1] EDX:EAX of CPUID.(EAX=3D0DH,ECX=3D0)
> > [2] SDM vol 1, 13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED
> >     FEATURES
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>
> Sorry, I did not get the point of this test? I run your test in an old
> (unpatched) kernel on two machines: 1) one with AMX and 2) one without
> it. (SPR and Skylake). Neither of them fails. Do you want to clarify a
> little bit?

The only known issue exists on newer versions of the kernel when run
on SPR.  It occurs after the syscall, prctl (to enable XTILEDATA), was
introduced.  If you run this test without the fix[1] you will get the
assert below, indicating the XTILECFG is supported by the guest, but
XTILEDATA isn't.

=3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
  x86_64/xcr0_cpuid_test.c:116: false
  pid=3D18124 tid=3D18124 errno=3D4 - Interrupted system call
     1 0x0000000000401894: main at xcr0_cpuid_test.c:116
     2 0x0000000000414263: __libc_start_call_main at libc-start.o:?
     3 0x00000000004158af: __libc_start_main_impl at ??:?
     4 0x0000000000401660: _start at ??:?
  Failed guest assert: !__supported || __supported =3D=3D ((((((1ULL))) <<
(18)) | ((((1ULL))) << (17)))) at x86_64/xcr0_cpuid_test.c:72
0x20000 0x60000 0x0

[1] KVM: x86: Clear all supported AMX xfeatures if they are not all set
https://lore.kernel.org/kvm/20230224223607.1580880-6-aaronlewis@google.com/

>
>
> Thanks.
> -Mingwei
