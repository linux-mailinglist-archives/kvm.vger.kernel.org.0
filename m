Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA57024651E
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 13:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgHQLIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 07:08:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58546 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726617AbgHQLIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 07:08:06 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 20E8964B12CB55BA6D23;
        Mon, 17 Aug 2020 19:08:01 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 19:07:50 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 0/2] KVM: arm64: Some fixes and code adjustments for pvtime ST
Date:   Mon, 17 Aug 2020 19:07:26 +0800
Message-ID: <20200817110728.12196-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During picking up pvtime LPT support for arm64, I do some trivial fixes for
pvtime ST.

change log:

v2:
 - Add Andrew's and Steven's R-b.
 - Correct commit message of the first patch.
 - Drop the second patch.

Keqian Zhu (2):
  KVM: arm64: Some fixes of PV-time interface document
  KVM: arm64: Use kvm_write_guest_lock when init stolen time

 Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
 arch/arm64/kvm/pvtime.c               | 6 +-----
 2 files changed, 4 insertions(+), 8 deletions(-)

-- 
1.8.3.1

