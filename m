Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A1C592800
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 05:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiHODMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Aug 2022 23:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiHODMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Aug 2022 23:12:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124AE64F3;
        Sun, 14 Aug 2022 20:12:33 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id bh13so5559974pgb.4;
        Sun, 14 Aug 2022 20:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=cUiGTukLp5Z4TNn08h9rOVBQaIchC1/2t/OT0dXiLQk=;
        b=OSIY8+US2J1b7Dr0jISaW94GV2zY+dM1VyNYvX+8RPh3MZoyqRaYefilWBMEJ3JsCK
         tCnJr98h7oXc+JyJ0P+9fTef37Xzbod7zSVBcaZpcrB91B1koDfFSSv3YJZiybfgSp7u
         GdvxpmQ0repWoRHkwpgDkfxFt4JSW3WIyebTVjt0O/ClBpJWwFxogRimJRVtGMe8BujO
         5rYLZoK9uRVjWO2eADTyrBACzYwp43OkJznY0bWsp3lSP6bKjb/2RigelG9VZPw+fw54
         dwB4bKwv0moZ2mg+DD6+0fCdq5fXatkL5vII9RkdQaDXyDzdpXTeK00ogikl5JdhWq5b
         g6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=cUiGTukLp5Z4TNn08h9rOVBQaIchC1/2t/OT0dXiLQk=;
        b=rHaD/PCeEBe5vpNHzQWud02JyfSdRZG8fyZu/m3LlCMWJ1VMZgGCK1PjYv3qcF2jov
         lr1I+85QBrEmqoPtbUeE2QjnVwS6bV6O2gNRRXNakSCW4k2AcJcJjfXwBRA8xHTCZ/jm
         etk7UnVESJPmrb9f5t4q3v7qFegi13wL1AR1OAOceNcSb1zbxE5CEXKDwdOwtI/Ln3ET
         r08Y3LzR+4iaqa8hEoTjQPXzedWHYsLzur1pCkzFXusIbnKYBTOgqmIEGSJVTpdo7MSP
         JyjUgsy/jemUAt0kYulNXEnKM3oC35Jsc55aR6+XjbotlOSA8Z72Q5JKrvfnmB9nP5F8
         PJvA==
X-Gm-Message-State: ACgBeo2Ue7DGvMCIEGIBLc9hpczHcnDk1cvhSAlfo1kjayEmexje6fCu
        fdg6ydEURrYj54TUxitx75k=
X-Google-Smtp-Source: AA6agR7HFNm2IlPZc/IZNrza4jlA6ATvvx+VWkFhXCIadfu5ZICmx0T5SsLgTN5BGdRS7y93slybYg==
X-Received: by 2002:a65:55cb:0:b0:41d:c914:d6af with SMTP id k11-20020a6555cb000000b0041dc914d6afmr12270737pgs.322.1660533152600;
        Sun, 14 Aug 2022 20:12:32 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id i67-20020a626d46000000b00528a097aeffsm5698418pfc.118.2022.08.14.20.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 20:12:32 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] KVM:define vcpu_get_pid_fops with DEFINE_DEBUGFS_ATTRIBUTE
Date:   Mon, 15 Aug 2022 03:12:28 +0000
Message-Id: <20220815031228.64126-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: ye xingchen <ye.xingchen@zte.com.cn>

From the coccinelle check:
./virt/kvm/kvm_main.c line 3847
WARNING  vcpu_get_pid_fops should be defined with DEFINE_DEBUGFS_ATTRIBUTE

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 515dfe9d3bcf..a0817179f8e4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3844,7 +3844,7 @@ static int vcpu_get_pid(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
 
 static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
-- 
2.25.1
