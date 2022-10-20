Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9387A60644B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJTPYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJTPYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3180A1AA261
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=coPeK5YfJIZ79ou6YIOFgQ4THN8V5is5WWnn9vkVNKM=;
        b=RIJ+LR9w7LZ7H/ivLnVa+4s3ZBcjmWKQ8mIKbUri89a3AeeXbLj89gv+MEovGb+3sBL8wE
        FNspAl8Hth5SzUnrT6KjV3GtKbbmOOkt/Tj4XHi1ewL5I8HQaebid3ZqV0fEyFpNSJWniU
        U3S/Jpj0f/gDPGGHWPPwpyif9GuwcO0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-lCbo5AmbOU2WETnEuRztkA-1; Thu, 20 Oct 2022 11:24:09 -0400
X-MC-Unique: lCbo5AmbOU2WETnEuRztkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C672A5955D
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:08 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4B6B2024CBE;
        Thu, 20 Oct 2022 15:24:06 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 00/16] kvm-unit-tests: set of fixes and new tests
Date:   Thu, 20 Oct 2022 18:23:48 +0300
Message-Id: <20221020152404.283980-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is set of fixes and new unit tests that I developed for the=0D
KVM unit tests.=0D
=0D
I also did some work to separate the SVM code into a minimal=0D
support library so that you could use it from an arbitrary test.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (16):=0D
  x86: make irq_enable avoid the interrupt shadow=0D
  x86: add few helper functions for apic local timer=0D
  svm: use irq_enable instead of sti/nop=0D
  svm: make svm_intr_intercept_mix_if/gif test a bit more robust=0D
  svm: use apic_start_timer/apic_stop_timer instead of open coding it=0D
  x86: Add test for #SMI during interrupt window=0D
  x86: Add a simple test for SYSENTER instruction.=0D
  svm: add nested shutdown test.=0D
  svm: move svm spec definitions to lib/x86/svm.h=0D
  svm: move some svm support functions into lib/x86/svm_lib.h=0D
  svm: add svm_suported=0D
  svm: move setup_svm to svm_lib.c=0D
  svm: move vmcb_ident to svm_lib.c=0D
  svm: rewerite vm entry macros=0D
  svm: introduce svm_vcpu=0D
  add IPI loss stress test=0D
=0D
 lib/x86/apic.c            |  37 ++=0D
 lib/x86/apic.h            |   6 +=0D
 lib/x86/processor.h       |   9 +-=0D
 lib/x86/svm.h             | 366 +++++++++++++++++++=0D
 lib/x86/svm_lib.c         | 168 +++++++++=0D
 lib/x86/svm_lib.h         | 142 ++++++++=0D
 x86/Makefile.common       |   4 +-=0D
 x86/Makefile.x86_64       |   5 +=0D
 x86/apic.c                |   1 -=0D
 x86/ioapic.c              |   1 -=0D
 x86/ipi_stress.c          | 235 +++++++++++++=0D
 x86/smm_int_window.c      | 125 +++++++=0D
 x86/svm.c                 | 258 ++------------=0D
 x86/svm.h                 | 453 +-----------------------=0D
 x86/svm_npt.c             |  45 +--=0D
 x86/svm_tests.c           | 724 ++++++++++++++++++++------------------=0D
 x86/sysenter.c            | 127 +++++++=0D
 x86/tscdeadline_latency.c |   1 -=0D
 x86/unittests.cfg         |  15 +=0D
 x86/vmx_tests.c           |   7 -=0D
 20 files changed, 1669 insertions(+), 1060 deletions(-)=0D
 create mode 100644 lib/x86/svm.h=0D
 create mode 100644 lib/x86/svm_lib.c=0D
 create mode 100644 lib/x86/svm_lib.h=0D
 create mode 100644 x86/ipi_stress.c=0D
 create mode 100644 x86/smm_int_window.c=0D
 create mode 100644 x86/sysenter.c=0D
=0D
-- =0D
2.26.3=0D
=0D

