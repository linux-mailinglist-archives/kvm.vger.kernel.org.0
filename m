Return-Path: <kvm+bounces-1188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B87117E55B2
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A4A1C20B04
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B49A168CD;
	Wed,  8 Nov 2023 11:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="fwF4aqSp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7A315EB2;
	Wed,  8 Nov 2023 11:40:11 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615921988;
	Wed,  8 Nov 2023 03:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699443611; x=1730979611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0Jgcv6m+dF2aXJkYUEQ0LNm7BqJp5LjYq5iFq0Bblbs=;
  b=fwF4aqSpl+cS0BFVkskMh0GRemTUK/H1egaYQbN9Dh1FZi/vzAcgsqHx
   FP3YZfVaORPFVI25KGibIpBduQ+7ysFNsUIEnqjave+W88658drRY79gv
   wtpMnDenKt5vDrSGeX0ABmue1FG+RrxcPceXMavxFJin4gvB/ZWQRfDur
   4=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="42023927"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:40:09 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 2273140D96;
	Wed,  8 Nov 2023 11:40:09 +0000 (UTC)
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:13613]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.241:2525] with esmtp (Farcaster)
 id 4d944fab-ae9e-4c2a-a996-73171ba7a68a; Wed, 8 Nov 2023 11:40:08 +0000 (UTC)
X-Farcaster-Flow-ID: 4d944fab-ae9e-4c2a-a996-73171ba7a68a
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:40:08 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Wed, 8 Nov
 2023 11:40:05 +0000
Message-ID: <a8da9071-68ee-42e6-810a-eac95aff317d@amazon.com>
Date: Wed, 8 Nov 2023 12:40:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/33] KVM: x86: hyperv: Introduce VSM support
Content-Language: en-US
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <dwmw@amazon.co.uk>, <jgowans@amazon.com>,
	<corbert@lwn.net>, <kys@microsoft.com>, <haiyangz@microsoft.com>,
	<decui@microsoft.com>, <x86@kernel.org>, <linux-doc@vger.kernel.org>
References: <20231108111806.92604-1-nsaenz@amazon.com>
From: Alexander Graf <graf@amazon.com>
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D040UWB001.ant.amazon.com (10.13.138.82) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64

SGV5IE5pY29sYXMsCgpPbiAwOC4xMS4yMyAxMjoxNywgTmljb2xhcyBTYWVueiBKdWxpZW5uZSB3
cm90ZToKPiBIeXBlci1WJ3MgVmlydHVhbCBTZWN1cmUgTW9kZSAoVlNNKSBpcyBhIHZpcnR1YWxp
c2F0aW9uIHNlY3VyaXR5IGZlYXR1cmUKPiB0aGF0IGxldmVyYWdlcyB0aGUgaHlwZXJ2aXNvciB0
byBjcmVhdGUgc2VjdXJlIGV4ZWN1dGlvbiBlbnZpcm9ubWVudHMKPiB3aXRoaW4gYSBndWVzdC4g
VlNNIGlzIGRvY3VtZW50ZWQgYXMgcGFydCBvZiBNaWNyb3NvZnQncyBIeXBlcnZpc29yIFRvcAo+
IExldmVsIEZ1bmN0aW9uYWwgU3BlY2lmaWNhdGlvbiBbMV0uIFNlY3VyaXR5IGZlYXR1cmVzIHRo
YXQgYnVpbGQgdXBvbgo+IFZTTSwgbGlrZSBXaW5kb3dzIENyZWRlbnRpYWwgR3VhcmQsIGFyZSBl
bmFibGVkIGJ5IGRlZmF1bHQgb24gV2luZG93cyAxMSwKPiBhbmQgYXJlIGJlY29taW5nIGEgcHJl
cmVxdWlzaXRlIGluIHNvbWUgaW5kdXN0cmllcy4KPgo+IFRoaXMgUkZDIHNlcmllcyBpbnRyb2R1
Y2VzIHRoZSBuZWNlc3NhcnkgaW5mcmFzdHJ1Y3R1cmUgdG8gZW11bGF0ZSBWU00KPiBlbmFibGVk
IGd1ZXN0cy4gSXQgaXMgYSBzbmFwc2hvdCBvZiB0aGUgcHJvZ3Jlc3Mgd2UgbWFkZSBzbyBmYXIs
IGFuZCBpdHMKPiBtYWluIGdvYWwgaXMgdG8gZ2F0aGVyIGRlc2lnbiBmZWVkYmFjay4gU3BlY2lm
aWNhbGx5IG9uIHRoZSBLVk0gQVBJcyB3ZQo+IGludHJvZHVjZS4gRm9yIGEgaGlnaCBsZXZlbCBk
ZXNpZ24gb3ZlcnZpZXcsIHNlZSB0aGUgZG9jdW1lbnRhdGlvbiBpbgo+IHBhdGNoIDMzLgo+Cj4g
QWRkaXRpb25hbGx5LCB0aGlzIHRvcGljIHdpbGwgYmUgZGlzY3Vzc2VkIGFzIHBhcnQgb2YgdGhl
IEtWTQo+IE1pY3JvLWNvbmZlcmVuY2UsIGluIHRoaXMgeWVhcidzIExpbnV4IFBsdW1iZXJzIENv
bmZlcmVuY2UgWzJdLgoKCkF3ZXNvbWUsIGxvb2tpbmcgZm9yd2FyZCB0byB0aGUgc2Vzc2lvbiEg
OikKCgo+IFRoZSBzZXJpZXMgaXMgYWNjb21wYW5pZWQgYnkgdHdvIHJlcG9zaXRvcmllczoKPiAg
IC0gQSBQb0MgUUVNVSBpbXBsZW1lbnRhdGlvbiBvZiBWU00gWzNdLgo+ICAgLSBWU00ga3ZtLXVu
aXQtdGVzdHMgWzRdLgo+Cj4gTm90ZSB0aGF0IHRoaXMgaXNuJ3QgYSBmdWxsIFZTTSBpbXBsZW1l
bnRhdGlvbi4gRm9yIG5vdyBpdCBvbmx5IHN1cHBvcnRzCj4gMiBWVExzLCBhbmQgb25seSBydW5z
IG9uIHVuaXByb2Nlc3NvciBndWVzdHMuIEl0IGlzIGNhcGFibGUgb2YgYm9vdGluZwo+IFdpbmRv
d3MgU2V2ZXIgMjAxNi8yMDE5LCBidXQgaXMgdW5zdGFibGUgZHVyaW5nIHJ1bnRpbWUuCgoKSG93
IG11Y2ggb2YgdGhlc2UgbGltaXRhdGlvbnMgYXJlIGluaGVyZW50IGluIHRoZSBjdXJyZW50IHNl
dCBvZiAKcGF0Y2hlcz8gV2hhdCBpcyBtaXNzaW5nIHRvIGdvIGJleW9uZCAyIFZUTHMgYW5kIGlu
dG8gU01QIGxhbmQ/IEFueXRoaW5nIAp0aGF0IHdpbGwgcmVxdWlyZSBBUEkgY2hhbmdlcz8KCgpB
bGV4CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3Ry
LiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2Vy
LCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVy
ZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkK
Cgo=


