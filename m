Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF55F211A4A
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 04:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgGBCvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 22:51:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgGBCvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 22:51:50 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 86C42AF8495509856FFE;
        Thu,  2 Jul 2020 10:51:46 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 10:51:36 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH v2 0/8] arm/arm64: Add IPI/LPI/vtimer latency test
Date:   Thu, 2 Jul 2020 10:50:41 +0800
Message-ID: <20200702025049.6896-1-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the development of arm gic architecture, we think it will be useful
to add some performance test in kut to measure the cost of interrupts.
In this series, we add GICv4.1 support for ipi latency test and
implement LPI/vtimer latency test.

This series of patches has been tested on GICv4.1 supported hardware.

* From v1:
  - Fix spelling mistake
  - Use the existing interface to inject hw sgi to simply the logic
  - Add two separate patches to limit the running times and time cost
    of each individual micro-bench test

Jingyi Wang (8):
  arm64: microbench: get correct ipi recieved num
  arm64: microbench: Use the funcions for ipi test as the general
    functions for gic(ipi/lpi/timer) test
  arm64: microbench: gic: Add gicv4.1 support for ipi latency test.
  arm64: its: Handle its command queue wrapping
  arm64: microbench: its: Add LPI latency test
  arm64: microbench: Allow each test to specify its running times
  arm64: microbench: Add time limit for each individual test
  arm64: microbench: Add vtimer latency test

 arm/micro-bench.c          | 218 +++++++++++++++++++++++++++++++------
 lib/arm/asm/gic-v3.h       |   3 +
 lib/arm/asm/gic.h          |   1 +
 lib/arm64/gic-v3-its-cmd.c |   3 +-
 4 files changed, 189 insertions(+), 36 deletions(-)

-- 
2.19.1


