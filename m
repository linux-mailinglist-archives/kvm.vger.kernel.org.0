Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECE64DE2D0
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 21:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbiCRUvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 16:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbiCRUvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 16:51:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC467F8EF2
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:49:44 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d61f6c1877so80032877b3.15
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 13:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2DFXQz1Lf7TwU+w/WQthlbAyrSNHFySEeqkcpCAo7MM=;
        b=q8qSxkqNKIZCgQ8PnRvxxNvoy7ce89qFtz73Joz2XYjKemyALrepL6x9o/k13ulLPu
         ygiZpRW1lZOfRpi+fJoi9tv3fSuLGhMP1mOsD1iIFFBIv4wTHFTe6IAT8tlUI4kUlXbY
         xlGmmEM5SJrwNlHk5WeAsqxT4694P+0GzMnZmEuvXUHSuifbICQ73KnaUS747+rv3B/X
         CmQjY8ykQxrr8mdV2yPdiFcb5zJ/nhNSj8KbkQJi/J//B8G2DwAF+8CY08je3tMQraNp
         bhfjDzmUkltKrYaUSm0bLrLSLf5F+w8VtwIwcpZH7H0qNl4D4AZEvzmuXRDin8uFN5ks
         X/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2DFXQz1Lf7TwU+w/WQthlbAyrSNHFySEeqkcpCAo7MM=;
        b=bHIcZFAnNlPZAZaZ8NSax40KpwZX+bQqo0S7hb2I1VkyQbYityKWKjnQ8mgOoTCkXD
         oWZMQA0EmYwMacvFu0k2CFiEEN3SKF/YMBa2C5rlbriAeJ2C2sULagmC1IOH5h7DDL46
         WEY24L/e+kGvScCLzZjD5rHZjvTXn1IIqvG8RePZ55IA0AtC5g0/W1QPLblJccQ51iVH
         csgZVuFZklQysjLTaIhaBmVKDGHyFUjxCA32g7CBhQ7yNvwvKHEOpOY8V9VlqHCrOm03
         vqb+oQSA36PFWLfdvBIki8WgD1haGam6HQcqNRL8ut7JIuD2x+WaKstk8+3fhFEv1nvR
         ZDNQ==
X-Gm-Message-State: AOAM530PlabiuQ9m5Q7/P8iz+ysqf8lgQjKngXnneWMLJBXHI1c8BXfe
        PCEY/2aCKSlOgPzm920JgLMuBfS7LIXLRQTxaHD5DfdhK+biufHZqk2qW7hI5MWnuuskyYAheDQ
        RbbFIQfsHk7vQTRkGlspXF0P59SikFnI0NeucrsA+dbwLW3p0nNIPaQjWEg==
X-Google-Smtp-Source: ABdhPJzIOQ58HhcjXsYWj0gz3EZKciZTZL7/HDQEHjuOj5PiDtPS9EJAUesa8jtEkSAn5mncmApDEMgK/cc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0d:ee03:0:b0:2d6:c6cd:d598 with SMTP id
 x3-20020a0dee03000000b002d6c6cdd598mr13427687ywe.425.1647636583970; Fri, 18
 Mar 2022 13:49:43 -0700 (PDT)
Date:   Fri, 18 Mar 2022 20:49:38 +0000
Message-Id: <20220318204938.496840-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH kvmtool v2] Revert "kvm tools: Filter out CPU vendor string"
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Dongli Si <sidongli1997@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>
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

This reverts commit bc0b99a2a74047707db73ba057743febf458fd90.

Thanks to some digging from Andre [1], we know that kvmtool commit
bc0b99a2a740 ("kvm tools: Filter out CPU vendor string") was intended
to work around a guest kernel bug resulting from kernel commit
5bbc097d8904 ("x86, amd: Disable GartTlbWlkErr when BIOS forgets it").
Critically, KVM does not implement the MC4 mask MSR and instead injects
a #GP into the guest. On guest kernels without commit d47cc0db8fd6
("x86, amd: Use _safe() msr access for GartTlbWlk disable code") this is
unexpected and causes a kernel oops.

Since the kernel has taken the position to fix the bug in the guest and
not KVM, there is no need for CPU vendor string filtering in kvmtool.
Vendor string filtering is highly problematic for feature discovery,
both in the kernel and userspace. As Andre noted, glibc depends on the
vendor string to discover CPU features at runtime [2]. This has been
generally innocuous, but as distributions begin to raise the minimum ISA
guest userspace will quickly crash and burn on kvmtool. Hiding the
vendor string also makes it impossible to test vendor-specific CPU
features in kvmtool guest kernels.

Given the fact that there are known dependencies in kernel and userspace
on the CPU vendor string, allow the guest to see the native CPU vendor
string. This has the potential to break certain guest kernels of 2011
vintage when running on an AMD Fam10h processor. Onus is on the guest to
update its kernel at this point.

Link: https://lore.kernel.org/kvm/20220311121042.010bbb30@donnerap.cambridge.arm.com/
Link: https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/x86/cpu-features.c;h=514226b37889;hb=HEAD#l398
Reported-by: Dongli Si <sidongli1997@gmail.com>
Suggested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---

v1: http://lore.kernel.org/r/20220317192707.59538-1-oupton@google.com

v1 -> v2:
 - Do a git revert of the original patch [Andre]
 - Add more context to the commit message [Andre]

Applies to kvmtool/master

Parent commit: 95f4796 ("arm: pci: Generate "msi-parent" property only with a MSI controller")

 x86/cpuid.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index aa213d5..f4347a8 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -10,7 +10,6 @@
 
 static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 {
-	unsigned int signature[3];
 	unsigned int i;
 
 	/*
@@ -20,13 +19,6 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 		struct kvm_cpuid_entry2 *entry = &kvm_cpuid->entries[i];
 
 		switch (entry->function) {
-		case 0:
-			/* Vendor name */
-			memcpy(signature, "LKVMLKVMLKVM", 12);
-			entry->ebx = signature[0];
-			entry->ecx = signature[1];
-			entry->edx = signature[2];
-			break;
 		case 1:
 			entry->ebx &= ~(0xff << 24);
 			entry->ebx |= cpu_id << 24;
-- 
2.35.1.894.gb6a874cedc-goog

