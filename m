Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1C911A472
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 07:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfLKG0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 01:26:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7215 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726676AbfLKG0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 01:26:48 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 52BEC7B47CD224B69C03;
        Wed, 11 Dec 2019 14:26:45 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Dec 2019
 14:26:38 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 0/6] Fix various comment errors
Date:   Wed, 11 Dec 2019 14:26:19 +0800
Message-ID: <1576045585-8536-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Fix various comment mistakes, such as typo, grammar mistake, out-dated
function name, writing error and so on. It is a bit tedious and many
thanks for review in advance.

Miaohe Lin (6):
  KVM: Fix some wrong function names in comment
  KVM: Fix some out-dated function names in comment
  KVM: Fix some comment typos and missing parentheses
  KVM: Fix some grammar mistakes
  KVM: hyperv: Fix some typos in vcpu unimpl info
  KVM: Fix some writing mistakes

 arch/x86/include/asm/kvm_host.h       | 2 +-
 arch/x86/kvm/hyperv.c                 | 6 +++---
 arch/x86/kvm/ioapic.c                 | 2 +-
 arch/x86/kvm/lapic.c                  | 4 ++--
 arch/x86/kvm/vmx/nested.c             | 2 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c                | 8 ++++----
 virt/kvm/kvm_main.c                   | 6 +++---
 8 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.19.1

