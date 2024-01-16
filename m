Return-Path: <kvm+bounces-6348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 439BE82F2A5
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 17:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A83A91F23C8B
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0693E1CD23;
	Tue, 16 Jan 2024 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yP0f7XIn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FED1CD22
	for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cf2714e392so4929539a12.0
        for <kvm@vger.kernel.org>; Tue, 16 Jan 2024 08:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705423932; x=1706028732; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gyBDnw5I/spgg3bAr/bFSG0rPZqjMGMdvDA0Is7JCWo=;
        b=yP0f7XInHDKATDRlgi4CEJzX/ZYU9NoF1tDZRgSDAb0ba24yZh8pG0v8GG6IjZOS9a
         NUad0X620tEsN90aKX1PsuOgjdrsQBl6Z83zeURsuvd5+nRSZfC40HutM3nUwkHykNVr
         pcJYay4bbmCRez1x3P3dD7AqLFzQ8Zs4rcw/beeQryPF7dht1lJOIkG0vu2nWS02SLXE
         WUHtvnbQKwqaMwNm9M4j0hX1n9ulI4X2LuSzIaniRhu9EMpqnc6d5kKxZLeI7TsOx3C9
         JQ0G2idaPE435rote70kqdxtt0VG/dRzsRNIodhqa0q5t20bYTjDig1tksFGMzleiPfg
         2aZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705423932; x=1706028732;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gyBDnw5I/spgg3bAr/bFSG0rPZqjMGMdvDA0Is7JCWo=;
        b=qRsdfV+qEBrwUvpZMBvO/m6Z+8p4ZycOUh2/uZsga/5v1DhV4oejlAyPVL3yr/lVt3
         YaSljJdIgma5pHYV9YTiWP8+1t3pkghwMfjrvhhWnNznmLgxPtrTdsqRxjI1lswHekYa
         RWt0EUJq1STmWQzt6JG0AsScjWObOs9wcEeuBRCJDvBEXhte+r3qeLgxeNYy/lrcUJO4
         /z01WwE49shFei2R752viR5qGQ7I6TtfiAevSXQcff8uUfVUUnONvumYg6C/A0G+uR0r
         yH4nJMqB9QAIUXuqWioWVMT18A+VTAOu9Ict0ZIIYI4+ieFNSoo/QQmH8bcXmzRqXkAA
         DMnw==
X-Gm-Message-State: AOJu0YzP4qzCWOKWtU7vIMcZecfZn1OmqxrJouRLvMo4GKsoCiiO/Ksg
	u2ayqTYsvuWmC94K/lFxs9O4d3Nws6Vs8bom7g==
X-Google-Smtp-Source: AGHT+IHE7OvWgAfaW7T00fZ9HjVoe2bbjTjOWu0CV5LMVASqPSxvEpnIf5zFETFR78boHA/CqtLSmbLhqZU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a7:b0:5ce:d659:23ff with SMTP id
 by39-20020a056a0205a700b005ced65923ffmr57318pgb.5.1705423931967; Tue, 16 Jan
 2024 08:52:11 -0800 (PST)
Date: Tue, 16 Jan 2024 08:52:10 -0800
In-Reply-To: <0717051e9379614721483aaef29572e0356cd347.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0717051e9379614721483aaef29572e0356cd347.camel@infradead.org>
Message-ID: <Zaa0Oi5lgH1UFVdv@google.com>
Subject: Re: [PATCH v3] KVM: x86/xen: Inject vCPU upcall vector when local
 APIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 16, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>=20
> Linux guests since commit b1c3497e604d ("x86/xen: Add support for
> HVMOP_set_evtchn_upcall_vector") in v6.0 onwards will use the per-vCPU
> upcall vector when it's advertised in the Xen CPUID leaves.
>=20
> This upcall is injected through the local APIC as an MSI, unlike the
> older system vector which was merely injected by the hypervisor any time
> the CPU was able to receive an interrupt and the upcall_pending flags is
> set in its vcpu_info.
>=20
> Effectively, that makes the per-CPU upcall edge triggered instead of
> level triggered.
>=20
> We lose edges.

Pronouns.  And losing edges isn't wrong in and of itself.  The only thing t=
hat
is "wrong" is that KVM doesn't exactly follow Xen's behavior.  How about sm=
ushing
the above sentence and the next two paragraphs into:

  Effectively, that makes the per-CPU upcall edge triggered instead of
  level triggered, which results in the upcall being lost if the MSI is
  delivered when the local APIC is *disabled*.

  Xen checks the vcpu_info->evtchn_upcall_pending flag when enabling the
  local APIC for a vCPU and injects the vector immediately if so.  Do the
  same in KVM since KVM doesn't provide a way for userspace to notice when
  the guest software enables a local APIC.
=20
> Specifically, when the local APIC is *disabled*, delivering the MSI
> will fail. Xen checks the vcpu_info->evtchn_upcall_pending flag when
> enabling the local APIC for a vCPU and injects the vector immediately
> if so.
>=20
> Since userspace doesn't get to notice when the guest enables a local
> APIC which is emulated in KVM, KVM needs to do the same.
>=20
> Astute reviewers may note that kvm_xen_inject_vcpu_vector() function has
> a WARN_ON_ONCE() in the case where kvm_irq_delivery_to_apic_fast() fails
> and returns false. In the case where the MSI is not delivered due to the
> local APIC being disabled, kvm_irq_delivery_to_apic_fast() still returns
> true but the value in *r is zero. So the WARN_ON_ONCE() remains correct,
> as that case should still never happen.
>=20
> Fixes: fde0451be8fb3 ("KVM: x86/xen: Support per-vCPU event channel upcal=
l via local APIC")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Paul Durrant <paul@xen.org>
> Cc: stable@vger.kernel.org
> ---
>  v3: Repost, add Cc:stable
>  v2: Add Fixes: tag.
>=20
> =C2=A0arch/x86/kvm/lapic.c |=C2=A0 5 ++++-
> =C2=A0arch/x86/kvm/xen.c=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0arch/x86/kvm/xen.h=C2=A0=C2=A0 | 18 ++++++++++++++++++
> =C2=A03 files changed, 23 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3242f3da2457..1e715ca717bc 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -41,6 +41,7 @@
> =C2=A0#include "ioapic.h"
> =C2=A0#include "trace.h"
> =C2=A0#include "x86.h"
> +#include "xen.h"
> =C2=A0#include "cpuid.h"
> =C2=A0#include "hyperv.h"
> =C2=A0#include "smm.h"
> @@ -499,8 +500,10 @@ static inline void apic_set_spiv(struct kvm_lapic *a=
pic, u32 val)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Check if there are APF=
 page ready requests pending */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (enabled)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (enabled) {

Argh, not your code, but there's really no reason this check needs to be ou=
tside
of the "if (enabled !=3D apic->sw_enabled)" block.  I don't care about opti=
mizing
anything, I just don't like that it implies that KVM always needs to take a=
ction
if SPIV is written.  Probably not worth trying to "fix" at this point thoug=
h :-(

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0kvm_xen_enable_lapic(apic->vcpu);

I think we should name the Xen helper kvm_xen_sw_enable_lapic(), to make it=
 clear
that the behavior doesn't apply to the APIC being hardware enabled via MSR.
Unless it does apply to that path?

