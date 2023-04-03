Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF72F6D4623
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjDCNte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjDCNt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:26 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D500EC66
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i9so29434305wrp.3
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTOWIebDq0xH5MEdgwVyuiNxE4JxhgEfL/zEAMmcLTQ=;
        b=Pd745bmnXlfs4LJh75sVHpdsPA+xhcR3XlKK3TosfuE1r4GmjMcCMK//Sg5U8B9OCy
         QApDpXjTidsFf6gSbmq2SgYwstpQ7u2awLYYx+4Vk6KUWZCwSWqLUJc+NeSG8H+V/dcS
         Dwbel5nNX0LpskAYoI3JNAv7Z3EznmNWbtxvBkjFqblsWce7z949QLS4zc79G8/BxSbl
         QSU/Lc8ZBOAeIZwJ/NOLRhqcgUAl4KP04pfjAGGX6zJyVB8QT3D5VkPhJV6sx3HNLe+I
         Jc9DoN1KL+ilRkw0P1VXc/p4l+WpoPVl1zCyAStMx/mXL11fRlcfkeTPV+1SMtDRrmRW
         LP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTOWIebDq0xH5MEdgwVyuiNxE4JxhgEfL/zEAMmcLTQ=;
        b=HOh1Jxb295lVYsjCTC7RrgjQbRW6gtU1mB34VJPSo+EQz02mHPxmDGaE1+E8V7tf2/
         +Rvkkj5ZRhparrIC6cOz+W20rwxwMliST7SjcL7KjI89qnk9uHpODUJI+7s77xly+anA
         LE3oYXy1PPsfdOywj0YSST5FknPIKfmkdhBODB47YQlWrp7YUuktjw8t/thj8uXiG/Y3
         WarNcsDDcvUwsgYn4FOcYmaJdhGX4wAzRiYMstOnsrkbtQS+RVsKLBN0fqJgKlWzJg3E
         OiZHrgv5ER2wH8tlWusQvowOpoh3nSEjFsOiJG2OSfNHjz7IB92eocRIM0/RFxyNee6V
         uLhQ==
X-Gm-Message-State: AAQBX9duSEPru4hg70FWwUjRH0dBBndobhV1UF5a4aHAL2GZa2ajOFQP
        Zb31qwVPjARmgDNv6or35yR8ag==
X-Google-Smtp-Source: AKy350ZRhlxNrjjVOSPUKEPVG7isDQmeeJWmbFFZBRlp1mMjzm7Mq0oej7yeF6yUqNQCE7KoPphvYw==
X-Received: by 2002:a5d:408b:0:b0:2cb:76d4:42ea with SMTP id o11-20020a5d408b000000b002cb76d442eamr29007696wrp.36.1680529764015;
        Mon, 03 Apr 2023 06:49:24 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm9760207wru.65.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:23 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 51E3D1FFBE;
        Mon,  3 Apr 2023 14:49:21 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH v2 06/11] metadata: add .git-blame-ignore-revs
Date:   Mon,  3 Apr 2023 14:49:15 +0100
Message-Id: <20230403134920.2132362-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403134920.2132362-1-alex.bennee@linaro.org>
References: <20230403134920.2132362-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Someone mentioned this on IRC so I thought I would try it out with a
few commits that are pure code style fixes.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230318115657.1345921-1-alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20230330101141.30199-6-alex.bennee@linaro.org>

---
v2
  - rm extraneous +
---
 .git-blame-ignore-revs | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 .git-blame-ignore-revs

diff --git a/.git-blame-ignore-revs b/.git-blame-ignore-revs
new file mode 100644
index 0000000000..93718ef425
--- /dev/null
+++ b/.git-blame-ignore-revs
@@ -0,0 +1,21 @@
+#
+# List of code-formatting clean ups the git blame can ignore
+#
+#   git blame --ignore-revs-file .git-blame-ignore-revs
+#
+# or
+#
+#   git config blame.ignoreRevsFile .git-blame-ignore-revs
+#
+
+# gdbstub: clean-up indents
+ad9e4585b3c7425759d3eea697afbca71d2c2082
+
+# e1000e: fix code style
+0eadd56bf53ab196a16d492d7dd31c62e1c24c32
+
+# target/riscv: coding style fixes
+8c7feddddd9218b407792120bcfda0347ed16205
+
+# replace TABs with spaces
+48805df9c22a0700fba4b3b548fafaa21726ca68
-- 
2.39.2

