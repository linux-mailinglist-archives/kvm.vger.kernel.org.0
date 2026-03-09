Return-Path: <kvm+bounces-73310-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIpvCmjirmlPJwIAu9opvQ
	(envelope-from <kvm+bounces-73310-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:08:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8315723B4AB
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 16:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BAE730CCD7A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 15:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB903D7D64;
	Mon,  9 Mar 2026 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1OKV2Oo2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167BF3D75D8
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773068709; cv=pass; b=AQ3jkUHxgSuUultuUpf1/NTt5V7epKNzTCK9KojvIN5xSgSMMrPE7DUxaEJ0pjkUejTeidu6aCLdGJDJrUgAu8lcqEE6wPIPTyeNSTyV0/bxThf4H5ijjJdEoYmdFryMke4coXISNVGs1QqQPXjT0G5LjBzyV8AkTbORygtYXKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773068709; c=relaxed/simple;
	bh=h506DdISAW0jZvmzWHOqq1yATIV5e0BG5Ps1k2LXKBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fR9BgKjltz9t8k4UOET5glneZv9Tl0Vlh3xUvVOdKMRYJIZEle9+OBbRdSBCKlqYsJI3th2UpV0EccFd7DY4oxB9rwpgdqJq4RrI3bbX0wfpiR4AE/rq7x0pIPp0N/jqDw9AJSpMSVKJ4f8cDR27WBT3FNtCWxJhpdXk/CLKYhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1OKV2Oo2; arc=pass smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-126ea4e9697so14321c88.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 08:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773068707; cv=none;
        d=google.com; s=arc-20240605;
        b=W5703Hc1b8DzEpBRY+TvehKhWyOZwbIE71uwhA9Xo8ZkkuTgoEScW1vg7GD6hyqlAx
         gHL0kUDGKZlOX2hNtBeL4/ihvHRAKpeSLwX3ZkQMYTnju6UCKQfpUpdPSnaW4ttFyd9+
         XNN5h2RFAHIvCggCMajSSMxlD6H48iwiMWfzlZyoNLwh3//aWlJFw6bmIaypecT2IGF3
         oR84AqfHBuVXZtgaOUAhrlW3jR50aoIGErv3mCJ3XRSXMjh7u4XABLc8LdGpMP9N+RwT
         HTgyqYg20+ZOcfYwN03EMRx4SyTEJ3SkK2zjdi2UQwI+xDuJyxx/KXXKrqmZYXsbROhQ
         cR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9VyI22y/VeTZdWcSGQANDYhZXVCP9xDCNVvpAO/VOQQ=;
        fh=XWkDB2ltUqqhcFy9muzev86NoOCQKBCUYLYCpoMBoZQ=;
        b=IRA/xMNeYSIH14WgwbwFBKZrmWcQ4KaWITRl2mK1tyqqjonTq3C9a0Ebj1WorBafuc
         OQb1sxMVdBg3X/qatqK33VCUcAS76aBUvG+gnVtG5xSZifCjC3BfzyNmsGZaFZuxLf0d
         z/UxoNpEt1fjRfJiRF+aoddKK/lXm02+L9qtKVE9lCOANaQjTSw6K4q46kkCahgsLj5M
         DSJ+Y8eGr/QsVgtOtf3Xx5DOZBWD5rf5p9XGtR2lexkKM/UuBsNCsWsPfLbHr4KgtlIy
         FhMGvdq43X4wtH1TDtyY+iQF82p6l905WFJJoR6bo4bh/TEqytFqUqXqK+QGINtLbc9i
         tMfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773068707; x=1773673507; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VyI22y/VeTZdWcSGQANDYhZXVCP9xDCNVvpAO/VOQQ=;
        b=1OKV2Oo2ZpvrDiIem7vHcExeAzTgPqeXPaLCENvu5K8kJPozVtYggxkGESq9typnHt
         L4kc+2KJo35EDCSUGcGCEDRFNCRea1Lfk7TwD5cJYwmvGtaSTQ2D/LL92PlhvhgS/ROK
         LvQ5WdPifdcUCV8931cxIotU41yboxSzu8SDGY24oYFf5QyD/S4qQyh0ZKyY3S9RENwJ
         JLV8S9c+Y6p1xPuqUvUBfFaNVjP/0+vo35QJ2GqG1o4QmvwJDpFm2NUfe+mYX3T/16ih
         foMIGYa8iIjQgcr/iQpfxcKWb9ysclIyHYO9UQMDgmcqglkw+ecm0Mm018u/gdjZHwZ8
         FryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773068707; x=1773673507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9VyI22y/VeTZdWcSGQANDYhZXVCP9xDCNVvpAO/VOQQ=;
        b=SWwERRWeGCCuw66tJdIP7ozUzZW6+Pl9/mVm6AhM2Pm0+2poSP1owoG7I81YS369k6
         gNCZOfPsOuEWiqn0r+scz+d5nszFdX6VHPb9+BIrQBLr3DtIjMLbVPrIf1ahWGMBoUsP
         yhC8d4UDzua42I1VUgnGStLrC/AWL7jxBXPyjAW0BkFkf0+LvTrSxlCnf3a6nOKNYtkd
         NqtQiSxijzGi7RY4rFVZYvD7d3lpWW+yo+gpqlqPAYQRiBJaAfzKDdU+fUmtJfA1j1Wq
         5SENbLHVURHqVT9iEghna+wGrMYgPIjvsOvv8I4RuAP32ggPHYzTzfZhqfTxXncQQLfC
         5TIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIyzaF9SRtIsVedqUS4ZVkbaHHhNM+9xpxMCL6qm4CzIl/6pAToIuzG3u64Sh1MVTluKI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4hJWz7VkDrzgXlUyGSzSA4BEK1lDhSDnPQCV3R27isNUssDLl
	n2CBiPP4nx9/sSCxNRgGtxRMGXUdyeT6cjZOT4+3b2LVwsoSpXCMdcvm1ougozwlsmVAsI7DBbt
	MaY885JWIaT1xJMXUNo/mk7yt5GSP678CGEB2IFi/
X-Gm-Gg: ATEYQzyxOROQeju4nlFmu+K/OoMV3xZVPDTzPRYxu1NqkKe3f4lJZ9hLtj4Yr0t/PsE
	svbbVWOZxDmjsc0J72aF/2bV92wRfqnskcCtZ6GEQrNu2p1YCphOS+xj5a1BBhMLgWLR7s65Wrp
	ANiBgtumTAQAEiTqFchDKEJqNZlYiz+aVmxNZRaTHi1ttupnPSqCKqKmaiCu0ZiSuLEP6ix3H+J
	RmKN57pwbXF4arpbyIP58/IdBjvnnY8Gy1Tc8VvoDWCuwOqYzB6CEQ5bz8E1IJf45p15qdXs6jZ
	kvzdQ1+Wcm5uD7bJ/P9gpUmS+22cVopoF+kFhpg=
X-Received: by 2002:a05:7022:984:b0:127:9745:c69f with SMTP id
 a92af1059eb24-128cd6c78e4mr326409c88.9.1773068706409; Mon, 09 Mar 2026
 08:05:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749672978.git.afranji@google.com> <aa7WjPHTUDCgsO-U@google.com>
In-Reply-To: <aa7WjPHTUDCgsO-U@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 9 Mar 2026 08:04:53 -0700
X-Gm-Features: AaiRm51CMdt3YQzldlYrLNi93jNDQSQgth1QTuEwDfkO5X2hip81D88zpTx2ItQ
Message-ID: <CAGtprH8Ls0vTYo_Fq_Tb8DwU8R2J14oaniAYNBOPb15dyaWOXg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/10] Add TDX intra-host migration support
To: Sean Christopherson <seanjc@google.com>
Cc: Ryan Afranji <afranji@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, sagis@google.com, bp@alien8.de, chao.p.peng@linux.intel.com, 
	dave.hansen@linux.intel.com, dmatlack@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, tglx@linutronix.de, zhi.wang.linux@gmail.com, 
	ackerleytng@google.com, andrew.jones@linux.dev, david@redhat.com, 
	hpa@zytor.com, kirill.shutemov@linux.intel.com, 
	linux-kselftest@vger.kernel.org, tabba@google.com, yan.y.zhao@intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8315723B4AB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73310-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_CC(0.00)[google.com,vger.kernel.org,kernel.org,alien8.de,linux.intel.com,intel.com,redhat.com,linutronix.de,gmail.com,linux.dev,zytor.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vannapurve@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.990];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 9, 2026 at 7:17=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Jun 11, 2025, Ryan Afranji wrote:
> > Hello,
> >
> > This is RFC v2 for the TDX intra-host migration patch series. It
> > addresses comments in RFC v1 [1] and is rebased onto the latest kvm/nex=
t
> > (v6.16-rc1).
> >
> > This patchset was built on top of the latest TDX selftests [2] and gmem
> > linking [3] RFC patch series.
>
> In case someone is feeling necromantic, don't bother reviewing this serie=
s.  I've
> provided a pile of feedback off-list (I forgot this on-list RFC existed),=
 and the
> next version should be have significant changes.

Thanks Sean for the note. We will soon refresh intrahost migration
support for software-protected VMs and this series. Need to inject
these features at the right place in the queue of guest_memfd and TDX
features already under review.

