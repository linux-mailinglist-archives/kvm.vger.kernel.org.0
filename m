Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAC729D454
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgJ1VvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:51:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:6920 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgJ1VvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 17:51:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CLfrL4rvqz6wXN;
        Wed, 28 Oct 2020 15:11:30 +0800 (CST)
Received: from [10.174.187.138] (10.174.187.138) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 28 Oct 2020 15:11:20 +0800
Message-ID: <5F991998.2020108@huawei.com>
Date:   Wed, 28 Oct 2020 15:11:20 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     <pbonzini@redhat.com>, <chenhc@lemote.com>, <pasic@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <mtosatti@redhat.com>,
        <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-s390x@nongnu.org>, <zhengchuan@huawei.com>,
        <zhang.zhanghailiang@huawei.com>
Subject: [PATCH 0/4] kvm: Add a --enable-debug-kvm option to configure
References: <5F97FD61.4060804@huawei.com>
In-Reply-To: <5F97FD61.4060804@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current 'DEBUG_KVM' macro is defined in many files, and turning on
the debug switch requires code modification, which is very inconvenient,
so this series add an option to configure to support the definition of
the 'DEBUG_KVM' macro.
In addition, patches 3 and 4 also make printf always compile in debug output
which will prevent bitrot of the format strings by referring to the
commit(08564ecd: s390x/kvm: make printf always compile in debug output).

alexchen (4):
  configure: Add a --enable-debug-kvm option to configure
  kvm: replace DEBUG_KVM to CONFIG_DEBUG_KVM
  kvm: make printf always compile in debug output
  i386/kvm: make printf always compile in debug output

 accel/kvm/kvm-all.c | 11 ++++-------
 configure           | 10 ++++++++++
 target/i386/kvm.c   | 11 ++++-------
 target/mips/kvm.c   |  6 ++++--
 target/s390x/kvm.c  |  6 +++---
 5 files changed, 25 insertions(+), 19 deletions(-)

-- 
2.19.1
