Return-Path: <kvm+bounces-72499-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AbsLThgpmlVOwAAu9opvQ
	(envelope-from <kvm+bounces-72499-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 05:14:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3291A1E8A8A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 05:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BEA5C306363E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 04:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F68382296;
	Tue,  3 Mar 2026 04:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bw2AvQwV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1809145948
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 04:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772511273; cv=none; b=LGNhKsjI8Joc7QO6bocgbvTQatchztXGqwtDi+TdbzW27iPs6YS/XtVQh2mu++VAclHJL6rzL3Dt7Ri4s6VqG/k/F/NRuBDmsGWuaJMVMnZ9rt5Sk249IAJoa+kjmtpOgfNG6hsq7QFwsAOdlDuJxLoco0I0Wp2pYSMXNtV+UVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772511273; c=relaxed/simple;
	bh=ZSQHLmAb+Ryn7kywl6DTB7LYe5JnGGQK4k8s3bcjzDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nKkDHMv23srxvQ4Z08rrqhx8YU6f9Jcr3+wwoU+ha6DjnFsQZ2aVKGm9Z2nr0ESLeNVpMsGbk/bh4uldXIKFnxGPShtdGjOjwUOlh1CwU6U0hzCzSxnDYG0tWkmNojCo41TOOBuc/mpMgp+yH46WFem2Ktxq4qRGYAnMrHrMpQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bw2AvQwV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E056FC2BCB1
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 04:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772511272;
	bh=ZSQHLmAb+Ryn7kywl6DTB7LYe5JnGGQK4k8s3bcjzDY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bw2AvQwVXt9MAZhIzWW3dXPxyy4PJpWBpBbJTEV8i4vGJKfJ7jdRZ9HTvTb910Vl2
	 lnFQeTFu9jLBj8WkQ9YFhYgkhc+6LgobvWHfH537ALrUTEk22YWNMfn4HiVmGKV0PZ
	 VbHvxIgPeRhZHUR89+7GTZweUH2Esv/oM5YnP/aBG8i9LDxCdO23CntbE1OFPQ0Krf
	 HwL1uuVsEdWA3Kky9MFYGicxG1wr4ZYHLCJGNJcaOXLrXxl04abnloyHfhn698qX0D
	 TckT3sYX+RFltSGV9glv3NmG/NYvByV9DDp5ikVrBRHyM8KGi1kHdeKvVJMACikdGd
	 5WVV5hvxojX5A==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65fa79f5c98so1825555a12.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 20:14:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWDFi9cg5aHRTtKXMFhmu+iKfW62uNj3HDHDDcrQSw20rV74TQbGMWg681/lE9srQMd/Sw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTHTZL0RWBy3vsNYl0dRxrGw4wJ0CENbCTJ6q9IcgNuhf3kSk6
	q+qxgpTU1Pu5N83X04WxTczz5Av25ku4Spg94NqZWwF+IT4Th8sUBemTX/k9rxSMfjtGSAsT4wR
	sxOOg7eO/LBhIfsYtz5KhrEEPWYRDchs=
X-Received: by 2002:a05:6402:270c:b0:64b:5d42:52f4 with SMTP id
 4fb4d7f45d1cf-660a466a6a6mr359374a12.15.1772511271244; Mon, 02 Mar 2026
 20:14:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206012028.3318291-1-gaosong@loongson.cn> <aYVhSp_eGBkpXdp-@pie>
 <df4de374-c5ef-6652-985f-39598e234e35@loongson.cn>
In-Reply-To: <df4de374-c5ef-6652-985f-39598e234e35@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 3 Mar 2026 12:14:34 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6w0hr1byyw6XEfFhR774_jDEeMQW=7omYNm9qnjDHufg@mail.gmail.com>
X-Gm-Features: AaiRm51sVum94D2VetgZyQNifNDhziF_-ggE4pI6Lo6yoqjEYVwcnMAjyXETbqQ
Message-ID: <CAAhV-H6w0hr1byyw6XEfFhR774_jDEeMQW=7omYNm9qnjDHufg@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] LongArch: KVM: Add DMSINTC support irqchip in kernel
To: gaosong <gaosong@loongson.cn>
Cc: Yao Zi <me@ziyao.cc>, maobibo@loongson.cn, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, kernel@xen0n.name, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3291A1E8A8A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72499-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[patchew.org:url,mail.gmail.com:mid,loongson.cn:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 11:54=E2=80=AFAM gaosong <gaosong@loongson.cn> wrote=
:
>
> =E5=9C=A8 2026/2/6 =E4=B8=8A=E5=8D=8811:34, Yao Zi =E5=86=99=E9=81=93:
> > On Fri, Feb 06, 2026 at 09:20:26AM +0800, Song Gao wrote:
> >> Hi,
> >>
> >> This series  implements the DMSINTC in-kernel irqchip device,
> >> enables irqfd to deliver MSI to DMSINTC, and supports injecting MSI in=
terrupts
> >> to the target vCPU.
> >> applied this series.  use netperf test.
> >> VM with one CPU and start netserver, host run netperf.
> >> disable dmsintc
> >> taskset 0x2f  netperf -H 192.168.122.204 -t UDP_RR  -l 36000
> >> Local /Remote
> >> Socket Size   Request  Resp.   Elapsed  Trans.
> >> Send   Recv   Size     Size    Time     Rate
> >> bytes  Bytes  bytes    bytes   secs.    per sec
> >>
> >> 212992 212992 1        1       36000.00   27107.36
> >>
> >> enable dmsintc
> >> Local /Remote
> >> Socket Size   Request  Resp.   Elapsed  Trans.
> >> Send   Recv   Size     Size    Time     Rate
> >> bytes  Bytes  bytes    bytes   secs.    per sec
> >>
> >> 212992 212992 1        1       36000.00   28831.14  (+6.3%)
> >>
> >> v6:
> >>    Fix kvm_device leak in kvm_dmsintc_destroy().
> >>
> >> v5:
> >>    Combine patch2 and patch3
> >>    Add check msgint feature when register DMSINT device.
> >>
> >> V4: Rebase and R-b;
> >>     replace DINTC to DMSINTC.
> >>
> >>
> >> V3: Fix kvm_arch_set_irq_inatomic() missing dmsintc set msi.(patch3)
> >>
> >> V2:
> >> https://patchew.org/linux/20251128091125.2720148-1-gaosong@loongson.cn=
/
> >>
> >> Thanks.
> >> Song Gao
> >>
> >> Song Gao (2):
> >>    LongArch: KVM: Add DMSINTC device support
> >>    LongArch: KVM: Add dmsintc inject msi to the dest vcpu
> > There's a typo in the titles, it should be LoongArch instead of
> > "LongArch".
>
> Hi,   huacai
>
> Should I need send v7 to fix this typo error?
Wait a moment, maybe there are other comments.

Huacai

>
> Thanks.
>
> Song Gao
> >
> > Best regards,
> > Yao Zi
> >
> >
>

