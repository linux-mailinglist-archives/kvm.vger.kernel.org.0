Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF252593B
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 03:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376283AbiEMBGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 21:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376271AbiEMBGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 21:06:23 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81A24477E
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:06:20 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id t16so5778400qtr.9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 18:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41th4FqtjLY8REZcblISgBRdApJKQ60IDEW4mTip2LA=;
        b=foqE6mOcH/tLCMdr1uqUS2jhnqlHckDYkOXfeOgLdc8gb3bncQhm7iz3vcQBcvJtQX
         0nThjSphk2lWPHjMd+Qd5vIL9Vg2HMYIz8ldDfOIS6AatLp02y5VLHRfe7McDoFZxSzX
         JOpX6aPokfAjtIIibVgfvmDz38gbn0YgMNOH/PNn0RWVECnhsHnTuEn2B753XqUC9Mez
         dI8Si+tdla0AKd1vK2+Fmcv6qhIOv/+Kg8S/jKbh9Ir+ALtLCTNpiIc1KON5gWJy1IWF
         628lZC/MHcvKu+yiNxeAMbefCbaVSbueO60WyaZ5y7MxE+BqzMuleP5F71Ppx4jdWePk
         YBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41th4FqtjLY8REZcblISgBRdApJKQ60IDEW4mTip2LA=;
        b=vvOBDadGdlK4ewxy9Cp1kWuCcaGflnftEoaxWirK/umE3BtU8LgQcSM1oZTGnyznFe
         usb8Sg+MdrnTkSDR5TwupbiTaxzu1oHauZRb0ozAE2A9XkaHv5cV1oUjrg1e6vuFO4G7
         gkwcfhTWz2+BvY/xuLPuQS1aYcI4Ge8bUoq55z5bhItr+tAXQ8n/Xw4P330ztVOO6AjQ
         gp50kkeyZdTXcgQmWOEZeg9Tv4K4eBJMuk+3psZ0oZsL382cVSioiK8XpDI4z9Gk87Lh
         MrwC84wLlId57FH0dh4l7t7BhswLBFvSKoKWZoCQAduG5qjlYwLswuow4fnt8JVJUk0C
         5bAQ==
X-Gm-Message-State: AOAM5310Xq7mp+EoLS85USQmjei8qgSXpk+2k8bAU7lk6NR+28Ucg+vx
        zpijTQ703rJQAM5fUxjmBvKShPvzWS6drQ==
X-Google-Smtp-Source: ABdhPJxkKz3Z4+IdKfqW0lxpUlkSNzyBMKuC5BLGxhgGlGIyOQwq8sFAmeh2TLVCdbLrBCRP6uOq0w==
X-Received: by 2002:a05:622a:1108:b0:2f3:d7d1:cf28 with SMTP id e8-20020a05622a110800b002f3d7d1cf28mr2425074qty.481.1652403979331;
        Thu, 12 May 2022 18:06:19 -0700 (PDT)
Received: from doctor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id cc6-20020a05622a410600b002f39b99f6b2sm619130qtb.76.2022.05.12.18.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 18:06:18 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Date:   Fri, 13 May 2022 01:07:40 +0000
Message-Id: <20220513010740.8544-3-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220513010740.8544-1-cross@oxidecomputer.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change modifies the `configure` script to run under illumos
by not probing for, `getopt -T` (illumos `getopt` supports the
required functionality, but exits with a different return status
when invoked with `-T`).

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 configure | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 86c3095..7193811 100755
--- a/configure
+++ b/configure
@@ -15,6 +15,7 @@ objdump=objdump
 ar=ar
 addr2line=addr2line
 arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
+os=$(uname -s)
 host=$arch
 cross_prefix=
 endian=""
@@ -317,9 +318,9 @@ EOF
   rm -f lib-test.{o,S}
 fi
 
-# require enhanced getopt
+# require enhanced getopt everywhere except illumos
 getopt -T > /dev/null
-if [ $? -ne 4 ]; then
+if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
     echo "Enhanced getopt is not available, add it to your PATH?"
     exit 1
 fi
-- 
2.31.1

