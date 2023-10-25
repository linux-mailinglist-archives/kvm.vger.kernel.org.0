Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59F27D70F9
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbjJYPbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjJYPbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2720136
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7L/i8kjYKMFqyKkJ6SgeCAWqw4jNr/y+ZqQ9jhXclJY=;
        b=V2pT7sn0s0r7NNJDGYTL/16Ap8bA1cXV9c8DILQY3pQv/WXZjhfVya57K7plKJ9/WTRBtI
        1KRuADISWCmriHKNJrJN8qC1eL7n9RgHWMV2YmY2+0zn+hPzyQ49D31cB+TextMcRW0W+6
        on85E7CEO7Q4BqSJaH6goMyirGUvK18=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-rNl0wh5_MZWT4UyjeOa68g-1; Wed, 25 Oct 2023 11:29:19 -0400
X-MC-Unique: rNl0wh5_MZWT4UyjeOa68g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23756811E98;
        Wed, 25 Oct 2023 15:29:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D28A2166B26;
        Wed, 25 Oct 2023 15:29:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH kvm-unit-tests 0/4] x86: hyper-v: Add support for CONFIG_KVM_HYPERV
Date:   Wed, 25 Oct 2023 17:29:11 +0200
Message-ID: <20231025152915.1879661-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the introduction of CONFIG_KVM_HYPERV:
https://lore.kernel.org/kvm/20231025152406.1879274-1-vkuznets@redhat.com/

it becomes possible to build KVM without Hyper-V emulation support. Make
Hyper-V tests in kvm-unit-tests handle such case with dignity.

Vitaly Kuznetsov (4):
  x86: hyper-v: Use '-cpu host,hv_passhtrough' for Hyper-V tests
  x86: hyper-v: Use report_skip() in hyperv_stimer when pre-requisites
    are not met
  x86: hyper-v:  Use 'goto' instead of putting the whole test in an 'if'
    branch in hyperv_synic
  x86: hyper-v: Unify hyperv_clock with other Hyper-V tests

 x86/hyperv_clock.c  | 12 ++++-----
 x86/hyperv_stimer.c |  6 ++---
 x86/hyperv_synic.c  | 61 +++++++++++++++++++++++----------------------
 x86/unittests.cfg   |  8 +++---
 4 files changed, 43 insertions(+), 44 deletions(-)

-- 
2.41.0

