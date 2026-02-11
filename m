Return-Path: <kvm+bounces-70837-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DPDGJNxjGn6oAAAu9opvQ
	(envelope-from <kvm+bounces-70837-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:09:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7147812418B
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BA7673004D88
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 12:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCE53382CF;
	Wed, 11 Feb 2026 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NB+AdALD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FcV/cYEt"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AE8335567;
	Wed, 11 Feb 2026 12:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770811788; cv=none; b=sHFOJKJuruPicEfl7SO+qAw54Crx8+4PUwEFOhg63EmpwKUzScQosRp8/gYvfmpShI6KNNpiBO/64WHzDGsW/Are5L6IOSS4N0u+UsoSAy1dIcJKeY8wYDgnHSOKmyvoSlEESPKQ7pfdvTP0L+vmUTkhVdO2moOCjehku19hdjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770811788; c=relaxed/simple;
	bh=v0TD2zjoRX4tHjSu22iCmsQ9xP0Mh5nYjq9eHrCR8Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bl+esbQlpLrErCezhXcvCM78sNxrFh6cGPC+rofUA6QZxwHhCxfV73VV4q5PsLS6lBE615U3wcCDFEeXfTTx0de2A0PkoTINERu1NYkLciROSXqcDzo90im4ilY5Ks/WCUhZdCjg7NA4FRfvsWxXsj+in0rhH+ryqc6TAdp7Q2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NB+AdALD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FcV/cYEt; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Wed, 11 Feb 2026 13:09:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1770811785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyZokm8/opRW9Nz2O+6PyNxHcfInLRhXVENWgckO/wA=;
	b=NB+AdALD26uv9K3ce4jS4nIx19bddx6pV85gDoIQbeVGghQz6mf6DcJhKd3+32p+ZVtpaN
	fMfsmWHw+aAbsR+AsxnO3qsfmzQXIBaKL9tROXeHh77dvhcAStWLOqyLZQVyVBJRtZzh9L
	Dzx1OqqCwhK4+6htFUINLhQ+S+GXSYvfLZO9cItAW16JstvVtzPSLpnYekagzAjo3ZADtI
	4ucWDX8BVUjU65kP2XZA/KelykEss7O7zLREfloNDzGtnnxXX0AfRVfdLMo6Y4zirj8BPW
	kyLDyW0Kl761JX2XgInUDDYHgDtJYryuLiHI5JzMbqgdJxNUIHGWw2rXdc5+zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1770811785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyZokm8/opRW9Nz2O+6PyNxHcfInLRhXVENWgckO/wA=;
	b=FcV/cYEtDuxRdDBrc2m7mQO4l2aOaJmu3DPZDhopbbrGiL/A+lUJWPxrXde159z54mGPQQ
	6yK8ZShWNEiwJEBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "shaikh.kamal" <shaikhkamal2012@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] KVM: mmu_notifier: make mn_invalidate_lock non-sleeping
 for non-blocking invalidations
Message-ID: <20260211120944.-eZhmdo7@linutronix.de>
References: <20260209161527.31978-1-shaikhkamal2012@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260209161527.31978-1-shaikhkamal2012@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70837-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bigeasy@linutronix.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linutronix.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linutronix.de:mid,linutronix.de:dkim,linutronix.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7147812418B
X-Rspamd-Action: no action

On 2026-02-09 21:45:27 [+0530], shaikh.kamal wrote:
> mmu_notifier_invalidate_range_start() may be invoked via
> mmu_notifier_invalidate_range_start_nonblock(), e.g. from oom_reaper(),
> where sleeping is explicitly forbidden.
>=20
> KVM's mmu_notifier invalidate_range_start currently takes
> mn_invalidate_lock using spin_lock(). On PREEMPT_RT, spin_lock() maps
> to rt_mutex and may sleep, triggering:
>=20
>   BUG: sleeping function called from invalid context
>=20
> This violates the MMU notifier contract regardless of PREEMPT_RT; RT
> kernels merely make the issue deterministic.
>=20
> Fix by converting mn_invalidate_lock to a raw spinlock so that
> invalidate_range_start() remains non-sleeping while preserving the
> existing serialization between invalidate_range_start() and
> invalidate_range_end().
>=20
> Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I don't see any down side doing this, but=E2=80=A6

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5fcd401a5897..7a9c33f01a37 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -747,9 +747,9 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>  	 *
>  	 * Pairs with the decrement in range_end().
>  	 */
> -	spin_lock(&kvm->mn_invalidate_lock);
> +	raw_spin_lock(&kvm->mn_invalidate_lock);
>  	kvm->mn_active_invalidate_count++;
> -	spin_unlock(&kvm->mn_invalidate_lock);
> +	raw_spin_unlock(&kvm->mn_invalidate_lock);

	atomic_inc(mn_active_invalidate_count)
> =20
>  	/*
>  	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
> @@ -817,11 +817,11 @@ static void kvm_mmu_notifier_invalidate_range_end(s=
truct mmu_notifier *mn,
>  	kvm_handle_hva_range(kvm, &hva_range);
> =20
>  	/* Pairs with the increment in range_start(). */
> -	spin_lock(&kvm->mn_invalidate_lock);
> +	raw_spin_lock(&kvm->mn_invalidate_lock);
>  	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
>  		--kvm->mn_active_invalidate_count;
>  	wake =3D !kvm->mn_active_invalidate_count;

	wake =3D atomic_dec_return_safe(mn_active_invalidate_count);
	WARN_ON_ONCE(wake < 0);
	wake =3D !wake;

> -	spin_unlock(&kvm->mn_invalidate_lock);
> +	raw_spin_unlock(&kvm->mn_invalidate_lock);
> =20
>  	/*
>  	 * There can only be one waiter, since the wait happens under
> @@ -1129,7 +1129,7 @@ static struct kvm *kvm_create_vm(unsigned long type=
, const char *fdname)
> @@ -1635,17 +1635,17 @@ static void kvm_swap_active_memslots(struct kvm *=
kvm, int as_id)
>  	 * progress, otherwise the locking in invalidate_range_start and
>  	 * invalidate_range_end will be unbalanced.
>  	 */
> -	spin_lock(&kvm->mn_invalidate_lock);
> +	raw_spin_lock(&kvm->mn_invalidate_lock);
>  	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
>  	while (kvm->mn_active_invalidate_count) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> -		spin_unlock(&kvm->mn_invalidate_lock);
> +		raw_spin_unlock(&kvm->mn_invalidate_lock);
>  		schedule();

And this I don't understand. The lock protects the rcuwait assignment
which would be needed if multiple waiters are possible. But this goes
away after the unlock and schedule() here. So these things could be
moved outside of the locked section which limits it only to the
mn_active_invalidate_count value.

> -		spin_lock(&kvm->mn_invalidate_lock);
> +		raw_spin_lock(&kvm->mn_invalidate_lock);
>  	}
>  	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> -	spin_unlock(&kvm->mn_invalidate_lock);
> +	raw_spin_unlock(&kvm->mn_invalidate_lock);
> =20
>  	/*
>  	 * Acquired in kvm_set_memslot. Must be released before synchronize

Sebastian

