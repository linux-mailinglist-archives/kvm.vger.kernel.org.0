Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716EFB5975
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 03:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfIRBzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 21:55:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40355 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfIRBzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 21:55:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so3296983pfb.7;
        Tue, 17 Sep 2019 18:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WpdhIb/HVSs710LcKaJm7aGI4UYk0FgZtLy6pHU/E7I=;
        b=bEkFHto9bgaJFozXvPcDAP9sOziRJ1a39ytrGCFhceycWTnUGuL0tEG1zjySa4ko86
         1i99GxosJphUChFuLilgBo87ghBxrZxeAynAvfEUM8u4ToDb+zwG+fYQSD+iXK17xKtX
         o8iNbNy4DkE7f5ZWcMdVww7NvF13UoswzJ2edSzkuwBhrAUvPq6ers4z4SpUbNKrCliE
         lomkueb9TlI4/6m2QkcUpJ8+vXUJhEvOgbrtahh7ahAJiImLYcWH0q7wMMAmdFJnIQPF
         LodRcKlngsVu/fC1AbR4sV7HTx5SLuF4CBfL791oxHGBRDE/CvgExsp8A4AMMkr0CVGS
         KMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WpdhIb/HVSs710LcKaJm7aGI4UYk0FgZtLy6pHU/E7I=;
        b=d5ROzrnRvOLjnNNqJmbokGjd8UA1ynieJhIFOAiDvAg3BN/IqYcNevQHjEcBVHzcaY
         ReDzvRrFAmU69eKBcsbVUAkv+1tWu6fRy4B+Icp5RZSvJG4UVHWIJe6XRleJP0M5dw9N
         HF/EdDhfWlr8ZUCLmhcXgMmcrMlmbSULW8QliWWGHI8zlbpq40GCTwfXkjAQLwMKbDtu
         X4RIVou38dUmoebyF5ZzHi5I08O8+IGSZWEqzRRkl/f82+h/3lsr2TD3CZbfTMeLsheO
         02WSmhHiyRlXmk+j/2icPU38sj9mEuzrXb2c6ggO2JVJ6bqAUgSt7dHxctqTyXu3lO0V
         7MMg==
X-Gm-Message-State: APjAAAV4DspkUhGmExUSMccWFnHzM7qvOucImZUpuCeemixwx7B3GZxV
        CdBywVu1XybhLIdXA/V3gZ1ijwjVMMlbjkf+j1M=
X-Google-Smtp-Source: APXvYqxs/XhVQtC4blrL5qTFdZH54Ew9KrJli2WIUrwrFhceMsYhJ26PzdUTFTJyPTei56tlVCraIzbJQpD7L7nc7tk=
X-Received: by 2002:a65:5043:: with SMTP id k3mr1752884pgo.406.1568771745985;
 Tue, 17 Sep 2019 18:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190822143021.7518-1-Tianyu.Lan@microsoft.com>
 <7ea7fa06-f100-1507-8507-1c701877c8ab@redhat.com> <874l1baqnf.fsf@vitty.brq.redhat.com>
In-Reply-To: <874l1baqnf.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <lantianyu1986@gmail.com>
Date:   Wed, 18 Sep 2019 09:55:34 +0800
Message-ID: <CAOLK0pzVGT2hV=OgJf0pJ5ih2AHN9N8pk1WC38835A-WZD0EMA@mail.gmail.com>
Subject: Re: [PATCH V4 0/3] KVM/Hyper-V: Add Hyper-V direct tlb flush support
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        kvm <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
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
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 11:28 PM Vitaly Kuznetsov <vkuznets@redhat.com> wro=
te:
>
> Paolo Bonzini <pbonzini@redhat.com> writes:
>
> > On 22/08/19 16:30, lantianyu1986@gmail.com wrote:
> >> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> >>
> >> This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
> >> in L0 can delegate L1 hypervisor to handle tlb flush request from
> >> L2 guest when direct tlb flush is enabled in L1.
> >>
> >> Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
> >> feature from user space. User space should enable this feature only
> >> when Hyper-V hypervisor capability is exposed to guest and KVM profile
> >> is hided. There is a parameter conflict between KVM and Hyper-V hyperc=
all.
> >> We hope L2 guest doesn't use KVM hypercall when the feature is
> >> enabled. Detail please see comment of new API "KVM_CAP_HYPERV_DIRECT_T=
LBFLUSH"
> >>
> >> Change since v3:
> >>        - Update changelog in each patches.
> >>
> >> Change since v2:
> >>        - Move hv assist page(hv_pa_pg) from struct kvm  to struct kvm_=
hv.
> >>
> >> Change since v1:
> >>        - Fix offset issue in the patch 1.
> >>        - Update description of KVM KVM_CAP_HYPERV_DIRECT_TLBFLUSH.
> >>
> >> Tianyu Lan (2):
> >>   x86/Hyper-V: Fix definition of struct hv_vp_assist_page
> >>   KVM/Hyper-V: Add new KVM capability KVM_CAP_HYPERV_DIRECT_TLBFLUSH
> >>
> >> Vitaly Kuznetsov (1):
> >>   KVM/Hyper-V/VMX: Add direct tlb flush support
> >>
> >>  Documentation/virtual/kvm/api.txt  | 13 +++++++++++++
> >>  arch/x86/include/asm/hyperv-tlfs.h | 24 ++++++++++++++++++-----
> >>  arch/x86/include/asm/kvm_host.h    |  4 ++++
> >>  arch/x86/kvm/vmx/evmcs.h           |  2 ++
> >>  arch/x86/kvm/vmx/vmx.c             | 39 +++++++++++++++++++++++++++++=
+++++++++
> >>  arch/x86/kvm/x86.c                 |  8 ++++++++
> >>  include/uapi/linux/kvm.h           |  1 +
> >>  7 files changed, 86 insertions(+), 5 deletions(-)
> >>
> >
> > Queued, thanks.
> >
>
> I had a suggestion how we can get away without the new capability (like
> direct tlb flush gets automatically enabled when Hyper-V hypercall page
> is activated and we know we can't handle KVM hypercalls any more)
> but this can probably be done as a follow-up.
>

Hi Vital'y=EF=BC=9A
              Actually, I have tried your proposal but it turns out
KVM in L1 fails to
enable direct tlb flush most time after nested VM starts.
"hv_enlightenments_control.
nested_flush_hypercall" flag in evmcs is cleared by Hyper-V after run
nested VM. I still
wait answer from Hyper-V team. So far, it looks like enabling direct
tlb flush before start
nested VM is a safe way.Once get more infomration from Hyper-V team and we =
may
have a look to how to enable your proposal.
--=20
Best regards
Tianyu Lan
