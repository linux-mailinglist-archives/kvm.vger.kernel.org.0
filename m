Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FD34B8EBD
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 18:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiBPRCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 12:02:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbiBPRCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 12:02:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E572AA2782
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 09:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645030914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B6YzSUwjYSM70cYuk+8dZTKX57Y4ae/DEzt0DtjiwiY=;
        b=FJzqhP4bIXObJdGX3zXpCFUDYejexsOyL3619tT+N3Tynn7M76ax3O0zZBLqmhmY6N9kBO
        YnWkCg3n4NuEIw7UbigUPkoMtR7jQE6gect/2NSxlMl/85VtBcYYtxCH+C7hXEPFnquI9V
        WetWDdvpN62jvLRDmMDGkXWfi15Ve/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-mFvRJu7vOlyWH3Dbjt5AmA-1; Wed, 16 Feb 2022 12:01:50 -0500
X-MC-Unique: mFvRJu7vOlyWH3Dbjt5AmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C14571006AA0;
        Wed, 16 Feb 2022 17:01:49 +0000 (UTC)
Received: from virtlab612.virt.lab.eng.bos.redhat.com (virtlab612.virt.lab.eng.bos.redhat.com [10.19.152.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7154F7B9F3;
        Wed, 16 Feb 2022 17:01:49 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [kvm-unit-tests v3 PATCH 0/3] vmx: Fix EPT accessed and dirty flag test
Date:   Wed, 16 Feb 2022 12:01:46 -0500
Message-Id: <20220216170149.25792-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes to EPT test plus improvements to test_vmx_vmlaunch reporting.

* Changes in v3:
 - Split fixes into 3 patches.
 - Provide more detailed patch descriptions. 
 - Improve change log entries.

* Changes in v2:
 - Use the saved EPTP to restore the EPTP after each sub-test instead of
   manually unwinding what was done by the sub-test, which is error prone
   and hard to follow
 - Explicitly setup a dummy EPTP, as calling the test in isolation will cause
   test failures due to lack a good starting EPTP 
 - Cleanup test_vmx_vmlaunch to generate clearer and
   more consolidated test reports.
   New format suggested by seanjc@google.com

Cathy Avery (3):
  vmx: Cleanup test_vmx_vmlaunch to generate clearer and more
    consolidated test reports
  vmx: Explicitly setup a dummy EPTP in EPT accessed and dirty flag test
  vmx: Correctly refresh EPTP value in EPT accessed and dirty flag test

 x86/vmx_tests.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

-- 
2.31.1

