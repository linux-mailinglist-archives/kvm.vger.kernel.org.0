Return-Path: <kvm+bounces-60054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 39066BDC177
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 04:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 575654F6D82
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 02:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4D3306497;
	Wed, 15 Oct 2025 02:00:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA62C28751D;
	Wed, 15 Oct 2025 02:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760493653; cv=none; b=b4D2He9ppLDd1H29HWU3hYi3WaEHquqIkDFOw9jyl9zkdBwJxOAHmMYd/Ia0Xxt3bqf5P2bNqM1dezPGGqUqH5nicrzYJx1kWoEVEf95+rjffbp7r82DQwvLkQCL9+SfEynzpDS06ppQsTt4Y2T8emhPEo/x2MmBFlGQzyj1XuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760493653; c=relaxed/simple;
	bh=LoWZyV9TIG//UZOryn5NkQWigvSilMfG1lx1cySBq+o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZKE5cXg6RRGPFh/BREvV2i6xDfDCP+MFqBZzB8Y7HBKyLZZZeQOszpnLGz2ZFXAuFihab+ukuJObwH81l9EgUUf4rLLa0qAJZ0HyRZAmy9mgUxuCBj9NEAaE9W1q8m4XEzVHz59PROdAkbp5sy5tFlGMuS26hYLUbZE/3CpNO+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from Jtjnmail201613.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202510151000403718;
        Wed, 15 Oct 2025 10:00:40 +0800
Received: from jtjnmailAR02.home.langchao.com (10.100.2.43) by
 Jtjnmail201613.home.langchao.com (10.100.2.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 15 Oct 2025 10:00:41 +0800
Received: from inspur.com (10.100.2.108) by jtjnmailAR02.home.langchao.com
 (10.100.2.43) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Wed, 15 Oct 2025 10:00:41 +0800
Received: from localhost.localdomain.com (unknown [10.94.16.205])
	by app4 (Coremail) with SMTP id bAJkCsDwRLVIAO9oJb4JAA--.1703S4;
	Wed, 15 Oct 2025 10:00:40 +0800 (CST)
From: Chu Guangqing <chuguangqing@inspur.com>
To: <kwankhede@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chu Guangqing
	<chuguangqing@inspur.com>
Subject: [PATCH v3 0/1] Fix spelling typo in samples/vfio-mdev
Date: Wed, 15 Oct 2025 09:59:53 +0800
Message-ID: <20251015015954.2363-1-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: bAJkCsDwRLVIAO9oJb4JAA--.1703S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5K7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aV
	CY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF
	04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
	18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdEfOUUUUU=
X-CM-SenderInfo: 5fkxw35dqj1xlqj6x0hvsx2hhfrp/
X-CM-DELIVERINFO: =?B?9SBcU5RRTeOiUs3aOqHZ50hzsfHKF9Ds6CbXmDm38RucXu3DYXJR7Zlh9zE0nt/Iac
	D+KWU3Ui6uP5DxCJj7wM2rXsXhmP1DiyZeOIe5ZDWagPqcMm4TJJGdl0nV0olMO4yl54T6
	3zbp2K7sPle4sGem6lU=
Content-Type: text/plain
tUid: 20251015100040fd29fc35393e0cdef76562a7e0910ed7
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Fixes for some spelling errors in vfio-mdev


v3:
 - The vfio-mdev module patch as a separate thread

v2:
 - Merge into a single commit 
 (https://lore.kernel.org/all/20251014060849.3074-1-chuguangqing@inspur.com/
)
v1:
 (https://lore.kernel.org/all/20251014023450.1023-1-chuguangqing@inspur.com/)

Chu Guangqing (1):
  vfio/mtty: Fix spelling typo in samples/vfio-mdev

 samples/vfio-mdev/mtty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.43.7


