Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCE557A1C2
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbiGSOhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbiGSOhc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:37:32 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C7DC64
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:31:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658241105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZyU2BYi7LeiqlQcK6LmNwCy8Z+l0G30madVNBDLhPek=;
        b=PwgqyNYLhf0AnYo+Gpl4JZ+jdndVqh6RpzxhLsT7/TLRGb4nI42T4/I1GKqaxDDw5vfR14
        u4wnlQxBrN1yKCNLLYa9RHmQ366Xj7rEsKWO+stkZdvK57YypiKufeEy5M6w+VdJG9D+zs
        AfQdy9XxOHK4NPO7HJ8uaj+Kbl4zf9c=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Oliver Upton <oupton@google.com>
Subject: [PATCH 0/3] selftests: KVM: Improvements to binary stats test
Date:   Tue, 19 Jul 2022 14:31:31 +0000
Message-Id: <20220719143134.3246798-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Oliver Upton <oupton@google.com>

Small series to improve the debuggability of the binary stats test w/
more descriptive test assertions + add coverage for boolean stats.

Applies to kvm/queue, with the following patches applied:

 - 1b870fa5573e ("kvm: stats: tell userspace which values are boolean")
 - https://lore.kernel.org/kvm/20220719125229.2934273-1-oupton@google.com/

First time sending patches from my new inbox, apologies if I've screwed
something up.

Oliver Upton (3):
  selftests: KVM: Check stat name before other fields
  selftests: KVM: Provide descriptive assertions in
    kvm_binary_stats_test
  selftests: KVM: Add exponent check for boolean stats

 .../selftests/kvm/kvm_binary_stats_test.c     | 38 +++++++++++++------
 1 file changed, 27 insertions(+), 11 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

