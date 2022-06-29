Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D8560C3E
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 00:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiF2WWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 18:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiF2WW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 18:22:29 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F7A21256
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 15:22:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k11-20020a170902ce0b00b0016a15fe2627so9309250plg.22
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 15:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LGTltIhYTCBJTh8cmqYHBqvvFfQs29gnx8uxud/aq4c=;
        b=nn2/Yf5nqZ/nbkWMQNpHb69r7yom3xSKYQv4RZQ9ogb+kxCZBn5arIq+qBNCmXZO50
         6hAMK3fycZM+rBhGKyYAOruXr6VKcV5o0SBJnHV4KVGxY1LoEwx3AoSN961V4y+xdwSZ
         11ru5WhmF/BZ45w66WKWbiUMPAf0OjsB9eB5zwo/TewiWjD4tbPjFMI3lVBSZVx+go64
         H3ZkZkcSHJRCRIl/hPoOzRh/JWFEhhX+PsDYEaIiRQGxgGFKvGNSFDjI5f4d6Jl/Wjos
         /qWGRxLd2ELRJQHT+5zHi0OtuF4iQbkxoOY3tbaMtWR1g/f0ayblB5CcfGzpyyEVxAEB
         pKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LGTltIhYTCBJTh8cmqYHBqvvFfQs29gnx8uxud/aq4c=;
        b=i57sWGVoOAiBrWiQV1YxtP6xki/emvgSLJCvqCKHJJBXmvpKxcbaQPOnnHc1ZmvZ6P
         z+fDPynfftQIjV36yUAexHQ2+FfFVcJSXdh9wCohrJnI12cp3/zXccbVFd067tBchBco
         kUkvh8NwVBiCi80xoozYyMGqN9N0ehbbThgpptzug7NCyC62Ii7PP4Q7AKO/5SfxQI9j
         YbPykdFf6CjPSABo0wz6y30cSK6OThfpXNJ0w5hHDhmKTkosGZX6mLfHdmW5fax1wjbp
         QT/EbYmHAyJGiJidnfm+wYi8EeXeijIvUNlXw1TGu7csPjI8KWkS8ElhDTHrtbKzoIo1
         xQNA==
X-Gm-Message-State: AJIora8ovaR460RLHHulDyGokVCdSnef8DL6SoceQX/+tBLUfxV/dXdK
        OqLaia5DTxTZoLgY4YlDK8BdrjnKJPjUjBTaeVGc2tHOMTrmg9vunNDfqx9e8uEtbfWSrj2rzBy
        AMhzlCjsiWIAKDujxO0XfvL6pMwh87/JOS93YFIAO+61qIQiJDqGS66ha5MYVe0E=
X-Google-Smtp-Source: AGRyM1vH/BeNS39j7ltmz9Z8Jqx2GBpv8yq48JR5AeNQTRvWjWvIrlVB/P8ObHbD+792SXUYTKzeUxbi5rkjFQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:dad1:b0:16a:749b:16d8 with SMTP
 id q17-20020a170902dad100b0016a749b16d8mr12350604plx.61.1656541348005; Wed,
 29 Jun 2022 15:22:28 -0700 (PDT)
Date:   Wed, 29 Jun 2022 15:22:21 -0700
Message-Id: <20220629222221.986645-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] KVM: x86: VMX: Replace some Intel model numbers with mnemonics
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel processor code names are more familiar to many readers than
their decimal model numbers.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c30115b9cb33..1e3ab13bc17d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2645,11 +2645,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	 */
 	if (boot_cpu_data.x86 == 0x6) {
 		switch (boot_cpu_data.x86_model) {
-		case 26: /* AAK155 */
-		case 30: /* AAP115 */
-		case 37: /* AAT100 */
-		case 44: /* BC86,AAY89,BD102 */
-		case 46: /* BA97 */
+		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
+		case INTEL_FAM6_NEHALEM:	/* AAP115 */
+		case INTEL_FAM6_WESTMERE:	/* AAT100 */
+		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
 			_vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 			_vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
 			pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
-- 
2.37.0.rc0.161.g10f37bed90-goog

