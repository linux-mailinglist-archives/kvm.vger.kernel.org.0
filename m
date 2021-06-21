Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DFE3AECA0
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 17:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFUPmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 11:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFUPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 11:42:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA63AC061574
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 08:39:56 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m14so2881589edp.9
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 08:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oLRhhhShTuwh+hyxDOfuOUG3kN6JTKhoqPpqYogQPwc=;
        b=Q0nO6k1nqvxTXXYqFjyrZMjCxcOTkq2hY+D96d9Evk/BHV2KzfUDFBJQWgPWQMxaOA
         OixSvjbz8yO8NPoCeLcyXpp/r7noFci5FeFmxegSV6TB9x6l7yzHYtI9u4bcwVnys0fs
         hJIgvAzw0Or9gKDFEGhTVIPhF396aLB+fl3F1PVdQWPnUMytb4JtoQNASvuLU3FBv80K
         8EL7lf3FoikRIUTEmpXdPCqro08nhQCmjFClLmQ+Yr8kUSvPtTnAmCVHDgLAscrTfctn
         bJyo9uatFPn7WPW24Xn8dJCJlSmC3kHvW5xuQ8NDq4biVibTjv8RKHi1oleT8RTIMxyg
         Y3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oLRhhhShTuwh+hyxDOfuOUG3kN6JTKhoqPpqYogQPwc=;
        b=cCwvcHShV2/07Epj0GROMvqPvsNioSZMpSYnhSfLDx3S1A66mnxYtgb/rESxz8i1/h
         MeTQy5v1NAkh9BgehHxSBZ017Xf8kEMvN9ZXttwVEX9Tx5k4flrrE2l8BmffFAgxXFo5
         oVz+SQusjcTZjZ7nUgXRTw7pzmm1QdJ3oob0NHU4GUCw3v3KEM0yjIAy688Lz/n2sC3K
         8+PUsZii8nye/rsk1pmf9YbneGkxDLPJIBnNxj4XVcLWuTMtTMe4awDmRTv3fV7GsMzF
         Gn/LdueKgPMQ7EcnOv3i8Gz8FcA8w15Q8i+jw3JX1rgrmVMC4yDDiXFk+lOHyXdfQXA7
         +fzQ==
X-Gm-Message-State: AOAM530hyqW52Le5jN2PnWtiF5Q0X3cY3AERD3xwnbk/0AKu3hwCsz4p
        KiVYqywyS+RMbreKz+aB85PdjqLSLJ/vVP+UXm4=
X-Google-Smtp-Source: ABdhPJwbYDj9OYrRY4jVDAYn99csNJPNfUMRVDbBVYzKK8yL/OI9XHywbZNgde7I+tY6Ag7gPpzZ5g==
X-Received: by 2002:a50:9b06:: with SMTP id o6mr22686198edi.284.1624289995515;
        Mon, 21 Jun 2021 08:39:55 -0700 (PDT)
Received: from laral.fritz.box (200116b82b183200057523d5827ff379.dip.versatel-1u1.de. [2001:16b8:2b18:3200:575:23d5:827f:f379])
        by smtp.gmail.com with ESMTPSA id f5sm4912177ejj.45.2021.06.21.08.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 08:39:55 -0700 (PDT)
From:   Lara Lazier <laramglazier@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Lara Lazier <laramglazier@gmail.com>
Subject: [PATCH v2 kvm-unit-tests] svm: Updated cr4 in test_efer to fix report msg
Date:   Mon, 21 Jun 2021 17:39:25 +0200
Message-Id: <20210621153925.31375-1-laramglazier@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated cr4 so that cr4 and vmcb->save.cr4 are the same
and the report statement prints out the correct cr4.

v1->v2: moved the assignment to vmcb->save.cr4 back to the previous test
as described in the comment.

Signed-off-by: Lara Lazier <laramglazier@gmail.com>
---
 x86/svm_tests.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8387bea..824c856 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2251,8 +2251,12 @@ static void test_efer(void)
 
 	/*
 	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
+	 * CR4.PAE needs to be set as we otherwise cannot
+	 * determine if CR4.PAE=0 or CR0.PE=0 triggered the
+	 * SVM_EXIT_ERR.
 	 */
-	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
+	cr4 = cr4_saved | X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
 	cr0 &= ~X86_CR0_PE;
 	vmcb->save.cr0 = cr0;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
-- 
2.25.1

