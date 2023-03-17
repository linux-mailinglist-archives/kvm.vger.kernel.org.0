Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322696BE967
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCQMhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCQMhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:37:46 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D598C24134
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j13so4942722pjd.1
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679056599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E5PF3sqkFmxXngJQJQHQ0RIO725f9lA9+mqcaHUiq3c=;
        b=EWpbQwx8Widt3BIdhrfMY5Nauao90WBf7m5d8GzkIFKqrtUuGdiWQETekCYtaXmZLc
         D5aHQ/9oQEJ70RzfGExhknVfs+KZJIB6Br0QZz/NfIaLTHVa9IPWnQChoYwSHQbLbnRV
         bBXet7j8G54dojD3aSSaxv2q3H2T1G7xE4oXlTZi/EfDxfkBAXDgCrAVi0pWqrui/KCp
         JNR6SWAM4b27n3pWPQmuGzqQqjkoMXShUFFfrbf5yJ79tY0/KhmYKqBG5c/PCnYchBBd
         AMGVxsdx06Mdxd3mOv+qikfYvjj8uufD39LKZMVCDbkQhhY8nvarPCJzYVeYVWA+qFRB
         wNIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679056599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E5PF3sqkFmxXngJQJQHQ0RIO725f9lA9+mqcaHUiq3c=;
        b=UuL2625LO3KLrPjZJ9hB1C9vPtox0r04fiHSkptrlY4/v5IayZMJevjnUEbzT6v6+j
         tg/rpttr3fCr/I7c008jjg/5tsA2Pxvub2q5F6QnXolZu7TpxRT9I88E8R6z7V3uu4OD
         MKq0ZneGCmF3Ce2DZBaJ1kLxk8oyW1lspV2eUnk3YEJm2wtK0LOhzr/jX/pt1yTJenBn
         DcgeljHm84O3Yq5uaJJysaJxKeoICrLgtz70fUke+VY9LOd6sfPiuhn+/uodzPAUby2R
         3Q6ZGSbFMt9zXM542suOHis5i0JU52Jk1cNvF7A4OIIFYVkxt4gD07ZLzmYsgS5xPqyx
         gVDw==
X-Gm-Message-State: AO0yUKVeTkePswnp9obGhmz3eji1gXe0T2qOQLgUg8u9PpOKuOWQKoFR
        ejYWQU7q3DJ274pD9hh9LzZVFNtnMSk=
X-Google-Smtp-Source: AK7set/r/9tsLIqaVCwWrJ+ljYodip91oYy0rj6NR5ublKD7VENvXuoiFu7Ci7CtZmpPRDXWdlYjNg==
X-Received: by 2002:a17:902:fa8b:b0:19d:14c:e590 with SMTP id lc11-20020a170902fa8b00b0019d014ce590mr5864922plb.9.1679056599077;
        Fri, 17 Mar 2023 05:36:39 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902b28400b001a19d4592e1sm1430990plr.282.2023.03.17.05.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 05:36:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 1/7] MAINTAINERS: Update powerpc list
Date:   Fri, 17 Mar 2023 22:36:08 +1000
Message-Id: <20230317123614.3687163-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM development on powerpc has moved to the Linux on Power mailing list,
as per linux.git commit 19b27f37ca97d ("MAINTAINERS: Update powerpc KVM
entry").

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 649de50..b545a45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -79,7 +79,7 @@ M: Laurent Vivier <lvivier@redhat.com>
 M: Thomas Huth <thuth@redhat.com>
 S: Maintained
 L: kvm@vger.kernel.org
-L: kvm-ppc@vger.kernel.org
+L: linuxppc-dev@lists.ozlabs.org
 F: powerpc/
 F: lib/powerpc/
 F: lib/ppc64/
-- 
2.37.2

