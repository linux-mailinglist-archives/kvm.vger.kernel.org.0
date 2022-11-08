Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30030620F9B
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 12:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiKHL4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 06:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiKHL42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 06:56:28 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702BB12AEB
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 03:56:27 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13d9a3bb27aso15184437fac.11
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 03:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r3IdGuVwuT9z55p1UOI8oOZYWHzgZr+lWq+tH4C3SKY=;
        b=i0yF7bg6ex4RKXikfrJ5zdJSayot1X2Lb0r694qbt0EYamWx6caup3VyriwtQQiy1d
         BABWfEwcAXH3CZnoS4IY9lpH6Jkq4WYJYSsi11NU5BCG1/7f4zdtqNzWbfN2Aps3p7Nh
         gXtqMZQgB9I/Yx984R9BSO84TsMBHgI8hSoLBQphrNk8ZOzIh/ue/Ehcu9tSkh0/IV5l
         I7/g5ctr1Hjlfk4p1zgtw6Ai1wn57Ymdt5nm/cnnjsqUrgs9XPXmAf/jwn+1bPWz9Tvm
         klJWYAalUb/0AZCW3xDoO6xiy1qoS08Ah9rPbG+nZjabfMG2sDJY+Qvgvne2ga+3Oslt
         9TPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3IdGuVwuT9z55p1UOI8oOZYWHzgZr+lWq+tH4C3SKY=;
        b=c23niIuL8On0yWbywdi8+SwUtmRf+ZxBurvj028i9yMZOiad8pFReLcjb3pXr9x06t
         1qGNuaOhBznDAzb50psNJ7vc2irTaiPVtFN2gREJSZfHrEQm0JR0VG+ZeJPkFyee5i5R
         jxRDMJ0lycCZh71Thz+e7SxIZt2CDbpe3Y4T2n2OWqZBUbDWUGC/5xHcQtqKZ4wHJj+0
         lywULdkTtXpMnoyDfXu3kHveZpSddZxH/irC+VPr0a3OCucx9oBLE3biOkh13c0vC94D
         0HnAUdq1x3FTliWt+SFgVxUiMSYCNtOODB3wUrKiUHJXSI7LiUafTTCauHDmldZaWRJp
         s/Qw==
X-Gm-Message-State: ACrzQf0jrmn5H94IVScrj8JerjDy5sAu3VBeMgCTGCfkDUBtAkByBy3S
        cXWyrSE9cMg3RZEn12zCO80X0Q==
X-Google-Smtp-Source: AMsMyM4kIRsBmrnl+RCP4gY1RKpg4ZErcblTVHcUHo3/UFVmRe6v2bNdNzQ70TixhA7jRnbwMNrwiQ==
X-Received: by 2002:a05:6870:64a9:b0:13c:673e:3313 with SMTP id cz41-20020a05687064a900b0013c673e3313mr37326532oab.128.1667908586671;
        Tue, 08 Nov 2022 03:56:26 -0800 (PST)
Received: from anup-ubuntu64-vm.. ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id s205-20020acadbd6000000b0034d9042758fsm3376199oig.24.2022.11.08.03.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 03:56:26 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH] RISC-V: KVM: Exit run-loop immediately if xfer_to_guest fails
Date:   Tue,  8 Nov 2022 17:25:43 +0530
Message-Id: <20221108115543.1425199-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If xfer_to_guest_mode_handle_work() fails in the run-loop then exit
the run-loop immediately instead of doing it after some more work.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 71ebbc4821f0..17d5b3f8c2ee 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -984,8 +984,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	while (ret > 0) {
 		/* Check conditions before entering the guest */
 		ret = xfer_to_guest_mode_handle_work(vcpu);
-		if (!ret)
-			ret = 1;
+		if (ret)
+			continue;
+		ret = 1;
 
 		kvm_riscv_gstage_vmid_update(vcpu);
 
-- 
2.34.1

