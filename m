Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539D11B08F4
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 14:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgDTMLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 08:11:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38476 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbgDTMLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 08:11:34 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B7A27F04CFD1B40AC454;
        Mon, 20 Apr 2020 20:11:32 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 20:11:23 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pbonzini@redhat.com>, <peterx@redhat.com>, <tglx@linutronix.de>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] kvm/eventfd: remove unneeded conversion to bool
Date:   Mon, 20 Apr 2020 20:38:05 +0800
Message-ID: <20200420123805.4494-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The '==' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

virt/kvm/eventfd.c:724:38-43: WARNING: conversion to bool not needed
here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 virt/kvm/eventfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 67b6fc153e9c..0c4ede45e6bd 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -721,7 +721,7 @@ ioeventfd_in_range(struct _ioeventfd *p, gpa_t addr, int len, const void *val)
 		return false;
 	}
 
-	return _val == p->datamatch ? true : false;
+	return _val == p->datamatch;
 }
 
 /* MMIO/PIO writes trigger an event if the addr/val match */
-- 
2.21.1

