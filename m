Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3107D78D97B
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbjH3SdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244190AbjH3Mnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 08:43:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89230185
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 05:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693399371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K19JqMqw3T4h5GNNeXhzPHPOdBTLzGKTl2fYtxS/84s=;
        b=DvEPznq1TiXfI/wzJMj/q9hjkY4gHZ74omnaxm4m96N6mhIaTmzvu5w2L/lszmnWO1pC7h
        gQsEE0hJX2HBFSl9RBNJVw37CEQsnBbL8QcOHWEa0AxZPm33a80pXk4ZPY0espVDVCMsJE
        HoFWq000HuvVyFwrxyuG7WzA5vCX4t0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-yKltu9uJPCqyO5sX2f5CVw-1; Wed, 30 Aug 2023 08:42:48 -0400
X-MC-Unique: yKltu9uJPCqyO5sX2f5CVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E79E0185A7AF;
        Wed, 30 Aug 2023 12:42:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2404A2026D38;
        Wed, 30 Aug 2023 12:42:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/4] KVM: x86: tracepoint updates
Date:   Wed, 30 Aug 2023 15:42:39 +0300
Message-Id: <20230830124243.671152-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is intended to add some selected information=0D
to the kvm tracepoints to make it easier to gather insights about=0D
running nested guests.=0D
=0D
This patch series was developed together with a new x86 performance analysi=
s tool=0D
that I developed recently (https://gitlab.com/maximlevitsky/kvmon)=0D
which aims to be a better kvm_stat, and allows you at glance=0D
to see what is happening in a VM, including nesting.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: x86: refactor req_immediate_exit logic=0D
  KVM: x86: add more information to the kvm_entry tracepoint=0D
  KVM: x86: add more information to kvm_exit tracepoint=0D
  KVM: x86: add new nested vmexit tracepoints=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |   2 +-=0D
 arch/x86/include/asm/kvm_host.h    |  11 ++-=0D
 arch/x86/kvm/svm/nested.c          |  22 ++++++=0D
 arch/x86/kvm/svm/svm.c             |  22 +++++-=0D
 arch/x86/kvm/trace.h               | 115 +++++++++++++++++++++++++++--=0D
 arch/x86/kvm/vmx/nested.c          |  21 ++++++=0D
 arch/x86/kvm/vmx/vmx.c             |  31 +++++---=0D
 arch/x86/kvm/vmx/vmx.h             |   2 -=0D
 arch/x86/kvm/x86.c                 |  34 ++++-----=0D
 9 files changed, 212 insertions(+), 48 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

