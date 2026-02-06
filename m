Return-Path: <kvm+bounces-70520-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KErLJoRthmmTNAQAu9opvQ
	(envelope-from <kvm+bounces-70520-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:39:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 49948103E9C
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A553D305A43B
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD173126D0;
	Fri,  6 Feb 2026 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1mBD6wb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B182A311966
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770417494; cv=pass; b=Y+7jpRi3qeNwpdw1JdMv+asgbwfT9/PbjS//agRotCrR3OCXNtKw9YFn3o2EnBSJ9/GYKKCS4px/+p4KJzAJ2m25WH0rvZ5WxFOBB/QFtVvhKixnglQHWoauNszroghQpJ+17hAKY2J2iHav78apaEvxALEsB/43R4+y4QZEDLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770417494; c=relaxed/simple;
	bh=WpKCdaj0b04bCkkhFNILyKYzgJ4uD6OczXLU8WXTaQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YYaOG5v3CuDweNd4Ymj04QmbN6HTNAI4UhpYvdH24LNzlnl1Opcp2X2sSwuQck9E9KI6cqm8wE9hCvjaQ7Q0/F377347GPJQkBEwWmY+NBqiVPjmIDwbLWiz+cpy42nwNdGFQhF32UDGwh6LBOnslDK7Zsqu+yuclN2edLRhXyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u1mBD6wb; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso1166a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 14:38:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770417492; cv=none;
        d=google.com; s=arc-20240605;
        b=TWRn0+ZHUuWtvA9s+r64syZIYvBsdvYQun31HJm/OBcSCXqdLDKdMwJURdzedT6upi
         okyFEFXY4jVBvAVDVWfFcfKCR8Zt9HmTQwT6lH6RcrrVRsGvjAg423E3/XWprktaYGbb
         pQsGm9KHRqwvPt0WLfxZuwgmgETuclAuQ5axOr/Az7gPjKMyx/RDBHs9Fn3pyBBGS0WN
         logRIOhHlPPMOliU9z3zV+zKbipsKxFAX6nur9B5hVTSgPs3USxX7E5rjCin9SYW3w2f
         HpX0UTESLF50BfjYvqqiZswFGl0VG2Q5lggRHxH/8iHwxf27+FxPx3VAIjnJ8whNbM8n
         +AzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8OZHNrPRDVp9qsqcZ7IHEQW80ty2xaejJuWwPlj+dT8=;
        fh=m0/0wZbj+/qFWtVNhDyLSWc69PwAA8NaBJbu6xfuYHs=;
        b=RZtANG9JYtJuncO4xBQ69GAPwY3L9fesHP4HNcvnmEkPCLUdpBSHayxAKGAT0MydRW
         aEEboMcoKlbh1lPLqE50LnWU6VD9PZ0AUAJ28CeBqtJK8r0LX46UH7//ODLZTqOwb0vA
         XrLWsk6GukTjbdZ3ZiuEb6nN3T0ghGv9GCQH/FsNW1p2p7YpMTngxt3P0HaAGsRmypiE
         YXMG4NIgWkH8t5hk0oMmHPnGa75xBMVaoIZpg3C6LCF3tXtNS5XyfpKf/X2Uqgu9ffrS
         32T/TmJrPVa4v8i0SLRohkM6rM1D+MpaTjQ3BEGXox0qtLLbL08ZRy6eNMhBxBB0oiMR
         WEsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770417492; x=1771022292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OZHNrPRDVp9qsqcZ7IHEQW80ty2xaejJuWwPlj+dT8=;
        b=u1mBD6wbcKxVlnN91xnB878u4ZBcAbrx5Y32mbsqf3zmsmhI6Dx+ydkBq1a/StgtFw
         9oQ96XfvYzZrHsc0J4f00PyN0z9Z+uANukgAPcRhY2H8on32/Fi8gBX5dPT49kFaw1gH
         0eSQehEYpJZpMEFncwW2g4flfjXZgVgwHdQfz2/v1BUgUoZTXDzBzQKBHeT52/+nWeuQ
         KSWOLqi9hp/c6dxJXkZwfJADbfSgP3kY0T1DAbER3ydEiaVUQC+pDe0aVTwnW2gvwJNs
         Kcw6A6BY7rIarowthTw8QEbvfmipCW7B8enaHD6eoT39pF4K4yTh95aUdAIZoKr9K2of
         wEsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770417492; x=1771022292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8OZHNrPRDVp9qsqcZ7IHEQW80ty2xaejJuWwPlj+dT8=;
        b=JMWf/XKVIWjVC+tqDo/GfZCb4AWlJ6UFjvzmWlrwO3+/1fn80k5gVeIQMHP8gRasfb
         KWMq8VIEc02XQQyiHha4SrFJg3QSmuuBjqBezONYLqu0PAdDROfw5WgiO84IB+Gf9X1C
         j8xuu/GKxvQe9DRSKvxqGr1cF3Drs01wIIeJ1r41tN+vX2QZwZtfCQX2EfMJMw3MHjtj
         Dw/ubSHfAWZXdTgLqiUdfzv9KAXjhIPy/D/i64Fs9YtO55yejQ2Q6d1elZ/iR2rhvsZJ
         GV99PjD8V91xfx/dETtlq6cRnT6WrAhgvTUIU1aKGUyjRGe1N6wf40Uw/au4Zx39h8W4
         5XlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFbhm35kCxjRE0ALn1DLDMuvios4txc6t4c693MyEcogurzHrV4teMLzgmjBPPHRMxtXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1NJ/I1vNO8f4+nUIikqivb+uBhDG7mzDHtGdbv23KIEmdaFML
	i7pRL7jtWgkMM+TfLECOvVcYQn8RThI/uA5ynmQ6G967FzM4Z/MLSs2/7oTGHhM6zdQnQyxNqPG
	wxw7/mbtY97HbpLTw/so6TiCAFLwkx2/e1rECvYfL
X-Gm-Gg: AZuq6aKZw1oa/HOMbUWKAKQpHqTJ0hHus1yX+lLOsxh09Yq7XCBNlXJdi0eBvS9Le0V
	6g8eU0L+wDMGOMmoPwLTrHTt9NZKAW3GIomNKjeyZ/+2H2Lfjw/7g4+KHGMax6qA1khkQfKJogl
	UB6KeQAapQCCH/whVTNRf7CNneoDTIQrLKVSMOeaqFu0jteVkq7hlrEkzkjmnkDf1MPqSXxM/BL
	FwKGzMUDsXxAUJunk7FdyzAD/cH1ZSj1/n7TEzYepCAtvDfOX7ZgtziB5nRe8kL6NWJaRE=
X-Received: by 2002:aa7:c98e:0:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-659a9c16313mr3646a12.7.1770417491919; Fri, 06 Feb 2026 14:38:11
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com> <20260205214326.1029278-8-jmattson@google.com>
 <aYY-ZwjEnHbY5J-T@google.com>
In-Reply-To: <aYY-ZwjEnHbY5J-T@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Feb 2026 14:38:00 -0800
X-Gm-Features: AZwV_QjIilRUJ1j9fcVJsKGyopyfYUmDpLvg2aSanEQA0gYSu9-DhXX9wC_lxkc
Message-ID: <CALMp9eTZaH=kc1xM-u9DT8QSMDBE05YwG8Tw5SqeMHa24x5gmQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] KVM: x86: nSVM: Handle restore of legacy nested state
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
	TAGGED_FROM(0.00)[bounces-70520-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 49948103E9C
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 11:18=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Feb 05, 2026, Jim Mattson wrote:
> > When nested NPT is enabled and KVM_SET_NESTED_STATE is used to restore =
an
> > old checkpoint (without a valid gPAT), the current IA32_PAT value must =
be
> > used as L2's gPAT.
> >
> > The current IA32_PAT value may be restored by KVM_SET_MSRS after
> > KVM_SET_NESTED_STATE. Furthermore, there may be a KVM_GET_NESTED_STATE
> > before the first KVM_RUN.
> >
> > Introduce a new boolean, svm->nested.legacy_gpat_semantics. When set, h=
PAT
> > updates are also applied to gPAT, preserving the old behavior where L2
> > shared L1's PAT. svm_vcpu_pre_run() clears this boolean at the first
> > KVM_RUN.
>
> State this last point as a command and explain why.  E.g. I think this is=
 why?
>
>   Clear legacy_gpat_semantics on KVM_RUN so that the legacy semantics are
>   scoped to a single restore (inasmuch as possible).  E.g. to support
>   restoring a snapshot from an old KVM, and then later restoring a snapsh=
ot
>   from a new KVM.

Actually, it's just because I'd like to return to normal behavior once
the non-atomic restore operation is complete. I'll add that note.

