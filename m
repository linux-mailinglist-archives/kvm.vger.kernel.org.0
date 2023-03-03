Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811166A9011
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 05:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCCELu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 23:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCCELs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 23:11:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A0815555
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 20:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677816662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i5FedhhMXmT7C9gajU5UIqVoxccypA6ZX2Fyp9n5EPE=;
        b=UsG/CWJww4c93A6bqhqZr03cYU54dGILrakQPioouBQ6uPL2qqC6VoIg3CPmCLm5apXBwJ
        Lm3psru0b8osDoT6ccb1pxHgEH5eeI8FT2OiYg6qj8sG1AzpYg0MnBGMqlu4oU43rMK5cA
        g53wRkj3VpeD1GPA+MxL7M9SgV1yLME=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-Yr58FajHPvqxhtu8toW25w-1; Thu, 02 Mar 2023 23:11:00 -0500
X-MC-Unique: Yr58FajHPvqxhtu8toW25w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CC231871D97;
        Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 758E3140EBF6;
        Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] Clean up the arm/run script
Date:   Thu,  2 Mar 2023 23:10:50 -0500
Message-Id: <20230303041052.176745-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using more simple bash command to clean up the arm/run script.

Patch 1 replace the obsolete qemu script.

Patch 2 clean up the arm/run script to make the format consistent and simple.

Changelog:
----------
v2:
  - Add the oldest QEMU version for which -chardev ? work.
  - use grep -q replace the grep > /dev/null.
  - Add a new patch to clean up the arm/run.

v1: https://lore.kernel.org/all/20230301071737.43760-1-shahuang@redhat.com/

Shaoqin Huang (2):
  arm: Replace the obsolete qemu script
  arm: Clean up the run script

 arm/run | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.39.1

