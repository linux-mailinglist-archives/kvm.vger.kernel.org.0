Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908D559F1C8
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiHXDEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiHXDD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7024B7EFE6
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-334d894afd8so271026947b3.19
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=vgttTHY430+uE/XAACUX7cfxlTvyNGKVSI1KzilHvB0=;
        b=LKwiWPcXyEyzSKk2zm6P0vbQRlj125+7FRjMKucFVDTgBIKko1AqyIM5yK3oYSjpwO
         Ru5+Y2h1AfHepn9tWBdnMnMLU5x5yq/MA4NHvw7tZpdA57noUlev5H5u2TZPVhf3kG7U
         KH7k0yXF/AIuw4ndgeBhHWxRN6/Y4/0FADic0FHvpB5gDEA2MjHWqiP6sf7yrwsrae66
         o72isSbPIG63qOjnJ1Nm24JBEKjNTkzujkb0DrdiW3kV5D0FnK0QMRZ5wDXgsnNtjJ98
         A4BVKzeNH06i8fyoPK8cqdcXqF52jTOzYaHfyUgBzsILEJ7i6YtHiSucrOQCAw2UJiZx
         4ZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=vgttTHY430+uE/XAACUX7cfxlTvyNGKVSI1KzilHvB0=;
        b=Pt/MDAb9rERS4sOYHQDbEGcdzOFlhz1GWrzEGz7AOPOLDgqsfzhrmPTZxo+jIQE/cF
         wGXqPny9p5zBWROfHau55DM5Y1VCSnhI7d4kVBq9OW3gZacwUy/kP8XMI1Mn2lRzEBST
         QoYWQkOsvZUyDSpTcWiOK24xKeC/wPjYftdpLuqDwyF9KRYbY7vm18X+dGB4tsuJJp3C
         ABLspCsT+2vIZv7HXzBNZ8TKCI2o+qSg1/zkofgQsy+h6pYuHnJFX07FpK583nsLW2bR
         XkPw4PGCeKR+P1NCiQIOi502hy4TzvC9PgiXQkzqNIngm8C6+esebYSn03gNV3+Bxv1V
         iXKA==
X-Gm-Message-State: ACgBeo1GVt5FiMAoIE6xag+cXICCME0NdFI7rWiUeiC5Qrcc54wZvbHF
        oiuSTALljEPOcRIJRckhWhWX4TvbwsM=
X-Google-Smtp-Source: AA6agR5joObt1EhQBxOOdGW3BXFePjZhCd1EXbl1kdHMxTZEHaB7Jgj5pPBo1whuyQ0/cVWmbjHBZw5VlVA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a551:0:b0:336:d825:1b5d with SMTP id
 v17-20020a81a551000000b00336d8251b5dmr27159140ywg.4.1661310152626; Tue, 23
 Aug 2022 20:02:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:33 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-32-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 31/36] KVM: x86: VMX: Replace some Intel model numbers
 with mnemonics
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
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

From: Jim Mattson <jmattson@google.com>

Intel processor code names are more familiar to many readers than
their decimal model numbers.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5dcec85db093..6f6d8a008183 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2652,11 +2652,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
2.37.1.595.g718a3a8f04-goog

