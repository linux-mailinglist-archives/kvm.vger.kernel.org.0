Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69AD367343
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 21:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbhDUTRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 15:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbhDUTQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 15:16:59 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07885C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 12:16:25 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 7-20020ac857070000b02901ba5c36e1b2so4613328qtw.21
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 12:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=v9nnmhaI+3rKYZNnvHToip4vX0d2kEHOoU/kzhzuhTM=;
        b=AMabSozBmKeff/PUqvU59eFGi+ala00I1aQqc19T2c/5xLzpov3n707ew+ymjPB1sj
         MP2eemyPUbTh/vk8fqT2pK1Ul1IX++H/9xEWydOoR5eMqphlKP1va6Li649oNwA0X4Ly
         crL7rszkmINQCQ3P372Q2+ktCmyFwbI3hwlMS3Qz+9CBu4Rdnwel5U2TXbAqeFwc9SSM
         Dco5bbKKT9rVvj0Ysh81npSSvoBUWa7Zas5xlfoK3x4ecs9l9i5mk7RDnrKJoHqtoX9r
         oapPF6uZ8jfRSn9eYEJ26i1wdIBeOTvhkmcxOg78jBdszoEKXOWhxFbn5YoAPgyTMQBy
         G6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=v9nnmhaI+3rKYZNnvHToip4vX0d2kEHOoU/kzhzuhTM=;
        b=frmAdM64ktx6Sp1SM2mXcQfD7pv69WjfkDe2lX36rmhFy1wTYCircV1t0cV5rGpCk7
         vnYx4Us6qA2FTsK15hdNSVFfIEmY+odrZn61IzaRcpmxkkHQCUB2/cgjm0IyCJpPQ9y1
         haqX05YbG87Uap7FbV0S2yuSHxj38jw8DRhwVeLNQEfOWLpqLQX0Y6Yqx5VAE3MMtnsJ
         tTD1jY1senhVEGzfNnQoKmc7yeNV2Wk8ZCwI/TtTfrKeu2QbNpg0XsnvR5jsYwoeOYih
         GH5wkGu/WQP/uLlnJF/2JibCxSehGTpqmuRlvH5cM7blvLAZEq29xn+rCz4v/OJQSKmW
         IoOg==
X-Gm-Message-State: AOAM532dmHmmq13ocN6g/TM8i1pBSxDOYDxrEqzu+V9NtmAxNAKqW5PA
        qrlI7MQ3rBjsM3MrQmlHmjgvmtiyGPUjVQ==
X-Google-Smtp-Source: ABdhPJwEm59yKHSwRJZrAiy3eX/j5n4rX/eKQT0sxP7Z1aDiYtBu6QPvi2MT5syZntyZtt/QJ9PPdYKXyz31gg==
X-Received: from mhmmm.sea.corp.google.com ([2620:15c:100:202:c919:a1bb:1eab:984c])
 (user=jacobhxu job=sendgmr) by 2002:a0c:b3c8:: with SMTP id
 b8mr30930406qvf.17.1619032584254; Wed, 21 Apr 2021 12:16:24 -0700 (PDT)
Date:   Wed, 21 Apr 2021 12:16:11 -0700
Message-Id: <20210421191611.2557051-1-jacobhxu@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [kvm-unit-tests PATCH] update git tree location in MAINTAINERS to
 point at gitlab
From:   Jacob Xu <jacobhxu@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jacob Xu <jacobhxu@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MAINTAINERS file appears to have been forgotten during the migration
to gitlab from the kernel.org. Let's update it now.

Signed-off-by: Jacob Xu <jacobhxu@google.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 54124f6..e0c8e99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -55,7 +55,7 @@ Maintainers
 -----------
 M: Paolo Bonzini <pbonzini@redhat.com>
 L: kvm@vger.kernel.org
-T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
+T:	https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
 
 Architecture Specific Code:
 ---------------------------
-- 
2.31.1.368.gbe11c130af-goog

