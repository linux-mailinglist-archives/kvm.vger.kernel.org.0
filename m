Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2191B415D08
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbhIWLtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 07:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240617AbhIWLts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 07:49:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5421C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 04:48:16 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g8so22523334edt.7
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 04:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehta71HGYsmwT29qXhdqAna3kd2+/JsDVe74ncaM1OE=;
        b=o0SSWas6D5OroegqjSQ1/eyb3PTG4zOUEVI5zbOROAyoLWJly6p6fWlc6S4x1SERPg
         xt2jtxrogyLRzGSEN6KWyQh5pWp09ZgywiTnKTsImX4pYdol1gjWAnllxqUyPrWq7cfi
         KgJSvWi9pHwgdX40V/C8qd9zJZHPXwpiIFUkakKnhUWHncl/f/AcuE0nigQfgUeB652X
         daHpklDodvq+N73qBCvxyBZPo82lbbgal0LlfalDEf7agg4G4zNvFtt9qpT+u9oaxQ3D
         tCSrCIxKnR03tIIujs1SDqL9yBeYW+o10Up5SxNXS42ycTs7KOs0TaIwy1Qvkt2iich/
         noVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ehta71HGYsmwT29qXhdqAna3kd2+/JsDVe74ncaM1OE=;
        b=dLp4nBY8U2vHpGEViUAX3C10hL8iGo+VGy5Kcn2EEX+2jNQFVUmKwxVMzV8XUo19bT
         kjEhHuBxZDLVnxndsL3eOy/E33pOw7mm1NmyS8YaztUXTgJjkVJ53Ca6pSn2/cO5BMZ2
         p8kVbQbKR/RoU6vrdq2312MDWAvF163nSmE94WDka9PI4gg5aljkaNDuqYxri5Kv8arJ
         g0hgSxjNF13PecqWPaUl/MA4kUJ/mxBFYr00I93jmF00CrlJru4NDUlBfH0oLsJ0h4Fe
         p/1y/mUvKTTnPfgau+n+Fyn/WdKdekbv1EN4IHFW7qvPaKXGlFx5nE3yKC9VJf0KSL2L
         0unQ==
X-Gm-Message-State: AOAM5325gnzVgb7o+w+5lt8LfsZjMYzfP7cfrK5Z1pOhNUaU3VU7/c3+
        RI6t5pvAiuTJldnrMusgVPCi2dcKD/s=
X-Google-Smtp-Source: ABdhPJzHjOcEnuYkzAG5fefwpkww08r4FK/CkTcl8yJrvzXMCtPqRvSVqwjkymiAZ9kIye6JcUapjA==
X-Received: by 2002:a50:8405:: with SMTP id 5mr4858084edp.111.1632397695448;
        Thu, 23 Sep 2021 04:48:15 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cn8sm3194131edb.77.2021.09.23.04.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 04:48:15 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests] MAINTAINERS: add S lines
Date:   Thu, 23 Sep 2021 13:48:14 +0200
Message-Id: <20210923114814.229844-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark PPC as maintained since it is a bit more stagnant than the rest.

Everything else is supported---strange but true.

Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 89b21c2..4fc01a5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -56,6 +56,7 @@ Maintainers
 M: Paolo Bonzini <pbonzini@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
 M: Andrew Jones <drjones@redhat.com>
+S: Supported
 L: kvm@vger.kernel.org
 T: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
 
@@ -64,6 +65,7 @@ Architecture Specific Code:
 
 ARM
 M: Andrew Jones <drjones@redhat.com>
+S: Supported
 L: kvm@vger.kernel.org
 L: kvmarm@lists.cs.columbia.edu
 F: arm/*
@@ -74,6 +76,7 @@ T: https://gitlab.com/rhdrjones/kvm-unit-tests.git
 POWERPC
 M: Laurent Vivier <lvivier@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
+S: Maintained
 L: kvm@vger.kernel.org
 L: kvm-ppc@vger.kernel.org
 F: powerpc/*
@@ -83,6 +86,7 @@ F: lib/ppc64/*
 S390X
 M: Thomas Huth <thuth@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
+S: Supported
 R: Cornelia Huck <cohuck@redhat.com>
 R: Claudio Imbrenda <imbrenda@linux.ibm.com>
 R: David Hildenbrand <david@redhat.com>
@@ -93,6 +97,7 @@ F: lib/s390x/*
 
 X86
 M: Paolo Bonzini <pbonzini@redhat.com>
+S: Supported
 L: kvm@vger.kernel.org
 F: x86/*
 F: lib/x86/*
-- 
2.31.1

