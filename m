Return-Path: <kvm+bounces-57162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C307AB50A9E
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50C943BA06F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9C822A4E8;
	Wed, 10 Sep 2025 02:01:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8866354F81;
	Wed, 10 Sep 2025 02:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757469668; cv=none; b=jCt1M6yl/WHdHgcw0z4luzmG/V7xM6NXxxPZSfu2V0qu4fzPQ8/Y/ULtTuCpKrdT1FHkNGp7BfH1SXzaqfpGnIcHY8CzIzN/ffUiYfgCQjj4/FLyZJpMTxmgLXqmNpzujlr8cV70I8js84B3k9fNmT/xYqNp3MckH9fEugZoqoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757469668; c=relaxed/simple;
	bh=nrgJ3fiPQ7FVQoDDJSgixRhiDEvwPwCA2HNWaKt8QF4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tb9pxtW8LWGTaaER5xTwBPDs+3aLDbiTIjA+rWR6EhVysJaYkAMCAZkTl4XRCc06/4zvyVcH/tjZYPtUASt9Nx7rt4sT3jREfDMfPCd07nF4opSnSkCJR31nN+DqeUpFvjb+3Nihp5YkYeEz3mcOIc7k9Hz7gmpsEU1qFDkA9io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cM3hv5tbkz13NYt;
	Wed, 10 Sep 2025 09:57:03 +0800 (CST)
Received: from dggpemf100009.china.huawei.com (unknown [7.185.36.128])
	by mail.maildlp.com (Postfix) with ESMTPS id AE3ED180488;
	Wed, 10 Sep 2025 10:01:03 +0800 (CST)
Received: from huawei.com (10.67.175.29) by dggpemf100009.china.huawei.com
 (7.185.36.128) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 10:01:02 +0800
From: Wang Tao <wangtao554@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <graf@amazon.com>, <kvm@vger.kernel.org>, <mingo@redhat.com>,
	<nh-open-source@amazon.com>, <peterz@infradead.org>, <sieberf@amazon.com>,
	<vincent.guittot@linaro.org>, <tanghui20@huawei.com>,
	<zhangqiao22@huawei.com>
Subject: Re: [PATCH] sched/fair: Only increment deadline once on yield
Date: Wed, 10 Sep 2025 01:43:53 +0000
Message-ID: <20250910014353.1015060-1-wangtao554@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <7eed0c3d-6a78-4724-b204-a3b99764d839@amazon.com>
References: <7eed0c3d-6a78-4724-b204-a3b99764d839@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100009.china.huawei.com (7.185.36.128)

Picking up this dead thread again.

Has this patch been applied to the mainline or other branch? 

Thanks.

