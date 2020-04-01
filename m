Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCC819A92C
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 12:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgDAKIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 06:08:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbgDAKIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 06:08:42 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 85F868AB10D6DBB20258;
        Wed,  1 Apr 2020 18:08:35 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.173.222.58) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Apr 2020 18:08:27 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        Jingyi Wang <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
Date:   Wed, 1 Apr 2020 18:08:10 +0800
Message-ID: <20200401100812.27616-1-wangjingyi11@huawei.com>
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
to add some simple performance test in kut to measure the cost of
interrupts. X86 arch has implemented similar test.

Jingyi Wang (2):
  arm/arm64: gic: Add IPI latency test
  arm/arm64: Add vtimer latency test

 arm/gic.c   | 27 +++++++++++++++++++++++++++
 arm/timer.c | 11 +++++++++++
 2 files changed, 38 insertions(+)

-- 
2.19.1


