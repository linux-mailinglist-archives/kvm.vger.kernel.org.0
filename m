Return-Path: <kvm+bounces-1202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A47D7E5803
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 14:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25A591C20B18
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080B219479;
	Wed,  8 Nov 2023 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="DDJ9ZTYp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1541945E;
	Wed,  8 Nov 2023 13:38:54 +0000 (UTC)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1C319A3;
	Wed,  8 Nov 2023 05:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699450734; x=1730986734;
  h=mime-version:content-transfer-encoding:date:message-id:
   cc:subject:from:to:references:in-reply-to;
  bh=a5e6wNSZiK4JDaQiFEGl7KqwDS/i2MZnnQlv70olvvw=;
  b=DDJ9ZTYpl1Jp+Z+H4cxBqp9Us4sf069NMFkLVioISsQgWLN/kuAdZxUh
   AHkrXUGzZQXP+hNRl9Z5NEdMCfjJ4YHBROrpVTEO7M3LHfmwCIZywpqdb
   nmFYfHz2wPZoi1clP5nWFFU1aOrqNYUUki7/IfwTEKDXI09aeE4YPy8L2
   g=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="312105881"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 13:38:47 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id 3A796A0F26;
	Wed,  8 Nov 2023 13:38:45 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:6240]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.103:2525] with esmtp (Farcaster)
 id 0325e4a2-3eaf-4ce9-95af-c1bca8ed9983; Wed, 8 Nov 2023 13:38:43 +0000 (UTC)
X-Farcaster-Flow-ID: 0325e4a2-3eaf-4ce9-95af-c1bca8ed9983
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 13:38:43 +0000
Received: from localhost (10.13.235.138) by EX19D004EUC001.ant.amazon.com
 (10.252.51.190) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 13:38:38 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 8 Nov 2023 13:38:35 +0000
Message-ID: <CWTH00RO3SCI.31S210JQ8XP8J@amazon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
Subject: Re: [RFC 30/33] KVM: x86: hyper-v: Introduce
 KVM_REQ_HV_INJECT_INTERCEPT request
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: Alexander Graf <graf@amazon.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.15.2-182-g389d89a9362e-dirty
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-31-nsaenz@amazon.com>
 <c1e85d8a-7f59-4c75-ada1-8a80d79c2b4e@amazon.com>
In-Reply-To: <c1e85d8a-7f59-4c75-ada1-8a80d79c2b4e@amazon.com>
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

On Wed Nov 8, 2023 at 12:45 PM UTC, Alexander Graf wrote:
>
> On 08.11.23 12:18, Nicolas Saenz Julienne wrote:
> > Introduce a new request type, KVM_REQ_HV_INJECT_INTERCEPT which allows
> > injecting out-of-band Hyper-V secure intercepts. For now only memory
> > access intercepts are supported. These are triggered when access a GPA
> > protected by a higher VTL. The memory intercept metadata is filled base=
d
> > on the GPA provided through struct kvm_vcpu_hv_intercept_info, and
> > injected into the guest through SynIC message.
> >
> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
>
>
> IMHO memory protection violations should result in a user space exit.=20

It already does, it's not very explicit from the patch itself, since the
functionality was introduced in through the "KVM: guest_memfd() and
per-page attributes" series [1].

See this snippet in patch #27:

+	if (kvm_hv_vsm_enabled(vcpu->kvm)) {
+		if (kvm_hv_faultin_pfn(vcpu, fault)) {
+			kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+			return -EFAULT;
+		}
+	}

Otherwise the doc in patch #33 also mentions this. :)

> User space can then validate what to do with the violation and if=20
> necessary inject an intercept.

I do agree that secure intercept injection should be moved into to
user-space, and happen as a reaction to a user-space memory fault exit.
I was unable to do so yet, since the intercepts require a level of
introspection that is not yet available to QEMU. For example, providing
the length of the instruction that caused the fault. I'll work on
exposing the necessary information to user-space and move the whole
intercept concept there.

Nicolas

[1] https://lore.kernel.org/lkml/20231105163040.14904-1-pbonzini@redhat.com=
/.

