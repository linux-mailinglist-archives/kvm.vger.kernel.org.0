Return-Path: <kvm+bounces-72250-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNDyAMgromk/0gQAu9opvQ
	(envelope-from <kvm+bounces-72250-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:42:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D6231BF147
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 62E81306CE57
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79D13ED126;
	Fri, 27 Feb 2026 23:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QcCofiKl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49C039A803
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235712; cv=pass; b=p+bJYVrHwIotrYeruPzJd+De1SErKSMXdk5qXHt8rjIS3+r4M4q0rUIElQ3Cdcj/odgougwhwYOBhlu0MTEQrnOwCHRsL/fC1WKwx6QMIJe3mDWIuW/8+cMilpQF7NQFRcoEeDSA1w2KFoyzX3iWhfgOaKBUB+CRY7bU5M3u/XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235712; c=relaxed/simple;
	bh=LaCci6f1hU3HLM+nhUMf6uUYL3oj+4Tnw5veCX/70DI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rAmvxQNKIVgwo/4EvpD0vbJIIhjjzG+WssNXvKb0V31ISQT/9t9wGbhA4QorSDBERQPsZpaqgjTUoVM8aScbF5KkYrl/l4MQjXVF5Y+JBSYlJ5Yz0iiRzBrOFx9r5hvSNpXR4XADhtTLIwKbNudSncQG/PLlGVN5DsEoznLy+Ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QcCofiKl; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a355aedfso166741cf.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:41:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772235710; cv=none;
        d=google.com; s=arc-20240605;
        b=hM9M4Nig737QlfsRryhtSb89ikz/YiUlGLEXE9XqBO1YnYiLLijMvzjSEspLLKTj7R
         Pz82MgudVr8UqfuclvSNFsU8ymktJOE0SpAu6Li8gllkCRq6qmN9ELqNwQMRW93eRwhp
         UU3hFvAXPUCsgOOhGXEyn/PULwX4dAolP/eDXQVZrxwXbaA6j/AzWsCXtBQQpshwAXM9
         CJtmAk5Zk9k0C642ZKRu4Fo1uW9RZhZDzjGtaT/AbJ+gdFTGdWz6F0k4u0AOlo2PPRHp
         PeH4DQGLSG6gLw+zQiq5hy0PU11iDigvfsOhQl4diCnMnVHFe1QUfb+BoEsxlaN7mNpO
         bbww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LaCci6f1hU3HLM+nhUMf6uUYL3oj+4Tnw5veCX/70DI=;
        fh=qEz3KXwsFVCPnbOgBPuYplsNRenuN6iZu6c4LInZCUw=;
        b=QmAhx4WA2XS4HtQkXX3duc8wt0O7ARNAuN4hqxkOK3cmQY0IK+xUavFV7HhUVSNUbP
         hy2K1mKcl0cUkuh3KZGOuYC/E2qQ8unKl3w0JQIWHFRMPGoLSJYFFGTDzDgW+xV4XEgL
         O8y37xtaPp1C7rD6YErYK8Tmff5qmZXmlKCb0UHS75jyzqE/eDC/9Uzz91yCm8i5Ighd
         8XfhtGPoFo2FixwxW2ADT1Ei8Lrwz8Pxkzj7RF9vT3u9eEcfR4gSaubAcfmF/OSrB/HY
         1FEBLkuU8nl/EibYJlv0hWn5mV2EtExlHm+2nuWg7nSlmy6fDRzyed7u+MSrpis0yWts
         eYZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235710; x=1772840510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaCci6f1hU3HLM+nhUMf6uUYL3oj+4Tnw5veCX/70DI=;
        b=QcCofiKllMPDNjWDzlthYm0VwJfYYdYJnp3/kLTZjTZIjEaxe+faxqHWsw/FedA3JA
         ++HEeErBr4xRrDOomGWIr2oIpzb5bTK3vKJgfXZNJ3NJ2MM9B9lw6Cr6PpS4EWVUhy2w
         BlIP/MTA4oGebZjWWIc7DmoQZ7wxxdvqZ5k82xjJ/vGJQjHtU8Y/9PAedvZRUol+hivH
         ik9ryVtMNn/niMoU4al8FklFNd0DEw2Hk+oNIB5PSwhmrqKeVXmfCliC027STGrmMS07
         uOPCxNfI6JizeXoR1hxyCeyzVDSFR0GxRHWGfuefoQ5C9i+kS2kbzuvfByau79UuRQSj
         zbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235710; x=1772840510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LaCci6f1hU3HLM+nhUMf6uUYL3oj+4Tnw5veCX/70DI=;
        b=gGlbPp38E9xAjoqe48qx06/Hu0b/1AKrpK3QM5XEs9EQLH1DTNmSS93lYVTnf49eCS
         o9CqEBdFok14MkUIrTsxHeUFREltQvn7s01Ean1hzGqsJuHc7vObfUKxRtmNup49VECb
         5riccPTKjXUTiPteFCGYTsv6oHs0I4U3/rqgo17hAjblMKJ3PTv4MEhc4pKTh487t10M
         0MLcxnimYSXX+XeLhNM4VfCyC0HtrMb9UlQogbQ8EHlntct95KKYNWb/husIH0yrMWaL
         4tneheF0qN7kBQaPUFAFhwU/4C5CPPLRETPU4MNCL4fuJ7jnvYbMcD8kDn8VtLyNV5GQ
         y4GA==
X-Forwarded-Encrypted: i=1; AJvYcCXQrH/yoBvI9rCJEa5EMTLzs8vVKaTMJWW7wykDlnVx/SWb/kUDk1v452RizthTkSKFUEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXHHEEDWaAAQwiYXjGHmbcl+6wYXDR7e4HC9255yC07/R18Kmc
	EXclixb6CLGPi3LcymE22MoM98/hKXtEKvrfOGFTHXPUnM3WIge8FSUjevs5efzWt6gvVDCZX4Q
	bnQauavOhzD+dGPJBn1mTpXMFgywhShVAmKp+gEBHUctBBvFRraRFEEzH
X-Gm-Gg: ATEYQzzqS+jErhxJlPjWAKH0qVZ2uBuWWfxSqhmQS5JDbHRvHw1Zch/3LAR99vWga73
	GsHmpq/Rvt7J/Bpqrm9S6IktxquoFq3KY9SbcJ5WGzlQk/qIeQtJDMoZESOutdQXvlPNefxDhlQ
	LqxLbfBkBQ3DnxdVm0Zf+FxGJCVpauOKCS5VAOt41qsMzlRbTplwWygRk89xENzx0eYGefyTciI
	qkNzSYWWzVEu5sE5Ip7kn3wfN8hqG9q+3PlkjUmjt4NLYM7ZVh5BdgACT8ODjAuM+T/hITeEv/G
	9g/GWjme
X-Received: by 2002:a05:622a:ca:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-5075fea13a4mr2446281cf.16.1772235709503; Fri, 27 Feb 2026
 15:41:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224182532.3914470-1-rananta@google.com> <20260227151958.4aba263e@shazbot.org>
In-Reply-To: <20260227151958.4aba263e@shazbot.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 27 Feb 2026 15:41:37 -0800
X-Gm-Features: AaiRm50aXx3bIjNrqUYRjSSv3AUMLZGaIAdIkXA11EWm5XgyB--oG5KnoZHzG54
Message-ID: <CAJHc60xy5vWx2A5mCXNoZfbt-Pkzd=WbCpw_OkdpBf_vCVwdcw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] vfio: selftest: Add SR-IOV UAPI test
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72250-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,shazbot.org:email]
X-Rspamd-Queue-Id: 9D6231BF147
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 2:20=E2=80=AFPM Alex Williamson <alex@shazbot.org> =
wrote:
> >
> > base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3
>
> Please rebase:
>
> $ git log --oneline --no-merges d721f52e31553a848e0e9947ca15a49c5674aef3.=
.v7.0-rc1 tools/testing/selftests/vfio/a55d4bbbe644 vfio: selftests: only b=
uild tests on arm64 and x86_64
> 1c588bca3bd5 vfio: selftests: Drop IOMMU mapping size assertions for VFIO=
_TYPE1_IOMMU
> 080723f4d4c3 vfio: selftests: Add vfio_dma_mapping_mmio_test
> 557dbdf6c4e9 vfio: selftests: Align BAR mmaps for efficient IOMMU mapping
> 03b7c2d763c9 vfio: selftests: Centralize IOMMU mode name definitions
> 193120dddd1a vfio: selftests: Drop <uapi/linux/types.h> includes
> e6fbd1759c9e selftests: complete kselftest include centralization
>
Rebased to v7.0-rc1 in v5:
https://lore.kernel.org/all/20260227233928.84530-1-rananta@google.com/

Thank you.
Raghavendra

