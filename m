Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF816C8017
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjCXOkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjCXOkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:40:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F50CA5E2
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:40:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54161af1984so20649337b3.3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679668838;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SWD3cJxn2SkFPUZgdDBk5dQiYHPrb9vKrni6NgDQ89U=;
        b=T4yA0v/Mqz9nVblO2vdOd+Ig6IKL1rsDD+kvqZSombbGj68Jh6VRsiYXw+7zWJMR2c
         Xu8I+jzi3HMGqRxaFdsQR8AyiygLnuydtBg16CS7wQeP3b+XRL8UYjq0A7tNbH9RrfHQ
         WGVXhE/kX032X7JMNSGlbDtOl8BlMHDdlwzexqrUUb08PBQwwgiNx+LKUKRnRsYlOp0l
         4yhMytvV/36Wu+0WFVVQZbjFrK1lzwY9n/NVBLlZUbU1J7Rf13Ijghd47XppQrIWeTzx
         ANZaDQeJl7Cd+iNQ3lfsYuCn+4Bi7slo63eP4wcrjSmS4h0cHO69boDEQupZeuEymcBM
         MMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679668838;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SWD3cJxn2SkFPUZgdDBk5dQiYHPrb9vKrni6NgDQ89U=;
        b=E9cBn8B0pkwovNbZbnlmLDnO7HQ803If1hFLqo54fCzUOZeOggNoupoBg469ZneLIS
         ZKfJNvWp7WnC+rXlYhMqjQohnd1r1yfB/gcM6LZZLelUyZ+VmrerO4uaWLV5ecBNSCLk
         gDuXkntBzKE85JAXF9cp9rM8HpuwZCWqh5aUipRbj6CW4bhSH2ji1hNwzYrLOpKnWaVU
         kcPnX4AqSsBElHjY1yrIQTEG/lIH3mA7f1xLa5CZG2bqw3yhIzQF6GWp96kVxvzuaB9w
         O7gNwWimJ6HwZ23L1ew49JGGPSVIpfxUyK/KDPuOr0Uy+J69wrLUJB6ovetxSuiW0cCW
         7rdQ==
X-Gm-Message-State: AAQBX9d7jVWTcrJLIvbFwbnXLVwPka4ERcR+8TehGlaDrjhGhBQ9ZWaw
        QQwg2mGA5r296H3+y80bTX6LyiytacE=
X-Google-Smtp-Source: AKy350a/gwP4fslejnndwPGcp5igbgiXIpP3dS7Wx5U5pvveEYUy7YuDjNxNXJfl+pB3rFXj0UvqtJBq960=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4426:0:b0:53d:2772:65d with SMTP id
 r38-20020a814426000000b0053d2772065dmr1168775ywa.9.1679668838445; Fri, 24 Mar
 2023 07:40:38 -0700 (PDT)
Date:   Fri, 24 Mar 2023 07:40:37 -0700
In-Reply-To: <MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com>
Mime-Version: 1.0
References: <MN2PR12MB3023F67FF37889AB3E8885F2A0849@MN2PR12MB3023.namprd12.prod.outlook.com>
Message-ID: <ZB22ZbhyneWevHJo@google.com>
Subject: Re: Nested virtualization not working with hyperv guest/windows 11
From:   Sean Christopherson <seanjc@google.com>
To:     "=?utf-8?Q?Micha=C5=82?= Zegan" <webczat@outlook.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023, Micha=C5=82 Zegan wrote:
> Hi,
>=20
> I've sent this some time ago, but was not subscribed here, so unsure if I
> didn't get a reply or maybe missed it, so repeating:
>=20
> I have a linux host with cpu intel core i7 12700h, kernel currently 6.2,
> fedora37.
>=20
> I have a kvm/qemu/libvirt virtual machine, cpu model set to host, machine
> type q35, uefi with secureboot enabled, smm on.
>=20
> The kvm_intel module has nested=3Dy set in parameters so nested virtualiz=
ation
> is enabled on host.
>=20
> The virtual machine has windows11 pro guest installed.
>=20
> When I install hyperv/virtualization platform/other similar functions, af=
ter
> reboot, the windows does not boot. Namely it reboots three times and then
> goes to recovery.

This is going to be nearly impossible to debug without more information.  A=
ssuming
you can't extract more information from the guest, can you try enabling KVM
tracepoints?  E.g. to see if KVM is injecting an exception or a nested VM-E=
ntry
failure that leads to the reboot.

I.e. enable tracing

    echo 1 > /sys/kernel/debug/tracing/tracing_on

and then to get the full blast from the trace firehose:

    echo 1 > /sys/kernel/debug/tracing/events/kvm/enable

or to get slightly less noisy log:

    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_inj_exception/enable
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_intercepts/ena=
ble
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_intr_vmexit/en=
able
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter_failed=
/enable
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit/enable
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmexit_inject/=
enable
    echo 1 > /sys/kernel/debug/tracing/events/kvm/kvm_nested_vmenter/enable

To capture something useful, you may need to (significantly) increase the s=
ize of
the buffer,=20

    echo 131072 > /sys/kernel/debug/tracing/buffer_size_kb

The log itself can be found at

    /sys/kernel/debug/tracing/trace
