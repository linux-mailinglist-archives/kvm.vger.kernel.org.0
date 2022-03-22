Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FF94E47E8
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 21:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiCVU6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiCVU5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 16:57:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C5866415
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 13:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647982577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aSq4dpZNnajAzpwvwp00tz4DxLhUym1A/FGdc+idMHI=;
        b=TJY8ktqHGiGupGiy5HWZ6M6KKALyKtbL0FzWRSNY+PW2X7AKyMACSWfLlaqCScoxij6YyX
        26qXQdSfJdahiEl129u/P9UIVeDO60+sXvp1kDWKL5mI/FfUGIEm0M9IF4DjrcpRRqlX49
        HoK0teiJk4oiarY/Nh7kvQO2DONPbZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-iMUa6owWO-CiXzdvc29H1A-1; Tue, 22 Mar 2022 16:56:15 -0400
X-MC-Unique: iMUa6owWO-CiXzdvc29H1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DC2C899ECD
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 20:56:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 807FFC26E9A;
        Tue, 22 Mar 2022 20:56:14 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 0/9] KVM unit tests for SVM options features
Date:   Tue, 22 Mar 2022 22:56:04 +0200
Message-Id: <20220322205613.250925-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those are few fixes and unit tests I used to=0D
test svm optional features and few more svm feaures.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (9):=0D
  pmu_lbr: few fixes=0D
  svm: Fix reg_corruption test, to avoid timer interrupt firing in later=0D
    tests.=0D
  svm: NMI is an "exception" and not interrupt in x86 land=0D
  svm: intercept shutdown in all svm tests by default=0D
  svm: add SVM_BARE_VMRUN=0D
  svm: add tests for LBR virtualization=0D
  svm: add tests for case when L1 intercepts various hardware interrupts=0D
  svm: add test for nested tsc scaling=0D
  svm: add test for pause filter and threshold=0D
=0D
 lib/x86/msr.h       |   1 +=0D
 lib/x86/processor.h |   4 +=0D
 x86/pmu_lbr.c       |   6 +=0D
 x86/svm.c           |  57 ++---=0D
 x86/svm.h           |  71 +++++-=0D
 x86/svm_tests.c     | 582 +++++++++++++++++++++++++++++++++++++++++++-=0D
 x86/unittests.cfg   |   8 +-=0D
 7 files changed, 688 insertions(+), 41 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

