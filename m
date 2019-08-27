Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895CD9E8A3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbfH0NHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:07:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:47058 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbfH0NHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:07:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id q139so14072552pfc.13;
        Tue, 27 Aug 2019 06:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0p0/hlezeGt/XbIcoNDfHR/8GDIxHTpZEoMAoi00kVo=;
        b=lwwkBmUDxvrSWCOKfQtDd9u6cFOILblaRkNEidKKOyHtBc3Y4yvbvqiAfXUh9n5TxK
         tBQqsvPhhXlqFv27/EfIqNoSw+t2qirVwqVRtLAvq0fTNWgjVVVvpyrXZdxiFJ9WpKsN
         0eA/xKIyBetTXLQg2hSC39JBJi0wrpM9HJzX+VU62MNye6pZ3X0t0ExlRrwAQRbZZG01
         v7RWCShBtjCUsTu62FtRb/YPo3PP+tpoiJ+AwqTFC06wZfVgr7UXghWE6YBz6A4j1krm
         7Rdq7VXhwciuSiWFHQzdrNjspRnGxpIR21uJHy30f2gDBWemnvnx6etM25pY7UzXQZ31
         hoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0p0/hlezeGt/XbIcoNDfHR/8GDIxHTpZEoMAoi00kVo=;
        b=LWkXurlSpoNv23QWUS1DWgnFYto4noncFRsADRe5hTzemz12+eIAzgjzS51uw0ppfJ
         V9e4DXv3K9npEOfPlAb5MI7p2Dy9nsk/N91ujPyhs1RbJCtLh8327arjXQB8UF3+1rHK
         16SmKSG0qZPoeKxUgbeGEbNYIDriJ38Ad7BrRH1GINMvwK+2tK5K2MQV+Hr+X7Mpmwwr
         jk1JG9iUc19mvXsM9dviASRdDaseDNQUciMgttE553QK3aB1z9bHRWvIxfHEot0DFR8m
         kFSpSuPHcgjYhTsImGve3yK2yxxIDTfI4+saUzHtY9vUsNfBqHXiHmGU4kSd1WNd0N1Z
         /cqw==
X-Gm-Message-State: APjAAAU6xf/BAT4DJjH4ifHxkinnp0T7xpskV5woE8lGU5xcwcLFCcPB
        ObJ02Foy5A+WI3NFL8OBSWFZSG80f7ozv0sJgw8=
X-Google-Smtp-Source: APXvYqxAXZc5R1W4+GvI1l4xx6Dj+UN3D4K2f77cZLskNZQvJNdFEJBSLNSa8RtTkr5L5dehnyQJBOMTR9EYrEDpjOs=
X-Received: by 2002:a62:8343:: with SMTP id h64mr24990152pfe.170.1566911262160;
 Tue, 27 Aug 2019 06:07:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
 <87ftlnm7o8.fsf@vitty.brq.redhat.com> <CAOLK0pzXPG9tBnQoKGTSNHMwXXrEQ4zZH1uWn2F2mQ2ddVcoFA@mail.gmail.com>
 <87v9uilr5x.fsf@vitty.brq.redhat.com>
In-Reply-To: <87v9uilr5x.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <lantianyu1986@gmail.com>
Date:   Tue, 27 Aug 2019 21:07:32 +0800
Message-ID: <CAOLK0py2rvYkLPP9uQ6Q7y31Btu4XOsWr3Vsk6GtUDWvg5uUOg@mail.gmail.com>
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

On Tue, Aug 27, 2019 at 8:38 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Tianyu Lan <lantianyu1986@gmail.com> writes:
>
> > On Tue, Aug 27, 2019 at 2:41 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >> lantianyu1986@gmail.com writes:
> >>
> >> > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> >> >
> >> > This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
> >> > in L0 can delegate L1 hypervisor to handle tlb flush request from
> >> > L2 guest when direct tlb flush is enabled in L1.
> >> >
> >> > Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
> >> > feature from user space. User space should enable this feature only
> >> > when Hyper-V hypervisor capability is exposed to guest and KVM profile
> >> > is hided. There is a parameter conflict between KVM and Hyper-V hypercall.
> >> > We hope L2 guest doesn't use KVM hypercall when the feature is
> >> > enabled. Detail please see comment of new API
> >> > "KVM_CAP_HYPERV_DIRECT_TLBFLUSH"
> >>
> >> I was thinking about this for awhile and I think I have a better
> >> proposal. Instead of adding this new capability let's enable direct TLB
> >> flush when KVM guest enables Hyper-V Hypercall page (writes to
> >> HV_X64_MSR_HYPERCALL) - this guarantees that the guest doesn't need KVM
> >> hypercalls as we can't handle both KVM-style and Hyper-V-style
> >> hypercalls simultaneously and kvm_emulate_hypercall() does:
> >>
> >>         if (kvm_hv_hypercall_enabled(vcpu->kvm))
> >>                 return kvm_hv_hypercall(vcpu);
> >>
> >> What do you think?
> >>
> >> (and instead of adding the capability we can add kvm.ko module parameter
> >> to enable direct tlb flush unconditionally, like
> >> 'hv_direct_tlbflush=-1/0/1' with '-1' being the default (autoselect
> >> based on Hyper-V hypercall enablement, '0' - permanently disabled, '1' -
> >> permanenetly enabled)).
> >>
> >
> > Hi Vitaly::
> >      Actually, I had such idea before. But user space should check
> > whether hv tlb flush
> > is exposed to VM before enabling direct tlb flush. If no, user space
> > should not direct
> > tlb flush for guest since Hyper-V will do more check for each
> > hypercall from nested
> > VM with enabling the feauter..
>
> If TLB Flush enlightenment is not exposed to the VM at all there's no
> difference if we enable direct TLB flush in eVMCS or not: the guest
> won't be using 'TLB Flush' hypercall and will do TLB flushing with
> IPIs. And, in case the guest enables Hyper-V hypercall page, it is
> definitelly not going to use KVM hypercalls so we can't break these.
>

Yes, this won't tigger KVM/Hyper-V hypercall conflict. My point is
that if tlb flush enlightenment is not enabled, enabling direct tlb
flush will not accelate anything and Hyper-V still will check each
hypercalls from nested VM in order to intercpt tlb flush hypercall
But guest won't use tlb flush hypercall in this case. The check
of each hypercall in Hyper-V is redundant. We may avoid the
overhead via checking status of tlb flush enlightenment and just
enable direct tlb flush when it's enabled.

---
Best regards
Tianyu Lan
