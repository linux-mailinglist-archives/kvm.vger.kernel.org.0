Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8794211C826
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 09:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfLLITS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 03:19:18 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728209AbfLLITQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 03:19:16 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3646C3A88C12610B275B;
        Thu, 12 Dec 2019 16:19:12 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Dec 2019
 16:19:02 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2 0/4] Fix various comment errors
Date:   Thu, 12 Dec 2019 16:18:34 +0800
Message-ID: <1576138718-32728-1-git-send-email-linmiaohe@huawei.com>
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

---
v2:
	Fix some comments according to Sean' advice and do the patch reorganizing.

Miaohe Lin (4):
  KVM: VMX: Fix some typos and out-dated function names in comments
  KVM: x86: Fix some comment typos and grammar mistakes
  KVM: Fix some writing mistakes and wrong function name in comments
  KVM: hyperv: Fix some typos in vcpu unimpl info

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

