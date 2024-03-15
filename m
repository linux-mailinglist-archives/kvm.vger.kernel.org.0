Return-Path: <kvm+bounces-11906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAAFE87CD0D
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 13:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC4271C21320
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 12:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5693A1C294;
	Fri, 15 Mar 2024 12:10:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C619C1AAD0
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 12:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710504642; cv=none; b=b0F7sji2IXpUdq2CKvmGDWLMaOxxoK5PtNzXhbt2gDKA5aqrljTs5TGUz4nH5uYFoIXmPhznBpzrgm9IQnxPHOa3wMP5SSPQNeVDzu4FqMZFPA+OD3u5EdzT0fmkhlDYbvIcyH7ng0nHSj7zkc6CN3tJH40pI+QC84+1y8JRsmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710504642; c=relaxed/simple;
	bh=V/xoCmoj1RXWaEhCvwqFOUaCmsiB96w4cTrsEm/5/Rg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XoPh8kLzl54GpVMpz+znL3LNYpklz55MmEEr0mFbtjtivj124wT1XYD6ABkmiVrZgwhQyQ8rwHS9s0VCJVdc+trUC8+kh8x0lEmLEFXphRu32D1QP2KrVLl7gwVo+/NOVnvZkxhjUywP8O88MPuK/nYfJwP1nZLMcQzx/A5R63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.202.115.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] KVM: use vfree for memory allocated by vcalloc/__vcalloc
Thread-Topic: [PATCH] KVM: use vfree for memory allocated by vcalloc/__vcalloc
Thread-Index: AQHaU+QuMEnq3jW6BE+VT2NDGuP3irE49w3A
Date: Fri, 15 Mar 2024 11:55:23 +0000
Message-ID: <26fef8f2fcf84df58ccad28a17598f8d@baidu.com>
References: <20240131012357.53563-1-lirongqing@baidu.com>
In-Reply-To: <20240131012357.53563-1-lirongqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.53
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM


> -----Original Message-----
> From: Li,Rongqing <lirongqing@baidu.com>
> Sent: Wednesday, January 31, 2024 9:24 AM
> To: kvm@vger.kernel.org
> Cc: Li,Rongqing <lirongqing@baidu.com>
> Subject: [PATCH] KVM: use vfree for memory allocated by vcalloc/__vcalloc
>=20
> commit 37b2a6510a48("KVM: use __vcalloc for very large allocations")
> replaced kvzalloc/kvcalloc with vcalloc, but not replace kvfree with vfre=
e
>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>


Ping

Thanks

-Li

