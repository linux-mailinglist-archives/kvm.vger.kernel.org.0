Return-Path: <kvm+bounces-22455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF7593E010
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 18:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D19751F21C83
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 16:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2781836F4;
	Sat, 27 Jul 2024 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="LhhdjyEK"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E771836D1;
	Sat, 27 Jul 2024 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722096192; cv=none; b=BXa6PtUoVYkCRxC/DmJr3gSlXf4JIV9xHugEzDfvYjbggbNTuyr/6rtU0geMpdqTqdshpUJAbAN66F30aOwDFL7RVnxAG0qwMjedAn02q21OP6jpsyrxe95Drj5vCJtFtAy9IKcA2CbUP0hzxatIZK+dfTPTpcWuE9eCVkavozs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722096192; c=relaxed/simple;
	bh=TtJ7YOsy8L8BEM7t0J60roW3VRNM0RBiVugXE8uEn00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VyiMrsxOGWXwowKVVaQqQrXgHgA5fyO9f7eCfoWFAlalVKqQvuNOUSiCTWDudmWqxWkWbOnPiDoVOKWum5AtuO1VoHCbocmK1keOUFhIMb3nOMpIAo8UWjesNt1NDgnVIeLzu2vy+1JFIV42a/IUEd2oS/RL5TFdHUAvvntzW9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=LhhdjyEK; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=9/5KynMQEWHzbTdYncEGyzsL0Kxnl9CjKKUOQD9PqJY=; b=LhhdjyEKmurFmR/8
	AkMWvzYZDWG69jQh/C+qgwa5ytoSHTvaR+rqYeriLzGnCWAqBZdFXUwnnJnWzlIkIJFU1aeLhDAjJ
	d5jmBgxFhbRJ17Iqkl+fafWlpLDjI4CT96rELpimLUi/YuMY/dT0Iym1KvG2MYLIHPiMuwSG6Dq+v
	+8XjkHRdbh5n9iHz7P70JEtNQLtdohtcqPMzIaomQV8ZUKD+Ugtl9FnmVGNB2VfDFDyWSGw9bYKPc
	T9spMgpyAIU/UAppts05AS5/D0YHSgQSBVIO+ByXn44HailjFa+ViY903Hg/GTH2LazTGW5ftcJyx
	8NIs7YAlQrwERAD5bA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sXjsx-00DYkq-34;
	Sat, 27 Jul 2024 16:03:07 +0000
From: linux@treblig.org
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] vfio/pci: Remove unused struct 'vfio_pci_mmap_vma'
Date: Sat, 27 Jul 2024 17:03:06 +0100
Message-ID: <20240727160307.1000476-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'vfio_pci_mmap_vma' has been unused since
commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ba0ce0075b2f..2127b82d301a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -57,11 +57,6 @@ struct vfio_pci_vf_token {
 	int			users;
 };
 
-struct vfio_pci_mmap_vma {
-	struct vm_area_struct	*vma;
-	struct list_head	vma_next;
-};
-
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
-- 
2.45.2


