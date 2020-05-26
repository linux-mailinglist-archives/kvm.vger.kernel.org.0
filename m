Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC2F1CE10E
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 19:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgEKRAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 13:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730066AbgEKRAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 13:00:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F363BC061A0C
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 10:00:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so11917873wrt.5
        for <kvm@vger.kernel.org>; Mon, 11 May 2020 10:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9kWXNAxgTfIQIU7fxFBJpa0sS9+TkbaWh3pDq6++0rA=;
        b=bs1VBD1JIL44wVJ24en8AeeQKL9fARRQgMeYcZZTzIyEZ58qGou8X63Y8fF3o56azJ
         KfwXivx/UEpQpEXxj9gg0pZohGa7L13g4sNgCEns2Ax1X4TNVjJWHc202d23y8NA/6YP
         S+F37AyBsMuVYuH/HvzjOXUzjVl0gZpbNsSkhj5fps4+o3zyZOeck5H1gXNrBvfxvNJi
         hv8QVU58pW1+jKghF9OPlbd4RkGXFVNJk1PHnM0n9WttDnZ48dyNDoWQD1KgDlQS+wjB
         QMsPoPSXnVw3yqu4TR2w2pHFcOTExOMhO7kHn1Bq1dQsEXKCYo4FREkFTmNbQRvlFPym
         bXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=9kWXNAxgTfIQIU7fxFBJpa0sS9+TkbaWh3pDq6++0rA=;
        b=Owa8J08Ejn0CvWr+pqOKYnQLWC0U0TgrlftMhD2jLtrveFaPq4SEs3Z/gXTBF7rm+r
         vHaxB/cE+SR5B7mmnG8C7LuOEHTsR42wUKXpgJunm81LRiSvJqLc1KBgJW0eCj9ecogr
         DkqjBQGGEWOo6u6hZcvtE43cwlZowWoQ2Krl1PQC84QpXR8BL24slJFBdL44fnJXiCyK
         as98FVJIl87dQ5xVMkmTZqWzPi/hqccAIqaPOj9TAHRe9kLePFkrf/JffGvQsCj+gbkG
         fYlBz/kXcZ0z75OydcBbHYnCog3OloWJpb/12n37CbcSOrv+yKYK4rIIlTERQRBcl7g6
         PUxw==
X-Gm-Message-State: AGi0PuZIl03QAPwnVtlKXubWerz3vvejT95E+VcOlO9FAEYmTfsVnc4T
        9mbHzTJ3hLQZ3eM0CRqPZ8GsHjd8EHI=
X-Google-Smtp-Source: APiQypKTlfhnV9AY9ECkxury0177vlKVo++RPFjZ/bv7HU0qlkkzVUb1NxRuMceFP1oLwQwDa5isUQ==
X-Received: by 2002:adf:afd6:: with SMTP id y22mr19681325wrd.417.1589216401444;
        Mon, 11 May 2020 10:00:01 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:4c95:a679:8cf7:9fb6])
        by smtp.gmail.com with ESMTPSA id m3sm2947258wrn.96.2020.05.11.10.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 10:00:00 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH kvm-unit-tests] x86: avoid multiply defined symbol
Date:   Mon, 11 May 2020 18:59:59 +0200
Message-Id: <20200511165959.42442-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fedora 32 croaks about a symbol that is defined twice, fix it.

Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/fault_test.c |  2 +-
 lib/x86/usermode.c   |  2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
index 078dae3..e15a218 100644
--- a/lib/x86/fault_test.c
+++ b/lib/x86/fault_test.c
@@ -1,6 +1,6 @@
 #include "fault_test.h"
 
-jmp_buf jmpbuf;
+static jmp_buf jmpbuf;
 
 static void restore_exec_to_jmpbuf(void)
 {
diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index f01ad9b..f032523 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -14,7 +14,7 @@
 #define USERMODE_STACK_SIZE	0x2000
 #define RET_TO_KERNEL_IRQ	0x20
 
-jmp_buf jmpbuf;
+static jmp_buf jmpbuf;
 
 static void restore_exec_to_jmpbuf(void)
 {
-- 
2.25.2

