Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCBBE4B7F8B
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 05:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbiBPEjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 23:39:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiBPEjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 23:39:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDC4F1EBB
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 20:38:51 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so5383162pjl.2
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 20:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dbH9RI717iPFnm2jv4oHXF6evDyAg9qpGzOWZIFDsC8=;
        b=mnPGINynYR4i9Bx3mTe3aepJrkI+kZWrM4+HMXwBby/4iPQLFI5czmhBNWZlWgKG3z
         V64KXjTJUX6WmwN7l86gzNtv+MMUwjaflkt/m1rDN9DvCSwLS6jSpTRlO/x7i/kvG1vx
         oqatc+4KXz71awr/yTz9gWL/hnbD+gjSqV988rfZeutK91zZgAbO37vrmcV+uK0AILOo
         wGXZYtgvkFIMLiaJLCmybIbPFQ0+eNoRcnxCgNyqrRU5TmXbqsoghD0G+sMjE2MWQotR
         C3Jx5itpYiE9UqkAMPfM//+Xp34HEu9pWSR7jT1ikjrICkzaYC6iXaEc7nrOqla9DiWU
         FSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dbH9RI717iPFnm2jv4oHXF6evDyAg9qpGzOWZIFDsC8=;
        b=XGdpRj+TRhk1XWj9BLa04BDonmrGF0XblFIrjXOKNTuQqe4i3BmskOyQtxpoBuKz+l
         C5i/SzBtW0E+hOKY0PuCfo5M8bDigS3+owIVV4/cZYZUutqS7A2QUJ61ZtmVsgf4U690
         8xSX8ClsUkuwhixbZY7i+HH0mKYsrKtUUMSzzaH+H1y01I72H4V6Px2aGff+bin5P6cR
         gu3daopTooO5tbqd1svetOOTi+WLjAFFBN9QsQuj0QX2uY5z+9kN61qKdcw3nqleUIkh
         NYDm54hzYeEUqwSE3UBC48hAJ+8DbmkawJHldH5f3XcsWIifHzhwVKM0/vcIChTxopzp
         /vaQ==
X-Gm-Message-State: AOAM530lrYEA7jE65mO6Cxwj33SvYwcfVpAGCpV9jc0Z5too5gapBM6b
        0/PHBcfrAWdS3Q/ct/q39c6jig==
X-Google-Smtp-Source: ABdhPJx4ft3jfFloYKbORaO3ht12C8pvd3/tuBJ4FG59RjQUrPBn41RFAd0aLFozwbXGTZVC6d8rvQ==
X-Received: by 2002:a17:902:e80a:b0:14c:def1:ef60 with SMTP id u10-20020a170902e80a00b0014cdef1ef60mr721127plg.144.1644986330705;
        Tue, 15 Feb 2022 20:38:50 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id lk8sm9115190pjb.47.2022.02.15.20.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 20:38:50 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     kvm@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH kvmtool 2/2] kvm tools: avoid printing [Firmware Bug]: CPUx: APIC id mismatch. Firmware: x APIC: x
Date:   Wed, 16 Feb 2022 12:38:34 +0800
Message-Id: <20220216043834.39938-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220216043834.39938-1-songmuchun@bytedance.com>
References: <20220216043834.39938-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I boot kernel, the dmesg will print the following message:

  [Firmware Bug]: CPU1: APIC id mismatch. Firmware: 1 APIC: 30

Fix this by setting up correct initial_apicid to cpu_id.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 x86/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index c3b67d9..aa213d5 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -8,7 +8,7 @@
 
 #define	MAX_KVM_CPUID_ENTRIES		100
 
-static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
+static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 {
 	unsigned int signature[3];
 	unsigned int i;
@@ -28,6 +28,8 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
 			entry->edx = signature[2];
 			break;
 		case 1:
+			entry->ebx &= ~(0xff << 24);
+			entry->ebx |= cpu_id << 24;
 			/* Set X86_FEATURE_HYPERVISOR */
 			if (entry->index == 0)
 				entry->ecx |= (1 << 31);
@@ -80,7 +82,7 @@ void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu)
 	if (ioctl(vcpu->kvm->sys_fd, KVM_GET_SUPPORTED_CPUID, kvm_cpuid) < 0)
 		die_perror("KVM_GET_SUPPORTED_CPUID failed");
 
-	filter_cpuid(kvm_cpuid);
+	filter_cpuid(kvm_cpuid, vcpu->cpu_id);
 
 	if (ioctl(vcpu->vcpu_fd, KVM_SET_CPUID2, kvm_cpuid) < 0)
 		die_perror("KVM_SET_CPUID2 failed");
-- 
2.11.0

