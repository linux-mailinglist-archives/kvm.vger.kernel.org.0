Return-Path: <kvm+bounces-73185-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YB3hNzdnq2kfcwEAu9opvQ
	(envelope-from <kvm+bounces-73185-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:45:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79211228D45
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31923303639B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 23:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF38A38F22C;
	Fri,  6 Mar 2026 23:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QifiXDk7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7495358377
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 23:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772840738; cv=pass; b=KuS79Yb2WfB2YYw+9WE0YCSh6XRF1G50gABclZhwQlF7LlOQaRknxc1vsJOJCIRTMZlmcF5vsMqpV1auLTxvrJauBZsK2LiCndJ+nMCWrw4ekIJ4qdNeheZmS4vi2ojnWPoz2Dr88MeouMdQtR1VM4f/JwdnshaDOB1CpvzRvzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772840738; c=relaxed/simple;
	bh=GJtBB9cbQADjutlg1/84ZCAeyk/fDQtRv94VxILrjkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DvbSO9HU1qtgpW48XJeZ5Pcb/n8yHMgADkDYyC6sZioouYSwBJIhU/Fe/XvK7JvlnWUt1N67fBB3rx2VgI/P0UAAdb2Tg2SvzpRUTCdQ9wv/H8UexldLuArtOYO5coeTVZWQuTL2+UM1/9gWOJ4S5pGaVHWNwrbKqF2YmIaHc48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QifiXDk7; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so1902a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 15:45:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772840735; cv=none;
        d=google.com; s=arc-20240605;
        b=J3dAFDync7gB2R6lH/WqQtDX2OSRh0/FZfPfw1v+STIjGMjdQNqMl4kD6zKJU9n0rl
         gJY2R3fvfx4BEn/aQdRt6TDn7WMS6TJVWh7gK4C8TGpH8k++WOJV2uctiHJIT9LeLXf4
         MHbjiFiZ94yIHPszDASS2NrPnOVULbB415lwVqxBCvQfWYqoqcq0ksCm8XWwCviIx7U0
         WE/UZcCoxj5k+cdKA2zB6mc1G00KCwnJBdyR4segkuRJbywOeBOL8nLkb5hnNp0/vu0r
         Zk2eWTtkHkOBpOCG9SHVYf1dBhNZOtX8KTlLXheeAhnHVfQBKcQvTu+08SR89b9uGJTl
         b6GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GJtBB9cbQADjutlg1/84ZCAeyk/fDQtRv94VxILrjkc=;
        fh=czHwFJ9lfJkj4DKwNM9RIuRAp12F9Fg+2Gfqn2qZ7bg=;
        b=IuYiw5MvmEHmEI5z2t16UqrV/yGoUVwkkltQ2XQrTt4rxAw7o1RvDRHar6Hsl9Yes7
         4iDapfbwCPaOT7cpW/3i8yVOyMnkSb0qVG0PZMx6x8zOaf/eDkpJUUt5gEnCxqqCffz6
         xh7JDcL5x6ndqZR0K1zdUWeRoMUSs28AqreWh44SCwgmXghSG/jPDl4ydHLE3SWldguS
         6qbRUVzqI+bpRu3MCTHp9+MFYqlVgN+RvUSYMShwkqH3X8q7ItUqNNT7XpJKOF9ARyIo
         fPwT2ccohabBrycUaLDMOubpuiEWpSWRD5zh7kcmxxNJpBxyGMWclXD6GDdRwo+bdx4N
         WL4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772840735; x=1773445535; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJtBB9cbQADjutlg1/84ZCAeyk/fDQtRv94VxILrjkc=;
        b=QifiXDk78JP3ncau1n7FjamvTnyiPlVxjBX8DA8uaXB4uvRQxrig0ZEJT0bko0ciFz
         AKv+C4NtV27O9fJPGVmiA5OOpoLJa2A1v5kW0qp9gyNLe8PeyqK4BruXLyOv0lidYV4N
         WeXdlD5V1sGatKVPMHinjBY/M0EXYz3OM4b0VX2bUvzYUnXxDoPJPlJB0aPSFJC0zupW
         TNkunCmoNBzLpCLlGLWPh3LMkgqgeBD/uOPVrkXATlttgjWtWRpKukAizfjSlhXFDWug
         pSX5wpxjK1eZlSoRoYdEgbNuf2C4eCGBBwZe5jnt2jpMezTEXGELOvqkl2mFBO/4S0J1
         p+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772840735; x=1773445535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GJtBB9cbQADjutlg1/84ZCAeyk/fDQtRv94VxILrjkc=;
        b=HCA+82sVoBg3tnQ8ZJ4jTc6cwUh/MFfjYmhH5ubU2GG2fj2C0ktbHiEBrjEciWWo0A
         UwagJSnnicO/oYF9IYkONnDvmXXLqcTIZMVY5LJS/fV302xrYR5QRwota0JXo+gQ9Q3h
         ppAPEccQhhsMLb2qrwvqDqi0QTzlOI07wLfnHBZLJS9eNY8r5oywmWgAjATuIlS5/Ing
         CYK04uj8OL/vw/HNtpPwFQF/Kdd1fzgPFuf3f2rBlxsoIxmgdFHl7bS+eXS18uockjek
         MIU6KNwcQVd5Uy5jaG8mgT/JIAhu7LGoIB9uPNoCUJwyHBeuN9LGcLl7WzTsf4hZDgtr
         Yvww==
X-Forwarded-Encrypted: i=1; AJvYcCWjXvM4qKTKHXb5nl1Is6WJAgtOxtYC9iEbJmOLzPxGXRZ1BUdXSuCywWSEwPucrml+uiU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8GV+t4IAfCdm1tU9jYfRArGspOqDYyquY9w4ZhOCylYe1UIO7
	fsykuaTeBr9wcxvX0b0ZkOFH95X1euTuCVbeQ2H95VGyb/55wL8yfzoghTljqDXq42C6adcm/As
	WxiPEab22G4qwZf2yayZrCsx2K9ejO1H2nQdCszfM
X-Gm-Gg: ATEYQzxbxmx7UjHmdz2n3DMeL3r15mlh0P9qFy3BD9NpINQTlNgO6z0418a8YYSs3cX
	VZFl5eQJE4I3aOgjJZQ3MjBBrgsfTRH40TXf8Rf31VEQqIERML3Igdw6H6l3Be73DTvaa2P5BOI
	qWxeT5u6SIwzrq+miGG5H4CYEq+YRFyvxTMuTmrgxS5bCBQNuiLmn6kgx2Cdduw5a8jR1yoh9uQ
	qPcqqgqY4KDjl21HOjzJzAQrxsyMolkWqL8t66a4DuWPz6ENE5P8nS3pt9My1EB/ojGnrpk/Ast
	WmL9NYg=
X-Received: by 2002:aa7:c245:0:b0:660:ce96:cd8d with SMTP id
 4fb4d7f45d1cf-661e70e9f6emr9285a12.2.1772840734706; Fri, 06 Mar 2026 15:45:34
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
 <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
 <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com> <CAO9r8zOK5+xmkf3FsWRz2wHcUCN30GJ9kfZx-K7DAa1HNGhRVA@mail.gmail.com>
In-Reply-To: <CAO9r8zOK5+xmkf3FsWRz2wHcUCN30GJ9kfZx-K7DAa1HNGhRVA@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 15:45:22 -0800
X-Gm-Features: AaiRm50abE4bbOMdoY75xPHADuVduiO8lygtoerodZLT3KKWu_82xp2UdXcy8Dk
Message-ID: <CALMp9eRZy78fc=8_NtGTeYYX8EU-VEKkSMG=oibTijKC8ANJWQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 79211228D45
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
	TAGGED_FROM(0.00)[bounces-73185-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.957];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 3:20=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > > Right, but I am trying to have the #GP check for VMLOAD/VMSAVE behave
> > > consistently with vls=3D1, whether it's done by the hardware or the
> > > emulator.
> >
> > Consistency should not be an issue, since VLS cannot be enabled when
> > the MAXPHYADDRs differ. VLS doesn't work in that scenario.
>
> Why? It's only broken if VMLOAD/VMSAVE is executed with a GPA that
> exceeds the guest's MAXPHYADDR, but not the host's, right? So only
> broken if the guest is misbehaving.

"Misbehaving" is a tad pejorative. Faulting behavior is part of the
architectural specification. A less biased assessment is that VLS is
partially correct when the MAXPHYADDRs don't match.

People thought it was a big deal when FDIV produced incorrect results
one out of 10 billion times.

> Taking a step back, I am not disagreeing that VLS should not be used
> with different MAXPHYADDRs, I am just saying it might be.

That would be wrong.

