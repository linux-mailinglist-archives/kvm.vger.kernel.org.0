Return-Path: <kvm+bounces-56797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7405EB4354D
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEF4C188161C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0552C0F8A;
	Thu,  4 Sep 2025 08:14:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1989E2BEFE1;
	Thu,  4 Sep 2025 08:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973658; cv=none; b=sPNrBPYLnQ1mlkXplrGOsFf55cYITR+FiNaZFnnjrwyqMNYiGXyJF2Kw2N+zCRkAyHZOKPuE8B9Da/00G0G5iv9fwDTj8Fudo+ORXbfbTsVQFUyGuRPevvn13ziJ3FwI9pjbq1n2j16qNBxeRw0eIuY0PlHhdj14q1HPpkA390E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973658; c=relaxed/simple;
	bh=MCg0R7lspWnUAF0f5SuTopyp8Sjf2uoftrZVGTPACaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIGfkx23/8TL/gKybC3B2RXfjXjPBagKvSF9FySn7kWs/SzXclkq4wVH6EuFec5KRQa2bglecCrxwS5Qi3ciMYKJ6xnOWUB36z7zvto6hPweGLrccP4WlGwcrtgZoD6vfortxL0NPz7I3CulWOab9N9XnRHkB7X23evmWmSO3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 22352d5c896711f0b29709d653e92f7d-20250904
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED, SA_LOWREP
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:14293aca-ade4-4f5a-8cfe-b60be37e72da,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.1.45,REQID:14293aca-ade4-4f5a-8cfe-b60be37e72da,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:6493067,CLOUDID:fcf7ad9177248482b0e7c728bd1ded62,BulkI
	D:250904142548XOOMPT96,BulkQuantity:2,Recheck:0,SF:19|24|44|66|72|78|81|82
	|83|102,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR
X-UUID: 22352d5c896711f0b29709d653e92f7d-20250904
X-User: cuitao@kylinos.cn
Received: from ctao-ubuntu.. [(39.156.73.13)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1218613750; Thu, 04 Sep 2025 16:14:09 +0800
From: cuitao <cuitao@kylinos.cn>
To: yangtiezhu@loongson.cn
Cc: chenhuacai@kernel.org,
	cuitao@kylinos.cn,
	kernel@xen0n.name,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	maobibo@loongson.cn,
	zhaotianrui@loongson.cn
Subject: Re: [PATCH] LoongArch: KVM: remove unused returns.
Date: Thu,  4 Sep 2025 16:13:55 +0800
Message-ID: <20250904081356.1310984-1-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <462e346b-424d-263d-19a8-766d578d9781@loongson.cn>
References: <462e346b-424d-263d-19a8-766d578d9781@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Thanks for the review.

My initial idea was to remove the switch-case structure. 
However, after checking the case value KVM_FEATURE_STEAL_TIME, 
I found there are 13 parallel definitions—and it is unclear when 
this part of the development will be completed later. Therefore, 
I temporarily retained the switch-case structure. 

Now, I have updated the patch according to your suggestion:
- Replaced `switch` with `if` since there is only one case.
- Removed the redundant semicolon after the block.

Please see the updated patch below.

Thanks,
Tiezhu

