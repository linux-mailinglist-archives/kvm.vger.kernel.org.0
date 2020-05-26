Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB58B1A8E66
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 00:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634292AbgDNWMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 18:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732548AbgDNWMq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 18:12:46 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D9FC061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:12:45 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id o24so894755uap.13
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RAayT8kRFP0BFo9zUWGRqbKZGPtkh0dg4G9PTqU2eyE=;
        b=VNoDXdWQ4hgDGmTNDZztX29k4ybyBKFOT69IVq8r9gQQUUFk9rFJhSsYSkT95mVZi5
         tbW92GOmjdEWj9NW/IZcNRgH0FB+33Oi1kSr8xSwcfVidA42k+tIS1jCmUTPVIIZmj8j
         G5Lgnk4Y3nJ4EF1ErYWCIU48YTn7je1ibaL4R360d7sWECbS55/9eI0txIsPSCZjOvMW
         yzVACLY3zMZP6yXbdR7IIiniCIf8hROMap1EohbaZ8G6WcCBOarhi3+L7HJ0FS/t3Ue5
         hpcJS5k4EtQ6vR3DixsXqI+CwFNB8Y14zIwN0CwUSknkMSeRZ9KsT+OvBDlKDaYbhMf9
         rLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RAayT8kRFP0BFo9zUWGRqbKZGPtkh0dg4G9PTqU2eyE=;
        b=QLV63xakIK0lqDuZptP280p8CZaCmhDJcTxGlYnWEK1rmESnGpJyN6LjwSRCOyXlfd
         sPQ2tcbV78RL1rvgknjWvk6AOLPWXXHFo9LcAZOSBz80wuPjfdmL+84gF69aGRtstl38
         WXSYDS4MupkxWHhYcY7EeAjBmFUgJH2DdqH0/OVhcVzWefgkN6lywLxpfo/vhkM4PI3p
         vLIqNOJhtRNxh3/LJkPquSbCvtA/hbFKmqJdb5ZixhKmZNH5f5WosjYxhR29lKY7/5IQ
         ma7+1QGgwqPkGlULR0bb07wz4YObI7Q4UjQbDFdl3ZNxu/NeDIapOqimnwUeObMTTt1+
         9UBg==
X-Gm-Message-State: AGi0PuZ5USpYBUU7DCXDd0Q4uWI0vuYaiHEfh3ufOlfP8iQi9k8m0ddf
        opk4qFf9TuOZQhjjXifm52zxc2QqOO42I2J9wUj/7aF4UbgDG7JxcN1/ANZbyXk28HQEun0HRt1
        AjYQOrPmPvqSEZE3lPACqu0zaE5sG8e58QR+Vyo/6YjaqoTsfxGYGfsGF1A==
X-Google-Smtp-Source: APiQypKkwVomJTrVzd6NPA2wKmGmVbxUAHKF3gY2BAZFb8X0YzJv6npWFeCQItv3JmGK5gEzt612/Kx4JOM=
X-Received: by 2002:ab0:20d6:: with SMTP id z22mr2303061ual.121.1586902364143;
 Tue, 14 Apr 2020 15:12:44 -0700 (PDT)
Date:   Tue, 14 Apr 2020 22:12:41 +0000
Message-Id: <20200414221241.134103-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH] kvm: nVMX: match comment with return type for nested_vmx_exit_reflected
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nested_vmx_exit_reflected() returns a bool, not int. As such, refer to
the return values as true/false in the comment instead of 1/0.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbc9ea2de28f9..2ca53dc362731 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5534,7 +5534,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 }
 
 /*
- * Return 1 if we should exit from L2 to L1 to handle an exit, or 0 if we
+ * Return true if we should exit from L2 to L1 to handle an exit, or false if we
  * should handle it ourselves in L0 (and then continue L2). Only call this
  * when in is_guest_mode (L2).
  */
-- 
2.26.0.110.g2183baf09c-goog

