Return-Path: <kvm+bounces-1283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AF97E5F81
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:55:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B15FB20F0B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64D737173;
	Wed,  8 Nov 2023 20:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sclfChXR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4140A19BCC
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:55:27 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E672113
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:55:26 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a839b31a0dso2984197b3.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699476926; x=1700081726; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qn42ChYNctj/w0ensW0B6va+N8faY+C33fMKSndlFT8=;
        b=sclfChXRpOhVDmJoT6b/eBocI1SszPQVq/7PBNx00IbEeVlS/I5z6gtXGdyYnYzPjZ
         PogKrrDXALGBITqexHQVzyCQd5z6/YtC/K9M0gwuqU+Cn11eiA2I4oMk8Ac/Eh2Zsv5O
         6r7mis4b+YSweN0xbzCJJBmwpUZFe2IgKblodFpRD+appW8xDXCOLpmpLNLLwdJDQE9i
         ShCHZMJnYm1uG+UMqPRkdXL/yLZyESracTvvVyeFDxf7E3XXPG2WxD6s4jAjkEGvj5gD
         UtlGkgq1Ip8dhZ+3pThihp0KFaIkQj9gdgmx6q0z5tsNGBeS0+HtdKEb9oOgnT8HdZk2
         2rtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699476926; x=1700081726;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qn42ChYNctj/w0ensW0B6va+N8faY+C33fMKSndlFT8=;
        b=HlRpT2hceG3ZFyPWQvTgA+3JkUJf2MhJt7EqXmXYwX/jwtFLh6KtM3oQOlaGaou7Yg
         M4Arvs7SG4gWJZWkw7dYEjSwemcVNoWZHTtK09Q9Ma2wmbHZvuuyx43L61e/rQYR4VWG
         uF/rjMGl5R2d/zRb7SnGWmLvVu7rizSXhpY43aSJC+VNBgD37LbYnpHgQwOEJz8rSgF5
         gtd9RtEWHe9bIDhqiNdOMS2RP6bwf/deVgqeBxEQgiekU4E4/o6srs4+mgsaANWj56Re
         GGdL39y+PXVzNgIB47FOsxEJGtLG/Lz7C0OtTTtpi0lg6hy4vx1jkS6yc557i8PDGvM/
         TgDA==
X-Gm-Message-State: AOJu0YxJvCpYXlUyy9DJDAf5I3YD0xkWj1j2gIKNGMGj/25NccQ3ECXH
	DASDtvLNAeZGtlTbIMcZS37rvYouryI=
X-Google-Smtp-Source: AGHT+IFdwZL4hIdLSN7odfxF6xZ8BJTf3oBbIOUZ/KNGoON0LJFagCHBxXmRktc78xk6AejuV9LZZYauRI0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f8c:0:b0:5a7:bb7e:993e with SMTP id
 d134-20020a814f8c000000b005a7bb7e993emr59767ywb.9.1699476925885; Wed, 08 Nov
 2023 12:55:25 -0800 (PST)
Date: Wed, 8 Nov 2023 12:55:24 -0800
In-Reply-To: <caad0c796b4c29a9370956a4c1c91f44f193a903.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-12-paul@xen.org>
 <ZUGUvdlxAoevcgJH@google.com> <caad0c796b4c29a9370956a4c1c91f44f193a903.camel@infradead.org>
Message-ID: <ZUv1vEtVCx62hFfT@google.com>
Subject: Re: [PATCH v7 11/11] KVM: xen: allow vcpu_info content to be 'safely' copied
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>, Jack Allister <jalliste@amazon.co.uk>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 08, 2023, David Woodhouse wrote:
> On Tue, 2023-10-31 at 16:58 -0700, Sean Christopherson wrote:
> >=20
> > > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > > index aafc794940e4..e645066217bb 100644
> > > --- a/arch/x86/kvm/xen.c
> > > +++ b/arch/x86/kvm/xen.c
> > > @@ -1606,9 +1606,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtc=
hn *xe, struct kvm *kvm)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > > =C2=A0=20
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!vcpu->arch.xen.vcpu_i=
nfo_cache.active)
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;
> > > -
> >=20
> > Hmm, maybe move this check after the "hard" error checks and explicitly=
 do:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EWOULDBLOCK
> >=20
> > That way it's much more obvious that this patch is safe.=C2=A0 Alternat=
ively, briefly
> > explain what happens if the cache is invalid in the changelog.
>=20
>=20
> Hm, I thought we dropped that? It doesn't want to return -EWOULDBLOCK.
> That would cause a "fast" irqfd delivery to defer to the slow
> (workqueue) path, but then the same thing would happen on that path
> *too*.
>=20
> I actually think this check needs to be dropped completely. The
> evtchn_pending_sel bit will get set in the *shadow* copy in vcpu-
> >arch.xen.evtchn_pending_sel, and will subsequently be set in the real
> vcpu_info when that is configured again. We do already handle that case
> correctly, I believe:
>=20
> 		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
> 			/*
> 			 * Could not access the vcpu_info. Set the bit in-kernel
> 			 * and prod the vCPU to deliver it for itself.
> 			 */
> 			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_se=
l))
> 				kick_vcpu =3D true;
> 			goto out_rcu;
> 		}
>=20
> If we leave this check in place as it is, I think we're going to lose
> incoming events (and IPIs) directed at a vCPU while it has its
> vcpu_info temporarily removed.

Oh, dagnabbit, there are two different gfn_to_pfn_cache objects.  I assumed=
 "gpc"
was the same thing as vcpu_info_cache.active, i.e. thought the explicit act=
ive
check here was just to pre-check the validity before acquiring the lock.

	if (!vcpu->arch.xen.vcpu_info_cache.active)
		return -EINVAL;

	rc =3D -EWOULDBLOCK;

	idx =3D srcu_read_lock(&kvm->srcu);

	read_lock_irqsave(&gpc->lock, flags);
	if (!kvm_gpc_check(gpc, PAGE_SIZE))  <=3D=3D I thought this was the same c=
heck
		goto out_rcu;

That's why my comment was nonsensical, and also why I was super confused by=
 your
response for a few minutes :-)

Good gravy, this even conditionally switches gpc and makes the out path dro=
p
different locks.  That's just mean.

Any objection to splitting out the vcpu_info chunk to a separate function? =
 That'd
eliminate the subtle gpc+lock switch, and provide a convenient and noticeab=
le
location to explain why it's ok for setting the vcpu_info to fail.

E.g.

---
 arch/x86/kvm/xen.c | 102 ++++++++++++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d65e89e062e4..cd2021ba0ae3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1621,6 +1621,57 @@ static void kvm_xen_check_poller(struct kvm_vcpu *vc=
pu, int port)
 	}
 }
=20
+static int kvm_xen_needs_a_name(struct kvm_vcpu *vcpu, int port_word_bit)
+{
+	struct gfn_to_pfn_cache *gpc =3D &vcpu->arch.xen.vcpu_info_cache;
+	bool kick_vcpu =3D false;
+	unsigned long flags;
+	int r =3D 0;
+
+	read_lock_irqsave(&gpc->lock, flags);
+	if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
+		/*
+		 * Could not access the vcpu_info. Set the bit in-kernel and
+		 * prod the vCPU to deliver it for itself.
+		 */
+		if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel)=
)
+			kick_vcpu =3D true;
+
+		r =3D -EWOULDBLOCK;
+		goto out;
+	}
+
+	if (IS_ENABLED(CONFIG_64BIT) && vcpu->kvm->arch.xen.long_mode) {
+		struct vcpu_info *vcpu_info =3D gpc->khva;
+		if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
+			WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+			kick_vcpu =3D true;
+		}
+	} else {
+		struct compat_vcpu_info *vcpu_info =3D gpc->khva;
+		if (!test_and_set_bit(port_word_bit,
+					(unsigned long *)&vcpu_info->evtchn_pending_sel)) {
+			WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+			kick_vcpu =3D true;
+		}
+	}
+
+	/* For the per-vCPU lapic vector, deliver it as MSI. */
+	if (kick_vcpu && vcpu->arch.xen.upcall_vector) {
+		kvm_xen_inject_vcpu_vector(vcpu);
+		kick_vcpu =3D false;
+	}
+
+out:
+	read_unlock_irqrestore(&gpc->lock, flags);
+
+	if (kick_vcpu) {
+		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
+		kvm_vcpu_kick(vcpu);
+	}
+
+	return r;
+}
 /*
  * The return value from this function is propagated to kvm_set_irq() API,
  * so it returns:
@@ -1638,7 +1689,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe=
, struct kvm *kvm)
 	unsigned long *pending_bits, *mask_bits;
 	unsigned long flags;
 	int port_word_bit;
-	bool kick_vcpu =3D false;
 	int vcpu_idx, idx, rc;
=20
 	vcpu_idx =3D READ_ONCE(xe->vcpu_idx);
@@ -1660,7 +1710,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe=
, struct kvm *kvm)
=20
 	read_lock_irqsave(&gpc->lock, flags);
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
-		goto out_rcu;
+		goto out_unlock;
=20
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
 		struct shared_info *shinfo =3D gpc->khva;
@@ -1688,52 +1738,16 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *=
xe, struct kvm *kvm)
 		kvm_xen_check_poller(vcpu, xe->port);
 	} else {
 		rc =3D 1; /* Delivered to the bitmap in shared_info. */
-		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel *=
/
-		read_unlock_irqrestore(&gpc->lock, flags);
-		gpc =3D &vcpu->arch.xen.vcpu_info_cache;
-
-		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
-			/*
-			 * Could not access the vcpu_info. Set the bit in-kernel
-			 * and prod the vCPU to deliver it for itself.
-			 */
-			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel=
))
-				kick_vcpu =3D true;
-			goto out_rcu;
-		}
-
-		if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
-			struct vcpu_info *vcpu_info =3D gpc->khva;
-			if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
-				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
-				kick_vcpu =3D true;
-			}
-		} else {
-			struct compat_vcpu_info *vcpu_info =3D gpc->khva;
-			if (!test_and_set_bit(port_word_bit,
-					      (unsigned long *)&vcpu_info->evtchn_pending_sel)) {
-				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
-				kick_vcpu =3D true;
-			}
-		}
-
-		/* For the per-vCPU lapic vector, deliver it as MSI. */
-		if (kick_vcpu && vcpu->arch.xen.upcall_vector) {
-			kvm_xen_inject_vcpu_vector(vcpu);
-			kick_vcpu =3D false;
-		}
 	}
=20
- out_rcu:
+ out_unlock:
 	read_unlock_irqrestore(&gpc->lock, flags);
+
+	/* Paul to add comment explaining why it's ok kvm_xen_needs_a_name() fail=
s */
+	if (rc =3D=3D 1)
+		rc =3D kvm_xen_needs_a_name(vcpu, port_word_bit);
+
 	srcu_read_unlock(&kvm->srcu, idx);
-
-	if (kick_vcpu) {
-		kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
-		kvm_vcpu_kick(vcpu);
-	}
-
 	return rc;
 }
=20

base-commit: 0f34262cf6fab8163456c7740c7ee1888a8af93c
--=20

