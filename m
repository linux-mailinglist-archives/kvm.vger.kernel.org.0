Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9C0412D9B
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 05:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhIUEBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 00:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhIUEBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 00:01:03 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CB8C061760
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 20:59:35 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x27so76108805lfu.5
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 20:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7fjX0XmTgopMoKrZvYVpXB0XGaDN8J/ur4pHmENXVM=;
        b=ALoZh4wR6Haaw/URX2h9V0CeOBH9Ni+KLQfRqkp4gbsxdoWfsY0tTuhpmXRsZvqy5i
         +0SFo/eT8WeqqQBbzzbhtxXZMTlr0Y+pfbE4UA5eHKtOTaagLUqOyRv7r/fPuh4Zig4H
         7uOejKFSjfwCpCe3dkhHYGidUepPeVAmWMrnHzTdH/S2ozJ8RLCpaQ7bDCJGapW2Z0f7
         sc7nogFJYJOvQTAlyI2K1dcoCw8vop/TVooelEb55NVkbNneKwsZUfQjpLadBSbzHBo3
         pHzMkQl8+xZpJHhYscHl7PY8ckVQLWgaI9Eyc3vnMWSJLVhdnRXiwPZ1GUnIx6+1cao9
         DZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7fjX0XmTgopMoKrZvYVpXB0XGaDN8J/ur4pHmENXVM=;
        b=27ATJhsmNZHk937PxYwbHGM5xpaPeXaaX8ixWGAl1+4acNqVwexuAdQ34ma16CdJ12
         Y2QTQf7gX370kU46/B2xtRMxEpNmsz1XOGec+bKQAEtbwQ4cXamj9ZG4V2Xtanb/SlC2
         rv7Bf/2IN109QEFLuxbDGX3DmPjkzWc2yS15127NAfcRg+gRomZYF/8JfHxa9ZdJ+1D6
         b1g3xej5XG3/ExJbT2YgS3Q3xysxR+X3UojpCGEnJTNglh8uwOLHPCCFgzZ86DXdhb8O
         lrOTIo4rHps6lzUif5KIt5UXEgaI9VT2CnQUNVzHiv9OHA9p2DjcBa5l2ZmSyahglnox
         dRBg==
X-Gm-Message-State: AOAM531HdHPUkCZC48B5zjIcz0Ki5VwR/HfVEiIJDnfv9rSSF8Iyr+/t
        ILe391+uUcta5yUXsX1O9oWg5AQl2h7QXUsO9z8=
X-Google-Smtp-Source: ABdhPJzdzcuPcxujlWSj48BIAP3jJaYWfVz+GviIbKzaGdOZjKwtReKQ535T8bthHsx/Ygib0WIRPvbKdJeMmC256Lo=
X-Received: by 2002:ac2:446e:: with SMTP id y14mr5409094lfl.326.1632196773642;
 Mon, 20 Sep 2021 20:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-2-zixuanwang@google.com> <0f423c39-a04d-160e-b3b8-488029080050@redhat.com>
In-Reply-To: <0f423c39-a04d-160e-b3b8-488029080050@redhat.com>
From:   Zixuan Wang <zxwang42@gmail.com>
Date:   Mon, 20 Sep 2021 20:58:57 -0700
Message-ID: <CAEDJ5ZQJ=D3ZwzMwp_jof-xLON=mZ=JFJMmvrwqcL_zW9CcJ1A@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 01/17] x86 UEFI: Copy code from Linux
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com, Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021 at 6:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/08/21 05:12, Zixuan Wang wrote:
> > +
> > +/*
> > + * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> > + * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> > + * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
> > + * this means that firmware services invoked by the kernel may assume that
> > + * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
> > + * do not tolerate misalignment. So let's set the minimum alignment to 32 bits.
>
> Here you're not doing that though.
>
> Paolo

Hi Paolo,

Indeed, I checked the original Linux code [1] and it has the alignment.

This patch is from Varad's patch set [2]. I can update this code in
the next version if Varad is OK with it.

I just finished my Google internship and lost my access to the Google
email, so I'm replying with my personal email.

[1] https://elixir.bootlin.com/linux/v5.14/source/include/linux/efi.h#L73
[2] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/

Best regards,
Zixuan
