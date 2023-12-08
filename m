Return-Path: <kvm+bounces-3945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D1480AC3A
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:39:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C401281A6A
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE654CB3E;
	Fri,  8 Dec 2023 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YR7wyDa9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926D7BD
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 10:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702060770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xpi6oKeZnMTqEA1GU/S46QdXQaCqr8RrHilbjEq4XU=;
	b=YR7wyDa9riYA9msFbkr7TvyqH/HyMjM2oTp5HM8JHFU94cUhjXRTYVLSi8hqq05LSMsPuN
	BrDW9AfSo0L9Gn3l0jKubRyamanMLsdPSvtaNPLAmE4hEaD0bhwgm//myywsgPuiRO4VUU
	xDtyZWZW2545Cu8uygLnIkWfusFexb8=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-6IdG74t5OBmTULg7NOZ82Q-1; Fri, 08 Dec 2023 13:39:29 -0500
X-MC-Unique: 6IdG74t5OBmTULg7NOZ82Q-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4ac34ddfb8aso571129e0c.1
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 10:39:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702060769; x=1702665569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xpi6oKeZnMTqEA1GU/S46QdXQaCqr8RrHilbjEq4XU=;
        b=h6KbNFAYMdWwXbvUxMQHV0oaB995TJre5ihw1qTde4LggzZ/uctBVUFbSdDp2+Ckic
         KOPtMG4wvM0QxVUFCpBcJC+G7k9GbMX/dMrpD3TuAhboSUhD1PB3TRleFt/Fnm/m7qpI
         cHTcictqv+tFCxADRZF9W7sVbXRQewlQj8NmfBjwNvxH6GpKylBKQeT5hD/FkFy6/c5m
         +faeJQ2PE/OtnlfW3RezzYVRPcIbjphxf7Eg8KY7LUVO9cbT/m4jj8P4zr7QTLLzglmK
         rmf/JlCXU/EFgrWnxeA3dCfals4cf0Tl9Q15Ea9H97WV7h9ir6HlWlVT4BGA09oq9w2h
         4Fwg==
X-Gm-Message-State: AOJu0YyG3qjn1xuY4hyN2usaQFdz/TSB0oV120CbLgowEfOxQfbZQpvV
	k4O5QaciwygptjYgbF9WaNKC+nULOyiY9mlkfi4Sd0RnDqsIDIh+w4FiwA9CSspVsdOcst34f03
	uOLhyvR4UF2gm320WKXMzJ/8lpcmt
X-Received: by 2002:a05:6122:3109:b0:4b2:f6a2:7736 with SMTP id cg9-20020a056122310900b004b2f6a27736mr649958vkb.28.1702060768855;
        Fri, 08 Dec 2023 10:39:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEV1aa0sxRQBUtb8Yg9bmtWfZ++LYpyWwYuXdMa4yWBmh1Kh+o1C5/hDc0PWIxzji4w5Q3kKRaFYRtPJHsE5OI=
X-Received: by 2002:a05:6122:3109:b0:4b2:f6a2:7736 with SMTP id
 cg9-20020a056122310900b004b2f6a27736mr649953vkb.28.1702060768633; Fri, 08 Dec
 2023 10:39:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205234956.1156210-1-michael.roth@amd.com> <ZXCTHJPerz6l9sPw@google.com>
In-Reply-To: <ZXCTHJPerz6l9sPw@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Dec 2023 19:39:16 +0100
Message-ID: <CABgObfb2AxwvseadmEBS7=VWLKKpYVeHkaecrPXG47sMfCKEZg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Fix handling of EFER_LMA bit when SEV-ES is enabled
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 4:28=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> Blech.  This is a hack to fix even worse hacks.  KVM ignores CR0/CR4/EFER=
 values
> that are set via KVM_SET_SREGS, i.e. KVM is rejecting an EFER value that =
it will
> never consume, which is ridiculous.  And the fact that you're not trying =
to have
> KVM actually set state further strengthens my assertion that tracking CR0=
/CR4/EFER
> in KVM is pointless necessary for SEV-ES+ guests[1].

I agree that KVM is not going to consume CR0/CR4/EFER. I disagree that
it's a good idea to have a value of vcpu->arch.efer that is
architecturally impossible (so much so that it would fail vmentry in a
non-SEV-ES guest).

I also agree that changing the source is not particularly useful, but
then changing the destination can be easily done in userspace.

In other words, bugfix or not this can and should be merged as a code
cleanup (though your older "[PATCH 1/2] KVM: SVM: Update EFER software
model on CR0 trap for SEV-ES" is nicer in that it clarifies that
svm->vmcb->save.efer is not used, and that's what I would like to
apply).

> So my very strong preference is to first skip the kvm_is_valid_sregs() ch=
eck

No, please don't. If you want to add a quirk that, when disabled,
causes all guest state get/set ioctls to fail, go ahead. But invalid
processor state remains invalid, and should be rejected, even when KVM
won't consume it.

> My understanding is that SVM_VMGEXIT_AP_CREATION is going to force KVM to=
 assume
> maximal state anyways since KVM will have no way of verifying what state =
is actually
> shoved into the VMSA, i.e. emulating INIT is wildly broken[2].

Yes, or alternatively a way to pass CR0/CR4/EFER from the guest should
be included in the VMGEXIT spec.

> Side topic, Peter suspected that KVM _does_ need to let userspace set CR8=
 since
> that's not captured in the VMSA[3].

Makes sense, and then we would have to apply the 2/2 patch from 2021
as well. But for now I'll leave that aside.

Paolo

> [1] https://lore.kernel.org/all/YJla8vpwqCxqgS8C@google.com
> [2] https://lore.kernel.org/all/20231016132819.1002933-38-michael.roth@am=
d.com
> [3] https://lore.kernel.org/all/CAMkAt6oL9tfF5rvP0htbQNDPr50Zk41Q4KP-dM0N=
+SJ7xmsWvw@mail.gmail.com
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c924075f6f1..6fb2b913009e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11620,7 +11620,8 @@ static int __set_sregs_common(struct kvm_vcpu *vc=
pu, struct kvm_sregs *sregs,
>         int idx;
>         struct desc_ptr dt;
>
> -       if (!kvm_is_valid_sregs(vcpu, sregs))
> +       if (!vcpu->arch.guest_state_protected &&
> +           !kvm_is_valid_sregs(vcpu, sregs))
>                 return -EINVAL;
>
>         apic_base_msr.data =3D sregs->apic_base;
>


