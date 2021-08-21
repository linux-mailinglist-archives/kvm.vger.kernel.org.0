Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026693F37D1
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 02:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhHUAnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 20:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhHUAnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 20:43:50 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888BCC061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:43:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id mf2so4913518ejb.9
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YCTjZi2TUDy4za21r2QAZ6XJ4IzDWNLkHU1IvKEb6Fs=;
        b=qNb/3kJFYEiaUmQF++Fg+uXHAqZ+dAM7nLy9lXhj4BkrdJZx6R8m0OACFHrxVlFbga
         qZwlHNS295iGDEzI2zgPtd2ciJRy/eVCju9dpJwJ0CpwiKc7k+UQlcH1zJn6cxWlPyZ1
         XqKqbsGYoavUu1wga6WeiBK3NVj+co5TA9z2aYzLJx4E6U3HVP+8MiIJ9xqeZrBam71D
         eFvAtN6JhboYLtD5zqkS3N5uPB60Glw25n7E9OEbVepoxiLYZHSgDOqESVln9/oD4Q1P
         Nkan2n4sJOf7JHxMigKp3DOSgRYpj12l+8OaY//IWXk+xqohRQXS5sFagnjvZVRKAQEn
         kLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YCTjZi2TUDy4za21r2QAZ6XJ4IzDWNLkHU1IvKEb6Fs=;
        b=Agi4D8IfcHX6xLntQ1x1ua/4+1vtP/7jjquhdi87wUkzpaPqP+Dhzxm4gaH2ADgVW+
         c5p9NExLDw7o26d69ZPYOs7gvQEXF9/yhOqctoB0/Vn/ARZKXdw26uo65luMbrE0sKEy
         uIX68AJoySJaIDtIkN95uzgzJz5gukgypAKeZ/TrY6hsMhlPFDVWBMn2H746LlUQvXXV
         qypjEAOZFF1rmIf2XnGxCmOzKJiyE+Le5mzY4QGJKVx7FL1ueLBbr59TK7hg+urj7ANY
         Wi90bTdZVq3cN2gEepRH/RE2EVoNt5dHd3CxUKwH4SM77oA5O6XMOKYpbT9yj59hGSti
         5B0w==
X-Gm-Message-State: AOAM531m1Q19YcMUWGwGIPWWsK+Mx9dJx/eVdf1cd587D9CHb1OrXbyF
        SBglO2ectdB5VX5fyXH26CYzvqjkis0vSOIcjEIApg==
X-Google-Smtp-Source: ABdhPJzoIf61TDjM9lb+sQmI9DrnNBfyDWvArnAqkUO1xQu6kmEcbCCWFgY9/BAnWdQ+UiSa/xajUbNTeDjiJgAi90o=
X-Received: by 2002:a17:906:3542:: with SMTP id s2mr24515564eja.379.1629506589763;
 Fri, 20 Aug 2021 17:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210819113400.26516-1-varad.gautam@suse.com> <YSBCSjJKvvowFbyb@google.com>
In-Reply-To: <YSBCSjJKvvowFbyb@google.com>
From:   Zixuan Wang <zixuanwang@google.com>
Date:   Fri, 20 Aug 2021 17:42:57 -0700
Message-ID: <CAFVYft099UxddW_BRv7sQCGhtwwo-id=4YWQTUKDpaU-Oad2ng@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/6] Initial x86_64 UEFI support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Varad Gautam <varadgautam@gmail.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Varad Gautam <varad.gautam@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 5:01 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Thu, Aug 19, 2021, Varad Gautam wrote:
> > This series brings EFI support to kvm-unit-tests on x86_64.
> >
> > EFI support works by changing the test entrypoint to a stub entry
> > point for the EFI loader to jump to in long mode, where the test binary
> > exits EFI boot services, performs the remaining CPU bootstrapping,
> > and then calls the testcase main().
> >
> > Since the EFI loader only understands PE objects, the first commit
> > introduces a `configure --efi` mode which builds each test as a shared
> > lib. This shared lib is repackaged into a PE via objdump.
> >
> > Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
> > relocate ELF .dynamic contents.
> >
> > Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.
> >
> > Commit 6 from Zixuan [1] fixes up some testcases with non-PIC inline
> > asm stubs which allows building these as PIC.
> >
> > Changes in v2:
> > - Add Zixuan's patch to enable more testcases.
> > - Fix TSS setup in cstart64.S for CONFIG_EFI.
> >
> > [1]: https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@goo=
gle.com/
> > git tree: https://github.com/varadgautam/kvm-unit-tests/tree/efi-stub-v=
2
> >
> > Varad Gautam (5):
> >   x86: Build tests as PE objects for the EFI loader
> >   x86: Call efi_main from _efi_pe_entry
> >   x86: efi_main: Get EFI memory map and exit boot services
> >   x86: efi_main: Self-relocate ELF .dynamic addresses
> >   cstart64.S: x86_64 bootstrapping after exiting EFI
>
> Zixuan and Varad, are your two series complimentary or do they conflict? =
 E.g.
> can Zixuan's series be applied on top with little-to-no change to Varad's=
 patches,
> or are both series trying to do the same things in different ways?
>
> And if they conflict, are the conflicts largely superficial, or are there
> fundamental differences in how the problems are being solved?
>
> Thanks!

I=E2=80=99m currently building my patches on top of Varad=E2=80=99s. This d=
oes not
require too many changes to my patches: I just need to (1) replace the
GNU-EFI function calls with Varad=E2=80=99s approach; (2) copy more
EFI-related definitions from Linux to implement several additional
UEFI service calls, e.g. a reset_system() call to shutdown the guest
VM; and (3) remove some duplicated code from Varad=E2=80=99s patches, e.g. =
I
remove Varad=E2=80=99s modifications in x86/cstart64.S because I implement
similar setup code in lib/x86/setup.c.

This migration affects only the first part of my patch series, and I=E2=80=
=99m
currently working on it. Hopefully I can send out the second version
where I take Varad=E2=80=99s patches as the foundation of mine.

Regards,
Zixuan
