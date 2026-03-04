Return-Path: <kvm+bounces-72623-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBOcGWd4p2kshwAAu9opvQ
	(envelope-from <kvm+bounces-72623-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:10:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EDE1F8BC9
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 99D323059AB5
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378BD221F20;
	Wed,  4 Mar 2026 00:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nReo+z9/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C0E1AAE17
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582805; cv=pass; b=MEVxY4jZAEWW7+m9SjgQQEwKjLiJN/iLAvFO9AsXnUn2lEvAfkFaCob0e9gsnIw0EWcsMClvZqirmexTZk2y/WvQViE9Y/nAuIrx3mVti2lnNdfizCXnmDX95vHQZRF5NbdEy59fiFUfFJmJIHF8ou6iuMNEIlzT9eeB+FfNh38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582805; c=relaxed/simple;
	bh=SE0iuTKzP7Mva7jgcYokHYOcLSARQ9ahmEoA1aPrACI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mLcBDwbfRtaB6KiMj6iv+6ot79KTnhVKM6avKPlDpvwuICxARTFQts5Bmjt8NLp6aIJC7VjQOV+y6Xl13gIfBoXoRcQ5reTBL9Sp+IfmxhEPQSZj/Wq0aCPy0frfq0BFaBPwGhz8XlXZrHGLBlcMSAYIQO7+sZYXQaGp+37fQGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nReo+z9/; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-505d3baf1a7so739471cf.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:06:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582800; cv=none;
        d=google.com; s=arc-20240605;
        b=Ns/AxltB+m6d7ljUS4RFNEVmPfN0p4CRlmeDRPSXmLFv95iL+5cwuLjMFHNF35tLBL
         e7vaXB7XQzwFUty1abbmw6FcmVnC9j8hRMLd0MsxbEEOWQqi1hg+68CtvHmBeH9bNWDF
         t6K5SR0oWUXOar5KlPKMRmXMKjyz4xXuF17BX/WZZqOGc5J7jTHzupc7qkjyweGEvjcD
         x80Lb3o4milai5rPhxEIFA2+Qd70p4AdUR/KXJStSpSiBGbQajRbbsdu9eWS71C826zv
         w3K4AHCj4eXi5KzrDgDDXwJ30q8CzvCDCPSJ/0eBMUShd2DVW0CqxER1Rh/Fx82kpSVG
         iqFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y/PStokD6IlhvxuuSo1FJomzpaCmyss/AOhqDAfuiyc=;
        fh=9wam3tfkI18hWhN2S1/xYbMDX9SoKE9lV/UGJWozFII=;
        b=aPOhtZBS7K9U4xIV/IXmh57RNuXzmQ3kyk1CuJjsZDFcAdTJ+ylM4VHK9RKz6XlMqd
         s/VrRkIYKraMoerJWzzvIVQwmPMnNKSd06EUnp5fXGd7ZTbzVxDpasmZJU6lkV1tNL5s
         Qe8cEje4J5BYMpgOzyVU1wFrEtIlrVZ4WbsB33ToynznduieiIj+HxguhgcdGgpHf7TR
         3zQg0EatpIXk6OPnVb9Lz/mzgt440Kn48KunFneb5SPhtBVIJ9xWUq6KbCa/brM5oMlD
         /3MmUmxVjOPaPlNtTVspiNyjWo6iDOUuquXvUpE0bD5gpOpMWxsiRUn5Rus92m7SLqRy
         07Xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772582800; x=1773187600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/PStokD6IlhvxuuSo1FJomzpaCmyss/AOhqDAfuiyc=;
        b=nReo+z9/o8L83cLNyVg+r1lbMnq0HXPXlgYU1hVmkO9C/K7O/O6b42E3swflnhnem4
         3Pcj2G2W1w0kiq+LS0kj9dvS/Fn6ApSDpDgcS7DpYhrVc69o7p84ZMxF00Y3T3rXrPvY
         zmv7/GYdelHg103EwXiQFY8Yxh8ZRdLDxGtJpGN9GNQNHGwrgfzh38Thy3IFI439IdNr
         T0iV/TixUf93iGwkqtwYpzupaVNx3iwBTWF1ldk7YLBRPdxoI6w4DXIs1Q4iunuLksLY
         AJP0JkAJc9hGunoOwi3IOMLwcJh5ZElxTmrGNvNRuTLj/QZlwKIkY07R1Z8QDSDliSq1
         w70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582800; x=1773187600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y/PStokD6IlhvxuuSo1FJomzpaCmyss/AOhqDAfuiyc=;
        b=usBATH9AEqiowFhBRCD6+sHtd9wlG5eBZLZw22hdTVkTAl4YGenQ5lklhJFF4XQZio
         OLiFVRRFPeyxlBhtpIbrCf5ovqVmntx55kgPk8F+Oez9Lx9rvhftN6pNFKxBjaj7ICGM
         0nRuLP4mXsgQaQKJmQ9/1eMLEaGDAHxz2LlpjLUgbgBRZ5u8u5Yi/uF7Iu3ytPpYUmlW
         B2XfxPlQYx0CQ0Fa3cuQ2umDkGHJxqw4s9Kzj6JVR4AbomWXXj9NHQygIEsgacMl8c5q
         SOZc3qX7Wwj0fznmlqmKTs0mNNL8V8VqUdJESuIrxSfCbSFHbBSh0M1HfBDHAsqDqABf
         TiHg==
X-Forwarded-Encrypted: i=1; AJvYcCVGHCUYspqSw6CrvqwPE9bUBEWmGrtLegpk9rcWZTG/+oLGHGSCsjtIU+dUxRjEvZXFsYM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlKH/AOifq7kDDYF443qvWtLC8pnL+CqGjlcBbVZBQH4BMKX4n
	9oxNp799/QdOLU8NQ3HNAZj3VTqQ/Ecw+P9VuSWfx5uQNuGDOR+cmiKdBJFEhMpM4oo1aNaW2mv
	Uo8ssQ5O2D130zobBJ941/IRZT1WVRmJGEnrkeKsz
X-Gm-Gg: ATEYQzy3ok2R97GFQ3vaBHD1u/PflyMIxO5G9IUuRWS7Eu3HcHq9QQcXW/YMRxszfeX
	BpCgDHcBWj+cd58SFW/30R2VjmglcI4DzwAck5t5f7DVC4NwOMUK0S6G4D+HFbfcl1gAH02TnXp
	vogBW6eSZ3anuY4HZnlVHpUf6zc7d+Tsh1PpHfdGQD+KdTNL5jeD1/pb5S8OjCWv5IWJH/Kz5Jg
	Kq4Zd3mzFfOeP0DV73XwM0T1JV8Jgf04CgUYELpPVUqiH7zFvY4yNXr7mHqDes79R79N9e+T7D8
	hPFT7VpSoos8z6+aYHDWT2vcT4ouRu/xhNSaxAgA
X-Received: by 2002:ac8:7f07:0:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-5076186631dmr41314681cf.13.1772582799147; Tue, 03 Mar 2026
 16:06:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com> <CAAhR5DF5BAcFO2tj0H63ZoRCcdpDS4Jw9XzqC=L2xWMW0M=0QQ@mail.gmail.com>
In-Reply-To: <CAAhR5DF5BAcFO2tj0H63ZoRCcdpDS4Jw9XzqC=L2xWMW0M=0QQ@mail.gmail.com>
From: Sagi Shahar <sagis@google.com>
Date: Tue, 3 Mar 2026 18:06:27 -0600
X-Gm-Features: AaiRm51ACYQne9diQMSqsETp8etVEqCczz3Uj5tSioGxwFV-IALILtfuhbSZAbg
Message-ID: <CAAhR5DFVmu5dViPBuwd_nSu_Z4=jL5W83q=sRkNP2bOqW-5_NA@mail.gmail.com>
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
X-Rspamd-Queue-Id: C1EDE1F8BC9
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
	TAGGED_FROM(0.00)[bounces-72623-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 3:39=E2=80=AFPM Sagi Shahar <sagis@google.com> wrote=
:
>
> On Fri, Feb 13, 2026 at 7:27=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Assuming I didn't break anything between v2 and v3, I think this is rea=
dy to
> > rip.  Given the scope of the KVM changes, and that they extend outside =
of x86,
> > my preference is to take this through the KVM tree.  But a stable topic=
 branch
> > in tip would work too, though I think we'd want it sooner than later so=
 that
> > it can be used as a base.
> >
> > Chao, I deliberately omitted your Tested-by, as I shuffled things aroun=
d enough
> > while splitting up the main patch that I'm not 100% positive I didn't r=
egress
> > anything relative to v2.
>
> Tested running TDs and TDX module update using "Runtime TDX Module
> update support" patches [1]
> Tested-by: Sagi Shahar <sagishah@gmail.com>
>
> [1] https://lore.kernel.org/lkml/20260123145645.90444-1-chao.gao@intel.co=
m/

Actually, looking at the "Runtime TDX Module update support" patches I
don't think I ran those with this version of the patches since the
"tdx_module_status" changes are incompatible. So it was just the
patches in this patchset.

