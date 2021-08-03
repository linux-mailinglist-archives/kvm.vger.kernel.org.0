Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADAF3DE4CD
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 05:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhHCDuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 23:50:25 -0400
Received: from mx21.baidu.com ([220.181.3.85]:42104 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233710AbhHCDtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 23:49:31 -0400
Received: from BC-Mail-HQEx02.internal.baidu.com (unknown [172.31.51.58])
        by Forcepoint Email with ESMTPS id 4193EA80AB2BD2529E04;
        Tue,  3 Aug 2021 11:49:11 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-HQEx02.internal.baidu.com (172.31.51.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 3 Aug 2021 11:49:10 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 3 Aug 2021 11:49:10 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <hca@linux.ibm.com>, <gor@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <cohuck@redhat.com>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <chaitanya.kulkarni@wdc.com>, <axboe@kernel.dk>
CC:     <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH 0/4] s390: Make use of PAGE_ALIGN/PAGE_MASK/PFN_UP helper macro
Date:   Tue, 3 Aug 2021 11:49:00 +0800
Message-ID: <20210803034904.1579-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex32.internal.baidu.com (172.31.51.26) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

it's a refactor to make use of PAGE_ALIGN/PAGE_MASK/PFN_UP helper macro

Cai Huoqing (4):
  s390/scm_blk: Make use of PAGE_ALIGN helper macro
  s390/vmcp: Make use of PFN_UP helper macro
  vfio-ccw: Make use of PAGE_MASK/PFN_UP helper macro
  s390/cio: Make use of PAGE_ALIGN helper macro

 drivers/s390/block/scm_blk.c   |  2 +-
 drivers/s390/char/vmcp.c       | 10 ++++------
 drivers/s390/cio/itcw.c        |  2 +-
 drivers/s390/cio/vfio_ccw_cp.c |  8 ++++----
 4 files changed, 10 insertions(+), 12 deletions(-)

-- 
2.25.1

