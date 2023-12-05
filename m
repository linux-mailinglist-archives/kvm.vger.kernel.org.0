Return-Path: <kvm+bounces-3639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D30E8061AB
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:28:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD941B211FA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 22:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505D96EB43;
	Tue,  5 Dec 2023 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vu3EGXbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D868188
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 14:28:04 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1f060e059a3so3391421fac.1
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 14:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701815283; x=1702420083; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xjX0ycV4920GSStvFTgVH7sc8iENdA8ndQ0y4AqF8VU=;
        b=Vu3EGXbQyT8Ew8s4IAlYMwTDas+H+dwLHSR+sMdXRfvn5EPHdVbo3Exf8CWu46L2SW
         vTnfUb7+Mx/Hq5bLolC8xz8NHqwTDb3u3UKt3hGSd9mn+yiKosoQFP4PYtpB+HKPhBf1
         EEIwtqcK7S/LLJGuKGDMHJKnRkFU2jVjgkn3z3PmeXIoljMGKOqQ4lVEbS04VDNbjuVn
         88SmsaBrqWs8x0LT+jxWQlLcIptgYbWr1LYzjJxbv68mVjYDxct+IdpVW5JeUEk3bahE
         tQNOzzj5doaYbwdVDZcCgPiP0WxpQgdqXqpNEaksIlo5XpkwEZHa1i4uOFrBo74pJ8O9
         ThwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701815283; x=1702420083;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xjX0ycV4920GSStvFTgVH7sc8iENdA8ndQ0y4AqF8VU=;
        b=uk0wCcRC9BHsUxW2D+bCYlbg+YaGRbF5dWH4tLEfNWqwIfYAQgGyqlV4cxQTbvltWF
         6Bx7tccKVy0eFm7hpneABf+kS48VJeetr+InD8dR+H4l2nBlO5iho5qquVTkaC9mEhbc
         jhjxJe0n/xtgPwsK4DjQjZ0VHSU7ZcCLrNpHVBMRv71IWq1DVznq/7dCZWZblUZefXs4
         HCh9YpNrlfefAb1Jo+m5LiOuF05erH/mEeSLTAAwohEnYBBHi87bO+oze44SYc/OX7Cz
         csNFCY1f4FJhlzmK726cEU3EjrLcKUVxns4S5xqO+/Vy1XfrDhz7XpqgFScxJRPFi2RS
         NRIg==
X-Gm-Message-State: AOJu0YwtF8ALyFNi4+eb11xgQf6W07rFA34S2Nhea/mJOWF5ZIzRw8JI
	8h41UDnJxjvXqceihKy0ProsAdD6pUHWZMyoZws=
X-Google-Smtp-Source: AGHT+IES70pDJVf8sueoaoiUDUCDV/HMf3EyXxEFs/HG+3R91ocZkALxZ7LF8wAyr/e6V0s+gHeCb3gZOGjbTOTGXxE=
X-Received: by 2002:a05:6870:ad07:b0:1fb:217:5203 with SMTP id
 nt7-20020a056870ad0700b001fb02175203mr8954653oab.53.1701815283498; Tue, 05
 Dec 2023 14:28:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205221219.1151930-1-michael.roth@amd.com>
In-Reply-To: <20231205221219.1151930-1-michael.roth@amd.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 5 Dec 2023 17:27:51 -0500
Message-ID: <CAJSP0QWtnDAmfM7FAyU4dizhVzUWrfagrBVzh-31MPAn9p4X4g@mail.gmail.com>
Subject: Re: [PATCH for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Dec 2023 at 17:12, Michael Roth <michael.roth@amd.com> wrote:
>
> Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> exposed a long-running bug in current KVM support for SEV-ES where the
> kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> kernel, in which case EFER write traps would result in KVM eventually
> seeing MSR_EFER_LMA get set and recording it in such a way that it would
> be subsequently visible when accessing it via KVM_GET_SREGS/etc.
>
> However, guests kernels currently rely on MSR_EFER_LMA getting set
> automatically when MSR_EFER_LME is set and paging is enabled via
> CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> MSR_EFER_LMA even though it is set internally, and when QEMU
> subsequently tries to pass this EFER value back to KVM via
> KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
> which is now considered fatal due to the aforementioned QEMU commit.
>
> This can be addressed by inferring the MSR_EFER_LMA bit being set when
> paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
> the expected bits are all present in subsequent handling on the host
> side.
>
> Ultimately, this handling will be implemented in the host kernel, but to
> avoid breaking QEMU's SEV-ES support when using older host kernels, the
> same handling can be done in QEMU just after fetching the register
> values via KVM_GET_SREGS*. Implement that here.

Hi Mike,
I am holding off on tagging 8.2.0-rc3 for one day so agreement can be
reached on how to proceed with this fix.

Stefan

>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> Cc: kvm@vger.kernel.org
> Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/kvm/kvm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..0e9e4c1beb 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3654,6 +3654,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
>  {
>      CPUX86State *env = &cpu->env;
>      struct kvm_sregs2 sregs;
> +    target_ulong cr0_old;
>      int i, ret;
>
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> @@ -3676,12 +3677,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
>      env->gdt.limit = sregs.gdt.limit;
>      env->gdt.base = sregs.gdt.base;
>
> +    cr0_old = env->cr[0];
>      env->cr[0] = sregs.cr0;
>      env->cr[2] = sregs.cr2;
>      env->cr[3] = sregs.cr3;
>      env->cr[4] = sregs.cr4;
>
>      env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> +            env->efer |= MSR_EFER_LMA;
> +        }
> +    }
>
>      env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>
> --
> 2.25.1
>
>

