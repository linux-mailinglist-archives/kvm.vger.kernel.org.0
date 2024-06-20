Return-Path: <kvm+bounces-20069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD958910272
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 13:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F321C215EF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 11:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CC61AB8E0;
	Thu, 20 Jun 2024 11:24:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BB51AB34D
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718882672; cv=none; b=NfYYeBIk1557cUtkilNvwGs9Q4+utKHr58XGM96WhfY/JKTzid+NzW/1uXoWoUDPkOc1j9y61LZtzD6ky44TubrFWqAEvRCGOWfwbppchMX11VmdKPYnGcBXpHiDMKqGEqKo7EbEYSiFiERJP5oKvB3YL/iLkMPOGCw8Sa71omE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718882672; c=relaxed/simple;
	bh=2VaOccW8lMYjeUaN3+kBsMhc3bDiu/AkOpsqY7Hln7k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NMqaGHZdqXiLBVsNfJCG0UbthHkofFnsUZRT6CYXBwYATiJ3hlpA6JoNe8pX3N4z4iepZMTMq0QEMol3lzxjj0bxT9hZh92KFU7VoQX55U1ZbTHQbTjCvQ3yORC30YkRTg96tHW2lW3iKPWkpnG4fXW8j9E/yi6/bR6Q81Gfv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "wanpengli@tencent.com"
	<wanpengli@tencent.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: =?utf-8?B?UkU6IFvlpJbpg6jpgq7ku7ZdIFJlOiBbUEFUQ0hdIHg4Ni9rdm06IGZpeCB0?=
 =?utf-8?Q?he_decrypted_pages_free_in_kvmclock?=
Thread-Topic: =?utf-8?B?W+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0geDg2L2t2bTogZml4IHRoZSBk?=
 =?utf-8?Q?ecrypted_pages_free_in_kvmclock?=
Thread-Index: AQHau6ncmV9I7Fhn7Ea4YIctRpRDL7HLI7gAgAVs2bA=
Date: Thu, 20 Jun 2024 11:23:06 +0000
Message-ID: <e4aa32b943c34834ac07649840feb549@baidu.com>
References: <20240611024835.43671-1-lirongqing@baidu.com>
 <87frtcrmxz.fsf@redhat.com>
In-Reply-To: <87frtcrmxz.fsf@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex16_2024-06-20 19:23:06:863
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex12_2024-06-20 19:23:06:982
X-FEAS-Client-IP: 10.127.64.35
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 52:10:53:SYSTEM

DQoNCj4gDQo+IA0KPiBPdXQgb2YgY3VyaW9zaXR5LA0KPiANCj4gc2hvdWxkbid0IHdlIHJhdGhl
ciB0cnkgdG8gbWFrZSBzZXRfbWVtb3J5X2RlY3J5cHRlZCgpIG1vcmUgYXRvbWljIHRvIGF2b2lk
DQo+IHRoZSBuZWVkIHRvIGh1bnQgZG93biBhbGwgdXNlcnMgb2YgdGhlIEFQST8gRS5nLiBpbiBI
eXBlci1WJ3MNCj4gX192bWJ1c19lc3RhYmxpc2hfZ3BhZGwoKSBJIHNlZToNCj4gDQo+ICAgICAg
cmV0ID0gc2V0X21lbW9yeV9kZWNyeXB0ZWQoKHVuc2lnbmVkIGxvbmcpa2J1ZmZlciwNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBQRk5fVVAoc2l6ZSkpOw0KPiAgICAgIGlmIChy
ZXQpIHsNCj4gICAgICAgICAgICAgIGRldl93YXJuKCZjaGFubmVsLT5kZXZpY2Vfb2JqLT5kZXZp
Y2UsDQo+IAkgICAgIC4uLg0KPiANCj4gZG9lc24ndCBpdCBoYXZlIHRoZSBleGFjdCBzYW1lIGlz
c3VlIHlvdSdyZSB0cnlpbmcgdG8gYWRkcmVzcyBmb3Iga3ZtY2xvY2s/DQo+IA0KDQpUaGlzIHBh
dGNoIHNob3VsZCBzaG93IHRoZSByZWFzb24NCg0KaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMjMv
MTAvMjQvMTM2OQ0KDQp0aGFua3MNCg0KLUxpDQo=

