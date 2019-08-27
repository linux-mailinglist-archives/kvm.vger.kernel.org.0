Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376B99E7AF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 14:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfH0MRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 08:17:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34969 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfH0MRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 08:17:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so12617084pgv.2;
        Tue, 27 Aug 2019 05:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M1Igxvo01clEvfQnAlKc8g7MH2NPhkoAR4LaSiR0pRs=;
        b=GKfBKw3D52+Xy/qWzQjGDH3QWIJHODnwZkm1akApr0LkuhNUohI1mb9gGCgPNeUhIb
         MXncX0VnltPoGAllYM3+i1DN39V3WhwM4okw/0ZZmKgNqbfkrQnk4agg96+GAUVGifOV
         GU8eIitNuu6MwiWxHjHSm6GILhJXmtCYFaHYeiJEDhViciRubgrXhGGdlufyaMDRIwTI
         pXv4DhMbx5kMo68fs2EhNGF5CXVRmdm4iEXHL5FpiAphlaDazQb8h62LgsGHuFteLofb
         LaH36pR9qI06StHW3Eg09JBASsBd2diSWMrfLYqyfqTELAXrfhaTtawN7QTqu79EZVnA
         FCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1Igxvo01clEvfQnAlKc8g7MH2NPhkoAR4LaSiR0pRs=;
        b=arIJ4TcfiXfU+2aVhvIzzW1ZtHo3BZz/2/iLsgc+LK3sG8P6QkcBSAwm1qZ42VYWec
         0FTomBJWxy+rXQNEiePdGEUL/NCwD6nb2qthYZ73ZLPqdSaEhzYCc2pjqvpri1DB7/44
         moDOzTg2R2Zoz4RVixeJN54XnUzlrarlYktm0IkwVeXaA3PZR5zM6Stn4aG2rvmCAHHg
         pc2dnfkx3/kYb3lmHpxCHbEl++N+SOLz3glopZVG8KcBScLVXjzW6FdieuUmBgbe6aOf
         78gEmUomVDhrruQISFaqYyxmSSDcltxktIX9vvafa0oEVyRyCoRpbTP2dtOGzQ6Sacbi
         DI0Q==
X-Gm-Message-State: APjAAAUSI4kadpHB5Fn7uVk4LEAKwZH5Z+6dXCyW/4iniKm5TOgHiX6l
        pVKRHghm//4f3fUef5zCHGkDV0XUTaYVOsxtmMQ=
X-Google-Smtp-Source: APXvYqyNVP7eTfGHr0vNdXoLRp87VeeH8daldujg3itfkr4XpFs5/WX66QGlRWGswR650VdAPNN74il5q9eRKSXEf08=
X-Received: by 2002:a65:5043:: with SMTP id k3mr7999171pgo.406.1566908265675;
 Tue, 27 Aug 2019 05:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com> <87ftlnm7o8.fsf@vitty.brq.redhat.com>
In-Reply-To: <87ftlnm7o8.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <lantianyu1986@gmail.com>
Date:   Tue, 27 Aug 2019 20:17:35 +0800
Message-ID: <CAOLK0pzXPG9tBnQoKGTSNHMwXXrEQ4zZH1uWn2F2mQ2ddVcoFA@mail.gmail.com>
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

On Tue, Aug 27, 2019 at 2:41 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> lantianyu1986@gmail.com writes:
>
> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> >
> > This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
> > in L0 can delegate L1 hypervisor to handle tlb flush request from
> > L2 guest when direct tlb flush is enabled in L1.
> >
> > Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
> > feature from user space. User space should enable this feature only
> > when Hyper-V hypervisor capability is exposed to guest and KVM profile
> > is hided. There is a parameter conflict between KVM and Hyper-V hypercall.
> > We hope L2 guest doesn't use KVM hypercall when the feature is
> > enabled. Detail please see comment of new API
> > "KVM_CAP_HYPERV_DIRECT_TLBFLUSH"
>
> I was thinking about this for awhile and I think I have a better
> proposal. Instead of adding this new capability let's enable direct TLB
> flush when KVM guest enables Hyper-V Hypercall page (writes to
> HV_X64_MSR_HYPERCALL) - this guarantees that the guest doesn't need KVM
> hypercalls as we can't handle both KVM-style and Hyper-V-style
> hypercalls simultaneously and kvm_emulate_hypercall() does:
>
>         if (kvm_hv_hypercall_enabled(vcpu->kvm))
>                 return kvm_hv_hypercall(vcpu);
>
> What do you think?
>
> (and instead of adding the capability we can add kvm.ko module parameter
> to enable direct tlb flush unconditionally, like
> 'hv_direct_tlbflush=-1/0/1' with '-1' being the default (autoselect
> based on Hyper-V hypercall enablement, '0' - permanently disabled, '1' -
> permanenetly enabled)).
>

Hi Vitaly::
     Actually, I had such idea before. But user space should check
whether hv tlb flush
is exposed to VM before enabling direct tlb flush. If no, user space
should not direct
tlb flush for guest since Hyper-V will do more check for each
hypercall from nested
VM with enabling the feauter..

-- 
Best regards
Tianyu Lan
