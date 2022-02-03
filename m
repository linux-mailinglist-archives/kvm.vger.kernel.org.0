Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BDA4A8298
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 11:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242371AbiBCKq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 05:46:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242200AbiBCKq2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 05:46:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643885187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZlK7KAyjX7xhlKn/DnEtC3ueH7LNaWwMRja7C4FInX8=;
        b=adbRg4kU1KMyTLng/4RyP+Huapsh70dgNtTGIvKHJRmowTEcfzOljMKqSJNE0Q7IcWu7FS
        wcJly+au1tUQCtsFfNhBo74f4IEbx44uAve4vuc7vBwLBuJc7/22DeX4NgfC6U36YAnI+z
        Y7mWdKBkpd14nlsLof65hapoqg8KTLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-v-FkZ_y6MOeNOO_yoeTggA-1; Thu, 03 Feb 2022 05:46:24 -0500
X-MC-Unique: v-FkZ_y6MOeNOO_yoeTggA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71AFC81431A;
        Thu,  3 Feb 2022 10:46:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FB73108B7;
        Thu,  3 Feb 2022 10:46:21 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] KVM: selftests: Introduce selftests for enlightened MSR-Bitmap feature
Date:   Thu,  3 Feb 2022 11:46:14 +0100
Message-Id: <20220203104620.277031-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM gained support for enlightened MSR-Bitmap Hyper-V feature (Hyper-V
on KVM) for both nVMX and nSVM, test it in selftests.

Vitaly Kuznetsov (6):
  KVM: selftests: Adapt hyperv_cpuid test to the newly introduced
    Enlightened MSR-Bitmap
  KVM: selftests: nVMX: Properly deal with 'hv_clean_fields'
  KVM: selftests: nVMX: Add enlightened MSR-Bitmap selftest
  KVM: selftests: nSVM: Set up MSR-Bitmap for SVM guests
  KVM: selftests: nSVM: Update 'struct vmcb_control_area' definition
  KVM: selftests: nSVM: Add enlightened MSR-Bitmap selftest

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/evmcs.h      | 150 ++++++++++++++-
 .../selftests/kvm/include/x86_64/svm.h        |   9 +-
 .../selftests/kvm/include/x86_64/svm_util.h   |   6 +
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |   6 +
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 ++++++-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  29 +--
 .../selftests/kvm/x86_64/hyperv_svm_test.c    | 175 ++++++++++++++++++
 8 files changed, 424 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c

-- 
2.34.1

