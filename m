Return-Path: <kvm+bounces-47337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D241AC01EE
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 03:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F60A20F24
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF05181ACA;
	Thu, 22 May 2025 01:55:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A323245BE3;
	Thu, 22 May 2025 01:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747878933; cv=none; b=ROFBCSN4aGjQDLo4Koi3UGJkxMUvCszs2+XSpxrnEdgHnVxh+xzZjfWCQCCLTySeUzSks1KFxElkRiS2/TeShm4VEhslem2XyOFqOtwh6BcidGObxRfnhw6WntKckePsrQdNyUhNcIZ5GyIT0N33CwPPKZPSyuoRt6mPCxzvuG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747878933; c=relaxed/simple;
	bh=/82BnZFFiaX1veUnIvRmpzzmMDTtNt+thgiAnfULiXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aK6To+S4Bp5MaMbQ9SltfXvPhzoUZcW3ud07fqADoUb1g6UNNZ/kA2ibgcj/h8W0N2q/PSIbJHxZGvWYfVx3zIoI+kkVWTTNmhR3FAelv1tOxuvAnBXHRYtvws2qZiQZE+5tlnLj9I2yegqMefnOk+9AplVkgZT9scI8t2GuuLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kwankhede@nvidia.com" <kwankhede@nvidia.com>, "yan.y.zhao@intel.com"
	<yan.y.zhao@intel.com>, "cjia@nvidia.com" <cjia@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIHZmaW8vdHlwZTE6IGZpeGVkIHJv?=
 =?gb2312?B?bGxiYWNrIGluIHZmaW9fZG1hX2JpdG1hcF9hbGxvY19hbGwoKQ==?=
Thread-Topic: [????] Re: [PATCH] vfio/type1: fixed rollback in
 vfio_dma_bitmap_alloc_all()
Thread-Index: AQHbygL+7rFEheWUqk2WZSAn5Jz+B7Pc++QAgADoCTA=
Date: Thu, 22 May 2025 01:53:48 +0000
Message-ID: <64e1bbd6b7e94aa0b5bc4556d5d335a6@baidu.com>
References: <20250521034647.2877-1-lirongqing@baidu.com>
 <20250521140034.35648fde.alex.williamson@redhat.com>
In-Reply-To: <20250521140034.35648fde.alex.williamson@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2025-05-22 09:53:48:767
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 10.127.64.37
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 52:10:53:SYSTEM

DQo+ICAgICB2ZmlvL3R5cGUxOiBGaXggZXJyb3IgdW53aW5kIGluIG1pZ3JhdGlvbiBkaXJ0eSBi
aXRtYXAgYWxsb2NhdGlvbg0KPiANCj4gICAgIFdoZW4gc2V0dGluZyB1cCBkaXJ0eSBwYWdlIHRy
YWNraW5nIGF0IHRoZSB2ZmlvIElPTU1VIGJhY2tlbmQgZm9yDQo+ICAgICBkZXZpY2UgbWlncmF0
aW9uLCBpZiBhbiBlcnJvciBpcyBlbmNvdW50ZXJlZCBhbGxvY2F0aW5nIGEgdHJhY2tpbmcNCj4g
ICAgIGJpdG1hcCwgdGhlIHVud2luZCBsb29wIGZhaWxzIHRvIGZyZWUgcHJldmlvdXNseSBhbGxv
Y2F0ZWQgdHJhY2tpbmcNCj4gICAgIGJpdG1hcHMuICBUaGlzIG9jY3VycyBiZWNhdXNlIHRoZSB3
cm9uZyBsb29wIGluZGV4IGlzIHVzZWQgdG8NCj4gICAgIGdlbmVyYXRlIHRoZSB0cmFja2luZyBv
YmplY3QuICBUaGlzIHJlc3VsdHMgaW4gdW5pbnRlbmRlZCBtZW1vcnkNCj4gICAgIHVzYWdlIGZv
ciB0aGUgbGlmZSBvZiB0aGUgY3VycmVudCBETUEgbWFwcGluZ3Mgd2hlcmUgYml0bWFwcyB3ZXJl
DQo+ICAgICBzdWNjZXNzZnVsbHkgYWxsb2NhdGVkLg0KPiANCj4gICAgIFVzZSB0aGUgY29ycmVj
dCBsb29wIGluZGV4IHRvIGRlcml2ZSB0aGUgdHJhY2tpbmcgb2JqZWN0IGZvcg0KPiAgICAgZnJl
ZWluZyBkdXJpbmcgdW53aW5kLg0KPiANCg0KWW91ciBjaGFuZ2Vsb2cgaXMgZXh0cmVtZWx5IGRl
dGFpbGVkIGFuZCBoaWdobHkgYWNjdXJhdGUuDQoNClBsZWFzZSBkaXJlY3RseSBpbmNvcnBvcmF0
ZSB0aGlzIHBhdGNoIHdpdGggeW91ciBjaGFuZ2Vsb2cNCg0KVGhhbmtzDQoNCi1MaQ0K

