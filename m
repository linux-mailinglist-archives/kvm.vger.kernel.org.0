Return-Path: <kvm+bounces-72078-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iD/yDqKqoGlGlgQAu9opvQ
	(envelope-from <kvm+bounces-72078-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:18:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D12BA1AF006
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B2C230EF1FB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8955645BD40;
	Thu, 26 Feb 2026 20:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aBxUevVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD9A38B7B4
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 20:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772136853; cv=pass; b=N26diONMpWfpuVYdz4v5JKIqSnEfIcBHLQQyNwv6FpL/fu2v5/CSAM1cQCLDCPw9CSWJFBwmK7k0aSiXIejV3yibe/TPKLaHWz19VfM5hZGf7f/WE0bSSAVXWKjWqB+HD0klFKPwkFfWBsjzw+CwI0tFXEM4lEyGcdehYB3Mdmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772136853; c=relaxed/simple;
	bh=Le3CCRs2YmUgLyN92lo7YhPPn3XSu/iya9OUAV8O3a0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EDDaAVUJK2zd2efeBwqKvnanf6/924BwZqrh8blcnehDd25/ACcSSvEbwvd5cE69HJHi0/OIG16d4jmTqWWYZ2rbizGh4pI1BqxM6E4R/+q6i96xjyl2HDDrHmsuS9iJ0KddJpchvqvoS86+j0j4rB9KsiugoVMk6n3+xaInAQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aBxUevVm; arc=pass smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1277e072e2dso1279867c88.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 12:14:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772136852; cv=none;
        d=google.com; s=arc-20240605;
        b=gYqI1DGWC7MyI2BesbUC1rcYDTfAUc/at1eHnFsMi3D9aTTIpdXRyo1mzoxAXjWP2m
         HdW27Y0PZEeqshKnqJoBrG6IE+mxRXQA9xSmb3lJCJsbBzFJAxgZMt+QwpemsTX8eq8Q
         +/amF170QkWFH29Xz7QNMicBW7pS9XkNG8X8ew19AUBkpFr10lkyCmDJDYvVVk3jF8CR
         du9lV/4kGQT7snodvJJc5ffuQysJGbSn2el3dzQEjJW1DrPAOx/MOwYeWgWZsfwGb9Lw
         8vEqgUTaWxHKVvINIydv6qVosgv6A8guEEh7GtFL/EryRGeF6VGIg6AonMA27gUZCX5W
         BgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jY7Ps4YbjzVj1c5UVA5cFtTOvCYyRNgyNhaRqmcxtic=;
        fh=sB4R9JgLUClfRDUTf7meRY4x7mUZTxds86VUjJs5klg=;
        b=faOHe+n5hyontEDJESfu/vAOt0H0ZujbFjLffZZFmqLO41zZGe4cVl5u+dbnkdk/ME
         67VB1eyLzchvBT3WfpT3zuutangmOHWgFBJcvSWm1rwFJeVaC05DKv70L8pcTLQslxpY
         LIkBQQ/FZdfR/fmr+aHlwtscY2ivSYll1ihxBEVwm2LIVFV6Qj3/LcQ8fXH9A0MSqGFe
         dPG+7hwvP6Vz6vV0UvCx40qqs/tTZDy3U8Y+tlxfAnquW+Vl9Mp6tYuXppNLTHUFtw09
         3G3poVtZZ/tKd1S6XKEWEUIdEsXoWr4ZqXuFdX5vQdAo1gbYf5PMcIbSA3t/5zF7lCdH
         daIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772136852; x=1772741652; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jY7Ps4YbjzVj1c5UVA5cFtTOvCYyRNgyNhaRqmcxtic=;
        b=aBxUevVmhvy17Y+UBZYxhDXZNAKJ7qrHtE1NlbQfsGTltfwNo621bxGSDILQ9ntfVN
         O7Nz+2UA8/TL8hDcJQCnC2uTfQbLaP3F3ICErZsQJ4vQ0H7wmMhCdw/gV9E/o81mmdcr
         TK1c90VPIxjBziX6dGyQtWDwQkTl3iKBU9KmkPXVcjVhp3cyu98S7kUQ3mgT7AGX6SCb
         YH7YqYtP+ifXe9WfIAdn5dO0jiUhRI54eMphKSBY7rkphZeOUenUXN7SqSFh94c/DAqO
         gJ1ovk+35Gm80AFb/xhl09ISS3/0nQ8jNcvudiUCml520Q1y4N4p0t2IiZ6fZI5kkSik
         wdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772136852; x=1772741652;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jY7Ps4YbjzVj1c5UVA5cFtTOvCYyRNgyNhaRqmcxtic=;
        b=XdCVzTFeexKdg2qmPg62wFbQHfQUtkA0n0n1V1HP6cUMyvqT8mvzrxcddSgaJZbGiT
         MJXJmcuAlGs2F+CzBQgmwFVvo1OmaiWsNSEhI5hk21m2SSsk3vu6ncfsh3kwtP/H7Xen
         DGTUlf+v4YSsmM5m43jcW+PakkbogtLXdrM9olF1xkEUod5d63CVl8UjUhsxKBfpjN/I
         5o7Kr1xCs3CdMcCx7MWO5Y2O8lvzYBCgIV5A+2RiT7k0ieO05EPcsCJoR7v7deSWU3dL
         Gda+T4uvTkcpnalEpOKAA8cTl4Q6WGlPiHCfuSMkSfRWKPSEddVOGKhf+Xyt4u6KxWsG
         C5zw==
X-Forwarded-Encrypted: i=1; AJvYcCXPBINO0JnTkx1EKCX2CxQy/5+Ko7Rnk/2LtXB1ZfBr7uYFmAXfnvyHC9BG+VbOJ93oGQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmAlyiU1MKpinhfKcr0Owfk+fSZprd8ONEioV5WsfiyPQvynCV
	KkHfW1XE3e9Q7z4BMzlyF1uYH6E3Dl6Bm5dwBn9ocN4wmNOEiHQrh4QV2X4SPNicQMl5kaRaOox
	sS47cajLf2+tKZ/Pk7WajSyh0XMltJPCOClHSonIB
X-Gm-Gg: ATEYQzyEls3bwOd14YQo0PhgIM9zPfFvasFjnAtcYTkikU54jTbaNl8VThv+hZCj1yj
	lfJ5uX+Lv0ig5uT/WoTmnNCeZ3q7340sZXRng8+JPBuu/IL3w3pvsvJR0NSNrXJ+vz2OBw95H4Q
	5upbSg1ZGkdqmn+PTl3klOr44QS8tfxrhFYtdjZGo7SMW+pnhINgGWSLb3WeIHtQt6dyo3Kf7qk
	Rg2Z/wEApBB7GRPxKvtbRgADywMl2ZKBIt6b72NPov475SvHFBw8k4MIa7AVQLAkZUOiC+tAzUp
	wzZ7v4typBG11O5vtEKa1pwIdXZle9fzQonc2B0=
X-Received: by 2002:a05:7022:108:b0:127:4da1:ed59 with SMTP id
 a92af1059eb24-1278906e107mr2012705c88.10.1772136851231; Thu, 26 Feb 2026
 12:14:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223215118.2154194-1-bvanassche@acm.org> <20260223215118.2154194-2-bvanassche@acm.org>
 <aZ3r5_P74tUJm2oF@google.com> <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org> <aaCHS5ZRuW-QJkK7@google.com>
In-Reply-To: <aaCHS5ZRuW-QJkK7@google.com>
From: Marco Elver <elver@google.com>
Date: Thu, 26 Feb 2026 21:13:34 +0100
X-Gm-Features: AaiRm53tFQdZWMWCGLDF7AFEHUZkrfZ39Te85LZ5HbhSU50DOaFQ1zSkLuk22sU
Message-ID: <CANpmjNPKkFxg0gLu+n+PaGgkq0AQ70DdHi69D3iEwGFO-r-yiw@mail.gmail.com>
Subject: Re: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
To: Sean Christopherson <seanjc@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72078-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[elver@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: D12BA1AF006
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 at 18:48, Sean Christopherson <seanjc@google.com> wrote:
> On Tue, Feb 24, 2026, Bart Van Assche wrote:
[...]
> > Regarding why the above patch is necessary, I don't think that it is
> > fair to blame the compiler in this case. The macros that implement
> > per_cpu() make it impossible for the compiler to conclude that the
> > pointers passed to the raw_spin_lock_nested() and raw_spin_unlock()
> > calls are identical:
>
> Well rats, that pretty much makes it infeasible to solve the underlying problem.
>
> > /*
> >  * Add an offset to a pointer.  Use RELOC_HIDE() to prevent the compiler
> >  * from making incorrect assumptions about the pointer value.
> >  */
> > #define SHIFT_PERCPU_PTR(__p, __offset)                               \
> >       RELOC_HIDE(PERCPU_PTR(__p), (__offset))
> >
> > #define RELOC_HIDE(ptr, off)                                  \
> > ({                                                            \
> >       unsigned long __ptr;                                    \
> >       __asm__ ("" : "=r"(__ptr) : "0"(ptr));                  \
> >       (typeof(ptr)) (__ptr + (off));                          \
> > })

There's a slim chance we can "fix" this with a similar approach as in:
https://lore.kernel.org/all/20260216142436.2207937-2-elver@google.com/
(specifically see patch 2/2)

The goal of RELOC_HIDE is to make the optimizer be less aggressive.
But the Thread Safety Analysis's alias analysis happens during
semantic analysis and is completely detached from the optimizer, and
we could potentially construct an expression that (a) lets Thread
Safety Analysis figure out that __ptr is an alias to ptr, while (b)
still hiding it from the optimizer. But I think we're sufficiently
scared of breaking (b) that I'm not sure if this is feasible in a
clean enough way that won't have other side-effects (e.g. worse
codegen).

If I find time I'll have a think unless someone beats me to it.

Thanks,
-- Marco

