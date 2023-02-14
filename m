Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4971B695790
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 04:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjBNDqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 22:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbjBNDqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 22:46:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640059779
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 19:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676346320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T3RTShQ549nS3MCyK+d3Glymy/QK2/1R23bUV/FnFH8=;
        b=EBdXI1U3G+RJBo53BZYopGICZ7idnqQN7R2No5fxRQ8TzlmdWzAli+RYnV4boyYQazXJIE
        2LVoMBCQNt8vt7jwDx97TDZ4QOgDGNwRiHQ+VMeQC5ruSVWssF3xT6riK5XrTRdvJqNquy
        pOaHFAAwV7yPAM/FpqDx/OE9ShQLgb4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-M1hFsxafMBq6KFp5tGyM0A-1; Mon, 13 Feb 2023 22:45:11 -0500
X-MC-Unique: M1hFsxafMBq6KFp5tGyM0A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4630985CBE5;
        Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EDDCC16022;
        Tue, 14 Feb 2023 03:45:11 +0000 (UTC)
From:   shahuang@redhat.com
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [kvm-unit-tests 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date:   Mon, 13 Feb 2023 22:44:50 -0500
Message-Id: <20230214034453.148494-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shahuang@redhat.com>

Some tests still use their own code to enable/disable irq, use
gic_enable/disable_irq() to clean up them.

The first patch fixes a problem which will disable all irq when use
gic_disable_irq().

The patch 2-3 clean up the code by using the macro.

Shaoqin Huang (3):
  arm: gic: Write one bit per time in gic_irq_set_clr_enable()
  arm64: timer: Use gic_enable/disable_irq() macro in timer test
  arm64: microbench: Use gic_enable_irq() macro in microbench test

 arm/micro-bench.c | 15 +--------------
 arm/timer.c       | 20 +++-----------------
 lib/arm/gic.c     |  4 +---
 3 files changed, 5 insertions(+), 34 deletions(-)

-- 
2.39.1

