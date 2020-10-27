Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B739F29CD64
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgJ1BiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:18 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:41123 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832970AbgJ0XK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:10:59 -0400
Received: by mail-qv1-f73.google.com with SMTP id c6so1857041qvo.8
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zTWeeM0gj4b+EZMzzsOuDy3TtUXgOfnUzZ7xyejxMz4=;
        b=e8acWBkgA6aNGezOtnocVItGlAOaDmHZl4Jm08GenX+pg8ZGT0T+4/puDL5oNhpLzb
         XcGU2roUbDv4Nm19ykA2Op3gcHOJvL7VswB0uoy3ncwnYbdqrL826cWz81nimpPbplKn
         3AOi0IvtN5E9k91PqCU3y7FyBayUaFnalP7icI6vIamF4bH+1YvX+nUAcSupFIjrtm84
         X2W90MEgoT7O7lKZ77ccd3q6DbAsfACpMhrCG4SIKsbncHzHHujIz4RdzujUTsyN9M8h
         uTtgDsoEdHBo2L2STPDygpkaJSvGpajm149ev9lwTUlR1tzE82sMOo4+2b5BV3sMLBUJ
         LWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zTWeeM0gj4b+EZMzzsOuDy3TtUXgOfnUzZ7xyejxMz4=;
        b=qZjtaKCz7tPnG9LpdYrcM8XZ6H+JxYPxo5tomklegYmeF30zxanJ40jcmsg8A5pIjE
         tDFHAtfYKkcECp7KTQ8D5PhAd7YWosze9fLkKeOcZVeqdLFZ4fhiMWlHgp8173jflqKj
         1hpjO949/2PppARxViw3GJYa3GsE4EeHLi3xGwMnOs3CkXCLUOE2B1PDs6L+wmqGM578
         LVz7ZgaG1OPYNK7DC4XC4PB0a9bEGQKZhu4fBJjwoVlbF0GzNmi+BdA0Q/qYYyP4fRSq
         s3y1HLIRulZ46FZUy+v823Z4MV8aLxCjHeYpONstNwwffRsev4xjbhZIjpXwKIjLCCJC
         RrBw==
X-Gm-Message-State: AOAM532DvgE8eCoZl5vFzpdPyrxw5NHhuAfqf7ewUOfcbH/N6E2Vs1g+
        vNN+Nhkfb/mSDDAhjCWDHXltxUaoCpuF1DaEL7ZhWSHlwyGx6oq9vR3XIx38F8D5AbHhlpFwJDB
        dY472/S59IL/tdzfwUbIKb32G7f+jGWaxgkAI0Qe4rG9HfHic6KfBgLY2/Q==
X-Google-Smtp-Source: ABdhPJzCoj87WMAPI7uZp6Rn2R2h2ntEUHQdRosJ1+mvRd95aCRbkOb7ixRcSZm/7w2UUZfwMgaob/lrxtA=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a05:6214:b84:: with SMTP id
 fe4mr5126248qvb.3.1603840257726; Tue, 27 Oct 2020 16:10:57 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:40 -0700
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
Message-Id: <20201027231044.655110-3-oupton@google.com>
Mime-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 2/6] Documentation: kvm: fix ordering of msr filter, pv documentation
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both were added around the same time, so it seems they collide for the
next heading number.

Fixes: 1a155254ff93 ("KVM: x86: Introduce MSR filtering")
Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 76317221d29f..fbc6a5e4585f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6367,7 +6367,7 @@ accesses that would usually trigger a #GP by KVM into the guest will
 instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
 KVM_EXIT_X86_WRMSR exit notifications.
 
-8.25 KVM_X86_SET_MSR_FILTER
+8.27 KVM_X86_SET_MSR_FILTER
 ---------------------------
 
 :Architectures: x86
@@ -6382,7 +6382,7 @@ trap and emulate MSRs that are outside of the scope of KVM as well as
 limit the attack surface on KVM's MSR emulation code.
 
 
-8.26 KVM_CAP_ENFORCE_PV_CPUID
+8.28 KVM_CAP_ENFORCE_PV_CPUID
 -----------------------------
 
 Architectures: x86
-- 
2.29.0.rc2.309.g374f81d7ae-goog

