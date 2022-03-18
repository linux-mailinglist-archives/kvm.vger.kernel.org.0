Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338094DE09E
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 19:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiCRSCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 14:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbiCRSCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 14:02:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DED4919B066
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 11:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647626473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=QFnnosepQLvXFzEFiJw0zB2N563wmVljW6vee0ufWVY=;
        b=ZXgGDeRPz0jogkylbVkJwh0jzHTkI8xTjnGEwkdrN+Sm1Odw/JFl2Q8mzwqoA/PZgtvGUj
        SY3wBnsj805uNK2RvqNhWUyKZ6sAz05coHXU0h7XmesZCtWuOdkk3vjPoBG9V+v2iFR8Qd
        oSCxbILLo3DJ0QDAHZkkSgLKshSDc88=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-yxNWEJ-CMHSeadQe3RS8Bw-1; Fri, 18 Mar 2022 14:01:12 -0400
X-MC-Unique: yxNWEJ-CMHSeadQe3RS8Bw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 476383804062
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 18:01:12 +0000 (UTC)
Received: from epyc.reserve.home (unknown [10.22.32.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E88141F378;
        Fri, 18 Mar 2022 18:01:12 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kvm/queue] KVM: SVM: Remove duplicates in
 arch/x86/kvm/svm/svm.h
Date:   Fri, 18 Mar 2022 14:01:11 -0400
Message-ID: <jpgh77vqgwo.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Commit 4a204f789587 ("KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255")
has duplicate AVIC constants in svm/svm.h that have already been moved elsewhere via
commit 391503528257 ("KVM: x86: SVM: move avic definitions from AMD's spec to svm.h")

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/svm/svm.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d07a5b88ea96..468f149556dd 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -577,17 +577,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
-#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
-#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
-
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
-#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
-#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
-
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.31.1

