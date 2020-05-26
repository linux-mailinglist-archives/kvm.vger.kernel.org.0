Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690F71C8B11
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 14:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgEGMgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 08:36:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37856 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726235AbgEGMgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 08:36:38 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C0507E11C10FEA00DF20;
        Thu,  7 May 2020 20:36:31 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 7 May 2020 20:36:22 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>, <suzuki.poulose@arm.com>
CC:     <maz@kernel.org>, <christoffer.dall@arm.com>,
        <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
        <kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <zhengxiang9@huawei.com>, <amurray@thegoodpenguin.co.uk>,
        <eric.auger@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH resend 0/2] KVM: arm64: Unify stage2 mapping for THP backed memory
Date:   Thu, 7 May 2020 20:35:44 +0800
Message-ID: <20200507123546.1875-1-yuzenghui@huawei.com>
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

This series was originally posted by Suzuki K Poulose a year ago [*],
with the aim of cleaning up the handling of the stage2 huge mapping for
THP. I think this still helps to make the current code cleaner, so
rebase it on top of kvmarm/master and repost it for acceptance.

Thanks!

[*] https://lore.kernel.org/kvm/1554909832-7169-1-git-send-email-suzuki.poulose@arm.com/

Suzuki K Poulose (2):
  KVM: arm64: Clean up the checking for huge mapping
  KVM: arm64: Unify handling THP backed host memory

 virt/kvm/arm/mmu.c | 121 ++++++++++++++++++++++++---------------------
 1 file changed, 65 insertions(+), 56 deletions(-)

-- 
2.19.1


