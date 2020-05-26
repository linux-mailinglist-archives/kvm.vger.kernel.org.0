Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9051D674A
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 12:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgEQKLV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 06:11:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55116 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727043AbgEQKLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 06:11:21 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EDB92EA9E14D29C6CA83;
        Sun, 17 May 2020 18:11:18 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.173.222.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sun, 17 May 2020 18:11:12 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <wangjingyi11@huawei.com>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>
Subject: [kvm-unit-tests PATCH 0/6] arm64: add IPI/LPI/vtimer latency
Date:   Sun, 17 May 2020 18:08:54 +0800
Message-ID: <20200517100900.30792-1-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the development of arm gic architecture, we think it will be useful
to add some performance test in kut to measure the cost of interrupts.
In this series, we add GICv4.1 support for ipi latency test and
implement LPI/vtimer latency test.

Jingyi Wang (6):
  arm64: microbench: get correct ipi recieved num
  arm64: microbench: Use the funcions for ipi test as the general
    functions for gic(ipi/lpi/timer) test.
  arm64: microbench: gic: Add gicv4.1 support for ipi latency test.
  arm64: its: Handle its command queue wrapping
  arm64: microbench: its: Add LPI latency test.
  arm64: microbench: Add vtimer latency test

 arm/micro-bench.c          | 215 +++++++++++++++++++++++++++++++------
 lib/arm/asm/gic-v3.h       |   5 +
 lib/arm/asm/gic.h          |   1 +
 lib/arm64/gic-v3-its-cmd.c |   3 +-
 4 files changed, 192 insertions(+), 32 deletions(-)

-- 
2.19.1


