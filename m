Return-Path: <kvm+bounces-73183-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2N9yDEhhq2mmcgEAu9opvQ
	(envelope-from <kvm+bounces-73183-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:20:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84316228943
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30273305E9AA
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 23:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D37E371D0D;
	Fri,  6 Mar 2026 23:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogYG1B/L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8372F26A0C7
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839225; cv=none; b=nlnCaUBw2Y1t9v51wI6K/zq6J0wr8IB9TSp/c77485fBqy2LmNE5xWSd59HxlI6uU78CyFD6HC+GOQ5zftlGsi5NbwsUfYazimj3KCqZB2hOg+oADcsk2Q/F34sB9A5cn7IvNUpCFFo1aIuMoG+otldmFLlMMbIEIz8IWs4iiLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839225; c=relaxed/simple;
	bh=FrqflCaA3mU2qxZttKPXlxCL2v1HNjlodM+ed8xOAlo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MxOB0euOVYcnV5wOLVzG7QFn2PEm8psuluOH0Wwyr9DE5JNqPVLN1XN0l5wYg9S6eehXZj8E+YNTgZt4lxpbsjulUB9XYsDqA0HQXAL6ktpCZONhrJfhJdzasfYQX43shPBDzYoisAp7YMAL4UwUdvaLU7XaAEBTuLeyZJFyC5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogYG1B/L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAFAC19422
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 23:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772839225;
	bh=FrqflCaA3mU2qxZttKPXlxCL2v1HNjlodM+ed8xOAlo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ogYG1B/L8NFU83naNxMenIKjtwmJgwEe1asQa7zEuaZqc8q/iv4DSu3Huzi42OcfV
	 STwED3x307S1IqhAkkqDE0ghWZRf8rHiCDfG3vIRGL5Lph6mi6RZOR4moNLIEM1+nX
	 n+OZ1i++rSPcUrtxjY675QxSJwfgbfXDNT5b3ezGXk73fOHh1nnYFVCvUK1Tu7Rd0o
	 eC2BM3lmVXYy2E8abfBQXarIn+yh5lHlcv/1dwTypoO17I0i8UB/4mzoxnx70lAozR
	 9s8n+OGccDbx9Pj/smLwWH6QXImct4+/T7vFKKDExGAs3QTIG2MGv+5mwi/8616P3T
	 q4Fj4iat5B6Hg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b942a41c5fcso152282766b.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 15:20:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWwk1fwL1aQDFxXuc3gJiVrfsNE6ex1p8E/nc1LX8NYRhMf0LC/7mX7ji+QUwwBL+h95Ww=@vger.kernel.org
X-Gm-Message-State: AOJu0YycKzhdAuA+eaVTpRhVWUo5YhZza2AO7hPnN8hgwbPzJZ74hC6j
	ng1wzsCQQAPG95xIEs1mMqdAuu1DMRlp5zG4K+Pzk6fMRCL8xlcCRY94FZCbmMMCnhOp06QtiyF
	MkwwHuf1hneWuBOndahuLMNw7bnjzwCg=
X-Received: by 2002:a17:907:8dc3:b0:b87:1741:a484 with SMTP id
 a640c23a62f3a-b942e0f391bmr220360066b.43.1772839224051; Fri, 06 Mar 2026
 15:20:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
 <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com> <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com>
In-Reply-To: <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 15:20:12 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOK5+xmkf3FsWRz2wHcUCN30GJ9kfZx-K7DAa1HNGhRVA@mail.gmail.com>
X-Gm-Features: AaiRm51TQDvKsaAV9yCGBNLOvcIDnaitlF-wU0FWbUGkYhVtp34olkA48CfIrSk
Message-ID: <CAO9r8zOK5+xmkf3FsWRz2wHcUCN30GJ9kfZx-K7DAa1HNGhRVA@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 84316228943
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73183-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.954];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

> > Right, but I am trying to have the #GP check for VMLOAD/VMSAVE behave
> > consistently with vls=1, whether it's done by the hardware or the
> > emulator.
>
> Consistency should not be an issue, since VLS cannot be enabled when
> the MAXPHYADDRs differ. VLS doesn't work in that scenario.

Why? It's only broken if VMLOAD/VMSAVE is executed with a GPA that
exceeds the guest's MAXPHYADDR, but not the host's, right? So only
broken if the guest is misbehaving.

Taking a step back, I am not disagreeing that VLS should not be used
with different MAXPHYADDRs, I am just saying it might be.

All that being said, I am fine with using cpuid_maxphyaddr(vcpu)
instead of kvm_host.maxphyaddr. Will wait for Sean's feedback to
figure out if a new version is needed.

