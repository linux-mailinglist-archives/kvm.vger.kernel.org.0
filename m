Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21467AC815
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjIXMpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 08:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjIXMpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 08:45:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8644C103
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 05:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695559458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iy6m9rfrGHIez/IGJ65IvETHEu81RQinD/bp3oWQKQI=;
        b=ZLBobyc0/2GYxAFplHGPf1w52YDgxojFiZqTsunRqBtyQKcSgpjJ3BUmPenSk4gD0tyzg/
        G2MBDxwoj+3nEUMD1SuPRyVkUydTJnLebwuXk0IiJXcdjivQZu1aegkLUUWIWvzV6/pKH3
        0tC6DI50tzqRMe51jkXrGpGvar4iW6s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-uE8Jf8XMOl6CmJI0vk2k7w-1; Sun, 24 Sep 2023 08:44:15 -0400
X-MC-Unique: uE8Jf8XMOl6CmJI0vk2k7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD3AD185A78E;
        Sun, 24 Sep 2023 12:44:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 588B840C6EA8;
        Sun, 24 Sep 2023 12:44:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/4] KVM: x86: tracepoint updates
Date:   Sun, 24 Sep 2023 15:44:06 +0300
Message-Id: <20230924124410.897646-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 9 files changed, 214 insertions(+), 46 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

