Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8252C699C51
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 19:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBPS3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 13:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBPS3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 13:29:36 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58784C14
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:29:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-50e79ffba49so29199087b3.9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 10:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NETT9pg/UDnIik4BeaCxxcIeCtyaHAruKX6vctetfVM=;
        b=cn++4Cx0+TSI4BXp2VyNeedxXsIRUN6rUdbrhgx7Vg0jOzhMeZ9QE9yLZ2hDFafZoc
         XeNDKooPy48BsAWequrBfKdbqLYsUUpZicddkD3tMnpj2+T4+mcMCg7mNkxKYNoSXmr4
         2XRIO+lTCwX2u8cAclDsdApnwvX0Ryw+UMmQvSousynDkR0wz2V0Elc4Kb95abB1nX/Q
         mzGlR6JsD2/y6BMbcWr3HcvDI5zyI6y1TCPvLrMOezpm8JLifopgaswnifAEltjiy17s
         Z624eCf5E0Fk7Bf6zLl7SGIetlDqB5AgwUlU1Tug4GJCVkIZIGcqgfmYyVX7TX3eaCTr
         vMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NETT9pg/UDnIik4BeaCxxcIeCtyaHAruKX6vctetfVM=;
        b=papm++QXwk/JQ5LBuSjXl3wGj7HzeXmYALXBlhhqD1P5owATTkGUsa4GgkhgHNqvBz
         xGbOvTRtJHwP0UjEbv6c59J13FTb5Z/Gf3bGRea7MoBM7BCUIGpS4mV7anx5fvYHtqHk
         +EYFolYAei8pvTeIF88fTsYKYZzOOwfnjtfJpO9lTkgLokBz6vOli15D6+aiPTcKNM84
         k5ZlwkSDoY61bv16al/jcsD9VYa0fl7C8n4na814sh4d8gi1RBuUv6lK92Y872MK52xF
         sUs9tY2DeuDXA+TdEdmRxdgotpeXMGpujI8YosCSsqJfHKqnbyxY630UnL5QQvbncmZU
         fy1A==
X-Gm-Message-State: AO0yUKURSo41Zim0NhIo/SVsMHuTpYT5cIcJ3Nw0MgHB8suQc2SE/rpv
        To6NFCqRMdNfwarYM/I4qcgc5uvoOew=
X-Google-Smtp-Source: AK7set8Gq1YQ0UMJmw7F/iUQxGLrh9NtxOHiFndhc4/urggSu+oPEcAu4oGwGPHUHH3MGryjdq/3ZeLOzl0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9d81:0:b0:919:407:ba6d with SMTP id
 v1-20020a259d81000000b009190407ba6dmr672438ybp.203.1676572175000; Thu, 16 Feb
 2023 10:29:35 -0800 (PST)
Date:   Thu, 16 Feb 2023 10:29:33 -0800
In-Reply-To: <BYAPR12MB301441A16CE6CFFE17147888A0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Mime-Version: 1.0
References: <c0bf0011-a697-da29-c2d2-8c16e9df21cf@outlook.com> <BYAPR12MB301441A16CE6CFFE17147888A0A09@BYAPR12MB3014.namprd12.prod.outlook.com>
Message-ID: <Y+52DQQT+N/4gWDb@google.com>
Subject: Re: Fwd: Windows 11 guest crashing supposedly in smm after some time
 of use
From:   Sean Christopherson <seanjc@google.com>
To:     "=?utf-8?Q?Micha=C5=82?= Zegan" <webczat@outlook.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023, Micha=C5=82 Zegan wrote:
> Resending to kvm mailing list, in case someone here might help... Also wi=
ll
> try again with newer ovmf, but assume it happens.
> I have windows11 installed on a vm. This vm generally works properly, but
> then might crash unexpectedly at any point, this includes situation like
> logging onto the system and leaving it intact for like an hour or less. T=
his
> can be reproduced by waiting long enough but there is no single known act=
ion
> causing it.
>=20
> What could be the problem?
>=20
>=20
> Configuration and error details:
>=20
> My host is a msi vector gp76 laptop with intel core i7 12700h, 32gb of
> memory, host os is fedora linux 37 with custom compiled linux kernel (fed=
ora
> patches). Current kernel version is 6.1.10 but when I installed the vm it
> was 6.0 or less, don't quite remember exactly, and this bug was present. =
Not
> sure if bios is up to date, but microcode is, if that matters.

...

> Guest is windows 11 pro 64 bit.
>=20
> What crashes is qemu itself, not that the guest is bsod'ing.

Can you try a 6.2 or later kernel?  E.g. Linus' HEAD, linux-next, kvm/queue=
, etc.
KVM had a pile of SMM fixes[*] merged for 6.2 specifically aimed at fixing =
issues
with secure boot of Windows 11 guest.  They aren't likely to be backported =
to LTS
kernels as they aren't easily consumable (though I'm guessing software vend=
ors
will end up backporting to their supported kernels).

[*] https://lore.kernel.org/all/20221025124741.228045-1-mlevitsk@redhat.com
