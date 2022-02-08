Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7F4AD913
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350409AbiBHNQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355707AbiBHMVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:21:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDDB6C03FECE
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 04:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644322913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v6KhURqz/ArUHvTlCRwuMaN5ev0wLM1tF/0no7z1oEA=;
        b=UXYd/rA4AErNqhFFscdlWZM2IdIbOWXMdgPpqFmXh947o3xLw8P31GRt9eUY/jHyGV69KM
        aejajGMW040ZbiNmWjeysSOdbBOAnVPbqQk2i+ejKJpnXONk+kqVT4l4fF8L11Ll2AhV9b
        TZjKobmN8WflSkEswG8tbeTvAeFA9d0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-tRCb4_ChMuy8sKRsAP41ug-1; Tue, 08 Feb 2022 07:21:51 -0500
X-MC-Unique: tRCb4_ChMuy8sKRsAP41ug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BACC1006AB0
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 12:21:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FFFF78C30;
        Tue,  8 Feb 2022 12:21:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/7] My set of KVM unit tests + fixes
Date:   Tue,  8 Feb 2022 14:21:41 +0200
Message-Id: <20220208122148.912913-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Those are few kvm unit tests tha I developed.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (7):=0D
  pmu_lbr: few fixes=0D
  svm: Fix reg_corruption test, to avoid timer interrupt firing in later=0D
    tests.=0D
  svm: NMI is an "exception" and not interrupt in x86 land=0D
  svm: intercept shutdown in all svm tests by default=0D
  svm: add SVM_BARE_VMRUN=0D
  svm: add tests for LBR virtualization=0D
  svm: add tests for case when L1 intercepts various hardware interrupts=0D
    (an interrupt, SMI, NMI), but lets L2 control either EFLAG.IF or GIF=0D
=0D
 lib/x86/processor.h |   1 +=0D
 x86/pmu_lbr.c       |   6 +=0D
 x86/svm.c           |  41 +---=0D
 x86/svm.h           |  63 ++++++-=0D
 x86/svm_tests.c     | 447 +++++++++++++++++++++++++++++++++++++++++++-=0D
 x86/unittests.cfg   |   3 +-=0D
 6 files changed, 521 insertions(+), 40 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

