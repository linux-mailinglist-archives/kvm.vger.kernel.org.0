Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27302ECEC2
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbhAGLcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:32:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26037 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbhAGLcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:32:54 -0500
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210107113211epoutp01ac9d7bee716a0d7239e314d386e297f8~X796cCKIO2582825828epoutp01B
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 11:32:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210107113211epoutp01ac9d7bee716a0d7239e314d386e297f8~X796cCKIO2582825828epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610019131;
        bh=Y5ImB5VQtfD9pDutmko4zwevF00ehKGnHWp7AUBRc0E=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=KV/2C/46bco6D8hPTNk5DldzyUlIv5ALKlF+OKrZ2JdKToIwJO8EMoTV4EB24FF9x
         WjayU8Wc0hgglu+zU7wDN9038YwO45MHmqVdIiNZP8CWhvkpN+OxRsVWW/aK7Nbw+g
         6iWERtM49OsFCYR5dJYzCmPiJIWAI9z46r9xIFuw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210107113210epcas5p19d377f7b6ba3de7aa3e69ecc1e6cd169~X795eAF2u2849628496epcas5p1M;
        Thu,  7 Jan 2021 11:32:10 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.193]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DBPGJ1nlRz4x9Pw; Thu,  7 Jan
        2021 11:32:08 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-af-5ff6f1385c4f
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D0.CD.15682.831F6FF5; Thu,  7 Jan 2021 20:32:08 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq equals
 to IRQ_NOTCONNECTED
Reply-To: jie6.li@samsung.com
Sender: =?UTF-8?B?5p2O5o23?= <jie6.li@samsung.com>
From:   =?UTF-8?B?5p2O5o23?= <jie6.li@samsung.com>
To:     "mst@redhat.com" <mst@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     =?UTF-8?B?6rmA6rK97IKw?= <ks0204.kim@samsung.com>,
        =?UTF-8?B?5L2V5YW0?= <xing84.he@samsung.com>,
        =?UTF-8?B?5ZCV6auY6aOe?= <gaofei.lv@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca@epcms5p2>
Date:   Thu, 07 Jan 2021 19:32:07 +0800
X-CMS-MailID: 20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsWy7bCmuq7Fx2/xBi/buSx2Ld7IYtG8eD2b
        xexprewWR/dwWMyZWmhxedccNov/v16xWpyd8IHVYm+fjwOnx/65a9g93u+7yubRt2UVo8fn
        TXIBLFE5NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
        hygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCgyNCvSKE3OLS/PS9ZLzc60MDQyM
        TIEqE3Iy+rbtYCs4wl3x/v8NpgbGW5xdjJwcEgImEn+OtzOC2EICuxkl/l606mLk4OAVEJT4
        u0MYJCwskCixtOszC0SJrMSth9eZIOJGEmfaesHibAIGEt0rr7J2MXJxiAhcYJR4fPc0M4jD
        LDCdUWLfjPtsEMt4JWa0P2WBsKUlti/fyghhi0rcXP2WHcZ+f2w+VFxEovXeWWYIW1Diwc/d
        UHEZid62m6wgh0oI1EvMOy8EsktCoINRYsrU81C7zCUu7moAu5RXwFei7f8FFpB6FgFVibUt
        6hAlLhJ7zraArWUWkJfY/nYOM0gJs4CmxPpd+hBhPone30+YYK7fMQ/GVpSYfW4X1CfiEi/f
        PYK6zENiz7pp0OAMlDi3YgrrBEa5WYgQnYVk2SyEZQsYmVcxSqYWFOempxabFhjmpZYjR+Mm
        RnDy0/LcwXj3wQe9Q4xMHIyHGCU4mJVEeC2OfYkX4k1JrKxKLcqPLyrNSS0+xGgK9OhEZinR
        5Hxg+s0riTc0NTIzM7A0MDW2MDNUEufdYfAgXkggPbEkNTs1tSC1CKaPiYNTqoEp2/uyWnuW
        1v2OeSm/T0/tkdxUV/t5w+8FEoeaF/c811u/RHeWsvifU80rAisKL7yfMW/Gos5jAi6/eutU
        zdSaA2MOLt1f+PH/6Ya/ujayplPmpknYqp85OvH/uSaF36+eLXylplmx5YHf6o7gD5OktOse
        BB3x4rt14P/2UwLKnhNTXvqEzJByMtogLXO/bLvxPIHy9Qy17wP5Lni1O2TwTK5gaPG29GU4
        cyBmsvpHz4Xtoj5hvOlChlc/Jr86fLJabsNRW+ls+0NmCapMgi6Vu7jaVnBamxn9yJ9xT6Ru
        hsfV031RN7U+7W9se8q5Oi3Ga0pFZPcKATOXFp9tSu+4H13hXnMw7lTekYpTG+8osRRnJBpq
        MRcVJwIACLTuJAcEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca
References: <CGME20210107113207epcms5p268119bdd826f36a0e5e488a5476f82ca@epcms5p2>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From 0fbcd7e386898d829d3000d094358a91e626ee4a Mon Sep 17 00:00:00 2001
From: Jie Li <jie6.li@samsung.com>
Date: Mon, 7 Dec 2020 08:05:07 +0800
Subject: [PATCH] uio: uio_pci_generic: don't fail probe if pdev->irq equals to
 IRQ_NOTCONNECTED

Some devices use 255 as default value of Interrupt Line register, and this
maybe causes pdev->irq is set as IRQ_NOTCONNECTED in some scenarios. For
example, NVMe controller connects to Intel Volume Management Device (VMD).
In this situation, IRQ_NOTCONNECTED means INTx line is not connected, not
fault. If bind uio_pci_generic to these devices, uio frame will return
-ENOTCONN through request_irq.

This patch allows binding uio_pci_generic to device with dev->irq of
IRQ_NOTCONNECTED.

Signed-off-by: Jie Li <jie6.li@samsung.com>
Acked-by: Kyungsan Kim <ks0204.kim@samsung.com>
---
 drivers/uio/uio_pci_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index b8e44d16279f..c7d681fef198 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -92,7 +92,7 @@ static int probe(struct pci_dev *pdev,
 	gdev->info.version = DRIVER_VERSION;
 	gdev->info.release = release;
 	gdev->pdev = pdev;
-	if (pdev->irq) {
+	if (pdev->irq && (pdev->irq != IRQ_NOTCONNECTED)) {
 		gdev->info.irq = pdev->irq;
 		gdev->info.irq_flags = IRQF_SHARED;
 		gdev->info.handler = irqhandler;
-- 
2.17.1

