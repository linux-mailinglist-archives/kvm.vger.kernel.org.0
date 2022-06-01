Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36553AFE7
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiFAV6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 17:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiFAV6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 17:58:41 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EE965E8
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 14:58:38 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id r84so2396534qke.10
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 14:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbxxMsKBxXTW+LHqS3uItjaVkQr6WN103MI4C6b0TXg=;
        b=FRW8+dpsGB4l97C7Mgdbxvgl8AAPoldqUMyBPP//RAApq4GHcoDyBvSUVRT0YkUInu
         2gVFxYzAhKUVGwz+Gz2SlSBJN1Pd0ePMeRGKbNvkhvvV/TDDpPbRnv+6ZK+XERaUoa2m
         tKHI6cKNGsYgrmpXsRuWHdQ2Gi655ApRuLEAmEV38qU8Wn7BYtaJwAOVDxqOQNDXA+Jb
         XEcz9zp+EhAlOlznvvRjPpHmwTdsMsQowT/keGqB48ZGXNpWhXItjsC1TSCPknnJaHtI
         yeB1FIsSZs/0dXzogxNmVqXaMUWmjAUq3OjemEtdy1L7ayidTByohRkazstEYSvpwoem
         cTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbxxMsKBxXTW+LHqS3uItjaVkQr6WN103MI4C6b0TXg=;
        b=j5V1K0cjlCujqWIyVVB1D8RgLZp6r3b+aekm8AYqE3I6DGMKdKsNuZxaputXC5ydRx
         o/rY9pxWYcGBB6tpe2p1gi6x/VUT5yqy6XFbEAlgAKN8fTBtpVFI72qyqNgvu+t8gHvj
         kZ59Ci+EFCMWUmfJp4SdguY3ZSwBNSkYFPfYivhXpESggp3hq2culkfi+3EzFZaRKwip
         4oXzHJcTdNcMR+A1shq6MgiataNoNBhkhCa3wX6cAMF6VnZLSCEYLL9WsT3jdiEbE9Vp
         gXS2g/BAjtYN/lMMKNYx8ZrsdVuYQrWskpqCwQT1m4hNj3FkEk5IqI1bFeWVD9HDy514
         xfHA==
X-Gm-Message-State: AOAM533SXWsG/fKgQJC8VgdpubDBP7bwr5RrMZaxYAQuZ96JW8zaZpTF
        7ecOl8+HWiuML+xdgaTY90HEFmmGSWCmgA==
X-Google-Smtp-Source: ABdhPJw51K3BbmrVqN6x48brdBSrGvhiq8mIHVQUlzOC5NdjoHNZluFiFY6NcBSsP2VMiEygPQWhAg==
X-Received: by 2002:a05:620a:4415:b0:6a5:895d:f254 with SMTP id v21-20020a05620a441500b006a5895df254mr1167161qkp.517.1654120717683;
        Wed, 01 Jun 2022 14:58:37 -0700 (PDT)
Received: from igor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm1823611qka.63.2022.06.01.14.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 14:58:37 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH v4 1/2] kvm-unit-tests: configure changes for illumos.
Date:   Wed,  1 Jun 2022 21:57:48 +0000
Message-Id: <20220601215749.30223-2-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601215749.30223-1-cross@oxidecomputer.com>
References: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
 <20220601215749.30223-1-cross@oxidecomputer.com>
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

Warn, don't fail, if the check for `getopt -T` fails in the `configure`
script.

Aside from this check, `configure` does not use `getopt`, so don't
fail to run if `getopt -T` doesn't indicate support for  the extended
Linux version.  Getopt is only used in `run_tests.sh`, which tests for
extended getopt anyway, but emit a warning here.

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 configure | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 23085da..5b7daac 100755
--- a/configure
+++ b/configure
@@ -318,11 +318,11 @@ EOF
   rm -f lib-test.{o,S}
 fi
 
-# require enhanced getopt
+# warn if enhanced getopt is unavailable
 getopt -T > /dev/null
 if [ $? -ne 4 ]; then
-    echo "Enhanced getopt is not available, add it to your PATH?"
-    exit 1
+    echo "Without enhanced getopt you won't be able to use run_tests.sh."
+    echo "Add it to your PATH?"
 fi
 
 # Are we in a separate build tree? If so, link the Makefile
-- 
2.36.1

