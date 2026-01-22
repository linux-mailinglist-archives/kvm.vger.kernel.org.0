Return-Path: <kvm+bounces-68850-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKhRGbCwcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68850-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:08:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5F361E89
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7CB8548B6E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77B4466B65;
	Thu, 22 Jan 2026 04:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2SBLXVwp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0346B4657DB
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057984; cv=pass; b=t3+lAbNo9VUuki6ShuC9v7vTg0aAj/lom8hni9bj7cq8GHpXtUfx35h2rIEA0sUcOtJX6Dl1XGIbEKCNIW3Zvv8s5jSKeFXAY37CqgmDL/GfhjZhHbuSB+f9s4d+Tya9Zz02TNieEBjSijEF2ufsHqF/4+u4MTDeeze8vqVGgRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057984; c=relaxed/simple;
	bh=mxywTa4HYO++f5hbQwwQ330xV3sepQJTN0SCUn37Rkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fEk+F0NwRzVxDiK7G1NzN1P7O4gfqQXdWM0MLFSSfZgCDkB92xy961RCbt2OsCAECe3S4RIuHf0mbHv2aZQMUHyxMgOtRopC5LPc0vTgKogOOxVQiQyv+fo373jR2N/f4e9tlX+bO/BZAcrtFYhzwhAmw3lZCYmkzV50GgBoq/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2SBLXVwp; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4359a302794so314820f8f.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:59:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769057981; cv=none;
        d=google.com; s=arc-20240605;
        b=ZGyt1Vcu9botPLJsO8kzI3oABt1s7ybArpHCKyZMLWBMWtDXPeyFHBNctK2CjX3yI9
         3GskgERne3EpPB1yZfsh08QMA+ZkQ79P2q3f8ZOzTbY1omgXrFiTVUlntHFQo+TuSf6/
         1hAPXm5CrIwkTO/bVetzHZze43Rb/nXWf1q0PsLXarfNpC8k3OnUJvOjIOogUOybF9bN
         ezKu8dAqSMP4XCtY36Vv0R74lO6aTVT1XLd6swicRfoVUJsvayb0iw2onZYEu9iImrrW
         1fOoAE097qqmaD0h1QrWTqkd2OHuCnIorqXd3hponu+zDebE2T8WCuvhaTnahqJsra8b
         syiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C24wmi9xaB+RPRHxZHMprTE/rvrgYmuoBvw8aeqpZuw=;
        fh=9zWVVUJ7aI7tQtJw7tU2bWl8RuJNyTxxS5zrWP/cNpU=;
        b=Kandjz+qcBdgr4Pelth5+8370uirRjydruPy6w62NFvCAbFc3Ti/HxncXrEVqKSP6i
         3qv1H0gF3Vy4Ta/DxuFHNl+48Ogygr50H5HULYepivdy1+7m8+COcOKQVHwsjaiFa6uf
         4VZUq547blN8WPBbVktIF1jMZkhOTsag5H96tR78/mcXqV3+ptcEznLOnO+0WVgXe6Yy
         SEEpbtZ5QKw4oYMRapyL0VJ1p04/miZK5LdO4Tzn+XKx14eAFDtlfQeTCSlkHpO21veE
         sy0zTHDYMJN/mOn/GSTfm4705lAf6lpZAgwzdarJPTQOYXtJAkFiqKsNyvA/RN3t8CJA
         zptA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057981; x=1769662781; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C24wmi9xaB+RPRHxZHMprTE/rvrgYmuoBvw8aeqpZuw=;
        b=2SBLXVwpPk5ykNKfBMh5w65tqL9Rc13mN5WqIDYXmoEmoOl2mNP6RcY5S9ykOAiNcA
         GeYcMZUsH+EbSWUuub0SupoZjsvmJ9oGhnOHa5FvQsQl+XKgfo+FpDD/udocbn752ky2
         mBwub8/bDmOhPPkOmlu8yKDJ9ByDXIndp6o47pXCuUrakxjDbNM+jQDavC8Y9yRNqMU3
         LQCV5cG1h+nnCUdTlXiFiwS4Bz9lpx9VQm8ThbKHOkytJXI/SKr0gHHAIjROfKEjFVKU
         c7fVWDba0B4rYb7ZqbX13nw2PxzYOCL+iemf65s34oa7wkVIB5IYN5Ugnbwx0EC5lKTM
         yy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057981; x=1769662781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C24wmi9xaB+RPRHxZHMprTE/rvrgYmuoBvw8aeqpZuw=;
        b=GnP1gR3U2b/cBN58f+/unknDr4bIHmG+wL1duKOxAISUgTKzA5X70JlVZJxvRc+JmP
         xSFB2qY8xkXE7J/2BQNA3ZSO37GgYijDRlgtHdrzyT6YVIM5hfmmHK+ibGdbFOjNy/Ep
         fmJ/wf5BV7LvC/qjHXmdAa8FCA+BoUDe4HPSOC8DXV27le2vzHmrcV+jIyLRw2PPyGVk
         rAaqVQzQhKR/uXD4yGA7U6YczvYu+sxkZ3kQQS38eE3JZWRlSOAKQhAPyD9vWFxYVdsS
         pLcdzN7jiSlIXTW95Y7BhrjxtDmJs0C9Ux38kYrmpXQwBPnDmNRGW96DDrZLs1SoaeLK
         FyIA==
X-Forwarded-Encrypted: i=1; AJvYcCUF2NYrfA3qiuwEX8bjNqsrhuX+qnshxKMmvMWH/lJJcHjptOrBtqpBq8FrqWgURJxhxJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv0qmMP/uplXZi3SEgNW7HIH4hPY3WQ5UPLAlTuVP1kFqduEXY
	4DSi+LAYpu7qSvVRIgYCbcjD9mgVrRk2cyZxvbaOkOCn717JpgB5rqe2qD7KH9VcmhBctidMpX5
	uWQ3y/BJaONF7CtosYVTTLTrWBK+Xx1iq0KVT7bdZ
X-Gm-Gg: AZuq6aKqO6dhLns2VfP1+NK7Ho/Bs9cmb4oztDtYe08R7pz7sg92knAS2oZq2Tb3lsW
	la3vgxOrB4f/UF9Bo7yi+wMc/41XEdwOf5jeUTS3RLM50q05m2AT8WyIo8LNqlzQh01M//jH8Iu
	/p1GNBRWikE1zAZvEh/q4tlVivEzYyr59tQp+jjuEMjVLJgb1uxTZFW7jtk+YzgZXfIxjI9Hxz7
	4rvTupwFTFHOcvxUsoiusEK4iNHTKlUH58VtLbU7Q/R4tGpWyGkFp+9+DeGOBWIuPfs4cz+7Z/6
	dTVyul04wVOnXaadPmdppihgaDpdgQ==
X-Received: by 2002:a05:6000:420a:b0:430:fdc8:8bbd with SMTP id
 ffacd0b85a97d-4356a053899mr27836720f8f.41.1769057981000; Wed, 21 Jan 2026
 20:59:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112174535.3132800-1-chengkev@google.com> <20260112174535.3132800-2-chengkev@google.com>
 <jmacawbcdorwi2y5ulh2l2mdpeulx5sj7qvjehvnhaa5cgdcs3@2tljlprwtl27>
 <aWhFQcNa8SKd679a@google.com> <xndoethnkd2djh5zkemvgmuj6gc4hsnxur2uo5frl57ugxa2ql@c3k7cadxmr4u>
 <aWkdF8gz1IDssQOd@google.com> <ugrjf3qqpeqafg6tnavw6p4l5seapl6mfx6ypypka25shvu6by@pq4qpwn24dyi>
 <aWkkBPH3IWn40rVN@google.com>
In-Reply-To: <aWkkBPH3IWn40rVN@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Wed, 21 Jan 2026 23:59:29 -0500
X-Gm-Features: AZwV_Qg15nEAd6LMr9WbduqSJPyRMDbSg3SRdtkTbR_CYrOEp4lsf4W4YheisCU
Message-ID: <CAE6NW_Zqw4pvvbDcyLgJL6Zk07oKuWwfuCAobsi0LJRa_HzMzA@mail.gmail.com>
Subject: Re: [PATCH V2 1/5] KVM: SVM: Move STGI and CLGI intercept handling
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68850-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0F5F361E89
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 12:29=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > On Thu, Jan 15, 2026 at 09:00:07AM -0800, Sean Christopherson wrote:
> > > On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > > > Or maybe it's clearer if we just put the checks in a helper like
> > > > svm_waiting_for_gif() or svm_pending_gif_interrupt().
> > >
> > > This was my first idea as well, though I would name it svm_has_pendin=
g_gif_event()
> > > to better align with kvm_vcpu_has_events().
> >
> > svm_has_pending_gif_event() sounds good.
> >
> > >
> > > I suggested a single helper because I don't love that how to react to=
 the pending
> > > event is duplicated.  But I definitely don't object to open coding th=
e request if
> > > the consensus is that it's more readable overall.
> >
> > A single helper is nice, but I can't think of a name that would read
> > well. My first instinct is svm_check_pending_gif_event(), but we are no=
t
> > really checking the event as much as requesting for it to be checked.
>
> Ya, that's the same problem I'm having.  I can't even come up with an abs=
urdly
> verbose name to describe the behavior.
>
> > We can do svm_request_gif_event(), perhaps? Not sure if that's better o=
r
> > worse than svm_has_pending_gif_event().
>
> Definitely worse in my opinion.  My entire motivation for a single helper=
 would
> be to avoid bleeding implementation details (use of KVM_REQ_EVENT) to tri=
gger
> the potential re-evaluation STGI/CLGI intercepts.  And then there's the f=
act that
> in most cases, there probably isn't a pending event, i.e. not request wil=
l be
> made.
>
> Let's just go with svm_has_pending_gif_event().

Sounds good. Thanks for the suggestions Yosry and Sean :) And thanks
for catching this!

