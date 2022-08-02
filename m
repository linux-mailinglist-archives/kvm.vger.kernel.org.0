Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B80587799
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbiHBHNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbiHBHM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:12:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C3932DBA;
        Tue,  2 Aug 2022 00:12:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id x2-20020a17090ab00200b001f4da5cdc9cso7513547pjq.0;
        Tue, 02 Aug 2022 00:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=H+nBQdQuCW3uq6+l/DiJOsc5BtydpsXCE4yEPObq9cM=;
        b=S8XcWuxRhvqJVqCZ1mQt3cZirZHBpz0stnQbyQ7jBziyzl5P2TIWlFa3rR2VCeP8tu
         KzU9ugu6MCN2unvnXWYVkY86Ck803pJHXwrhYDRFTubkZVMaVTK83epzzN3HEoKf76yC
         uxxoIC625B80mJDPAjLNiAdniWh+90k293VuXFWpKP7LF1wEKnOEsg89hW686oFYqudh
         ahjj7sw61M4gKBPvnklfF6leifjRfU2u5//nezKattkQLRRJKHxVpmvDaK0QTxx7oQQN
         IzY6qCPKX+DVSt+JxrrJkzhiUQh7DwQr47kB/ZkqBwguElX/wCZfJt/e5BYxsRN0hf2p
         N/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=H+nBQdQuCW3uq6+l/DiJOsc5BtydpsXCE4yEPObq9cM=;
        b=2WAhd34XTVdVj6KVVuKXU8TBVaiYNeRuMfyUlN37pAiyJUWxZZKY/Fwq5S63xbFuSk
         zndIo0hfJe95eUt0UbUyKMpwTpb8QKli/0cLZQ8A1ZAC882sc7B/ugUDy83Jj29am/eC
         T+UFiXDnPgA1fs7pmivTVDcjW6FHE11LScRKeKedDXBIwx0YlTfKXbalRHOVC9QF5XFI
         rIi/NSIt0O4kgp8k+Z5KKTFRUtnS52Ze6wXs+zWhMc3abz5hoIq0Tx0PN01C1at0aIOm
         CjIQpdpTV827PIWnlU2h0hZ3u6OAqkrC80bzcJQFQZHt0U1LbdtilKd0/ngJ49g/wkWF
         LQMw==
X-Gm-Message-State: ACgBeo3sYx0JU5SCj92yyfiCjlik124J8NOuqqjLVJxGXxlQ+1RnnR63
        gkWYMFheX1y/kX5GAev2EGK9fw+akcY=
X-Google-Smtp-Source: AA6agR6XWcVoRurLS07GBJOFohs3JZHIf7SiDbCoGZKzwZP6ERMTgzFG0+ZoZt2/Q6XStXyvre4R4g==
X-Received: by 2002:a17:90b:164b:b0:1f5:15ae:3206 with SMTP id il11-20020a17090b164b00b001f515ae3206mr5331278pjb.140.1659424375397;
        Tue, 02 Aug 2022 00:12:55 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x21-20020a1709027c1500b0016dd4b1ceb5sm8843833pll.124.2022.08.02.00.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 00:12:55 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm: Fix a compile error in selftests/kvm/rseq_test.c
Date:   Tue,  2 Aug 2022 15:12:40 +0800
Message-Id: <20220802071240.84626-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jinrong Liang <cloudliang@tencent.com>

The following warning appears when executing:
	make -C tools/testing/selftests/kvm

rseq_test.c: In function ‘main’:
rseq_test.c:237:33: warning: implicit declaration of function ‘gettid’; did you mean ‘getgid’? [-Wimplicit-function-declaration]
          (void *)(unsigned long)gettid());
                                 ^~~~~~
                                 getgid
/usr/bin/ld: /tmp/ccr5mMko.o: in function `main':
../kvm/tools/testing/selftests/kvm/rseq_test.c:237: undefined reference to `gettid'
collect2: error: ld returned 1 exit status
make: *** [../lib.mk:173: ../kvm/tools/testing/selftests/kvm/rseq_test] Error 1

Use the more compatible syscall(SYS_gettid) instead of gettid() to fix it.
More subsequent reuse may cause it to be wrapped in a lib file.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index a54d4d05a058..299d316cc759 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -229,7 +229,7 @@ int main(int argc, char *argv[])
 	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker,
-		       (void *)(unsigned long)gettid());
+		       (void *)(unsigned long)syscall(SYS_gettid));
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vcpu);
-- 
2.37.1

