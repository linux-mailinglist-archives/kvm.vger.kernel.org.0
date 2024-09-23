Return-Path: <kvm+bounces-27300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F4C97EA90
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 13:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B09B1F21C81
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 11:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA476198A0D;
	Mon, 23 Sep 2024 11:17:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D028193425
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 11:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727090261; cv=none; b=ZT+kNrgYtGr/G+eEYFQTS/so3EcnlX3CNFUlCpOwmp+rhu8+8+IzVWv7bz6RS9Df0NJHnld70az12zYYBzgYMhebZ6/MDcrmIH6zUUQJGrezb3Vh5MNgps8Ck4wY4kabnTbdO/IdxnMf0TDa93tN+2JbGJb9X7XOQDSe974Emd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727090261; c=relaxed/simple;
	bh=haF89THumj34ISphY5bF8K/60e93FNC5wK1Q4Rv7yJ0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=iCJnq+ZZ8t2O9YdBeFc+86ngOTgtMDsqZgkSSGBNHZ3Jfs9xDE9HmZNuiZRf0LZxQ/P03YhqVUFPMnoWyjrOMQnK+Vrun3fZqo90XXoVoY+0/LfjQ3oaEyCqV1LvIiiw5amBd7h+jYsojhBDU0nQid3zrf8NyUWtyDN7CCmWNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-78-2HWEI-iCP3Slj4pwHrzwtw-1; Mon, 23 Sep 2024 12:17:29 +0100
X-MC-Unique: 2HWEI-iCP3Slj4pwHrzwtw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 23 Sep
 2024 12:16:34 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Mon, 23 Sep 2024 12:16:34 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: 'Vitaly Kuznetsov' <vkuznets@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>
CC: Jan Richter <jarichte@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
Thread-Topic: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
Thread-Index: AQHbC3Pl9P3vlAEDCEWIcS9mz1FdzrJlOyxw
Date: Mon, 23 Sep 2024 11:16:34 +0000
Message-ID: <2a62086810c14d0e88e38706a06aedde@AcuMS.aculab.com>
References: <20240920154422.2890096-1-vkuznets@redhat.com>
In-Reply-To: <20240920154422.2890096-1-vkuznets@redhat.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Sent: 20 September 2024 16:44
>=20
> Some distros switched gcc to '-march=3Dx86-64-v3' by default and while it=
's
> hard to find a CPU which doesn't support it today,

I didn't think that any of the Atom based cpu supported AVX.
I'm pretty sure one we use that are still in production as
server motherboards don't support it.

Doesn't -v3 also require support for the VEX encoding.
Which removes a lot of perfectly reasonable cpu?

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


