Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A10B158B60
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 09:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgBKIkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 03:40:42 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727669AbgBKIkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 03:40:42 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 797FE2C7D398984F714B;
        Tue, 11 Feb 2020 16:40:40 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 16:40:33 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <alexandru.elisei@arm.com>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [kvm-unit-tests PATCH 0/3] arm64: minor cleanups for timer test
Date:   Tue, 11 Feb 2020 16:38:58 +0800
Message-ID: <20200211083901.1478-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

There's some minor cleanups which based on your arm/queue branch for
the timer test.  Please consider taking them if they make the code
a bit better :)

Thanks

Zenghui Yu (3):
  arm/arm64: gic: Move gic_state enumeration to asm/gic.h
  arm64: timer: Use the proper RDist register name in GICv3
  arm64: timer: Use existing helpers to access counter/timers

 arm/timer.c          | 27 ++++++++++-----------------
 lib/arm/asm/gic-v3.h |  4 ++++
 lib/arm/asm/gic.h    |  7 +++++++
 3 files changed, 21 insertions(+), 17 deletions(-)

-- 
2.19.1


