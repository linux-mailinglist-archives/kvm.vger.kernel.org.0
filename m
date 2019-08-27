Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E7F9E7FF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 14:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfH0MdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 08:33:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36332 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfH0MdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 08:33:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so12621181pgm.3;
        Tue, 27 Aug 2019 05:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eLpuR9eRgxYeI49WIr/DhspGOopwmemU6oZ7y4W2wxE=;
        b=NDT6L9KHNjR1GCoCxK1ZeypCroDAPTE9Xdbr9iwV5pnx2Iw3K2qiOkdU1O+7fEKxSG
         AHJ0Y2O77FZQ8BcfNtiTAXFJZGtNXJDfM2nYSSDXzfbOe6SYWDkaqmDw4/FMQNDR1MuB
         RUNGxcGSefzzagY2RfSHmRiVJpfQum72TScMtfnkvTWC19QpCao8tznI0seHahBJH3pE
         muxHfuh+rxQwYcfWDmxEnw36LJgHQU3yQYWIQlgkNbS1PVcBsQjIj0aO1zykAqKn4uDS
         AJHnOyT4ioAHBZSNWqzmy4MrOjx8Xog8B0FLqtfH5H0tTEnRs/xao3lAXKbPB6i8BUkA
         JP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eLpuR9eRgxYeI49WIr/DhspGOopwmemU6oZ7y4W2wxE=;
        b=CiLPRIItLCQTpsiz3yJHqqmILDs3lhF46GTh1ldAb963QrwaX6Bsz2YRHPLuP5LjNN
         VhUx95c+HjEc9jMDmmu38UtoSqoFM9ikI2FB7EH4SovpXH+9QZakw0zwDE5KO+dRusoM
         4TYbe0EptJhO2o+73hubdXK4FKGxNw45OHzVHMtNIf4nzn2fllB5GxVnZEPwRw2E5OlB
         gmsWCNWl4+Ax9rS4tl4zsd0qpGSoJmp/LoFPQEKfheH4hZfGtoxrNtsX3ap7/SHEB2br
         DlyJZlMKIysffJzpvgr7Bc5cBDTzZjQtQHRnUATBuA2qb7DzWluExN+KhdEaY9QI9Riz
         2IBA==
X-Gm-Message-State: APjAAAUBmaKIM9ld6Oiyqt4Xrs4xLbmnnT39YTA0w9f3mSBxbm+8i+MJ
        OAtXIh1MEAMec2Cxr8P8cENzKyZcV4YIYqwYcPI=
X-Google-Smtp-Source: APXvYqxrik847aPLhiBBi7qMgRzNGcEy1mVw8hFjeVmPyk+8dhmq87qvJI5sFKcfJsvyZPHCCkIVKQwVF30hG+3Czqs=
X-Received: by 2002:aa7:8219:: with SMTP id k25mr11889026pfi.72.1566909198804;
 Tue, 27 Aug 2019 05:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
 <87ftlnm7o8.fsf@vitty.brq.redhat.com> <CAOLK0pzXPG9tBnQoKGTSNHMwXXrEQ4zZH1uWn2F2mQ2ddVcoFA@mail.gmail.com>
In-Reply-To: <CAOLK0pzXPG9tBnQoKGTSNHMwXXrEQ4zZH1uWn2F2mQ2ddVcoFA@mail.gmail.com>
From:   Tianyu Lan <lantianyu1986@gmail.com>
Date:   Tue, 27 Aug 2019 20:33:08 +0800
Message-ID: <CAOLK0pwfxhsZN66dU2DE=qb1Y7mnVVjOCxYJP3Fi7kKgjoOFcw@mail.gmail.com>
Subject: Re: [PATCH V3 0/3] KVM/Hyper-V: Add Hyper-V direct tlb flush support
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, corbet@lwn.net,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        michael.h.kelley@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 8:17 PM Tianyu Lan <lantianyu1986@gmail.com> wrote:
>
> On Tue, Aug 27, 2019 at 2:41 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > lantianyu1986@gmail.com writes:
> >
> > > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > >
> > > This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
> > > in L0 can delegate L1 hypervisor to handle tlb flush request from
> > > L2 guest when direct tlb flush is enabled in L1.
> > >
> > > Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
> > > feature from user space. User space should enable this feature only
> > > when Hyper-V hypervisor capability is exposed to guest and KVM profile
> > > is hided. There is a parameter conflict between KVM and Hyper-V hypercall.
> > > We hope L2 guest doesn't use KVM hypercall when the feature is
> > > enabled. Detail please see comment of new API
> > > "KVM_CAP_HYPERV_DIRECT_TLBFLUSH"
> >
> > I was thinking about this for awhile and I think I have a better
> > proposal. Instead of adding this new capability let's enable direct TLB
> > flush when KVM guest enables Hyper-V Hypercall page (writes to
> > HV_X64_MSR_HYPERCALL) - this guarantees that the guest doesn't need KVM
> > hypercalls as we can't handle both KVM-style and Hyper-V-style
> > hypercalls simultaneously and kvm_emulate_hypercall() does:
> >
> >         if (kvm_hv_hypercall_enabled(vcpu->kvm))
> >                 return kvm_hv_hypercall(vcpu);
> >
> > What do you think?
> >
> > (and instead of adding the capability we can add kvm.ko module parameter
> > to enable direct tlb flush unconditionally, like
> > 'hv_direct_tlbflush=-1/0/1' with '-1' being the default (autoselect
> > based on Hyper-V hypercall enablement, '0' - permanently disabled, '1' -
> > permanenetly enabled)).
> >
>
> Hi Vitaly::
>      Actually, I had such idea before. But user space should check
> whether hv tlb flush
> is exposed to VM before enabling direct tlb flush. If no, user space
> should not direct
> tlb flush for guest since Hyper-V will do more check for each
> hypercall from nested
> VM with enabling the feauter..
>
Fix the line break.Sorry for noise.

Actually, I had such idea before. But user space should check
whether hv tlb flush is exposed to VM before enabling direct tlb
flush. If no, user space should not direct tlb flush for guest since
Hyper-V will do more check for each hypercall from nested VM
with enabling the feauter..
---
Best regards
Tianyu Lan
