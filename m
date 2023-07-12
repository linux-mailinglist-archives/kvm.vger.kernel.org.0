Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D1A74FDDB
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 05:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjGLDhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 23:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjGLDhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 23:37:03 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27B110C0
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 20:37:01 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R13MH61yHzBR5l4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 11:36:59 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689133019; x=1691725020; bh=hjXFyhsAZ/wnrRUPYfcEPXDIVA4
        ZThOmbKHnKC59n9c=; b=kWhmE1/StW2GUYDXKrQUnSBEceTWdKsLFiydLQTk9Qq
        dsItnFvVOWPM9HGga/RUpgL+ryj5bpKHssdR3shjVHAjH3FNz7b/yzHUIh/Z69ve
        REi0rt6LKZLf2Z32apdgUWCL/RO7usxFEFZu11i0PhNfOVCztNyC0IFZsu5v45ZN
        k2pggyNC/zuolFwmI8JkbyXsm6uvBQX6xwfdQP0kqpNDgv0vH7TzBxI0cxO8JtZs
        LwIFECAscNoX6sPgSk7XURtOJmP34i66FPeznfIDtWUwIvUMyNOA2mHS22vq0J1S
        yyU8ueUdwVa8Rri2xcuMAGLf8F5sJ6drjusZUXRbqoA==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mreNzLo1mDQS for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 11:36:59 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R13MH2fRhzBHXgq;
        Wed, 12 Jul 2023 11:36:59 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 11:36:59 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix warning in lapic.h
In-Reply-To: <tencent_E1ECE7495AFECC3FFE961A6BFAB2CAC82F05@qq.com>
References: <tencent_E1ECE7495AFECC3FFE961A6BFAB2CAC82F05@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <c968eaa74e0d3ddac2879130eb3d8c7e@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch warning is removed:
WARNING: please, no space before tabs

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/lapic.h | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..1925c956324c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -45,7 +45,7 @@ enum lapic_lvt_entry {

  struct kvm_timer {
      struct hrtimer timer;
-    s64 period;                 /* unit: ns */
+    s64 period;                /* unit: ns */
      ktime_t target_expiration;
      u32 timer_mode;
      u32 timer_mode_mask;
