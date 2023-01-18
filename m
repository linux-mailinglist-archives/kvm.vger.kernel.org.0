Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3F96718C4
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjARKRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjARKPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:15:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC235D7EC
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674033724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4tifeO2xGEUe2BR4MTPcvqD9DYXo+N6z/AHt0y7Gfcc=;
        b=P6ZHFv0sEFEJ9MaUPCiGMyuWJrxj//6tDTyyPsAdParD710V0O7tMX4VteGJvuceMRc2a6
        tETp0exKWgu3ILdvTy1BobxahMEgy/Gra8eChP45dAQifj5faxA2aNiuvT/SzMgGOrSLz+
        gGwkopP69UFdmvSQYtZLPLEL7bKrsMc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310--F4ruqJ1OKeRdNCD9UsWbQ-1; Wed, 18 Jan 2023 04:21:58 -0500
X-MC-Unique: -F4ruqJ1OKeRdNCD9UsWbQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEB67858F0E;
        Wed, 18 Jan 2023 09:21:57 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F9DA40C2064;
        Wed, 18 Jan 2023 09:21:53 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        pbonzini@redhat.com, shuah@kernel.org, maz@kernel.org,
        oliver.upton@linux.dev, maciej.szmigiero@oracle.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH 0/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
Date:   Wed, 18 Jan 2023 17:21:31 +0800
Message-Id: <20230118092133.320003-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PATCH[1] Removes the duplicate VM in memslot_perf_test
PATCH[2] Assign guest page size in the sync area in prepare_vm()

Gavin Shan (2):
  KVM: selftests: Remove duplicate VM in memslot_perf_test
  KVM: selftests: Assign guest page size in sync area early in
    memslot_perf_test

 tools/testing/selftests/kvm/memslot_perf_test.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

-- 
2.23.0

