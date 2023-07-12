Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7603774FEF0
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 08:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjGLGCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 02:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjGLGCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 02:02:41 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706A6E49
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 23:02:39 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R16bH5JygzBR5lL
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 14:02:35 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689141755; x=1691733756; bh=XftksNkbaGgeHrSFH4tY5Gx98LB
        UKIB1AKJqkGcq9Oc=; b=jBGylL5XVKqXlX04z1cI2Nms+NetQG51vXOVl8B89Vt
        XYGD+HJ5pdPuCRf8N1tdewfYQBdJ3nQO695FT20sCKueGLtD5lO2RrfyjiDZFHZm
        DiwX35Y7IQUPMg9r0ng83K+2FheVraei2M/mkrp4MY+RBly+x62VxveDf7K4RNHb
        FZIYJ6fe1OR20ACfpHmP7SlOIdS5PQOQd1zzRvvXVniqY6uE6xizXmpX5/UVcZ6h
        L9n6ydg/ug7DjDE2ugH5v8LI5Z72U2j2p86U5hSca/izwrBXbJbJQA8u6JSgRgmo
        uBivVlR1/T37C5Hc7a9qB4/awQYV6CfYFXhVfays6jw==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ByL2FDGa8VPu for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 14:02:35 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R16bH2L4qzBHXhj;
        Wed, 12 Jul 2023 14:02:35 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 14:02:35 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org
Cc:     hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com
Subject: [PATCH] KVM: x86: Fix error & warning in i8254.h
In-Reply-To: <tencent_EA89B0582F8F8C3CC33C9F7AE407FC956F09@qq.com>
References: <tencent_EA89B0582F8F8C3CC33C9F7AE407FC956F09@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <f1a0806ffdb74240f9bfbba9f4ece732@208suo.com>
X-Sender: shijie001@208suo.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,SPF_HELO_FAIL,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following checkpatch error & warning are removed:
WARNING: please, no space before tabs
ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/i8254.h | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index a768212ba821..89eab61cfc51 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -27,7 +27,7 @@ struct kvm_kpit_state {
      struct kvm_kpit_channel_state channels[3];
      u32 flags;
      bool is_periodic;
-    s64 period;                 /* unit: ns */
+    s64 period;                /* unit: ns */
      struct hrtimer timer;

      struct mutex lock;
@@ -52,7 +52,7 @@ struct kvm_pit {
  #define KVM_SPEAKER_BASE_ADDRESS    0x61
  #define KVM_PIT_MEM_LENGTH        4
  #define KVM_PIT_FREQ            1193181
-#define KVM_MAX_PIT_INTR_INTERVAL   HZ / 100
+#define KVM_MAX_PIT_INTR_INTERVAL   (HZ / 100)
  #define KVM_PIT_CHANNEL_MASK        0x3

  struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags);
