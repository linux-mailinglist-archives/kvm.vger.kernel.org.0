Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E894CA784
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbiCBOJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 09:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242790AbiCBOJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 09:09:55 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B7333A0A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 06:08:51 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id f12-20020a7bcd0c000000b00384993440cfso632190wmj.3
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 06:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
        b=bBhuDLfF3Fy5j0yM+Nt52Pqwz1QANqHLfDVW1j5XwFAV2/QtrO+qH0ZuTlmBrJ+jWs
         D3Zq73lOUSa/o02QHpCnBnCGNGo0REXtD8aInMWgtlzth2EWAZCn3ab0SvUE0iPsO3ey
         aduBOOq0agqpOgYWuCYKmRpg66VwMavhIu+f+deKupFIdldP64aLXyLaiHi+pas6UCg1
         mCETxmxR+/v7xWQSKU54vd+ywURSu4/a+Y3dBo1MQqIP/+3gx8Mp1T93jgpxANDSDYVj
         LkJuFGJh4rqH9ahtIG1WKdfgwghS6P/7UIdTjilSEOoerJUm/e3uphHAIN06quyF4TWt
         8ofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
        b=nVKrtilvT3kyzghjdKM3oV5B0P34bX/69b6eTQUHwc+KTQXluAAmutw0dNx5joqAql
         w9EV1Dqs36Z33c/88j9FsZDXnwHJEmA2dnmeMY72MdPhAHIeEuQj1l7az+NwvHwgxOzy
         K//dkRnfJ8btOXlHtfwrE4MampDK4AiQs46c2pO3laaBKYHA4jafdpPe+jQ54AYRPE/K
         +UjWClEfTxLlKhf438NTDQoplX56v3kAoQvyvVUAL/HrrUdz88Fj6VUYqBCSJgd/helZ
         lqkyk/NUMDfpnWa+SF7njbeJOI6IARZaHFNM0cYqCeohbkg6edzXcJh5o0n7gGiFe5Fp
         OxYQ==
X-Gm-Message-State: AOAM532vCxFEq61DxcfTsqAEDiCISVW/cvFkkIqT4eZsI/5AEIAGz2SH
        fu8IZkHqPxEXdtHevuPxwtkCbJgN0yXMyhKChvwgOLqOiuQaWUV6iOgCR+F5j0zFM9MgKPHCENX
        qyjzSlpQGGQy3kCBWPTVurdM8eVWYkhIcDBWIo4wD5dVjpItv4VWMAUzVv8QZ2lOAH+PX1I5zBA
        ==
X-Google-Smtp-Source: ABdhPJzyiYNBOHbqdOVZBET/2I0nv8F5wQOX74+gM57vzAENtbjkBqPkJKoP8LQZ9yIgaOP5R4Z0MYccjEAv11o0v6M=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3c89:b0:37f:aacb:cac7 with
 SMTP id bg9-20020a05600c3c8900b0037faacbcac7mr294123wmb.1.1646230128931; Wed,
 02 Mar 2022 06:08:48 -0800 (PST)
Date:   Wed,  2 Mar 2022 14:07:33 +0000
In-Reply-To: <20220302140734.1015958-1-sebastianene@google.com>
Message-Id: <20220302140734.1015958-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140734.1015958-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v7 1/3] aarch64: Populate the vCPU struct before target->init()
From:   Sebastian Ene <sebastianene@google.com>
To:     kvm@vger.kernel.org
Cc:     qperret@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        will@kernel.org, julien.thierry.kdev@gmail.com,
        Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the vCPU structure initialisation before the target->init() call to
 keep a reference to the kvm structure during init().
This is required by the pvtime peripheral to reserve a memory region
while the vCPU is beeing initialised.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/kvm-cpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.574.g5d30c73bfb-goog

