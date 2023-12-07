Return-Path: <kvm+bounces-3830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A0A808404
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E215C1F22769
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 09:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8110832C76;
	Thu,  7 Dec 2023 09:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Laf2zfNa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D90910CF
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 01:14:30 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id 5614622812f47-3b9db318839so456404b6e.3
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 01:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701940470; x=1702545270; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UGjQCd7LVQJ0VtFzIdDdhxzodi3g57d9KV1C6E0+n8=;
        b=Laf2zfNafaJGvN5keculosfgrQWQq+1Lu7ziheYSTvv4yxcw3hpXcvtst0S7/kJZhK
         fxM4Fu0Nlxyw4omhjBo1EK5y88w/wu38XCA+2Jz/3HVQ6g7vrkvA7kEO5LaJisT2xS1s
         fFafgyLfC6fw5GsmH+GjzEG+L/1BK8s4oJcP1Nch22RbRRe5pFBY3pG0qtVBG1NsdqP1
         pqP542zanA/XiYJwYCzmoNwCHYOwrWlP98qggUonvIyCggSA+H1WP51A8i6Jggx+rBZg
         qrQaJI6N9+KBVQ2kAn9m64wTcY5wlkdKNCZZNQ+a4b3iE/6MDq+kk/Ef9IHTeB/dKMET
         8gAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701940470; x=1702545270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UGjQCd7LVQJ0VtFzIdDdhxzodi3g57d9KV1C6E0+n8=;
        b=O38u8I8xx3pCxF6Erw6DQvLBC9nM4uIzl8ULK4zoiSev+CH5ZHnb+W+EkpV6TCuYUM
         kYvU2nQWw4TMDaaMjQpW9Wp3P7rhEO/dEi36mc4porV9BM2PsxhGsNoJz/Z3DGzyGwOb
         HkHKd6CKCy/xBFQnbhSTx+xqmRpbmLOuzcxp0Qy1l7LgG3f+Na7/esXMJNRnzGkc0TEY
         GkuvHod7aSna6GHufq8jIpbaRPKBUuSYcoSjqFjk2Olzlny+gCA9ShOYZT5abGvxhv/V
         CmX6zZWeDL8t665Fo96Itp7t6r4Aq64hZDgbmNteTmuGg+jljQ+CN6upwVs5eevJbuuk
         GlKQ==
X-Gm-Message-State: AOJu0YwMLq1OKaSLH9PVNmpugM6Vel36p+UwD4trlfF6N7cqNjM5xJBi
	qtjssjhgZ/VtQOgt2qFYeTviysJx8U1tduiTOqM=
X-Google-Smtp-Source: AGHT+IFMAgiw3M79ejSrDddrDQo7MF/CVWsVF5aT0rrGGbQnV8/fVx1NkazPHxw78qtagcKmLyS3kLb5SA3+IsDAzw4=
X-Received: by 2002:a05:6870:3047:b0:1fb:75a:c436 with SMTP id
 u7-20020a056870304700b001fb075ac436mr2173231oau.95.1701940469762; Thu, 07 Dec
 2023 01:14:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231206155821.1194551-1-michael.roth@amd.com>
In-Reply-To: <20231206155821.1194551-1-michael.roth@amd.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 7 Dec 2023 04:14:17 -0500
Message-ID: <CAJSP0QUnqJPTL2W9xknEW7Er0SWCcK1kxST1fCvedmqsics_VA@mail.gmail.com>
Subject: Re: [PATCH v3 for-8.2] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Lara Lazier <laramglazier@gmail.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Dec 2023 at 10:59, Michael Roth <michael.roth@amd.com> wrote:
>
> Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> exposed a long-running bug in current KVM support for SEV-ES where the
> kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> kernel, in which case EFER write traps would result in KVM eventually
> seeing MSR_EFER_LMA get set and recording it in such a way that it would
> be subsequently visible when accessing it via KVM_GET_SREGS/etc.
>
> However, guest kernels currently rely on MSR_EFER_LMA getting set
> automatically when MSR_EFER_LME is set and paging is enabled via
> CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> MSR_EFER_LMA bit, even though it is set internally, and when QEMU
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
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> Cc: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Cc: Lara Lazier <laramglazier@gmail.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: kvm@vger.kernel.org
> Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  target/i386/kvm/kvm.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied, thanks!

Stefan

>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..4ce80555b4 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3643,6 +3643,10 @@ static int kvm_get_sregs(X86CPU *cpu)
>      env->cr[4] =3D sregs.cr4;
>
>      env->efer =3D sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME &&
> +        env->cr[0] & CR0_PG_MASK) {
> +        env->efer |=3D MSR_EFER_LMA;
> +    }
>
>      /* changes to apic base and cr8/tpr are read back via kvm_arch_post_=
run */
>      x86_update_hflags(env);
> @@ -3682,6 +3686,10 @@ static int kvm_get_sregs2(X86CPU *cpu)
>      env->cr[4] =3D sregs.cr4;
>
>      env->efer =3D sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME &&
> +        env->cr[0] & CR0_PG_MASK) {
> +        env->efer |=3D MSR_EFER_LMA;
> +    }
>
>      env->pdptrs_valid =3D sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>
> --
> 2.25.1
>
>

