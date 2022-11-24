Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3F76376A7
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKXKlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKXKlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:41:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323EA14D861
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FORAn5crX/r0husew0/sqSFF6fBX+MsZF8UkiBdk69I=; b=NCuffGNg0AINjXBKrGizoMAvgo
        Qfp3OGx7wLINMmpu6Zfks+hHVC+UEy4FTPyEKfCnqteygkDDD7Vk9rkitmLEJVsPNE7uheC5uR19b
        VvIhSYdjR/lAcNmPVJgjApjeHl7sOKx1+79MsOsp8kzQmP9Yb/2LiAW4CJtjKkS5tFhTgkW8aVqCd
        Cv9iZ0gLiPnkHmkoeDjpfNxFr6KGKzLX+/RqQqRLiJnoc3cEcZXjsMvqwmGuBGgiuMNeSdNiyZvG9
        /4PGRmZnogt6Ts6Vpwl9xIj9GyiGcAvoH975faMVRYuTqeg/G3WpGo+9miZSTTMQAOVp1vZ6qB6+O
        hTHVHi1w==;
Received: from [2001:8b0:10b:5:e35e:4295:9d62:caa0] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oy9fx-008cT7-0X; Thu, 24 Nov 2022 10:41:49 +0000
Message-ID: <65b8050a6e883371cac09e3a27f0403f357cf339.camel@infradead.org>
Subject: Re: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Durrant <xadimgnik@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Date:   Thu, 24 Nov 2022 10:41:41 +0000
In-Reply-To: <CABgObfYw7mwt7Jk72Gg57izHduWBWUXKD+fNPix4s-4kKXRVQg@mail.gmail.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
         <20221119094659.11868-3-dwmw2@infradead.org>
         <681cf1b4edf04563bba651efb854e77f@amazon.co.uk>
         <Y3z3ZVoXXGWusfyj@google.com>
         <d7ae4bab-e826-ad0f-7248-81574a5f2b5c@gmail.com>
         <c552b55c926d8e284ba24773a02ea7da028787f5.camel@infradead.org>
         <CABgObfY=jePpPmZJVLdA7nyuPut7B7qCYA64UVwGFxPsmvAVqg@mail.gmail.com>
         <a9d826ca775d0d250fa6dc8fa208d2ae20a345db.camel@infradead.org>
         <CABgObfYw7mwt7Jk72Gg57izHduWBWUXKD+fNPix4s-4kKXRVQg@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-08SuOvS8utQOtbq1ssCj"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-08SuOvS8utQOtbq1ssCj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-11-24 at 02:11 +0100, Paolo Bonzini wrote:
>=20
> What if vx contained a struct vcpu_runstate_info instead of having
> separate fields? That might combine the best of the on-stack version
> and the best of the special-memcpy version...

Well... the state field is in a different place for compat vs. 64-bit
which makes that fun, and the state_entry_time field need to have the
XEN_RUNSTATE_UPDATE bit masked into it which means we don't really want
to just memcpy *that* part... and we already *are* just doing a memcpy
for the rest, which is the time[] array.

But we *can* recognise that the fast and slow paths aren't all that
different really, and combine them. How's this?

=46rom bf9d04e1c59771c82d5694d22a86fb0508be1530 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Thu, 24 Nov 2022 09:49:00 +0000
Subject: [PATCH] KVM: x86/xen: Reconcile fast and slow paths for runstate
 update

Instead of having a completely separate fast path for the case where the
guest's runstate_info fits entirely in a page, recognise the similarity.

In both cases, the @update_bit pointer points to the byte containing the
XEN_RUNSTATE_UPDAT flag directly in the guest, via one of the GPCs.

In both cases, the actual guest structure (compat or not) is built up
from the fields in @vx, following a preset pointer. The only difference
is whether that pointer points to the kernel stack (in the split case)
or to guest memory directly via the GPC.

All that can be the same if we just set the pointers up accordingly for
each case. Then the only real difference is that dual memcpy, and the
whole of that original fast path can go away, disappearing into the slow
path without actually doing the slow part.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 249 +++++++++++++++++++++++----------------------
 1 file changed, 126 insertions(+), 123 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d4077262c0a2..eaa7fddfbb8c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -177,44 +177,78 @@ static void kvm_xen_update_runstate_guest(struct kvm_=
vcpu *v, bool atomic)
 	struct gfn_to_pfn_cache *gpc2 =3D &vx->runstate2_cache;
 	size_t user_len, user_len1, user_len2;
 	struct vcpu_runstate_info rs;
-	int *rs_state =3D &rs.state;
 	unsigned long flags;
 	size_t times_ofs;
-	u8 *update_bit;
+	uint8_t *update_bit;
+	uint64_t *rs_times;
+	int *rs_state;
=20
 	/*
 	 * The only difference between 32-bit and 64-bit versions of the
 	 * runstate struct is the alignment of uint64_t in 32-bit, which
 	 * means that the 64-bit version has an additional 4 bytes of
-	 * padding after the first field 'state'.
+	 * padding after the first field 'state'. Let's be really really
+	 * paranoid about that, and matching it with our internal data
+	 * structures that we memcpy into it...
 	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D 0);
 	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) !=3D 0);
 	BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) !=3D 0x2c);
 #ifdef CONFIG_X86_64
+	/*
+	 * The 64-bit structure has 4 bytes of padding before 'state_entry_time'
+	 * so each subsequent field is shifted by 4, and it's 4 bytes longer.
+	 */
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=3D
 		     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
 	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=3D
 		     offsetof(struct compat_vcpu_runstate_info, time) + 4);
+	BUILD_BUG_ON(sizeof(struct vcpu_runstate_info) !=3D 0x2c + 4);
 #endif
+	/*
+	 * The state field is in the same place at the start of both structs,
+	 * and is the same size (int) as vx->current_runstate.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D
+		     offsetof(struct compat_vcpu_runstate_info, state));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=3D
+		     sizeof(vx->current_runstate));
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=3D
+		     sizeof(vx->current_runstate));
+
+	/*
+	 * The state_entry_time field is 64 bits in both versions, and the
+	 * XEN_RUNSTATE_UPDATE flag is in the top bit, which given that x86
+	 * is little-endian means that it's in the last *byte* of the word.
+	 * That detail is important later.
+	 */
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
=3D
+		     sizeof(uint64_t));
+	BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_t=
ime) !=3D
+		     sizeof(uint64_t));
+	BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) !=3D 0x80);
+
+	/*
+	 * The time array is four 64-bit quantities in both versions, matching
+	 * the vx->runstate_times and immediately following state_entry_time.
+	 */
+	BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=3D
+		     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time)=
 !=3D
+		     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=3D
+		     sizeof_field(struct compat_vcpu_runstate_info, time));
+	BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=3D
+		     sizeof(vx->runstate_times));
=20
 	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
 		user_len =3D sizeof(struct vcpu_runstate_info);
 		times_ofs =3D offsetof(struct vcpu_runstate_info,
 				     state_entry_time);
-#ifdef CONFIG_X86_64
-		/*
-		 * Don't leak kernel memory through the padding in the 64-bit
-		 * struct if we take the split-page path.
-		 */
-		memset(&rs, 0, offsetof(struct vcpu_runstate_info, state_entry_time));
-#endif
 	} else {
 		user_len =3D sizeof(struct compat_vcpu_runstate_info);
 		times_ofs =3D offsetof(struct compat_vcpu_runstate_info,
 				     state_entry_time);
-		/* Start of struct for compat mode (qv). */
-		rs_state++;
 	}
=20
 	/*
@@ -251,145 +285,114 @@ static void kvm_xen_update_runstate_guest(struct kv=
m_vcpu *v, bool atomic)
 		read_lock_irqsave(&gpc1->lock, flags);
 	}
=20
-	/*
-	 * The common case is that it all fits on a page and we can
-	 * just do it the simple way.
-	 */
 	if (likely(!user_len2)) {
 		/*
-		 * We use 'int *user_state' to point to the state field, and
-		 * 'u64 *user_times' for runstate_entry_time. So the actual
-		 * array of time[] in each state starts at user_times[1].
+		 * Set up three pointers directly to the runstate_info
+		 * struct in the guest (via the GPC).
+		 *
+		 *  =E2=80=A2 @rs_state   =E2=86=92 state field
+		 *  =E2=80=A2 @rs_times   =E2=86=92 state_entry_time field.
+		 *  =E2=80=A2 @update_bit =E2=86=92 last byte of state_entry_time, which
+		 *                  contains the XEN_RUNSTATE_UPDATE bit.
 		 */
-		int *user_state =3D gpc1->khva;
-		u64 *user_times =3D gpc1->khva + times_ofs;
-
+		rs_state =3D gpc1->khva;
+		rs_times =3D gpc1->khva + times_ofs;
+		update_bit =3D ((uint8_t *)(&rs_times[1])) - 1;
+	} else {
 		/*
-		 * The XEN_RUNSTATE_UPDATE bit is the top bit of the state_entry_time
-		 * field. We need to set it (and write-barrier) before writing to the
-		 * the rest of the structure, and clear it last. Just as Xen does, we
-		 * address the single *byte* in which it resides because it might be
-		 * in a different cache line to the rest of the 64-bit word, due to
-		 * the (lack of) alignment constraints.
+		 * The guest's runstate_info is split across two pages and we
+		 * need to hold and validate both GPCs simultaneously. We can
+		 * declare a lock ordering GPC1 > GPC2 because nothing else
+		 * takes them more than one at a time.
 		 */
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
=3D
-			     sizeof(uint64_t));
-		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_=
time) !=3D
-			     sizeof(uint64_t));
-		BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) !=3D 0x80);
+		read_lock(&gpc2->lock);
=20
-		update_bit =3D ((u8 *)(&user_times[1])) - 1;
-		*update_bit =3D (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
-		smp_wmb();
+		if (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
+			read_unlock(&gpc2->lock);
+			read_unlock_irqrestore(&gpc1->lock, flags);
=20
-		/*
-		 * Next, write the new runstate. This is in the *same* place
-		 * for 32-bit and 64-bit guests, asserted here for paranoia.
-		 */
-		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=3D
-			     offsetof(struct compat_vcpu_runstate_info, state));
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=3D
-			     sizeof(vx->current_runstate));
-		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=3D
-			     sizeof(vx->current_runstate));
-		*user_state =3D vx->current_runstate;
+			/* When invoked from kvm_sched_out() we cannot sleep */
+			if (atomic)
+				return;
=20
-		/*
-		 * Then the actual runstate_entry_time (with the UPDATE bit
-		 * still set).
-		 */
-		*user_times =3D vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+			/*
+			 * Use kvm_gpc_activate() here because if the runstate
+			 * area was configured in 32-bit mode and only extends
+			 * to the second page now because the guest changed to
+			 * 64-bit mode, the second GPC won't have been set up.
+			 */
+			if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
+					     gpc1->gpa + user_len1, user_len2))
+				return;
+
+			/*
+			 * We dropped the lock on GPC1 so we have to go all the
+			 * way back and revalidate that too.
+			 */
+			goto retry;
+		}
=20
 		/*
-		 * Write the actual runstate times immediately after the
-		 * runstate_entry_time.
+		 * In this case, the runstate_info struct will be assembled on
+		 * the kernel stack (compat or not as appropriate) and will
+		 * be copied to GPC1/GPC2 with a dual memcpy. Set up the three
+		 * rs pointers accordingly.
 		 */
-		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=3D
-			     offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
-		BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time=
) !=3D
-			     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=3D
-			     sizeof_field(struct compat_vcpu_runstate_info, time));
-		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=3D
-			     sizeof(vx->runstate_times));
-		memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
-
-		smp_wmb();
+		rs_times =3D &rs.state_entry_time;
=20
 		/*
-		 * Finally, clear the 'updating' bit. Don't use &=3D here because
-		 * the compiler may not realise that update_bit and user_times
-		 * point to the same place. That's a classic pointer-aliasing
-		 * problem.
+		 * The rs_state pointer points to the start of what we'll
+		 * copy to the guest, which in the case of a compat guest
+		 * is the 32-bit field that the compiler thinks is padding.
 		 */
-		*update_bit =3D vx->runstate_entry_time >> 56;
-		smp_wmb();
-
-		goto done_1;
-	}
-
-	/*
-	 * The painful code path. It's split across two pages and we need to
-	 * hold and validate both GPCs simultaneously. Thankfully we can get
-	 * away with declaring a lock ordering GPC1 > GPC2 because nothing
-	 * else takes them more than one at a time.
-	 */
-	read_lock(&gpc2->lock);
-
-	if (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
-		read_unlock(&gpc2->lock);
-		read_unlock_irqrestore(&gpc1->lock, flags);
-
-		/* When invoked from kvm_sched_out() we cannot sleep */
-		if (atomic)
-			return;
+		rs_state =3D ((void *)rs_times) - times_ofs;
=20
 		/*
-		 * Use kvm_gpc_activate() here because if the runstate
-		 * area was configured in 32-bit mode and only extends
-		 * to the second page now because the guest changed to
-		 * 64-bit mode, the second GPC won't have been set up.
+		 * The update_bit is still directly in the guest memory,
+		 * via one GPC or the other.
 		 */
-		if (kvm_gpc_activate(v->kvm, gpc2, NULL, KVM_HOST_USES_PFN,
-				     gpc1->gpa + user_len1, user_len2))
-			return;
+		if (user_len1 >=3D times_ofs + sizeof(uint64_t))
+			update_bit =3D ((u8 *)gpc1->khva) + times_ofs +
+				sizeof(uint64_t) - 1;
+		else
+			update_bit =3D ((u8 *)gpc2->khva) + times_ofs +
+				sizeof(uint64_t) - 1 - user_len1;
=20
+#ifdef CONFIG_X86_64
 		/*
-		 * We dropped the lock on GPC1 so we have to go all the way
-		 * back and revalidate that too.
+		 * Don't leak kernel memory through the padding in the 64-bit
+		 * version of the struct.
 		 */
-		goto retry;
+		memset(&rs, 0, offsetof(struct vcpu_runstate_info, state_entry_time));
+#endif
 	}
=20
 	/*
-	 * Work out where the byte containing the XEN_RUNSTATE_UPDATE bit is.
+	 * First, set the XEN_RUNSTATE_UPDATE bit in the top bit of the
+	 * state_entry_time field, directly in the guest. We need to set
+	 * that (and write-barrier) before writing to the rest of the
+	 * structure, and clear it last. Just as Xen does, we address the
+	 * single *byte* in which it resides because it might be in a
+	 * different cache line to the rest of the 64-bit word, due to
+	 * the (lack of) alignment constraints.
 	 */
-	if (user_len1 >=3D times_ofs + sizeof(uint64_t))
-		update_bit =3D ((u8 *)gpc1->khva) + times_ofs + sizeof(u64) - 1;
-	else
-		update_bit =3D ((u8 *)gpc2->khva) + times_ofs + sizeof(u64) - 1 -
-			user_len1;
+	*update_bit =3D (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
+	smp_wmb();
=20
 	/*
-	 * Create a structure on our stack with everything in the right place.
-	 * The rs_state pointer points to the start of it, which in the case
-	 * of a compat guest on a 64-bit host is the 32 bit field that the
-	 * compiler thinks is padding.
+	 * Now assemble the actual structure, either on our kernel stack
+	 * or directly in the guest according to how the rs_state and
+	 * rs_times pointers were set up above.
 	 */
 	*rs_state =3D vx->current_runstate;
-	rs.state_entry_time =3D vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
-	memcpy(rs.time, vx->runstate_times, sizeof(vx->runstate_times));
-
-	*update_bit =3D rs.state_entry_time >> 56;
-	smp_wmb();
+	rs_times[0] =3D vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
+	memcpy(rs_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
=20
-	/*
-	 * Having constructed the structure starting at *rs_state, copy it
-	 * into the first and second pages as appropriate using user_len1
-	 * and user_len2.
-	 */
-	memcpy(gpc1->khva, rs_state, user_len1);
-	memcpy(gpc2->khva, ((u8 *)rs_state) + user_len1, user_len2);
+	/* For the split case, we have to then copy it to the guest. */
+	if (user_len2) {
+		memcpy(gpc1->khva, rs_state, user_len1);
+		memcpy(gpc2->khva, ((u8 *)rs_state) + user_len1, user_len2);
+	}
 	smp_wmb();
=20
 	/*
@@ -400,7 +403,7 @@ static void kvm_xen_update_runstate_guest(struct kvm_vc=
pu *v, bool atomic)
=20
 	if (user_len2)
 		read_unlock(&gpc2->lock);
- done_1:
+
 	read_unlock_irqrestore(&gpc1->lock, flags);
=20
 	mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
--=20
2.25.1



--=-08SuOvS8utQOtbq1ssCj
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMTI0MTA0MTQxWjAvBgkqhkiG9w0BCQQxIgQgZn5i03LH
nqSed1qxsI8n1tqEr2wDXR7J5EyPWLHMGdkwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAgxIj/Ki4uQD8wO43VYOKzTe+WQAzzuCKm
/ne/21LxafJZMNf+dOSKtqRIDGFcwZBezX5Nvqsh7cXIkdJwFHgjY9sBhG6V3/HRUoWAha20BJFc
mciarmBQAa8TjHR34mAOp21SQvN5aL3AeknTgmV6lrq3EC/3yJ6STwEKw/UatD9iEN7hus85UUik
KRfTYzIiY6Yq7TfnXuCEbKcvpm0N3Jo6mQJEJMrFKJMdM6VEzc5RCdx+r7mm34LNcCkYAJy+dQZZ
IeAVipQKV+jW8sFWd5hqr2xUl5ugQ2XzNny/iH+FLStDANN9IvyNkeRUoB8GP94AeSrhnuW00pWg
RHPQCUMN6gEVFSdVhG1Uc0kBOUvxQv92U+vFNGPSfUWZMaRVsfOVnKtGLarroeeTg0ZFdVJiAUuV
iVkOmD0PKiGaaCAUVfTFA3NNXgGPn7OZosjrplkFnajhrW6aSqAn8dczcVj8dKa9wTrYp8sFWe6Y
nCDy59g2zPyqe/xOQnj6YGfeZwW0/k4jbdvOy+2BLI9dOnaVPuuWWPzMPutr/D3JUiJwzULwx966
TFu9MghMXlhg4Hdi8DirtOEhIlv03UkwUgdO3JEuPdwFpafqxQeRnT8h009mwSqo2iD2T2VrZj6b
ebqqX7trmd8wtshQ2qIHLsoOB1omo6uoy3J90a+cVgAAAAAAAA==


--=-08SuOvS8utQOtbq1ssCj--

