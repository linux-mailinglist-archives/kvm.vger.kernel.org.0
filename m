Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E9F29CD69
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgJ1BiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:17 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:39290 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832969AbgJ0XKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:10:54 -0400
Received: by mail-pg1-f201.google.com with SMTP id j10so1559320pgc.6
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=GUpfgn1Atr/2cgV/VF9psyOiQEeFuFoj8Fw//sfCSj8=;
        b=DdTWKmn7fGFcxd+qoXrvE3LWbuDlW7z0ERl0bxE2SMCPY9oeEYk6H+59ceRSwCdf12
         Y7OUHygpvbV6KjGKg6j6udXOaDN1VQ9fbEdxv2sDoJNzKpmKnGj7c/6GsvstslkHA9j2
         Y0Y8z0SNGqG3o9i/0Hic4U7E8VtIqkfNNaCazTbOcc27BOS7ytp4KGaVzpQnMPGaftfA
         a7W+2VCcwgt2MAsO0CqhpeAck6tpBU+U43APTa60qO0Ur7R/F9YdCnpghd+vsrUsBPzs
         pn0wZbTk4nSJO9wfCRYIxMMyJenJ2MESmLBX35DZFY8Ar05nMAREg4R2ONMxWF2Hnt1E
         e3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GUpfgn1Atr/2cgV/VF9psyOiQEeFuFoj8Fw//sfCSj8=;
        b=rNPuiT+9a/LJNhQSHHlO1oz2sm+Cmnlx3HHNZi/kf+LAwtjMOyRHo6NWWpFhVOO4Kl
         YQMj8ZRDqpO6tOpkrOYNr1XQoOYRtPGuzJHlzEFqVEIr2kz1XRqZp+igNP5Qhs0p5wPq
         60UA2KEIC7taXrqmYpqYtQvtT0fS3IyQ5tFy9foes4JFVA2hvzSnoHbak73oNdv6uFCB
         80jKMbCOtCNHmy0+stCfUpf1dTZDcvauzJqbHGMuBfyz0g4K+HpK+h2T3fTN5YwAbTN5
         i99Eg60OZwnLqUwnzf7246VF/+FHif1f/96vxdr0tOD0WvTWmqJqs91nwS2kKdrSraSa
         NPvA==
X-Gm-Message-State: AOAM530VdN42X4P0KS2KluErtLQyfL12qr4AAugM5xp9NBNIySinYtK5
        iaUTn4DXiZP9STrta3Xx2z5pfHbGMxbFEFuTTUf/L7sXohiH5sUDskZO8IkVbdDqbrfd9h8gUmr
        Y87kGcUDzDliqU3L3duKMIM07Tzu8rr+z0veoJ26aWhdJRgg1sCq5gqucOw==
X-Google-Smtp-Source: ABdhPJyEzTEEvDlJjlDbUn/6XfE1h8nlUGycDTApGRN9bfGl+92UGQWSSM7P9UEOct96Ma7ISmCTPBIjC+U=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a17:902:d213:b029:d4:d273:d40a with SMTP id
 t19-20020a170902d213b02900d4d273d40amr4692991ply.76.1603840253558; Tue, 27
 Oct 2020 16:10:53 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:39 -0700
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
Message-Id: <20201027231044.655110-2-oupton@google.com>
Mime-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 1/6] selftests: kvm: add tsc_msrs_test binary to gitignore
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on guest writes")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 307ceaadbbb9..0f19f5999b88 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -15,6 +15,7 @@
 /x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
+/x86_64/tsc_msrs_test
 /x86_64/vmx_close_while_nested_test
 /x86_64/vmx_dirty_log_test
 /x86_64/vmx_set_nested_state_test
-- 
2.29.0.rc2.309.g374f81d7ae-goog

