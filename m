Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C35421950
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 23:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhJDVc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 17:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbhJDVc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 17:32:56 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093F1C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 14:31:07 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id b20so77966686lfv.3
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 14:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eO8kWT+8NWawi4Jh401O1dsfIbuZIcBjZPjEBFkhLbo=;
        b=hBj5wI7xMv4waTCrLLfDt855ZpmYSnvqb0buDdEKwGQXZUkEVRVaozfuCnzW7ePpjq
         tRrahf7rwnzQwWw5zaK0ofREaj96lMhc1/luN+/q2yKlL8YAMGuCBVsDQY2PH/Jf5MsX
         EwIK00QUFjzmkJLs8ROShheyg0VABrlTdKSrN+Wffdt5fegQYo4Po6CCjgvyBnBFs8E4
         WUv9onK3N8HIx/NOTxyerXzFpXmGnOmZ46gj7z1r+IwtiG6mxa9v9sNRbkLIDSWr2AAO
         8ddkKvBNh8OUTOASZJxa/ZZtHQYnNSQ+m7TNdi/V513/WMGQI90QDbHJypWYHz1bTD20
         geBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eO8kWT+8NWawi4Jh401O1dsfIbuZIcBjZPjEBFkhLbo=;
        b=WSRJY6CEywdaRHOrX42nllvxEoZmjxnCRaDsuTarKxDvWREAx2NWG1wWtfYZIroQ4m
         QlocCBcjcvXCQ3yGyzBNqB9etzId7fdp913/h4yCvmqDwrkDt+mvlKX9jSYKkOsEJBQ9
         uiclBqs5Ld+0WpFjNPYnv37j4/PHxXCtyKcAiLBOc94c0DSq008/XBRKDr7qSBkISzkV
         Vzn4jVxK6mmQ7w639nDzVdbckDrZ+PckZhJvrP/RrUoezkuNvU/97dhLB0cR23Gon3wL
         oO3tOefNWVx0fRiwe8IuVrffZkKpWIwWH8Wf1TznJFj2+bt7IsVWMHSMU+thzQMZFKN5
         mlOQ==
X-Gm-Message-State: AOAM533YyF7j9sylL3T/lY0bCLnPcl1lldmM+ZkqE9EfmmeyVkvORJDR
        M99G0VvuMgYsK9DH+qsa4f/LhyCmSa72VEBnId8=
X-Google-Smtp-Source: ABdhPJxybxOaHOuH+qDrszd0pF6BfmqLRDwudWzOZl3x0psci6wBQ9hzExrEQ6jDG4TekjZOTWIOvRvRkOjLNnNBNEM=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr10204412lfi.662.1633383065437;
 Mon, 04 Oct 2021 14:31:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-5-zixuanwang@google.com> <20211004125541.bf76snknn3umwsfe@gator>
In-Reply-To: <20211004125541.bf76snknn3umwsfe@gator>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 4 Oct 2021 14:30:31 -0700
Message-ID: <CAEDJ5ZScDTVaWa9EP-k-_tkv8orYiYFuwoQwPoPqiQ23rSfsvg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 04/17] x86 UEFI: Boot from UEFI
To:     Andrew Jones <drjones@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 5:58 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 27, 2021 at 03:12:09AM +0000, Zixuan Wang wrote:
> > This commit provides initial support for x86 test cases to boot from
> > -unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> > +efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >  {
> > +     int ret;
> > +
> >       efi_system_table = sys_tab;
> >
> > -     return 0;
> > +     setup_efi();
> > +     ret = main(__argc, __argv, __environ);
>
> In my new AArch64 PoC I call an 'efi_setup' from 'start' in cstart64.S
> and then when that returns 'main' is called like normal.
>

x86 is a bit tricky: the cstart64.S 'start' code is compiled to run in
real mode, but C functions are compiled for long mode. From my
experience, calling a long mode function from real mode can crash the
guest VM. So we developed a new start-up assembly that directly starts
from long mode.

I remember Varad's original patchset [1] calls the EFI setup function
from cstart64.S, which introduces several ifdefs to the file.

[1] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/

> > -#include <efi.h>
> > -#include <efilib.h>
> > -
> > +#include "linux/uefi.h"
> > +#include "efi.h"
> >  #include <elf.h>
> >
> > -EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
> > -                   EFI_HANDLE image EFI_UNUSED,
> > -                   EFI_SYSTEM_TABLE *systab EFI_UNUSED)
> > +efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t handle, efi_system_table_t *sys_tab)
>
> I think these conversions should be done as separate patches after the
> import patches.
>

Got it! I will add this to the next version.

> > +EFI_RUN=y \
> > +"$TEST_DIR/run" \
> > +     -drive file="$EFI_UEFI",format=raw,if=pflash \
>
> Also need the 'readonly' property on this drive.
>

I didn't notice this. I will add it to the next version. Thanks for
pointing it out.

> > --
> > 2.33.0.259.gc128427fd7-goog
> >
>
> Thanks,
> drew
>

Best regards,
Zixuan
