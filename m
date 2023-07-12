Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E174FD54
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 04:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjGLC5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 22:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjGLC5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 22:57:36 -0400
Received: from mail.208.org (unknown [183.242.55.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA56E60
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 19:57:33 -0700 (PDT)
Received: from mail.208.org (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTP id 4R12Td3dR7zBS5pl
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 10:57:25 +0800 (CST)
Authentication-Results: mail.208.org (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)" header.d=208.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=208.org; h=
        content-transfer-encoding:content-type:message-id:user-agent
        :references:in-reply-to:subject:to:from:date:mime-version; s=
        dkim; t=1689130645; x=1691722646; bh=I+1oVhI7HyCYy6UbFxBzWprF38a
        2WdZpKYom3O4ZeZ4=; b=bZnZBZmjskDXnMyxw+AOW00H3aBqYKbJE6XiP3DLTJr
        qLzSn0XoHv2TrWOUGQ6WFEa6rKCNAHRCxgTeiBatC23n0hJS29Vb5c2FmAkqzEnn
        rV9BfFpMRjJLSUIX0AmvOhVpRSt9SHRThd7vQp8M+FB6sSOgLiB/nkp+OUq+ubi1
        9gP2ZMmzhJiTJrk6hYzDvRuPACK8T0GsXxTqQ6qB/OdXDyFH4ODw4JUbUaPPXUKk
        zJ5esyeUTajHklNazQKIATDnQCzH5DY1HJhRRnqdsKTn2uTLgYlh2Am8zyw9b+if
        ccvSjjfLfvonXdPSA2qAVlil+DgtpFy/kFYAvKkMdjg==
X-Virus-Scanned: amavisd-new at mail.208.org
Received: from mail.208.org ([127.0.0.1])
        by mail.208.org (mail.208.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zKOvJ2S-WAap for <kvm@vger.kernel.org>;
        Wed, 12 Jul 2023 10:57:25 +0800 (CST)
Received: from localhost (email.208.org [127.0.0.1])
        by mail.208.org (Postfix) with ESMTPSA id 4R12Tc70yRzBJ8lL;
        Wed, 12 Jul 2023 10:57:24 +0800 (CST)
MIME-Version: 1.0
Date:   Wed, 12 Jul 2023 10:57:24 +0800
From:   shijie001@208suo.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH] KVM: x86:Fix warnings in irq.c
In-Reply-To: <tencent_C058FF13993C887FC16D1E16D72597914306@qq.com>
References: <tencent_C058FF13993C887FC16D1E16D72597914306@qq.com>
User-Agent: Roundcube Webmail
Message-ID: <d7a492c39633d9373cf29e7ac02a30b1@208suo.com>
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
WARNING: Missing a blank line after declarations

Signed-off-by: Jie Shi <shijie001@208suo.com>
---
  arch/x86/kvm/irq.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b2c397dd2bc6..e03757eee8c9 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -136,6 +136,7 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
  int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
  {
      int vector = kvm_cpu_get_extint(v);
+
      if (vector != -1)
          return vector;            /* PIC */
