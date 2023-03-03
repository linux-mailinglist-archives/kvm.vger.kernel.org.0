Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F226A8FB5
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 04:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCCDNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 22:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCCDNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 22:13:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11C157D32
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 19:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677813154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IO1gpQ6okMjDRZ9SmWpM9jmX/gPcR4kBaLTqXQqGADg=;
        b=DolW2TDnWMy9zQBsyF6D+uDWD97Cyh0woMp/ap772kvPrEzheeoIplnZQC3CoPL8+lAqBB
        JdSZlDemdXwlORUB02Nc1gH85vGIgH67BIC7a/jQIsuuHrgSr6q7vso53AjYf7bQS6cZR3
        KPhYUHQZVBF+QNzrKt9uUWObKe067jg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-PbniyvcsO82z3qx0h8TcAg-1; Thu, 02 Mar 2023 22:12:28 -0500
X-MC-Unique: PbniyvcsO82z3qx0h8TcAg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7F761871D94;
        Fri,  3 Mar 2023 03:12:27 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B343E492C3E;
        Fri,  3 Mar 2023 03:12:27 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Eric Auger <eric.auger@redhat.com>,
        kvm@vger.kernel.org (open list:ARM)
Subject: [kvm-unit-tests PATCH v3 0/3] arm: Use gic_enable/disable_irq() macro to clean up code 
Date:   Thu,  2 Mar 2023 22:11:44 -0500
Message-Id: <20230303031148.162816-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

Changelog:
----------
v3:
  - s/diretly/directly.
  - Refer Gic Spec to make comments more clear.
v2:
  - tweak the comments in patch 1. (Eric)
  - Reviewed by Eric.

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

