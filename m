Return-Path: <kvm+bounces-1499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AC47E822F
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 20:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 064871F20F14
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 19:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CDE93AC2D;
	Fri, 10 Nov 2023 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="czq1qkBS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BA238DC8;
	Fri, 10 Nov 2023 19:04:35 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D918B2B793;
	Fri, 10 Nov 2023 11:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699643075; x=1731179075;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:from:to:references:in-reply-to:subject;
  bh=L3s6MCb/ddOZq92pe5PVKstKWmwAub27mVyvpvCtbZM=;
  b=czq1qkBSGIathm+YSbtfFkRjXOrdy4dS3v5oVWs3LJ6MREFCyPFTkN9f
   N9xB5v1qiZ9kcwkHLo4iVtwje/29zu3YOpSJCOd+2rDj1cL4+mlFmSQ/x
   4CV7eJW56XuSyO+LeIDQPw6hE3P3xbQNAxqhvo6a0OBEe6HKDhsbwpjT9
   c=;
X-IronPort-AV: E=Sophos;i="6.03,291,1694736000"; 
   d="scan'208";a="615422768"
Subject: Re: [RFC 0/33] KVM: x86: hyperv: Introduce VSM support
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 19:04:31 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 6F6E740BBD;
	Fri, 10 Nov 2023 19:04:29 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:47554]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id e5367148-3541-4113-bfc2-60c97d59a71c; Fri, 10 Nov 2023 19:04:28 +0000 (UTC)
X-Farcaster-Flow-ID: e5367148-3541-4113-bfc2-60c97d59a71c
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Fri, 10 Nov 2023 19:04:28 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Fri, 10 Nov
 2023 19:04:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Nov 2023 19:04:20 +0000
Message-ID: <CWVD6IUUDJ1H.27RK4NIBUTSD6@amazon.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <ZUu9lwJHasi2vKGg@google.com>
In-Reply-To: <ZUu9lwJHasi2vKGg@google.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D036UWB004.ant.amazon.com (10.13.139.170) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 4:55 PM UTC, Sean Christopherson wrote:
> > This RFC series introduces the necessary infrastructure to emulate VSM
> > enabled guests. It is a snapshot of the progress we made so far, and it=
s
> > main goal is to gather design feedback.
>
> Heh, then please provide an overview of the design, and ideally context a=
nd/or
> justification for various design decisions.  It doesn't need to be a prop=
er design
> doc, and you can certainly point at other documentation for explaining VS=
M/VTLs,
> but a few paragraphs and/or verbose bullet points would go a long way.
>
> The documentation in patch 33 provides an explanation of VSM itself, and =
a little
> insight into how userspace can utilize the KVM implementation.  But the d=
ocumentation
> provides no explanation of the mechanics that KVM *developers* care about=
, e.g.
> the use of memory attributes, how memory attributes are enforced, whether=
 or not
> an in-kernel local APIC is required, etc.

Noted, I'll provide a design review on the next submission.

> Nor does the documentation explain *why*, e.g. why store a separate set o=
f memory
> attributes per VTL "device", which by the by is broken and unnecessary.

It's clear to me how the current implementation of VTL devices is
broken. But unncessary? That made me think we could inject the VTL In
the memory attribute key, for ex. with 'gfn | vtl << 58'. And then use
generic API and a single xarray.

Nicolas

