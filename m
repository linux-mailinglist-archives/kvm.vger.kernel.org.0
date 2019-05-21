Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3348C247C2
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 08:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfEUGHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 02:07:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40177 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfEUGHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 02:07:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id u17so8482193pfn.7;
        Mon, 20 May 2019 23:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sbuzaaWsGooYKRF5hbHXqNhTGEcasdrIczbLRR2hHHM=;
        b=saXJWYw2jHbhxim/0lwRfNiV2/djBlPQ0xI0+lFcXra2FD1zMCQXuXa4MrdDYpvZip
         H9iA2q4ty2ZLuw66wIlkLY1712YH5n5vbZsQrf85uOEiqikX9AQCALDmF7+8qj5S5vpr
         aa8f2k4Bp4kOuntmJEzQikmD4oeFiqE3FNOS8LBKX1HU/YXThyZVeTJeqPelBhX45QTz
         L2rBuX301sv42jVomroF9Z4fX1QorWaMM3yoUWNCdp0chKPxxNhC3DLqK8A1A6iFhRhQ
         TaqMjedI2GmsxD/v2vDALrg6S3hL45fy9rGhFQIx6clAPsxeIGoJD4hL5FKPjWOso5Rz
         BccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sbuzaaWsGooYKRF5hbHXqNhTGEcasdrIczbLRR2hHHM=;
        b=dE6HesCMrACar16chqqOVyRxycyXuHFAiTnEFXH4RblK0xJjAxd5o8/vvroDKAoYL/
         7AX4B3DCG1QaSRi+YuSfHR7AqIZqeDUvWpgqb/inMqBZqOOdJaYsg3RV8FzYqxZSYhzm
         kdD+RlSIf65gOVl6DPQ3nN8geJkxBY166ZXji8kSldcrTxTtV70SIExBE9jFkRDqXrzv
         Cz7eHIUQsYoiT6qlca0710hju+REYqA+3WWQUYZ8BsRvtqR243lFg88vnxQ9Oqh4QAXN
         DKK5WSPCebK3dRGx3kxSdk2g4JkwbMJ9PEMfJwFIwLbEvbi/V6693TJbjwQfg0pcKabi
         4j1A==
X-Gm-Message-State: APjAAAWQqFuH1iQ7J9SBCe1J76bGTVYkaThFBtM5+e2nFnIJtqIIErsJ
        UMeHeS+mbcd+J380udnkcM8KXljg
X-Google-Smtp-Source: APXvYqyYJfAhOFbsgbheeA9FzL945ilIFAg5nm75jDFRMsMJCNztDnsUsAARni2j8OwUhJQctAfIVQ==
X-Received: by 2002:a62:2cc2:: with SMTP id s185mr46057385pfs.106.1558418820429;
        Mon, 20 May 2019 23:07:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id a15sm2351484pgv.4.2019.05.20.23.06.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 23:07:00 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 1/3] KVM: Documentation: Add disable pause exits to KVM_CAP_X86_DISABLE_EXITS
Date:   Tue, 21 May 2019 14:06:52 +0800
Message-Id: <1558418814-6822-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Commit b31c114b (KVM: X86: Provide a capability to disable PAUSE intercepts)
forgot to add the KVM_X86_DISABLE_EXITS_PAUSE into api doc. This patch adds 
it.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 Documentation/virtual/kvm/api.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ba6c42c..33cd92d 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -4893,6 +4893,7 @@ Valid bits in args[0] are
 
 #define KVM_X86_DISABLE_EXITS_MWAIT            (1 << 0)
 #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
+#define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
-- 
2.7.4

