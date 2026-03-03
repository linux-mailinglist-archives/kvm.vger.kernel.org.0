Return-Path: <kvm+bounces-72609-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2PRHHR1Vp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72609-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:39:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E74C01F7A81
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B94B13090080
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43913932FA;
	Tue,  3 Mar 2026 21:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="urrYZLlS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03F63932C7
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772573961; cv=pass; b=ZUMOTi5NxXeUhzQ3OAjzQROcdrNrKkUNJhHhC0TyFagHDEyr6BZh/lL3ZYjilgvdUANHfe2XNOoLoC7Q6JoNLlP1gbrjAQZ0GojOpPyMVamt+601LZR0gA90vpVu/+2jJylgBTJbRutiZ2P6kmdq8cErWa9zG3b5N7f6VXPaFuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772573961; c=relaxed/simple;
	bh=fFAElkF7CUR60GDJaFO5zfK9HienfC7eKeiuvWcR+Kw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qKt5lUESJS5wmDN8nfFhU+ggkeYPCTZbGSC4s/daEF6NTX8zcCZerec/WV0ClEs63OB9sOUUFsj9GcVGEmVxrLMPGaG0wS7Z9XrDajJ6fus5Pwi/aMGbd9WQCMPfGfVwULDn2+tQcxcfTPH0+0X6AZX/MPV6SbO8u79143au9Nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=urrYZLlS; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-506a355aedfso631691cf.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:39:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772573958; cv=none;
        d=google.com; s=arc-20240605;
        b=W46mXAkzaD9JpE/OZsKt48FCVeI5nx3T6957SNFWFfJA6XvFSC33zsxKjakqCQE8XH
         bto6/xeyvRGPibExjcg5LjFKku1t0F5vOQQQFvAt0yGHjPg4832WtjchnuQLE490p7LQ
         0AaLTicaxEms+2SldMZXGmum0eFAk89VjNSg2wWSGEblYAxli0LzxY0kq8yO2wvFVbKC
         DXrMtZ0By0/H5+6ijHaCCFo9sX52IDHD0EV4SaPw4t6pWsd8dYQiNbTMtA9eIRdneMZx
         oQy3NEWjHVDWemXK/mTmJ8SEfxK2Wzkhttx9Bbsp+Px1cHxAcTqyftDPhZ+Vs/sXoYyn
         dKbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bcnZYXl2BjJMuM0/iADjl1cewrDesHr5oW+IPkJ8qks=;
        fh=vwvUf1LQ4cCcqmVFft6MX+wxUs8K+Z0hX0fN8agHEwQ=;
        b=LKnfYDVvhZT4G/bS713zULsO40FCOre1qQg8ZfcQ2CZ2cURc2bmiAxZ7lDe1uUPsYy
         osQucvXyeH2slul2Afc5XVJzbcYi63d2JrRq9JESrGWvA3r2wYvWQR5TCuQrkHvMzZaa
         LHwPUOprVum0aggoba3nuCCINKHy7UVz61wHrShQadzA1gJa4aQWphDofKLPj8d0OdEX
         Z58zRR4d2BpOIppVH3E8C5hy4Gi9YmiWK+FcaMNxRA3AySNV/HvhlHt/lYqib70uazyj
         lGbindggxhC3bqnm3d+zkFo5k7ajHyu8aXul/phKP0Y/Da9ayjwf19LBmoV7SeGApLY6
         ifwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772573958; x=1773178758; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcnZYXl2BjJMuM0/iADjl1cewrDesHr5oW+IPkJ8qks=;
        b=urrYZLlSRrKI5XMoirf+oqqipuJjfyedHLrjVILHepEH+u3/VD1hN/pcBfB7oVB+N5
         TqF5GESRKSqtHHcEAIBTXV5+PB9wtZ0XCfSgpbQygJtAuh/uMY0yOFZ0BAiKes1CAIn2
         1Z+TepzcISZDNJD9MkZmJTeQrjIEd7SybnHZPOMrz+2mgwqlFcutm9FxK/C9E/ZYi69o
         SMG/79bHPRP505syYLqe+uAy7gTdngVnEjXkiQsLEUWHXrmcoGPucANRUew+53hi+Mj6
         Efp91BO394jvkSvIpEzmsnLt+4dPxkWlKAypkJcl4Y+F3WQ6pYkU1Tr3FLKaAYKnUAX5
         2gow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772573958; x=1773178758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bcnZYXl2BjJMuM0/iADjl1cewrDesHr5oW+IPkJ8qks=;
        b=IDQUdzxJcK6za0aY0424mRffxdrdLBVwrGIqsr0VhCh9LW0Tuuw2drN80cT9Cv3509
         AQz/3Akv0/FZxr2kraYwvE8bDjb0ilFhwPjFhf5QS89X7Mr7BtL7pmv6foUGYrbTnyKl
         qfoWKwUeKjaEGkFPB2KNPKjdBIO5+ZZ8H3Pz799PiZnLgmigHyrQOT4nZmzq1G20wxuU
         C34bskFMqT1H+xQKZdXOp7hlxnDgqafXD7YKx77K+85k18KYABjQsHN+Jd5hQRGTZFt3
         gGWKclmFfZJ1fbU8lb1YYZy3aKp0rU8Bgsy9r7wuhwF1s57aoccirXXFYL/T6qmWswSO
         wgBw==
X-Forwarded-Encrypted: i=1; AJvYcCXdDeQcxcWZdbIx6VzcNc6U4IrLuQTIpXTjoiEoO5wXUZyC3wkQ7pkYdL52wRVtdVvc5H0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjUazvAHnbjzbpdXLNltsRNRHEoEyVVpAiKTMpV1I6xjTL8iSz
	xoO/XmXMpGS9aU6dt1tsqC0WkSSmI76D+L3lrf+uD436NzsuWD/npAAeU7PVQSVMhIA5Bio2tnT
	mULgCXYt123awNrvGKDDBCvtHZB59Av8Spkxa3jha
X-Gm-Gg: ATEYQzxU7IC5OuUHxnwAWhCVv+vD+disg9Tm9NWJQ6FsDTZYXFIYDEim+JLsWIGLG13
	fM1G7xLzY/7RAE0CEsbLb+RmsSulmJofOFX01oZVin2gLSDU/8SQ9Kdf2Nyhaxpzu0FLF0iQ2t3
	BUVeQq63nCl1ayyCuDT1yGGPzeTThU1qyLvnIsOuKR+g9lL9M3TAZhIPjYiRFpc6TifAvgSqgvJ
	+VFIGbRwWttcfyYD3QNFtkLkeDe2ak23ADxAG43rygdQW2ptwBVALsRUyzdA1/t7j/zNtF+/taR
	zbYqD76NhcllLDt3edwEbfGdS1AqEvsSIVV8ZF57
X-Received: by 2002:ac8:5dd1:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-5075fe651d3mr42016611cf.8.1772573957041; Tue, 03 Mar 2026
 13:39:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 3 Mar 2026 15:39:06 -0600
X-Gm-Features: AaiRm52vA8aXyZ84QO0eVPVcndLPd2lZR9vVhS9_WQuv-P7okwod2ZXFImZ6Qdk
Message-ID: <CAAhR5DF5BAcFO2tj0H63ZoRCcdpDS4Jw9XzqC=L2xWMW0M=0QQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/16] KVM: x86/tdx: Have TDX handle VMXON during bringup
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E74C01F7A81
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72609-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 7:27=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Assuming I didn't break anything between v2 and v3, I think this is ready=
 to
> rip.  Given the scope of the KVM changes, and that they extend outside of=
 x86,
> my preference is to take this through the KVM tree.  But a stable topic b=
ranch
> in tip would work too, though I think we'd want it sooner than later so t=
hat
> it can be used as a base.
>
> Chao, I deliberately omitted your Tested-by, as I shuffled things around =
enough
> while splitting up the main patch that I'm not 100% positive I didn't reg=
ress
> anything relative to v2.

Tested running TDs and TDX module update using "Runtime TDX Module
update support" patches [1]
Tested-by: Sagi Shahar <sagishah@gmail.com>

[1] https://lore.kernel.org/lkml/20260123145645.90444-1-chao.gao@intel.com/

