Return-Path: <kvm+bounces-28198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 644A299644E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BAB31F219DD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8D518873F;
	Wed,  9 Oct 2024 09:00:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FA42A1D1
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 09:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728464450; cv=none; b=dJwS99lwMVHnmghKIw8jY2zDY9lXc4Mx2PbXZvpo394+UPZCi0234RhYQv3B3gR8LquA5uT4H5XeuxTbW+heKlFJ8gfDfoqdear9kivjW56sQJgZbZTrGm6tSwmwHWG6/Fb9vQGw6W1RikJVgEWZNEKkAuBYRIoYGNqa+J+OHnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728464450; c=relaxed/simple;
	bh=B8TRprmUEN3TbBhD35Gh5msxlBC+l4F6F6QPRRdDLG4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Q9admothEFRS1vA2+AXfUoCwzkeITLPSu8/y6b49g2n7dXE+ChABFfJlAtbusZK0W1H2HY/gcFNpVhdSRR0fwrLPzY9zuUCql371DNeD+6VeeZMLTuPoEa/YTQodGjFunvAgMLkX5hqb1EimO4iMa6mj+URngc3ruRub9Kfn6L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Gao,Shiyuan" <gaoshiyuan@baidu.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] x86: Add support save/load HWCR MSR
Thread-Topic: [PATCH v1 1/1] x86: Add support save/load HWCR MSR
Thread-Index: AQHbGimJGzzAu7a83kSSJ9vdQ5PkZA==
Date: Wed, 9 Oct 2024 08:59:24 +0000
Message-ID: <7AEC3E01-EDA4-4507-8FD8-E14CA59A9D45@baidu.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C793F23FC709542AE759AC8321A4B61@internal.baidu.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.14
X-FE-Last-Public-Client-IP: 100.100.100.60
X-FE-Policy-ID: 52:10:53:SYSTEM

PiA+IGRpZmYgLS1naXQgYS90YXJnZXQvaTM4Ni9jcHUuYyBiL3RhcmdldC9pMzg2L2NwdS5jDQo+
ID4gaW5kZXggODVlZjc0NTJjMC4uMzM5MTMxYTM5YSAxMDA2NDQNCj4gPiAtLS0gYS90YXJnZXQv
aTM4Ni9jcHUuYw0KPiA+ICsrKyBiL3RhcmdldC9pMzg2L2NwdS5jDQo+ID4gQEAgLTcwOTMsNiAr
NzA5Myw3IEBAIHN0YXRpYyB2b2lkIHg4Nl9jcHVfcmVzZXRfaG9sZChPYmplY3QgKm9iaiwgUmVz
ZXRUeXBlIHR5cGUpDQo+ID4gZW52LT5hMjBfbWFzayA9IH4weDA7DQo+ID4gZW52LT5zbWJhc2Ug
PSAweDMwMDAwOw0KPiA+IGVudi0+bXNyX3NtaV9jb3VudCA9IDA7DQo+ID4gKyBlbnYtPmh3Y3Ig
PSAwOw0KPg0KPg0KPiBXaHkgd2UgbmVlZCB0byBjbGVhciBpdCBoZXJlPyBUaGlzIG5lZWRzIHRv
IGJlIGV4cGxhaW5lZCBpbiB0aGUgY29tbWl0DQo+IG1lc3NhZ2UuDQoNCkkgbWlzdW5kZXJzdG9v
ZCwgdGhlcmXigJlzIG5vIG5lZWQgdG8gY2xlYXIgaGVyZS4NCg0KPiA+DQo+ID4gKyNkZWZpbmUg
TVNSX0s3X0hXQ1IgMHhjMDAxMDAxNQ0KPiA+ICsNCj4gPiAjZGVmaW5lIE1TUl9WTV9IU0FWRV9Q
QSAweGMwMDEwMTE3DQo+ID4NCj4gPiAjZGVmaW5lIE1TUl9JQTMyX1hGRCAweDAwMDAwMWM0DQo+
ID4gQEAgLTE4NTksNiArMTg2MSw5IEBAIHR5cGVkZWYgc3RydWN0IENQVUFyY2hTdGF0ZSB7DQo+
ID4gdWludDY0X3QgbXNyX2xicl9kZXB0aDsNCj4gPiBMQlJFbnRyeSBsYnJfcmVjb3Jkc1tBUkNI
X0xCUl9OUl9FTlRSSUVTXTsNCj4gPg0KPiA+ICsgLyogSGFyZHdhcmUgQ29uZmlndXJhdGlvbiBN
U1IgKi8NCj4NCj4NCj4gV2UgY2FuIGtlZXAgdGhlIHNhbWUgY29tbWVudCBhcyBtc3JfaHdjciBp
biBLVk0gdG8gZW1waGFzaXplIHRoaXMgaXMgYW4NCj4gQU1ELXNwZWNpZmljIE1TUiwgaS5lLiwN
Cj4NCj4NCj4gLyogQU1EIE1TUkMwMDFfMDAxNSBIYXJkd2FyZSBDb25maWd1cmF0aW9uICovDQo+
DQo+DQo+ID4gKyB1aW50NjRfdCBod2NyOw0KPg0KPg0KPiBBZGQgdGhlIG1zcl8gcHJlZml4IHRv
IGluZGljYXRlIHRoYXQgdGhpcyB2YWx1ZSBpcyBvbmx5IGludGVuZGVkIHRvDQo+IHN0b3JlIHRo
ZSBNU1IuIEN1cnJlbnRseSwgZm9yIHNpbWlsYXIgbWVtYmVycywgc29tZSBoYXZlIHRoZSBtc3Jf
IHByZWZpeA0KPiBhbmQgc29tZSBkbyBub3QsIGJ1dCBpdCBpcyBiZXR0ZXIgdG8gaGF2ZSBpdCBm
b3IgY2xhcml0eS4NCj4NCg0KVGhhbmtzLCBJIHdpbGwgbW9kaWZ5IGl0Lg0KDQo=

