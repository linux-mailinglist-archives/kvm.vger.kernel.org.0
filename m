Return-Path: <kvm+bounces-1200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B247E5683
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 13:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B05028146F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F347F11CBE;
	Wed,  8 Nov 2023 12:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="LxkkFqJ1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8278563C1;
	Wed,  8 Nov 2023 12:46:09 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825861BF2;
	Wed,  8 Nov 2023 04:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699447569; x=1730983569;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IMs3Jzbr/vq41dM8w9vnjLZzo+zDotJHPcWCxMB6uUE=;
  b=LxkkFqJ1WYK3Zf0f4L/7l6orz0EObPwspi+16hv4GvE5Y3oUKrkiqPy9
   kpMeI7TUCACbzUq5QX1n/69n+ffyRHwVxzn2RzUcC2alMQTnJ5wZKkqsQ
   BEP8/90wEn3pq8opgwX5/VjWUmOh8lTFRzmfsOIvMiFifT4JSRK7+QOwu
   o=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="369131464"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 12:45:58 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id A4E6880E33;
	Wed,  8 Nov 2023 12:45:54 +0000 (UTC)
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:19714]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.134:2525] with esmtp (Farcaster)
 id e7d7ba6d-66b4-4fac-9ac6-77ed28c7a2e1; Wed, 8 Nov 2023 12:45:53 +0000 (UTC)
X-Farcaster-Flow-ID: e7d7ba6d-66b4-4fac-9ac6-77ed28c7a2e1
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 12:45:44 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 12:45:40 +0000
Message-ID: <c1e85d8a-7f59-4c75-ada1-8a80d79c2b4e@amazon.com>
Date: Wed, 8 Nov 2023 13:45:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 30/33] KVM: x86: hyper-v: Introduce
 KVM_REQ_HV_INJECT_INTERCEPT request
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
 <20231108111806.92604-31-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-31-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D041UWA002.ant.amazon.com (10.13.139.121) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

Ck9uIDA4LjExLjIzIDEyOjE4LCBOaWNvbGFzIFNhZW56IEp1bGllbm5lIHdyb3RlOgo+IEludHJv
ZHVjZSBhIG5ldyByZXF1ZXN0IHR5cGUsIEtWTV9SRVFfSFZfSU5KRUNUX0lOVEVSQ0VQVCB3aGlj
aCBhbGxvd3MKPiBpbmplY3Rpbmcgb3V0LW9mLWJhbmQgSHlwZXItViBzZWN1cmUgaW50ZXJjZXB0
cy4gRm9yIG5vdyBvbmx5IG1lbW9yeQo+IGFjY2VzcyBpbnRlcmNlcHRzIGFyZSBzdXBwb3J0ZWQu
IFRoZXNlIGFyZSB0cmlnZ2VyZWQgd2hlbiBhY2Nlc3MgYSBHUEEKPiBwcm90ZWN0ZWQgYnkgYSBo
aWdoZXIgVlRMLiBUaGUgbWVtb3J5IGludGVyY2VwdCBtZXRhZGF0YSBpcyBmaWxsZWQgYmFzZWQK
PiBvbiB0aGUgR1BBIHByb3ZpZGVkIHRocm91Z2ggc3RydWN0IGt2bV92Y3B1X2h2X2ludGVyY2Vw
dF9pbmZvLCBhbmQKPiBpbmplY3RlZCBpbnRvIHRoZSBndWVzdCB0aHJvdWdoIFN5bklDIG1lc3Nh
Z2UuCj4KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIFNhZW56IEp1bGllbm5lIDxuc2FlbnpAYW1h
em9uLmNvbT4KCgpJTUhPIG1lbW9yeSBwcm90ZWN0aW9uIHZpb2xhdGlvbnMgc2hvdWxkIHJlc3Vs
dCBpbiBhIHVzZXIgc3BhY2UgZXhpdC4gClVzZXIgc3BhY2UgY2FuIHRoZW4gdmFsaWRhdGUgd2hh
dCB0byBkbyB3aXRoIHRoZSB2aW9sYXRpb24gYW5kIGlmIApuZWNlc3NhcnkgaW5qZWN0IGFuIGlu
dGVyY2VwdC4KClRoYXQgbWVhbnMgZnJvbSBhbiBBUEkgcG9pbnQgb2YgdmlldywgeW91IHdhbnQg
YSBuZXcgZXhpdCByZWFzb24gCih2aW9sYXRpb24pIGFuZCBhbiBpb2N0bCB0aGF0IGFsbG93cyB5
b3UgdG8gdHJhbnNtaXQgdGhlIHZpb2xhdGluZyBDUFUgCnN0YXRlIGludG8gdGhlIHRhcmdldCB2
Q1BVLiBJIGRvbid0IHRoaW5rIHRoZSBpbmplY3Rpb24gc2hvdWxkIGV2ZW4ga25vdyAKdGhhdCB0
aGUgc291cmNlIG9mIGRhdGEgZm9yIHRoZSB2aW9sYXRpb24gd2FzIGEgdkNQVS4KCgoKQWxleAoK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgK
MTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9u
YXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50
ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK


