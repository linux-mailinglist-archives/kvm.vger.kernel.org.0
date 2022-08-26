Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DAF5A30B6
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 23:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243298AbiHZVAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 17:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345003AbiHZVAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 17:00:30 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6590E1908
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:00:29 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so1724990plg.23
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 14:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=nLh/sEBwEiC0QIMEtp/GiRB6P15JdaiLeuaytMstG80=;
        b=NZjG81ZeUzl6mXbsnxcda2x0BhOOBuT+qa2NRq0psVS1+DERw+ZHyY1KUUBMqOxg5t
         Qkt6fIRfXQzqMFj6zNPkcwe9+qkx5vVNVdHxtPdRRa1kx7Ze+yapnmNo0uFhAIzxyHzY
         czrqjPsfIu7YCF4jAJdNbqAAOq3X720LzZfPcmDzgerQHglU2j+JlJGloaCsWcV2ePmA
         sbo34xZJot4iX5eX9s6Hsj87Zju7MsZGhgroefOav40cwpgysB17xuBi9q2wWwNlpNTw
         gdVX3MPQ7sMb8a8A5QZaYvxeSXgJ1XvmeYfNn7b1146dqlp9JaPUEIEeO7BYymQ3CvN9
         vVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=nLh/sEBwEiC0QIMEtp/GiRB6P15JdaiLeuaytMstG80=;
        b=z3CbZP4/y9dPUlY1b079p6rddnnJwHfgljEkPCU2FLF72UmeAntKOYTWoUDXOQAHLf
         cargpWp/imB2ctWRKM3L7xZQ6woBos/YF68CMqo6HI08/S/Yr7S5suayvuAzQ7YxaLLl
         Aw1Fj5o79gFkkL0M2EO46X+ewmv1WBcIga8Jpll24YnxhmYQiJwesHxF/fR2+eI8bqmR
         Rf4ne9XhoxcRRLmS/vjEBECkGA6RUq/NwlfgnCvjrUQATcxAVa2/H6qR4eDiPL1hb8VT
         udC0oMV1j1H2txQ30N3pIQ78AgwWiG2Env1+sTdrRKXgfb8Gn3aw43vvtIxv3LVZQabv
         bNMQ==
X-Gm-Message-State: ACgBeo2kX7LGW8glMuKy1Uc8gFzzWV9/w8G9lwxxwi/OBuFEWn88M98f
        7w8Gm7vvnw/GKgcdM4VPe1F+vHgp4QKDZMje9eAsuaU/CGhLXXExZxhpLpVzSLM2xBYuxnBX69o
        xbISvjzi0KF3W5+8d2FPmmF55RWhzukpQiAK2xsw07xphgVBLJU6r+eyv0WvCyY0=
X-Google-Smtp-Source: AA6agR5A30xxYjPVF4S/var2cLfF/zrE0FpjC6vf2Q71X3hqtR2cJizCDxsFjtfB3WNp7PRr06jiX3X5IOz/yQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90b:1803:b0:1fb:45e2:5d85 with SMTP
 id lw3-20020a17090b180300b001fb45e25d85mr6315953pjb.163.1661547629232; Fri,
 26 Aug 2022 14:00:29 -0700 (PDT)
Date:   Fri, 26 Aug 2022 14:00:18 -0700
In-Reply-To: <20220826210019.1211302-1-jmattson@google.com>
Mime-Version: 1.0
References: <20220826210019.1211302-1-jmattson@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826210019.1211302-2-jmattson@google.com>
Subject: [PATCH 2/3] KVM: x86: Report CPUID.7.1 support on CPUs with CPUID.7
 indices > 1
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Previously, KVM reported support for CPUID.(EAX=7,ECX=1) only if the
maximum leaf 7 index on the host was exactly 1. A recent microcode
patch for Ice Lake raised the maximum leaf 7 index from 0 to 2,
skipping right over 1. Though that patch left CPUID.(EAX=7,ECX=1)
filled with zeros on Ice Lake, it nonetheless exposed this bug.

Report CPUID.(EAX=7,ECX=1) support if the maximum leaf 7 index on the
host is at least 1.

Cc: Sean Christopherson <seanjc@google.com>
Fixes: bcf600ca8d21 ("KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07be45c5bb93..64cdabb3cb2c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -886,7 +886,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_entry_override(entry, CPUID_7_EDX);
 
 		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
-		if (entry->eax == 1) {
+		if (entry->eax >= 1) {
 			entry = do_host_cpuid(array, function, 1);
 			if (!entry)
 				goto out;
-- 
2.37.2.672.g94769d06f0-goog

