Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C098D6A79C4
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 04:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjCBDDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 22:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCBDDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 22:03:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8AF4E5E7
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 19:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677726167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6kZFiug5mIRB7tAkTIUwsKmYbfqvTxNd2xDpOYGIXL0=;
        b=Hi/4kFNHwLXlsytk/Ur/0wM9017ZCutW/6G4nvBdLnsFPoKn+84a7ZHf4DrlOJCfKz+gGQ
        bKZKn2U/Y8sX4IghQPwfTr1jhIFRT8XrKfr9fb7kh3NErVJD7lTbfQ+32ZuMg+lB0V/NrH
        gv1s0f4wlOG6vTIje4g48CQMRGxJ7yk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-ovs6SDUBP0usNKu_LA2C6A-1; Wed, 01 Mar 2023 22:02:46 -0500
X-MC-Unique: ovs6SDUBP0usNKu_LA2C6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E843B802D38;
        Thu,  2 Mar 2023 03:02:45 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8B922026D4B;
        Thu,  2 Mar 2023 03:02:45 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Eric Auger <eric.auger@redhat.com>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [RESEND kvm-unit-tests 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date:   Wed,  1 Mar 2023 22:02:34 -0500
Message-Id: <20230302030238.158796-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

