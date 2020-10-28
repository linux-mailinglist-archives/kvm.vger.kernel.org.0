Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C9229D807
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgJ1W3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:29:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6703 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387485AbgJ1W27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 18:28:59 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CLfrV41sFzkbRj;
        Wed, 28 Oct 2020 15:11:38 +0800 (CST)
Received: from [10.174.187.138] (10.174.187.138) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Wed, 28 Oct 2020 15:11:26 +0800
Message-ID: <5F99199D.2020601@huawei.com>
Date:   Wed, 28 Oct 2020 15:11:25 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     <pbonzini@redhat.com>, <chenhc@lemote.com>, <pasic@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <mtosatti@redhat.com>,
        <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-s390x@nongnu.org>, <zhengchuan@huawei.com>,
        <zhang.zhanghailiang@huawei.com>
Subject: [PATCH 1/4] configure: Add a --enable-debug-kvm option to configure
References: <5F97FD61.4060804@huawei.com> <5F991331.4020604@huawei.com>
In-Reply-To: <5F991331.4020604@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch allows CONFIG_DEBUG_KVM to be defined when passing
an option to the configure script.

Signed-off-by: AlexChen <alex.chen@huawei.com>
---
 configure | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/configure b/configure
index e6754c1e87..2cdef5be4c 100755
--- a/configure
+++ b/configure
@@ -338,6 +338,7 @@ pvrdma=""
 gprof="no"
 debug_tcg="no"
 debug="no"
+debug_kvm="no"
 sanitizers="no"
 tsan="no"
 fortify_source=""
@@ -1022,11 +1023,16 @@ for opt do
   ;;
   --disable-debug-tcg) debug_tcg="no"
   ;;
+  --enable-debug-kvm) debug_kvm="yes"
+  ;;
+  --disable-debug-kvm) debug_kvm="no"
+  ;;
   --enable-debug)
       # Enable debugging options that aren't excessively noisy
       debug_tcg="yes"
       debug_mutex="yes"
       debug="yes"
+      debug_kvm="yes"
       strip_opt="no"
       fortify_source="no"
   ;;
@@ -1735,6 +1741,7 @@ disabled with --disable-FEATURE, default is enabled if available:
   module-upgrades try to load modules from alternate paths for upgrades
   debug-tcg       TCG debugging (default is disabled)
   debug-info      debugging information
+  debug-kvm       KVM debugging support (default is disabled)
   sparse          sparse checker
   safe-stack      SafeStack Stack Smash Protection. Depends on
                   clang/llvm >= 3.7 and requires coroutine backend ucontext.
@@ -5929,6 +5936,9 @@ fi
 if test "$debug_tcg" = "yes" ; then
   echo "CONFIG_DEBUG_TCG=y" >> $config_host_mak
 fi
+if test "$debug_kvm" = "yes" ; then
+  echo "CONFIG_DEBUG_KVM=y" >> $config_host_mak
+fi
 if test "$strip_opt" = "yes" ; then
   echo "STRIP=${strip}" >> $config_host_mak
 fi
-- 
2.19.1
