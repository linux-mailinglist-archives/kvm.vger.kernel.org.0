Return-Path: <kvm+bounces-36855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E72DA21EB6
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93B16169EB7
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1C41EEA3D;
	Wed, 29 Jan 2025 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCg1Ybt8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FA71C5F25;
	Wed, 29 Jan 2025 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159431; cv=none; b=AwliW+4Yt/WFyJLVW70c3TwkaBz1fPEESRf86GWINY8HqCcTuSPGfdawX5++hgkXauteDARKJifjZ4o7mUdi/0Goh2D5Okhgn6hRxFX5Sjsz9ySs9+DIV7zM0bpr9PK/IdDFLMzY4JW9tCOfUGrhwmaxTzEadD7qT4s8yScRHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159431; c=relaxed/simple;
	bh=h4vxqUB4hOERtsdwP43pEGBi99XkQnC4xaaefbGsTHI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W6wrkbsDgeMjSI7dr10HRJ9ZiC0PwFk7VC+fUDFCfeV/e2A2ZJ7DGe7xPYDJxte+s0gl88IPBiWxY2H1vsvjLAjjdC2S8F3QJxwvCK6cq9nykezfSjOIeuwBrNwlS9ZfvGgxKmBzzkqUwYjkyGbCE44+/2alwRwW0laEeeicGZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCg1Ybt8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E41C4CED1;
	Wed, 29 Jan 2025 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738159430;
	bh=h4vxqUB4hOERtsdwP43pEGBi99XkQnC4xaaefbGsTHI=;
	h=From:To:Cc:Subject:Date:From;
	b=dCg1Ybt8jiaTm13HGSLvgVO21x6z7pQypJ8H+VZetCtRu0p4HlFId4RKiGBHsWdTB
	 Gxt8PYtMBdWSlM1H9C1qftqD8DH+I43G9HfJUVFnLPwZxmf/D0V0rynFSmQM9mQ4Bj
	 1p4aLlNsnDE5T5XsyxAVHw7NHNahKgr7I9JDXXr37B5gg1yYh1rCQ68WgardRCaM6R
	 DqpKo7uA3Bs84i02kuw8ffc2o3U1KEjVuXXG6ZKxUqZokMsKReQ6bA8AqjbmYNpBvD
	 bAJYiShkcezeMuL+RGxxYSCjVOZVizzV9JaAch/cNMKwR6jLrPCdgmiHrLnon8trP0
	 lbGNMv9Jn39zg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ramesh Thomas <ramesh.thomas@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Yunxiang.Li@amd.com,
	gbayer@linux.ibm.com,
	jgg@ziepe.ca,
	ankita@nvidia.com,
	bpsegal@us.ibm.com,
	kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1] vfio/pci: Enable iowrite64 and ioread64 for vfio pci
Date: Wed, 29 Jan 2025 08:00:05 -0500
Message-Id: <20250129130008.1273212-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.127
Content-Transfer-Encoding: 8bit

From: Ramesh Thomas <ramesh.thomas@intel.com>

[ Upstream commit 2b938e3db335e3670475e31a722c2bee34748c5a ]

Definitions of ioread64 and iowrite64 macros in asm/io.h called by vfio
pci implementations are enclosed inside check for CONFIG_GENERIC_IOMAP.
They don't get defined if CONFIG_GENERIC_IOMAP is defined. Include
linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64 macros
when they are not defined. io-64-nonatomic-lo-hi.h maps the macros to
generic implementation in lib/iomap.c. The generic implementation does
64 bit rw if readq/writeq is defined for the architecture, otherwise it
would do 32 bit back to back rw.

Note that there are two versions of the generic implementation that
differs in the order the 32 bit words are written if 64 bit support is
not present. This is not the little/big endian ordering, which is
handled separately. This patch uses the lo followed by hi word ordering
which is consistent with current back to back implementation in the
vfio/pci code.

Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241210131938.303500-2-ramesh.thomas@intel.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe7..8191c8fcfb256 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 
 #include "vfio_pci_priv.h"
 
-- 
2.39.5


