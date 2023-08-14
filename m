Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97A777C368
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjHNWZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 18:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbjHNWZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 18:25:00 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9C418B
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 15:24:58 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzZ-00FWLK-Rb; Tue, 15 Aug 2023 00:24:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject
        :Cc:To:From; bh=ob9Z6a2R9ZQTI0T4OL8ULWUeLEKDleudJ+EMJY1Cyj0=; b=vyJfOOGwJ1TIX
        p/dn4uke3+/Xbqqw+7sgJMDCto+imCJwkdiE5wSSOh72MjclukSEZDFjePlaVo8shvGpR8Xs/cwbE
        y81lpGQu3p2OVEKnrrsUuHvRsvArw0Yejh0lgoWqZrfrhc57qP2+t/Uqj42V4SdXUmX+dWSUszFq9
        RTL/w+GnfwHaX07Y1qYg9705MZSnXxBVPoOsYwMDq7Qa3ajHKMPuBt5VMRbXU1Mo43uU9r9i4EZls
        2978KbgFIoMWdNrhMKTNsUkbfzzx6R6xMSUAJ8WCz73Or5e8gKsWTort9o1DPjwGfgki7djyKwrAG
        3YX3FpKdSEH0uCQlbWHXQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qVfzU-0000a0-6L; Tue, 15 Aug 2023 00:24:48 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qVfzG-00077S-9S; Tue, 15 Aug 2023 00:24:34 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net
Cc:     kvm@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 0/3] KVM: x86: Cleanups
Date:   Tue, 15 Aug 2023 00:08:34 +0200
Message-ID: <20230814222358.707877-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0
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

As discussed[*], some minor clean-ups. Plus an attempt to smuggle a fix for
a typo in API documentation.

[*] https://lore.kernel.org/kvm/e55656be-2752-a317-80eb-ad40e474b62f@redhat.com/

Michal Luczaj (3):
  KVM: x86: Remove redundant vcpu->arch.cr0 assignments
  KVM: x86: Force TLB flush on changes to special registers
  KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation

 Documentation/virt/kvm/api.rst | 34 +++++++++++++++++-----------------
 arch/x86/kvm/smm.c             |  1 -
 arch/x86/kvm/x86.c             |  9 ++++++---
 3 files changed, 23 insertions(+), 21 deletions(-)

-- 
2.41.0

