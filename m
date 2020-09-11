Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F93265F0D
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 13:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgIKLug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 07:50:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgIKLtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 07:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599824987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DbEzTZlBUFKy7piP8BvfmrFeBFroI6ej+Yt1VrkfQ1U=;
        b=CdxO3+KOzGB8Bi6vhccEAS2cH/S52rAAr+I1IYN/TIEgDsRx465PIiuda4K0uwNbeVKvsT
        Fv/wlzzVOj3kgPfXjj4EzBD8eGk6vTgtpXynx7aYHkfBaNDXO7xhO1fCh+YMyXpSv4DTlf
        1WYosbcVG7rE+1ndr0lD8GyYCgRzNvo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-YzFAYytYPVCfA4pPW5LuAA-1; Fri, 11 Sep 2020 07:49:46 -0400
X-MC-Unique: YzFAYytYPVCfA4pPW5LuAA-1
Received: by mail-wm1-f72.google.com with SMTP id a7so860476wmc.2
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 04:49:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DbEzTZlBUFKy7piP8BvfmrFeBFroI6ej+Yt1VrkfQ1U=;
        b=I71TuhqMBLfVPFE7n4wlHTfCvD6PHGZ3doGHq8ec6UUb6u5xEy/kgi0BiSLvqKB7kM
         nNln9nU0vsqkmQIOUTKfJKOSMOIs1hC8cEkcvWCsW67b72FL67kmF6UkTG8dMUfcq8Gr
         ubjNwMjQJ91jkTapOAKt8CeSiV1WUatDytYvVfTopzHD7ZxAoLo7CZweFawjt75INua3
         IffhxziTxyrgZ2GyLUG6wCrv/SovMZ/HLV6M6cjMHg+ouGOsO9m6c5N5n5sb6AdM95mw
         kxJeTEKurHKBv1NYBdySXGBYE40w+lO1Lo6D/N5Y9m+apb4X+i+5pCz2GBS3+yACg4PB
         GIvg==
X-Gm-Message-State: AOAM533EsI4nEQDdBTMKm9Srbb5Gi/fgjjHUMhnPrf/fcJ2tlrwGfnHU
        /jXMMa9/JfmjkXI897xtZmJ+S7Xmc3MzGKQDTtpYKtFVIZXM8eM0pKtyKeTCqZYG2VHks8yGtTi
        ufAyDbOTYENgD
X-Received: by 2002:adf:e952:: with SMTP id m18mr1661050wrn.171.1599824984854;
        Fri, 11 Sep 2020 04:49:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQpXn3O6dhb557D4NANTuUDGxEUZvFWXlBeAuUYP1vZZatKQtPsXhGfsneRWhJehwI7Yiyhw==
X-Received: by 2002:adf:e952:: with SMTP id m18mr1661017wrn.171.1599824984563;
        Fri, 11 Sep 2020 04:49:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k84sm3776613wmf.6.2020.09.11.04.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 04:49:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Colin King <colin.king@canonical.com>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer\:X86 ARCHITECTURE" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH][next] KVM: SVM: nested: fix free of uninitialized pointers save and ctl
In-Reply-To: <20200911110730.24238-1-colin.king@canonical.com>
References: <20200911110730.24238-1-colin.king@canonical.com>
Date:   Fri, 11 Sep 2020 13:49:42 +0200
Message-ID: <87o8mclei1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the error exit path to outt_set_gif will kfree on
> uninitialized

typo: out_set_gif

> pointers save and ctl.  Fix this by ensuring these pointers are
> inintialized to NULL to avoid garbage pointer freeing.
>
> Addresses-Coverity: ("Uninitialized pointer read")
> Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures
> on stack")

Where is this commit id from? I don't see it in Paolo's kvm tree, if
it's not yet merged, maybe we should fix it and avoid introducing the
issue in the first place?

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  arch/x86/kvm/svm/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 28036629abf8..2b15f49f9e5a 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1060,8 +1060,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	struct vmcb *hsave = svm->nested.hsave;
>  	struct vmcb __user *user_vmcb = (struct vmcb __user *)
>  		&user_kvm_nested_state->data.svm[0];
> -	struct vmcb_control_area *ctl;
> -	struct vmcb_save_area *save;
> +	struct vmcb_control_area *ctl = NULL;
> +	struct vmcb_save_area *save = NULL;
>  	int ret;
>  	u32 cr0;

I think it would be better if we eliminate 'out_set_gif; completely as
the 'error path' we have looks a bit weird anyway. Something like
(untested):

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 28036629abf8..d1ae94f40907 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1092,7 +1092,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
        if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
                svm_leave_nested(svm);
-               goto out_set_gif;
+               svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
+               return 0;
        }
 
        if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
@@ -1145,7 +1146,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
        load_nested_vmcb_control(svm, ctl);
        nested_prepare_vmcb_control(svm);
 
-out_set_gif:
        svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 
        ret = 0;

-- 
Vitaly

