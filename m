Return-Path: <kvm+bounces-1207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DCD7E595E
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C56B21C20B64
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 14:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2345A34577;
	Wed,  8 Nov 2023 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="SCmW0XVj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ADB815;
	Wed,  8 Nov 2023 14:42:06 +0000 (UTC)
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF20E172E;
	Wed,  8 Nov 2023 06:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699454526; x=1730990526;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:subject:from:to:references:in-reply-to;
  bh=m5j5x7nNAFVyRYtdkX1gMrUVJ3IBvqYpFYgMswAfYXw=;
  b=SCmW0XVjef4+FFJ7VSHSAXoQZINhQwriry2rzIDhgxiv9wJFPbV4PRnL
   V0BwBluHWYkfkkjnJNyJ2L6gg7mOmp8fqlw7MiXmh62OkSHgOVd5Mar6J
   zml/+KgWVeyrFSAqsiuLrhZqMr6gS4tsWRGNgQY8QXIDQzgBYQMQy9uFL
   Q=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="593847629"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 14:42:03 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 0A99C8049A;
	Wed,  8 Nov 2023 14:42:00 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:56026]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.222:2525] with esmtp (Farcaster)
 id e7c875e3-d454-4710-a698-3611a062b2a8; Wed, 8 Nov 2023 14:41:59 +0000 (UTC)
X-Farcaster-Flow-ID: e7c875e3-d454-4710-a698-3611a062b2a8
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 14:41:59 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 14:41:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 8 Nov 2023 14:41:51 +0000
Message-ID: <CWTICGO95L4K.2DL1G1DZ9EW3H@amazon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<kys@microsoft.com>, <haiyangz@microsoft.com>, <decui@microsoft.com>,
	<x86@kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [RFC 0/33] KVM: x86: hyperv: Introduce VSM support
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Alexander Graf <graf@amazon.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <a8da9071-68ee-42e6-810a-eac95aff317d@amazon.com>
In-Reply-To: <a8da9071-68ee-42e6-810a-eac95aff317d@amazon.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D037UWC001.ant.amazon.com (10.13.139.197) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 11:40 AM UTC, Alexander Graf wrote:
> Hey Nicolas,

[...]

> > The series is accompanied by two repositories:
> >   - A PoC QEMU implementation of VSM [3].
> >   - VSM kvm-unit-tests [4].
> >
> > Note that this isn't a full VSM implementation. For now it only support=
s
> > 2 VTLs, and only runs on uniprocessor guests. It is capable of booting
> > Windows Sever 2016/2019, but is unstable during runtime.
>
> How much of these limitations are inherent in the current set of=20
> patches? What is missing to go beyond 2 VTLs and into SMP land? Anything=
=20
> that will require API changes?

The main KVM concepts introduced by this series are ready to deal with
any number of VTLs (APIC ID groups, VTL KVM device).

KVM_HV_GET_VSM_STATE should provide a copy of 'vsm_code_page_offsets'
per-VTL, since the hypercall page is partition wide but per-VTL.
Attaching that information as a VTL KVM device attribute fits that
requirement nicely. I'd prefer going that way especially if the VTL KVM
device has a decent reception. Also, the secure memory intecepts and
HVCALL_TRANSLATE_VIRTUAL_ADDRESS take some VTL related shortcuts, but
those are going away. Otherwise, I don't see any necessary in-kernel
changes.

When virtualizing Windows with VSM I've never seen usages that go beyond
VTL1. So enabling VTL > 1 will be mostly a kvm-unit-tests effort. As for
SMP, it just a matter of work. Notably HvStartVirtualProcessor and
HvGetVpIndexFromApicId need to be implemented, and making sure the QEMU
VTL scheduling code holds up.

Nicolas

