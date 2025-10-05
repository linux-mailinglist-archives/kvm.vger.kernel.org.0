Return-Path: <kvm+bounces-59505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7654DBB9561
	for <lists+kvm@lfdr.de>; Sun, 05 Oct 2025 12:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AFB13B8D28
	for <lists+kvm@lfdr.de>; Sun,  5 Oct 2025 10:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6846226B2D5;
	Sun,  5 Oct 2025 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="RdLzWvjf"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EAB15ECCC;
	Sun,  5 Oct 2025 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.158.153.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759659428; cv=none; b=Y3D8mHJWTYypEH+0TxCATa+J0t7icsBIuw6C0SKZBHhhNTFW+Y3Cjh2KVQ3vrsDIVSK6DGtgTAr+ZMucVGsvo2J+EIBVHmuY9EVahmbe+DqL4OOoA4ZPN0WRzPgcI5RFNK7/jHJEq6sS88sTd2j2KXg60dttc8gHE0vSTkp1ZnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759659428; c=relaxed/simple;
	bh=Eir7mnyPTT8PTo7bKSZ3J9jzIVPPdHCgaz3naHwIT9c=;
	h=Subject:From:To:CC:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QRNr9UCneAOi1FAcKT9bREMk81YyIBC9vmxDirDxG8UnHpmcdny4nIfyFBtDisCks6VbWA5IUyzHYwDsHoMtOlBfzUUlDBg5Jep9PT/k+ntnmRvgR5IOwM67wTpeTurIM6FU9gYsWktOznfDqSXXq3fchIiyitZ9SgUxmcL0rJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=RdLzWvjf; arc=none smtp.client-ip=18.158.153.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759659426; x=1791195426;
  h=from:to:cc:in-reply-to:references:date:message-id:
   mime-version:content-transfer-encoding:subject;
  bh=Eir7mnyPTT8PTo7bKSZ3J9jzIVPPdHCgaz3naHwIT9c=;
  b=RdLzWvjf2O0X7DBFBCBczSEynTMPokOIiuAScKifK8Cw0x1PQNYb++ur
   k6zM3BGnbhy1Xa+eVmjcfqHJFSzeON3N76AW0PPQTGXk4iMYDTtDKFk3x
   SEfpXryrvLe587gI8b0rzPzWIiORltUwCwJnrYTj+DzUwv//BAu3UFtn9
   ABhsXTCnxzyA9d4AblGR5io8eZWfGMvA8wFuSlg+46kSIj9x0tyUuMpDU
   zCMxMpDZk7MIClQ8oPBduqHG/TwbaIujbY9kyB+6dU4dbjMjLNW298s7j
   a3tMwq1Yf6ndUA3w0vBM1olwYusgbbu3BLb8a3jjKCXng/S4/UmXvN0pr
   g==;
X-CSE-ConnectionGUID: Mnu0jyX4Tpe7ruHcgSU6DA==
X-CSE-MsgGUID: a0tqmQ3nR0WM8qCJxcJ3KA==
X-IronPort-AV: E=Sophos;i="6.18,317,1751241600"; 
   d="scan'208";a="3000952"
Subject: Re: [RFC PATCH 0/7] vfio: Add alias region uapi for device feature
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2025 10:16:54 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:8805]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id d1d31bb2-8496-4c91-806d-605142009e03; Sun, 5 Oct 2025 10:16:53 +0000 (UTC)
X-Farcaster-Flow-ID: d1d31bb2-8496-4c91-806d-605142009e03
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Sun, 5 Oct 2025 10:16:52 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Sun, 5 Oct 2025
 10:16:48 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: David Matlack <dmatlack@google.com>
CC: <kvm@vger.kernel.org>, <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
	<kbusch@kernel.org>, <benh@kernel.crashing.org>, David Woodhouse
	<dwmw@amazon.co.uk>, <pravkmr@amazon.de>, <nagy@khwaternagy.com>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <CALzav=cRjQedF_g7qkJfrAtUEZKsME5=QpC+C6B7-nB_j-jc_Q@mail.gmail.com>
	(David Matlack's message of "Fri, 3 Oct 2025 14:58:50 -0700")
References: <20250924141018.80202-1-mngyadam@amazon.de>
	<CALzav=cRjQedF_g7qkJfrAtUEZKsME5=QpC+C6B7-nB_j-jc_Q@mail.gmail.com>
Date: Sun, 5 Oct 2025 12:16:45 +0200
Message-ID: <lrkyq8qhpbqlu.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: EX19D044UWA002.ant.amazon.com (10.13.139.11) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
Content-Transfer-Encoding: base64

RGF2aWQgTWF0bGFjayA8ZG1hdGxhY2tAZ29vZ2xlLmNvbT4gd3JpdGVzOgo+IE9uIFdlZCwgU2Vw
IDI0LCAyMDI1IGF0IDc6MTHigK9BTSBNYWhtb3VkIEFkYW0gPG1uZ3lhZGFtQGFtYXpvbi5kZT4g
d3JvdGU6Cj4+Cj4+IFRoaXMgYWRkcyB0d28gbmV3IHJlZ2lvbiBmbGFnczoKPj4gLSBWRklPX1JF
R0lPTl9JTkZPX0ZMQUdfQUxJQVM6IHNldCBvbiBhbGlhcyByZWdpb25zLgo+PiAtIFZGSU9fUkVH
SU9OX0lORk9fRkxBR19XQzogaW5kaWNhdGVzIFdDIGlzIGluIGVmZmVjdCBmb3IgdGhhdCByZWdp
b24uCj4KPiBPbmNlIHlvdSBzZXR0bGUgb24gYSB1QVBJLCB0aGlzIHdvdWxkIGJlIGEgZ29vZCBj
YW5kaWRhdGUgZm9yIHNvbWUKPiBWRklPIHNlbGZ0ZXN0cyBjb3ZlcmFnZSBbMV1bMl0uCgpZdXAs
IEkgd2FzIHBsYW5uaW5nIHRvIGRvIHRoYXQgYWZ0ZXIgc2VlaW5nIHRoZSBuZXcgYWRkaXRpb24g
b2YgdmZpbwpzZWxmdGVzdHMuIEkgaGF2ZSBhbHJlYWR5IGEgc21hbGwgdGVzdCB0aGF0IEkgdXNl
IGZvciB0ZXN0aW5nIHRoaXMuIEkKY2FuIGNsZWFuIGl0IHVwICYgcG9ydCBpdCB0byBmaXQgaW4g
dGhlIHZmaW8gc2VsZnRlc3QsIG9uY2UgdGhlcmUgaXMKc29tZSBtb21lbnR1bSBvbiB0aGlzIHNl
cmllcy4gVGhhbmtzIERhdmlkLgoKLU1OQWRhbQoKCgpBbWF6b24gV2ViIFNlcnZpY2VzIERldmVs
b3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKVGFtYXJhLURhbnotU3RyLiAxMwoxMDI0MyBCZXJs
aW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyCkVpbmdldHJhZ2VuIGFt
IEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBCZXJs
aW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=


