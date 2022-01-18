Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA0C492C5D
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244071AbiARR3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiARR3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 12:29:40 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2A6C061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:29:39 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id m8-20020a9d4c88000000b00592bae7944bso22026760otf.1
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 09:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EmjNg9lNxh54HZ72qxgQELVSPnW1LTx7hlMB9FXaGSU=;
        b=T1DHldf9aXpA2NB/vIe/tUGYfP8s7lMazNYGYEgvlJJZ1lGAyEltryFVs4wPKrv9DD
         Z2uUMcfImr1rw9UQPCLoo52JvXV1Sz4Ee6e/kq8FWgGgA2mKSR9bTXPpp7tsmOOFAz0n
         ud9OesyF86Rtpvq1MhvvDhezMMpgprbsg2ltFq2EGpCZ2czatyb2aYvFGMWqI/DWeSMj
         l0MePvRq0+jmXAbxQDcXtJbbame/e1528txoydl4dJr9KW2LJpGnG9x9H4O7pLqxYkSn
         pzTzTWCCmwh6x+rlsNIpLb6gEacDlz72+mC5D4egBGyMzES9RZDnzsyM8jvnZmI6GqrB
         S0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EmjNg9lNxh54HZ72qxgQELVSPnW1LTx7hlMB9FXaGSU=;
        b=fwo0cU8KiEdqXNIrw1vsL4zJnEnSZij5vjYy09c1YJnFwtzhHTyQcUDXfbbitpY0ra
         Shd45uWa6kk7oTGP9gEaeNUJd8M7PFCYYqbaTCOaR8gGMNOvueUSykiBm7J3SNxQCGAY
         R5te07t0vbqYydnk7uMvXGTTT6jDKS4xUpbDR86kiVZdPxtHVg90mnbjL9mIkvaJ7UfO
         6WgYHvD8H/cBj5kDImvtpzr4YasBFsVH8M7XHau3lf9D18wJ5a7CL25ym6l5JOFtliOs
         slqeBh/4sigGhHxEftuln1VfPXeJ7b5T5O4U2ANYT7eqMS9BHDBJMMhW9FqDZxVH96fI
         Q+gw==
X-Gm-Message-State: AOAM533OxCLeoWC0dkwhuW+ax7o6+PpeX9HblOZIAkGwrWdzoU8tvjHj
        IxFfr9gkHV8Fb9OoEnQQH6GN0pKl3/x5ngiP4IfLSA==
X-Google-Smtp-Source: ABdhPJwJHm9wHLgBGSZ7FmlGNvcLqlh2j6gUYpZat/k4e9UljHEhGTJYZBfk1it+aXdUYgPNZUM9Xc6m/A5tF66yHFk=
X-Received: by 2002:a05:6830:1bea:: with SMTP id k10mr11942905otb.29.1642526978945;
 Tue, 18 Jan 2022 09:29:38 -0800 (PST)
MIME-Version: 1.0
References: <20211116204053.220523-1-zxwang42@gmail.com> <7ecac5d3-a132-73cd-e5b9-8f35cf946d4b@redhat.com>
In-Reply-To: <7ecac5d3-a132-73cd-e5b9-8f35cf946d4b@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 18 Jan 2022 09:29:27 -0800
Message-ID: <CAA03e5E9qBrs3GXZnkxR71-hi0GyvhQMkvbCgqRk8aZ_b=euuA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 00/10] x86_64 UEFI set up process
 refactor and scripts fixes
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 8:51 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/16/21 21:40, Zixuan Wang wrote:
> > Hello,
> >
> > This patch series refactors the x86_64 UEFI set up process, fixes the
> > `run-tests.sh` script to run under UEFI, and improves the boot speed
> > under UEFI. The patches are organized as four parts.
> >
> > The first part (patches 1-3) refactors the x86_64 UEFI set up process.
> > The previous UEFI setup calls arch-specific setup functions twice and
> > generates arch-specific data structure. As Andrew suggested [1], we
> > refactor this process to make only one call to the arch-specific
> > function and generate arch-neutral data structures. This simplifies the
> > set up process and makes it easier to develop UEFI support for other
> > architectures.
> >
> > The second part (patch 4) converts several x86 test cases to
> > position-independent code (PIC) to run under UEFI. This patch is ported
> > from the initial UEFI support patchset [2] with fixes to the 32-bit
> > compilation.
> >
> > The third part (patches 5-8) fixes the UEFI runner scripts. Patch 5
> > sets UEFI OVMF image as read-only. Patch 6 fixes test cases' return
> > code under UEFI, enabling Patch 7-8 to fix the `run-tests.sh` script
> > under UEFI.
> >
> > The fourth part (patches 9-10) improves the boot speed under UEFI.
> > Patch 9 renames the EFI executables to EFI/BOOT/BOOTX64.EFI. UEFI OVMF
> > recognizes this file by default and skips the 5-second user input
> > waiting. Patch 10 makes `run-tests.sh` work with this new EFI
> > executable filename.
> >
> > This patchset is based on the `uefi` branch.
>
> Hi, I have now merged this series and the uefi branch into master.
>
> Paolo
>

Excellent! The change to the last patch looks good to me by the way.
