Return-Path: <kvm+bounces-53106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6616B0D5EF
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC36816A0A4
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5180C2DC35C;
	Tue, 22 Jul 2025 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fIZ9Aqfl"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7D22BE7A1
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176368; cv=none; b=SZnKVPe572/+iieFPlF0yf6PsJOA4ux9UiZy1T7g6/oDerM/pMeyU6unA2wZ+Quvd0f57pob1rVwJtXb0QKKUey2rlH7z2V9ip+jnITtgNG+vj108wqnWzZecg4p60vXvhK+McY//iiG4X29hI71M9w+TM4DcTkpL9NS0CkerpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176368; c=relaxed/simple;
	bh=iHUHRl51OJR0rqe5C5RdfHieRPLsHXheQ6j2EGUF6Hs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=Hg6EtCqfGUl46tOVSGWdSE5Aa9kzBwdsUXyypNL5mLjrMEnAzuVUSYJ02Kw5Sq64v9cSUMTrfOMa066OHT+WSgSE8+GrULKieX8OS7mGNcR6xnkdgLwPacZ8WG13zk+vUDn10L5KJICeyKM5vO4zcUweodjsxmczgrEp+pZl8cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fIZ9Aqfl; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <acc016f6-5378-46e3-8076-a3f9edb83c51@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753176352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2KvHPce0iqMprg/stk3/r9S5h9EdXxFtZBxzAhWsm/U=;
	b=fIZ9AqflieHpIHrGp+6Yk72/qNnRZuwFU/1hUrda8DRJcmNgCABZ4VWZMmSXmIL65Y017V
	be6wBjWTMczN3pKla0mYMGdxtvh5Jn/PQmnlw+LCXLIzla19/KDiPG0ZyUYT12FpRHgX8W
	SlXi7eoFe1SlfTbHvunRlxPjbJ91dyI=
Date: Tue, 22 Jul 2025 17:25:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [PATCH v15 15/21] KVM: arm64: Refactor user_mem_abort()
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, tabba@google.com,
 linux-mm@kvack.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: Tao Chan <chentao@kylinos.cn>

-- 
Thanks,
   Kunwu.Chan(Tao.Chan)


