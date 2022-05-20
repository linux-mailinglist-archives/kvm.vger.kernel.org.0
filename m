Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C3152EB5C
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348820AbiETMAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243571AbiETMAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:00:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFEDC3EBA4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 05:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653048017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=605A85MV8zA5Tmbn3R+kznNXMiIuQQdRxWs90LDiRko=;
        b=YQiORPRGUl8yHDy6Cc2bxxVmyVc+/1+XEPVIN2ZkcqEGVogNuTYYvvggmOcc/QTc/cjM/k
        R4/XRlpemmyoxGePs8r/ABT5Nko0a1P5KC9jvq+E2bfSMjQ5qpoFzkvxU5GLFschK7mWcy
        ODo6+nz/raIyHI30t+96Q9mtF3betSI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-yhoQ07uhNDSq52_IpxLa3w-1; Fri, 20 May 2022 08:00:14 -0400
X-MC-Unique: yhoQ07uhNDSq52_IpxLa3w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B7B3C0218E;
        Fri, 20 May 2022 12:00:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9323403152;
        Fri, 20 May 2022 12:00:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     likexu@tencent.com
Subject: [PATCH] KVM: x86/pmu: remove useless prototype
Date:   Fri, 20 May 2022 08:00:13 -0400
Message-Id: <20220520120013.3312909-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/pmu.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0bce361f72b8..4e9785d3dc70 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -196,7 +196,6 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
-void kvm_init_pmu_capability(void);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.31.1

