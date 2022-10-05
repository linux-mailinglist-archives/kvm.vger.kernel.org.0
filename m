Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114FB5F5483
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJEMb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJEMbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:31:51 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB034E853
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:31:48 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yw-00Gee0-FW
        for kvm@vger.kernel.org; Wed, 05 Oct 2022 14:31:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=Xh6AFv1IJhVFTpWQub5DvhExo8/2my5YKn4bDq0Mp+g=; b=I9NBOYWWYcsqg4AVsEiA8V2dzT
        2OhjQL0QMvJLVWrp3xrh/Q9rYlshKorF8N9PWxJwvME6QqzSp1/wx9hEzvGMnjFl4lFxjTLXcUj8Y
        vAnMyMB15QNP46eOaFYwkidiry5pRXUqpYqIg9eg+q5roxdlGzS1SxIn5VLy/Vvrl+FU+r8P26kJc
        g+Hi6a5SryI5N36NwZJHcqetyr03bZdIXqYmj69lXuJO0kVnSfkbmB8dy1zqpeevtUe8QgnaRB32n
        NZVx5gFXahfOPcutMxhfja+ne8E1yxHyn8NQbZr2E5nokAa5M7ALNJDL9EZpOI02CoUdQCmI0UsRc
        BKYHLIkw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1og3Yw-00061A-4j; Wed, 05 Oct 2022 14:31:46 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1og3YP-0007vp-DP; Wed, 05 Oct 2022 14:31:13 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 0/8] KVM: x86: gfn_to_pfn_cache cleanups and a fix
Date:   Wed,  5 Oct 2022 14:30:43 +0200
Message-Id: <20221005123051.895056-1-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <YySujDJN2Wm3ivi/@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Politely resending after two weeks :)

Series marked v2, but there're no functional changes, I've only tweaked
patch 4/8 commit message.

I've also made sure there are no merge conflicts with 6.0 release.

Please let me know if this needs any corrections and/or to wait.

Thanks,
Michal

Michal Luczaj (8):
  KVM: x86: Add initializer for gfn_to_pfn_cache
  KVM: x86: Shorten gfn_to_pfn_cache function names
  KVM: x86: Remove unused argument in gpc_unmap_khva()
  KVM: x86: Store immutable gfn_to_pfn_cache properties
  KVM: x86: Clean up kvm_gpc_check()
  KVM: x86: Clean up hva_to_pfn_retry()
  KVM: x86: Clean up kvm_gpc_refresh(), kvm_gpc_unmap()
  KVM: x86: Fix NULL pointer dereference in kvm_xen_set_evtchn_fast()

 arch/x86/kvm/x86.c        | 24 ++++++------
 arch/x86/kvm/xen.c        | 78 +++++++++++++++++--------------------
 include/linux/kvm_host.h  | 64 ++++++++++++++++---------------
 include/linux/kvm_types.h |  2 +
 virt/kvm/pfncache.c       | 81 +++++++++++++++++++++------------------
 5 files changed, 128 insertions(+), 121 deletions(-)

-- 
2.37.3

