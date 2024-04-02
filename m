Return-Path: <kvm+bounces-13367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA0D8950A2
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 12:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D75EB229B1
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 10:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E56C5FBB1;
	Tue,  2 Apr 2024 10:46:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E305E093;
	Tue,  2 Apr 2024 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.245.218.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712054792; cv=none; b=iPbvWtBGGba58II9fXQIRMYh0QltGcWlKX/xUTFpNXQjjTS6oAjqrhcYcWGWW744sa463ycgmUw9busEkCkdq0KCjIHL8R+BrTDQWhvsbI1jszQNTYoJ7bc3y5SPDSU+zw2HgHFX8YcFHLhAM5YPbhFgrspoTd4v4aQhDB+e8o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712054792; c=relaxed/simple;
	bh=BwFIqznhYSYPd8an0Q2AyYq224PV4XlpCYp/tz+LHdU=;
	h=From:To:Cc:Subject:Mime-Version:Content-Type:Date:Message-ID:
	 References:In-Reply-To; b=gZP0ssFXjePsGSTPXvmbv2ko0J23v2ojk9g163d18WwaBz3cGbIkUCb+VZkgp249ceK9LxMQSX8qo+pJvl6Tjtf+ZKMAhC+AJFg91QTQLAbD6xl1m+1CRasuY6CjRusbGLAcPfVZnBuX7Vo4ZL4TnwZ/ylvc/y4RsSHWZm6nf8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=13.245.218.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-GoodBg: 1
X-QQ-SSF: 00400000000000F0
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-FEAT: +ynUkgUhZJkXJ2GkVrAA9ITwCMeqGEJyg7gbtaR1iiaMCqpI6vaifUXdwjFYG
	5U1zWO3XFcFaZ62i3wALBksaW6ZaL1uoFOV0eBC9Y7tpf6+apvRrZ7cES1KFu2PW59/go/k
	WQ8pAOp73PrC5E/iWVNf68gxgIzYAkzuZvoz19mwB+j2ebVefaAzbUGnkTs+b+IQg/rpf2T
	6omaPTc5D/nODZkslWljv/UPRXGjvWYkpDzd3D9dUH7U4r7S1Rgn9LKzhXGxVu7I95HgxWt
	hcaLd3NEE8pG2KklyhD1azaU/MMS/Xy6Z1dQ6t97MvdZ1Q0fFU9XrhNnQpiXhT/ZzHq3Ju4
	hRRGffWAnX+irMmcl4Q4aa+vhAIKMzI5bkzF+9TN2Ef7YNk0sT9BlpX68pPHw==
X-QQ-BUSINESS-ORIGIN: 2
X-QQ-Originating-IP: B4F1NIpmc8L+ioATNeMek/eIAECDvCDomBf9TwzzcB8=
X-QQ-STYLE: 
X-QQ-mid: t5gz7a-2t1712054752t2506555
From: "=?utf-8?B?V2VudGFvIEd1YW4=?=" <guanwentao@uniontech.com>
To: "=?utf-8?B?WGkgUnVveWFv?=" <xry111@xry111.site>, "=?utf-8?B?emhhb3RpYW5ydWk=?=" <zhaotianrui@loongson.cn>
Cc: "=?utf-8?B?bG9vbmdhcmNo?=" <loongarch@lists.linux.dev>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?546L5pix5Yqb?=" <wangyuli@uniontech.com>, "=?utf-8?B?a3Zt?=" <kvm@vger.kernel.org>
Subject: Re: [PATCH] LoongArch: KVM: Remove useless MODULE macro for MODULE_DEVICE_TABLE
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Tue, 2 Apr 2024 10:45:51 +0000
X-Priority: 3
Message-ID: <tencent_411F127936C0F14A261A445E@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <20240402103942.20049-1-guanwentao@uniontech.com>
	<453b49801d789523f7366507d1620728315b1097.camel@xry111.site>
In-Reply-To: <453b49801d789523f7366507d1620728315b1097.camel@xry111.site>
X-QQ-ReplyHash: 4178647614
X-BIZMAIL-ID: 486678769786288338
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
	by smtp.qq.com (ESMTP) with SMTP
	id ; Tue, 02 Apr 2024 18:45:53 +0800 (CST)
Feedback-ID: t:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

T0ssIGl0IHdpbGwgcmVzZW5kIGluIFBBVENIIFYyLg0KSSBoYXZlIGEgbWlzdGFrZSB0byBu
b3QgYWRkICJfX21heWJlX3VudXNlZCIgaW4gY3B1X2ZlYXR1cmUgc3RydWN0dXJlLg==


