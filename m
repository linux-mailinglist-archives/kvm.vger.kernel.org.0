Return-Path: <kvm+bounces-1201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 103747E5688
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD20C2815AC
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFFC11CBE;
	Wed,  8 Nov 2023 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="pK3+yyPO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B779DF53;
	Wed,  8 Nov 2023 12:49:24 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4779A1BF4;
	Wed,  8 Nov 2023 04:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699447764; x=1730983764;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hj4kKItmy717X2Mt8TEVpr5/Nab+Gw3L9gWPEgJENgE=;
  b=pK3+yyPOY/zVLO82K+Umqv3Uz/rde3jsZKg67myyymfZCTJvwCpdss93
   n2uLcejSYIuuIbAYet+pMql9rAU8FN86/eyrFB1ECHIlizZaedzP2XQ3r
   fbHrtrzq1A+XOriXU9O9NtSeZpaPufMVZHasjGMnQGIWfJ4enMb1lYSJ+
   E=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="164975405"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:49:22 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id 7C2868052F;
	Wed,  8 Nov 2023 12:49:19 +0000 (UTC)
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:1753]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.225:2525] with esmtp (Farcaster)
 id 964dc4eb-de72-4eec-8c95-e76cdf299137; Wed, 8 Nov 2023 12:49:18 +0000 (UTC)
X-Farcaster-Flow-ID: 964dc4eb-de72-4eec-8c95-e76cdf299137
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 12:49:18 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 12:49:14 +0000
Message-ID: <5ac466d6-ea71-472d-a09b-5bd54e88a398@amazon.com>
Date: Wed, 8 Nov 2023 13:49:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 32/33] KVM: x86: hyper-v: Implement
 HVCALL_TRANSLATE_VIRTUAL_ADDRESS
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-33-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-33-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE4LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IEludHJv
ZHVjZSBIVkNBTExfVFJBTlNMQVRFX1ZJUlRVQUxfQUREUkVTUywgdGhlIGh5cGVyY2FsbCByZWNl
aXZlcyBhCj4gR1ZBLCBnZW5lcmFsbHkgZnJvbSBhIGxlc3MgcHJpdmlsZWdlZCBWVEwsIGFuZCBy
ZXR1cm5zIHRoZSBHUEEgYmFja2luZwo+IGl0LiBUaGUgR1ZBIC0+IEdQQSBjb252ZXJzaW9uIGlz
IGRvbmUgYnkgd2Fsa2luZyB0aGUgdGFyZ2V0IFZUTCdzIHZDUFUKPiBNTVUuCj4KPiBOT1RFOiBU
aGUgaHlwZXJjYWxsIGltcGxlbWVudGF0aW9uIGlzIGluY29tcGxldGUgYW5kIG9ubHkgc2hhcmVk
IGZvcgo+IGNvbXBsZXRpb24uIEFkZGl0aW9uYWxseSB3ZSdkIGxpa2UgdG8gbW92ZSB0aGUgVlRM
IGF3YXJlIHBhcnRzIHRvCj4gdXNlci1zcGFjZS4KCgpZZXMsIHBsZWFzZSA6KS4gV2Ugc2hvdWxk
IGhhbmRsZSB0aGUgY29tcGxldGUgaHlwZXJjYWxsIGluIHVzZXIgc3BhY2UgaWYgCnBvc3NpYmxl
LiBJZiB5b3UncmUgYWZyYWlkIHRoYXQgZ3ZhIC0+IGdwYSBjb252ZXJzaW9uIG1heSBydW4gb3V0
IG9mIApzeW5jIGJldHdlZW4gYSB1c2VyIHNwYWNlIGFuZCB0aGUga3ZtIGltcGxlbWVudGF0aW9u
cywgbGV0J3MgaW50cm9kdWNlIAphbiBpb2N0bCB0aGF0IGFsbG93cyB5b3UgdG8gcGVyZm9ybSB0
aGF0IGNvbnZlcnNpb24uCgoKQWxleAoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJt
YW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzog
Q2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dl
cmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3Qt
SUQ6IERFIDI4OSAyMzcgODc5CgoK


