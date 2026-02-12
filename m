Return-Path: <kvm+bounces-71015-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qB6/JONMjmkaBgEAu9opvQ
	(envelope-from <kvm+bounces-71015-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:57:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEA713165B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6CC0F30292F6
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA8D35D5FC;
	Thu, 12 Feb 2026 21:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Re4Gl1j2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9ED2DB7A1
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933463; cv=pass; b=bbUKlvtSH8zdCijW/VZs80TxlGHxI7TketcFX54b6c0I16ovc/SfmBK6PhlbW7ehBWskYJ9gX0VDCMeqpAXdkPzbkLh9aQ3eqE0Zh5mBn3eHOk2S4nbMAAikMbaLqUUFf0nknBd8CPqk7VGROHKdY5ARnZq/MlQdzfkH3upbpM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933463; c=relaxed/simple;
	bh=5wuBvFYG5eYmHwQJLl0Nnqe6SghQDBWYnfHSmfQufXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=clYSgc1futWe7WQvDqvjmw4cjZ+ncnwG3ww00HO1OkFsm9Ak07wVSf/KATxhpjkXGZuNm1L7aWn2f1+gz87M3zMZ/Japu+wODyrZpycXV+Hv1fVFJCDmx9lNOG1LUULbzmDOx8u+OWj9CwniBNhSlCzML2XmHIsGyVII4GeM7Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Re4Gl1j2; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8947404b367so3855766d6.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 13:57:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770933462; cv=none;
        d=google.com; s=arc-20240605;
        b=QreP42McX3CdEMxVFsWdx/TGke01LbQAKurEzlnXPoHdwU9owp+D169H9icWd/5W1a
         ElCfW6DmGFIHvisaO129XRZOTW6oSlQwETioy2ipGRTJbtXpdxjXcuniPpOScOrCIU3g
         Jx1nj1ZetzqzDq/LClL+MwXt+WvlVwdxKuiieI4o76c5vVCUHIk2cAmEZyDwYFD9WQwc
         4m1yT8nRY1La1IwGSwkK+H/WAIFeYgmcFNw9No9B4vZ9RUfndBhz2fRWYT2EuH6nOWLL
         SxRd8N+aFYzMZyq2d2JwirgNWCQ1xdc7JvWCEWqNOzZbF/yeGi9wiD92gBuR/nwmkVnx
         DGYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QyG1076wjt51FSatBpiTWFn6dskrQWa3Gr2G6atn4p0=;
        fh=rptxf2ETcxDS+B2a7lex/Rw5L5mEoerAKiNvZXtnLmw=;
        b=VZf1cUBX38R0pPIUBrPDsvvfBU7XFn2fEssDuVrxQqVfFUDN0FICLx1VBchM1II7BS
         1d/omEUR2SJagUohU+C4AQrsXne4WYfqx7lSJ0od1dRd+DD3TacYalK/2JcWepbrKcK9
         Was99xhTzGzBTBh/M4/dOzMufTPeXPpskQtx9dsu2ZGMcFbrBNW4K1cActycG1nsf/T0
         i6Zx3TwwRLyHxG54SsA5SFp0AVkm8hOqrWbA4uDH7WikFn/q7xgHU8p8epJS0cwDXqHD
         NDxYLs0VHSo7QOONb2Ntc9Thlx2HjlyBSawOmXymcfRRKr3dBMiWzD8CJqQScxZu7b6k
         CcZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770933462; x=1771538262; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyG1076wjt51FSatBpiTWFn6dskrQWa3Gr2G6atn4p0=;
        b=Re4Gl1j2dQfYAY6rF3n9l+hiGlMu3ur6an2aa6uJc6VgN0Pu6Po8HcD+uYfCAVcGGZ
         eLy39wi0fR0QQ0disOjuIJzJu4PY75sx+tZ+pHES7jcSXWxhC4d3mzPznE780q+0uLCG
         eEu2er1Apm/DjYC6kSsyUX5LOer18kOYzgbGY0l3IxSWUzIQ88YS2IACOxJzMK1ha+sC
         5SnbSn977lfJeV0bRrFtrwTie5IxrJe1kFqWsogO94imERb1yrIs1vMf7dKmB1eZMLQx
         fc1n17l1aNibHjL81BYY1AV5E+GGNwKix87HWOdz19NwzFtwnkR7kcOQFfxg3fPyVRpX
         /nZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770933462; x=1771538262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QyG1076wjt51FSatBpiTWFn6dskrQWa3Gr2G6atn4p0=;
        b=OTGPfvlynowO0mbt+WDDLDwZpzmmdw44TxC8faNZjjXt6eOtZHdEGAfTbqnd+X3Fif
         Qt3umZjordP6THAmbTLM2VTaf538A1BuLQfffvD2iKFL5EfSHfEsMR2lkf5lzqR+xI19
         KfcywqQqFW39WRFZULQqVGC+C84Eg5ySU3bV1kK/slPfyGj/S3ODH2inn1fbG2NnnTHr
         kangKRjEa7sUXzFfwmolrNj2UbiBSOAuxhQOc5wn7v6Pd8kJUhiQ0wH8STEVue6g82wB
         wxiSiWtXtQ/XHgcQqkVlovsDYHg3jBIXrWaNbG9lTDEV0X1T50zj1gCt8vGF2S9hsFt1
         uytw==
X-Forwarded-Encrypted: i=1; AJvYcCUwVOUQK+eLZ/6jgwlmaj+2utlI643RB1CF5lyBxJXeKJneFp/bpnPX0iGpUT7gzPV2TRc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ4ZwoSXbI5YhHrl/U4YQvFIJQ/H49bLsrGt+LYy1AcLXYslfY
	Fxwm23/d5RJ3XRrMF3v7pbiK4rEjrcdBCYD7nwGZcKN5WL7xV5clswj+uw74btI7nOFCdD5EZ/M
	oaJi2kSYNfLiN9NmKPhpmqyPLSQOZMrvwD+sp4klC
X-Gm-Gg: AZuq6aIENptMTDize7/ckme5LgCq2rb8x9Ze87ys3z9XuvI49Cj41LYTTGZcOVTlnSd
	2M7ICQ61Y97DPQgKvnKvf7FoKfyJHcYwNr0jVpuy23k8CxrhQMNBiGnnN3f456kjdIVCMKO86BA
	sE4p9IMtz8/XtJDdT9s4MNXDINeAXVtbb9muCrK082/inAN2YytGZi32uM5o1EBnkrnNq8nATeg
	zYFw4CgJeiVsX/BeZtq0F66zBJIfkkc2nT3Atm8frL1igONQ0hpz6iVSzlYdsAs2hjnUITPQRso
	G8qNLu5PtuZNSIiZbl3Szw8gFQclvmdo16LnAS7sdvLaaLewhU8q
X-Received: by 2002:a05:6214:1cc4:b0:894:7cd8:59b2 with SMTP id
 6a1803df08f44-897347dce1emr9873236d6.58.1770933461344; Thu, 12 Feb 2026
 13:57:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com> <20260122045755.205203-3-chengkev@google.com>
 <aY5DHUQl3jWnk3TN@google.com> <aY5DoEINs4PhXv7_@google.com>
In-Reply-To: <aY5DoEINs4PhXv7_@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Thu, 12 Feb 2026 16:57:30 -0500
X-Gm-Features: AZwV_QgcI2zknxW9_T4Lcwi73EasvdfGbQmfR7xa6JlSykemao88v9msUO2ucac
Message-ID: <CAE6NW_afk_zv=-qtz13x6qEDiBanaZGEUou1G4euQpqwJS8DxQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and
 SVM Lock and DEV are not available
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71015-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 0CEA713165B
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 4:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Feb 12, 2026, Sean Christopherson wrote:
> > On Thu, Jan 22, 2026, Kevin Cheng wrote:
> > > The AMD APM states that STGI causes a #UD if SVM is not enabled and
> > > neither SVM Lock nor the device exclusion vector (DEV) are supported.
> > > Support for DEV is part of the SKINIT architecture. Fix the STGI exit
> > > handler by injecting #UD when these conditions are met.
> >
> > This is entirely pointless.  SVML and SKINIT can never bet set in guest=
 caps.
> > There are many things that are documented in the SDM/APM that don't hav=
e "correct"
> > handling in KVM, because they're completely unsupported.
> >
> > _If_ this is causing someone enough heartburn to want to "fix", just ad=
d a comment
> > in nested_svm_check_permissions() stating that KVM doesn't support SVML=
 or SKINIT.
>
> Case in point, patch 4 is flawed because it forces interception of STGI i=
f
> EFER.SVME=3D0.  I.e. by trying to handle the impossible, you're introduci=
ng new
> and novel ways for KVM to do things "wrong".

Just to clarify, do you mean patch 4 is flawed with patch 2? Or is the
forcing of STGI interception flawed regardless? I am assuming the
former here

