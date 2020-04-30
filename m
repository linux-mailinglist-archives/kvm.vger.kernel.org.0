Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEC81C089C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 22:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgD3Uyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 16:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgD3Uyx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 16:54:53 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69644C035495
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 13:54:53 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id v38so3780360qvf.6
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 13:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=massaru-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYotVXEQ7QSaXZH0Cb6CySMSy1hNmT60Cfqey+kK7ik=;
        b=jnjRwyAu+dul5Y4kKLE7Ghb/Vc5TscG+yAoDRRIloYrY59wrKC6a8XzxjHt8F1Dj0e
         VFMLTpT+9U/DWo9TVhqTr+G/yhBPumcPucHbAZ8QiJUk51xU0Af6cSBZ48nzqPtCUL5e
         bjeUwvSs9OL5V9YXvXwZ4I9NmO9UA5IG0n1ZCQnT7JOYuDdGUHxjTspOnSc5Ki4BNAiZ
         bfU1A9oV4+HjOYT1mdjkiMR3EBDEOUP+Andpppt7WtwCwDQlPTXrdxhcv7r5a9SpgWbm
         kMK46SIX/uy11edzTFrZ6yLt8PJjxua6QkvIyadi2JXfNnT0YwilHmtEMO/Ju5Ya24y7
         +x4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WYotVXEQ7QSaXZH0Cb6CySMSy1hNmT60Cfqey+kK7ik=;
        b=MtyiHMdHYzLqmVwJHg6brjSNaMVvCBJJS8Z7QcE1+4aRP9YBmwufncC07k7IsxV+LM
         D0r/PEpwo8pzwgaNVrCFKAGUWwPmuwxZGw3O78d/m7oHgUdJVRIlXDHrL4ksBBXv/PN0
         JcttMywT6efbUOoWFVgk2KagSZR2fEF9+RTpUV16kGCBjX4i+HR6UGu4+dXU1A+oJyaD
         cBaHArHhpXpjn/ygaElmeFbiv7eUEoWjoikLexI7emrvRa10hvcdE2ZeAhuy5iAUpgBi
         OXlEcm0oSoBKuWlbDdz9Cs65CKGQ4Dg2SCp9tx9NVug94oa2SZzApU1oahHr7QVfy9tF
         giYw==
X-Gm-Message-State: AGi0Pua6M94kYasARN4HD2c22PYuByvK2W/bEcZaJyFs1uTtt7mEWHMf
        6kKn/BxkpnYVS+jUzJfas/WIkg==
X-Google-Smtp-Source: APiQypK0h2W3QvMGCUPB12GV8ymVk7gxiCl0cTc0DUvsoGMLKTbfcrDwWZOkdVEW+vKkXVSFxmr5hg==
X-Received: by 2002:a05:6214:cf:: with SMTP id f15mr816040qvs.59.1588280092358;
        Thu, 30 Apr 2020 13:54:52 -0700 (PDT)
Received: from bbking.lan ([2804:14c:4a5:36c::cd2])
        by smtp.gmail.com with ESMTPSA id t7sm652804qtr.93.2020.04.30.13.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 13:54:51 -0700 (PDT)
From:   Vitor Massaru Iha <vitor@massaru.org>
To:     linux-doc@vger.kernel.org
Cc:     pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendanhiggins@google.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] Documentation: fix `make htmldocs ` warning
Date:   Thu, 30 Apr 2020 17:54:47 -0300
Message-Id: <20200430205447.93458-1-vitor@massaru.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix 'make htmldocs' warning:
Documentation/virt/kvm/amd-memory-encryption.rst:76: WARNING: Inline literal start-string without end-string.

Signed-off-by: Vitor Massaru Iha <vitor@massaru.org>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index c3129b9ba5cb..57c01f531e61 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -74,7 +74,7 @@ should point to a file descriptor that is opened on the ``/dev/sev``
 device, if needed (see individual commands).
 
 On output, ``error`` is zero on success, or an error code.  Error codes
-are defined in ``<linux/psp-dev.h>`.
+are defined in ``<linux/psp-dev.h>``.
 
 KVM implements the following commands to support common lifecycle events of SEV
 guests, such as launching, running, snapshotting, migrating and decommissioning.
-- 
2.25.1

