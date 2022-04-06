Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24614F5B67
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354801AbiDFKIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353520AbiDFKIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:08:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3833D10DB;
        Tue,  5 Apr 2022 23:37:28 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i11so1121004plg.12;
        Tue, 05 Apr 2022 23:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9h7cNl4OV6dWhSGgkfELugf4Gfp2Bajmd0kV8a3QGTU=;
        b=C4DawLXtXk+rbfCbIFt3NucikB71x43F7DrvMn0qUSBlrwT4xDhU/0qd1oSzSL240R
         31/Cr9C3aHZPiTPqMsghgNRAsmjxPJk0fGU9pbJLJ0awDX1vcMbFZp3K5niBYcsJ2W0b
         R0HnSkwF7FRVYojuj+nVUYVQFvdl6c8+q6v+bOvB6+uHpKJ0woAvyTqWZmk7eNkz4alR
         /z7WOU9q/UpoRQgqv7tPro3nC8Uq3+KIC8gaWKLE8mw7El4AhmP9uoJ7xoqbh9d9aCjT
         N2tt5QXigus2k/sBnx3fY4WEXVdFJy/cEC96hF6ORXCa4ZudFaLzYATxQuS+TAf9LmRF
         MGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9h7cNl4OV6dWhSGgkfELugf4Gfp2Bajmd0kV8a3QGTU=;
        b=p4i25TeCWfbUbon7GzVFtyH3OnpvQMFCMe2F3CbBNCfEOJVoURRuocU7+8K2F2w50e
         jekcp1o7y/5NGLbnAAAxo9it+uH6htQIWd6exqlEh3Stf7AYkhH65dWkkUfuBUKvR5gl
         MJa37Wtrbks59kkSLTa1RaPypd3n9ossaM7k/nu/shMItORNg84Vi9SA0nCEV+ng4ctH
         bd0rJT6oDN8dQnqMYeXnBM2FZ4flrUkm9AUDblWzJ1KwTwg+W6nLsGYtuf8s9O4+gO0W
         r8diVXoFQ3ISssIh4tibK3FTGLKwTnfQ/7xwcilYZcMcW+PXlDp98RadY39npuqaRIxG
         JG8w==
X-Gm-Message-State: AOAM531Wd7rzyIUi/3dzXp2h9Y0JzSnG/Sz8+JNIdxkSWIpf31qDlu9h
        wRX0egz508GOilokYxcu8vM=
X-Google-Smtp-Source: ABdhPJwrTO2KH9oUuLhDamqRuJXyZOqUzpzCZeW3brJG+JSapGjT6GsplV0VRM3CR8DorVxwtKPhgg==
X-Received: by 2002:a17:902:ced0:b0:153:f78e:c43f with SMTP id d16-20020a170902ced000b00153f78ec43fmr7139450plg.64.1649227047778;
        Tue, 05 Apr 2022 23:37:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id bt18-20020a056a00439200b004faad3ae59esm17286650pfb.95.2022.04.05.23.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:37:27 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] selftests: kvm/x86/xen: Replace a comma in the xen_shinfo_test with semicolon
Date:   Wed,  6 Apr 2022 14:37:14 +0800
Message-Id: <20220406063715.55625-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406063715.55625-1-likexu@tencent.com>
References: <20220406063715.55625-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+WARNING: Possible comma where semicolon could be used
+#397: FILE: tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c:700:
++				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
++				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);

Fixes: 25eaeebe710c ("KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN_SEND")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index d9d9d1deec45..5e6f40633ea6 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -702,7 +702,7 @@ int main(int argc, char *argv[])
 
 			case 14:
 				memset(&tmr, 0, sizeof(tmr));
-				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
+				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER;
 				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
 				TEST_ASSERT(tmr.u.timer.port == EVTCHN_TIMER,
 					    "Timer port not returned");
-- 
2.35.1

