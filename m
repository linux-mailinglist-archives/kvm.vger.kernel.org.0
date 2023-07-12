Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6027501DA
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjGLIk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjGLIkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:40:20 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CFBB1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 01:40:05 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R1B4z1ysRzBS5qs
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:40:03 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689151203; x=1691743204; bh=1Hm+s0IKnP6ZqYPgfy5KWas3L4s
        7IJiAqGYKpub4IUY=; b=ZXJezIxwdGsGI78ETwWO9jasT0BQ9bAOufx3ILqj7/E
        XVbWTaFr1nMMvAp8J8ul74AWTWkanSe+DYUPAijkZYK/mWrzQ2cOEwvYfSTUtLw1
        C7iEypALRY+dEFRRUWWwhVqseRaXmUiJf7+DW5JgPlWd4/liKoXEI59QirwDwJCy
        tAOY9rPtLQvxkhxor0kEBrePgqwt5sJhJ4q5lHOLW/zIdcZoSOIBo7GkXyoSrjBc
        xhh24kXaVo+CwbI7lZAAK7yyaSdDsAN4bRW5wDJA5IRg1xNIodUqjAHyx37hyCKi
        tvLflK/v+n5LdMoFzt37iwd/pdyEwTxzGuIsQGA8XLg==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SnUJS1wbZ7jH for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 16:40:03 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R1B4y6pK7zB77YW;
        Wed, 12 Jul 2023 16:40:02 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 16:40:02 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, mingo@redhat.com,
        mingo@redhat.com, mingo@redhat.com
Cc:     Hpa <hpa@zytor.com>, Kvm <kvm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: x86: Fix errors in vmcs12.c
In-Reply-To: <tencent_833CA5C82FF883DD2261815EDE19C9858D0A@qq.com>
References: <tencent_833CA5C82FF883DD2261815EDE19C9858D0A@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <eec40752bc900473f65ad8f94d160106@208suo.com>
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

The following checkpatch errors are removed:
ERROR: space prohibited before open square bracket '['
ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/vmx/vmcs12.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 106a72c923ca..da239ca58f90 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -4,10 +4,10 @@
  #include "vmcs12.h"

  #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
-#define FIELD(number, name)    [ROL16(number, 6)] = VMCS12_OFFSET(name)
+#define FIELD(number, name)[ROL16(number, 6)] = VMCS12_OFFSET(name)
  #define FIELD64(number, name)                        \
      FIELD(number, name),                        \
-    [ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
+    [ROL16(number##_HIGH, 6)] = (VMCS12_OFFSET(name) + sizeof(u32))

  const unsigned short vmcs12_field_offsets[] = {
      FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
