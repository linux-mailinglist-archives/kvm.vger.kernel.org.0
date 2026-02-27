Return-Path: <kvm+bounces-72201-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMKaLb/joWmUwwQAu9opvQ
	(envelope-from <kvm+bounces-72201-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:34:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB061BC049
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:34:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EE47E3043AC5
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 18:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807D9395D81;
	Fri, 27 Feb 2026 18:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKyTjyUf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8F36E468
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772217266; cv=none; b=i6Mg0YnpqslD9BEtlj2fx/B6g25VJh+5yCqNzZ1UafH9L66NVrfSaMeDlvidYw0imaUGKD2iZKDjc2+SE0kvLSWCjW5b10W7SGN9QxfDC0pii8My4Cd9k0YUjrbldbfY4eYDE9H6lX0grbOv/5HKAY9Cx6kkNmeD04yk4/YBka8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772217266; c=relaxed/simple;
	bh=Mgk0K/EJjbQGTmCAk5uLg4ahE4CRyp3mIhKucVvDAm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oz5pm/DMuyOtNLbwh4akC+LVgXCp5zLiZ8ZvU5gaImpPBYLTxTvwaIk3mFfC3Cwia0InDtsTal680Efvn8V867+zpLH0QADYBRYpEoE5S1eeXWBocVISNXNkZxBt5CDvNzvhzdpKckUuldWkYVvlha4ao4c/uWkjVi0NAJcLKfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKyTjyUf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639B9C19423
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772217266;
	bh=Mgk0K/EJjbQGTmCAk5uLg4ahE4CRyp3mIhKucVvDAm4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VKyTjyUfQj92kL2dhz7pSfiIMZ3GtgLwIKqOItXxXw04Ofq6OBV74SQ4pyG1uYHCw
	 +39MaUIMm7KgKowwp6PGXxQsyltmoMF4VSdwXRi4aw0QL66wgsCTSQezt8I3bTdQL2
	 /v+AnhzXJNJJcQ53RMmy2tpiNTOfuZOxkWYTqMgzRCrhCnFOpDFUSfklTPtHkuk3Jo
	 wTU+TWPh8n1zlsZkmQqFjFIi62YuO9r6J9px8L1Q4dqkfjqREbTxmgK4L8jXOk7Beb
	 II2Eca3JE5cQmaNotAG1r6JqLuRZbWN0nZJi43fZlHvSty5Rvoyzf1ezzglysTcfca
	 l8D0eQ6u1Jnmw==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65f980cea07so3457736a12.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 10:34:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYtXN8owH2o2m3Bz5CRgalvDer3axvR4ItOIASPnS4UwwDoHu2gNUi9NLiOWhv2jOBIgo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLl7q1Y0BbROKRxxyWjWg/g/laVOofak7YHNePCnd60SHqfGTb
	/XunjDyxtgzay/RABUAd+aIGkYnStYgDHmmeRkAqxuIgTE9e0FMMCB+3LzGdfiqbVWtzWBUMFr1
	tU4G2LLaXC0dtAqZtNVxrhmdHthP223s=
X-Received: by 2002:a17:907:930e:b0:b88:4849:38bd with SMTP id
 a640c23a62f3a-b93763b7321mr219417566b.23.1772217265161; Fri, 27 Feb 2026
 10:34:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
 <aaG_o58_0aHT8Xjg@google.com> <aaHHg2-lcpvkejB8@google.com>
 <CAO9r8zMdyvAJUvnxH0Scb6z3L51Djb1qpMAzX3M9g7hOkB=ZOQ@mail.gmail.com> <aaHf9Lxx8ap_3DRI@google.com>
In-Reply-To: <aaHf9Lxx8ap_3DRI@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 27 Feb 2026 10:34:13 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOFWHZ5LHRRKL4KU8TctjNs+vQYDr9OoBmao=eG9Q8C2w@mail.gmail.com>
X-Gm-Features: AaiRm52rJ-A7KLy3iyU2IcCLsgB54DML8nsfbDrfDkkRxULiu0a_JTXTZhg64_Q
Message-ID: <CAO9r8zOFWHZ5LHRRKL4KU8TctjNs+vQYDr9OoBmao=eG9Q8C2w@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-72201-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Queue-Id: 2DB061BC049
X-Rspamd-Action: no action

> > That being said, I hate nested_run_in_progress. It's too close to
> > nested_run_pending and I am pretty sure they will be mixed up.
>
> Agreed, though the fact that name is _too_ close means that, aside from the
> potential for disaster (minor detail), it's accurate.
>
> One thought is to hide nested_run_in_progress beyond a KConfig, so that attempts
> to use it for anything but the sanity check(s) would fail the build.  I don't
> really want to create yet another KVM_PROVE_xxx though, but unlike KVM_PROVE_MMU,
> I think we want to this enabled in production.
>
> I'll chew on this a bit...

Maybe (if we go this direction) name it very explicitly
warn_on_nested_exception if it's only intended to be used for the
sanity checks?

>
> > exception_from_userspace's name made me think this is something we
> > could key off to WARN, but it's meant to morph queued exceptions from
> > userspace into an "exception_vmexit" if needed. The field name is
> > generic but its functionality isn't, maybe it should have been called
> > exception_check_vmexit or something. Anyway..
>
> No?  It's not a "check", it's literally an pending exception that has been morphed
> to a VM-Exit.

I meant that the exception_from_userspace flag means "KVM should check
if this exception should be morphed to a VM-Exit". It doesn't mean
that the exception has already morphed or will necessarily morph. So
exception_check_vmexit makes sense to me, if it's set, KVM checks if
we need to morph the exception to a VM-Exit.

> > That gave me an idea though, can we add a field to
> > kvm_queued_exception to identify the origin of the exception
> > (userspace vs. KVM)? Then we can key the warning off of that.
>
> That would incur non-trivial maintenance costs, and it would be tricky to get the
> broader protection of the existing WARNing "right".  E.g. how would KVM know that
> the VM-Exit was originally induced by an exception that was queued by userspace?

It should have the info when morphing a pending exception to a
VM-Exit, assuming whoever is queuing the exception is passing it in,
but yeah I see how this can be a burden.

>
> > We can potentially also avoid adding the field and just plumb the
> > argument through to kvm_multiple_exception(), and WARN there if
> > nested_run_pending is set and the origin is not userspace?
>
> Not really, because kvm_vcpu_ioctl_x86_set_vcpu_events() doesn't use
> kvm_queued_exception(), it stuffs things directly.

Right, what I had in mind was that by default exceptions are assumed
to be queued by KVM, so kvm_vcpu_ioctl_x86_set_vcpu_events() doesn't
need to change. Basically, if a code path is queuing an exception from
userspace, it should use a new variant of kvm_queued_exception() (e.g.
kvm_queue_exception_u()). If it's stuffing things directly, nothing to
do. I think the code paths queuing exceptions from userspace should be
limited, so it should be fine to do this.

That being said, this still WARNs on the queuing side, not on the
checking side, so if you think that's not the right thing to do in
general then scratch this too.

>
> That said, if you want to try and code it up, I say go for it.  Worst case scenario
> you'll have wasted a bit of time.

I meant something like this (completely untested), this just WARNs if
we try to queue the exception, doesn't really stop it:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c8aacf1fa67f..6f4148eae08be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -836,11 +836,14 @@ static void kvm_queue_exception_vmexit(struct
kvm_vcpu *vcpu, unsigned int vecto

 static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
                                   bool has_error, u32 error_code,
-                                  bool has_payload, unsigned long payload)
+                                  bool has_payload, unsigned long payload,
+                                  bool from_userspace)
 {
        u32 prev_nr;
        int class1, class2;

+       WARN_ON_ONCE(!from_userspace && vcpu->arch.nested_run_pending);
+
        kvm_make_request(KVM_REQ_EVENT, vcpu);

        /*
@@ -899,7 +902,7 @@ static void kvm_multiple_exception(struct kvm_vcpu
*vcpu, unsigned int nr,

 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-       kvm_multiple_exception(vcpu, nr, false, 0, false, 0);
+       kvm_multiple_exception(vcpu, nr, false, 0, false, 0, false);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_queue_exception);

@@ -907,14 +910,19 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_queue_exception);
 void kvm_queue_exception_p(struct kvm_vcpu *vcpu, unsigned nr,
                           unsigned long payload)
 {
-       kvm_multiple_exception(vcpu, nr, false, 0, true, payload);
+       kvm_multiple_exception(vcpu, nr, false, 0, true, payload, false);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_queue_exception_p);

 static void kvm_queue_exception_e_p(struct kvm_vcpu *vcpu, unsigned nr,
                                    u32 error_code, unsigned long payload)
 {
-       kvm_multiple_exception(vcpu, nr, true, error_code, true, payload);
+       kvm_multiple_exception(vcpu, nr, true, error_code, true,
payload, false);
+}
+
+static void kvm_queue_exception_u(struct kvm_vcpu *vcpu, unsigned nr)
+{
+       kvm_multiple_exception(vcpu, nr, false, 0, false, 0, true);
 }

 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned int nr,
@@ -1015,7 +1023,7 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu)

 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-       kvm_multiple_exception(vcpu, nr, true, error_code, false, 0);
+       kvm_multiple_exception(vcpu, nr, true, error_code, false, 0, false);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_queue_exception_e);

@@ -5519,7 +5527,7 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct
kvm_vcpu *vcpu,
                banks[3] = mce->misc;
                vcpu->arch.mcg_status = mce->mcg_status;
                banks[1] = mce->status;
-               kvm_queue_exception(vcpu, MC_VECTOR);
+               kvm_queue_exception_u(vcpu, MC_VECTOR);
        } else if (!(banks[1] & MCI_STATUS_VAL)
                   || !(banks[1] & MCI_STATUS_UC)) {
                if (banks[1] & MCI_STATUS_VAL)
@@ -12546,9 +12554,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct
kvm_vcpu *vcpu,
                if (kvm_is_exception_pending(vcpu) ||
vcpu->arch.exception.injected)
                        goto out;
                if (dbg->control & KVM_GUESTDBG_INJECT_DB)
-                       kvm_queue_exception(vcpu, DB_VECTOR);
+                       kvm_queue_exception_u(vcpu, DB_VECTOR);
                else
-                       kvm_queue_exception(vcpu, BP_VECTOR);
+                       kvm_queue_exception_u(vcpu, BP_VECTOR);
        }

        /*

