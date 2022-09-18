Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326D45BBE6E
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiIROga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Sep 2022 10:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiIROg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Sep 2022 10:36:27 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E912220ED;
        Sun, 18 Sep 2022 07:36:27 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t65so24622841pgt.2;
        Sun, 18 Sep 2022 07:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=XMOsXthWhrmjLtejUJ/4n1w+SFC2fUyvrhVzdIwCMn4=;
        b=P96W9eY9xHRrhDWOkhcV5ZyhlFagu7vWgx1mVAuu1WXvSoaNv9S+uC0Y9Ri3gau7j9
         CTbbhHcB4ih9tEMc8X/RUsZLCRx7Cy3IZ/CoiuDNCToJHgPqtNXG/p+ol+U+WIPaIo+f
         M7NiyPUbPBi4ZZszvV2uAWbhMk9O8d8J4T52rqzkQ+tSjwHJgbNJXPVZiILFWuKj0qx3
         +C3t8E/yFQF+ZsYRjGP5+GfWe5I2IQ/O2Wsh6a0KCZWyMVoDJ6RncbVi8rVuTTuRflXP
         wt8aDv3jmczjdpDvDETGpSPce2h1GxY6F63/FinzIKBKy65Ii0vaeoNsT5QkBh7LGLyj
         MCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=XMOsXthWhrmjLtejUJ/4n1w+SFC2fUyvrhVzdIwCMn4=;
        b=oB9ux5zh9VHL7mmDIiXtO2huwfdNHKpQn4QwHdX/ietPnliOkK8MJQavvHePgABdQi
         QtGMeRWO/0EncSj4pY7IjYDcMo/dAZwq5lSXdVpUHZ4DltZpgK0f9GGFdp/r39SipElS
         7FrCapUoAfDUxAqVg8ntcVVg9GaW2Q8TOeytkQqI7JoN6npd05xeGqOQ0eaYJOosGXrN
         OVEIi0Bvq+07deMcEfgfe4mNYS9ebrg2JVl0ZPKcAqyt9p/iiEP1HT5Uu2ck/75tW5U+
         oqjymFN7jfba81Jur/H7CcuwCFzdmM/bjcr305fbaunBoLcppuwsobhRg5YgQoX6Ulbf
         MV9A==
X-Gm-Message-State: ACrzQf1rVVJpQcRvo/cCrMKn6+pJAgRsQ4GkV75H1wn++bd59mYyD/ZV
        rfWPwVTDwaTj6LROZYc6g315SbIX1dQ=
X-Google-Smtp-Source: AMsMyM51IzYJWpLhR8hIiPoEHk2FErqom4TQnm8VzJ/+KxHioh5NTs8x4jcgjo0SBPbRnIcbon9drA==
X-Received: by 2002:a05:6a00:1f13:b0:546:7b39:83da with SMTP id be19-20020a056a001f1300b005467b3983damr14907333pfb.0.1663511786874;
        Sun, 18 Sep 2022 07:36:26 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i128-20020a626d86000000b0054a15345162sm6512820pfc.207.2022.09.18.07.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 07:36:26 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.panda@zte.com.cn
To:     mjrosato@linux.ibm.com
Cc:     farman@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xu Panda <xu.panda@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] KVM: s390: pci: fix comparing pointer to 0
Date:   Sun, 18 Sep 2022 14:36:04 +0000
Message-Id: <20220918143603.209974-1-xu.panda@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Xu Panda <xu.panda@zte.com.cn>

Comparing pointer whith NULL instead of comparing pointer to 0.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
---
 arch/s390/kvm/pci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 3a3606c3a0fe..aadafa2e03d1 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -46,8 +46,8 @@ extern struct zpci_aift *aift;
 static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
                                                 unsigned long si)
 {
-       if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == 0 ||
-           aift->kzdev[si] == 0)
+       if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == NULL ||
+           aift->kzdev[si] == NULL)
                return 0;
        return aift->kzdev[si]->kvm;
 };
-- 
2.15.2

