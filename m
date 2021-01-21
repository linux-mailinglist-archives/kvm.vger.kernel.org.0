Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651792FF1E6
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbhAUROC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 12:14:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388531AbhAURMV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 12:12:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611249055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gj145NXZKVxVx1ghR0FfUZ22hzpc5dsaWCMQogr6chs=;
        b=aYCm4P9R0XKY0cPZFeR8hfqPjhiQqqXdatZ8O/csKtKNNhVvRQj1lfsD8ecbhAeGDKMRg2
        byjwEOd036/3TEr4FJ6EBlrc7IWALomPbWfldR1VeMiS3skGYlBMmozalGtJUUk3UzRMC+
        N8sN8V+a8WB6DY4o63ND1MrCE9H0hrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-Dyxws2CMMhWBvLUgMr6g5Q-1; Thu, 21 Jan 2021 12:10:54 -0500
X-MC-Unique: Dyxws2CMMhWBvLUgMr6g5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 624EC1005504;
        Thu, 21 Jan 2021 17:10:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28CB1648A8;
        Thu, 21 Jan 2021 17:10:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/2] VMX: few tracing improvements
Date:   Thu, 21 Jan 2021 19:10:41 +0200
Message-Id: <20210121171043.946761-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the fix for the bug in nested migration on VMX is=0D
already merged by Paulo, those are the remaining=0D
patches in this series.=0D
=0D
I added a new patch to trace SVM nested entries from=0D
SMM and nested state load as well.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (2):=0D
  KVM: nSVM: move nested vmrun tracepoint to enter_svm_guest_mode=0D
  KVM: nVMX: trace nested vm entry=0D
=0D
 arch/x86/kvm/svm/nested.c | 26 ++++++++++++++------------=0D
 arch/x86/kvm/trace.h      | 30 ++++++++++++++++++++++++++++++=0D
 arch/x86/kvm/vmx/nested.c |  5 +++++=0D
 arch/x86/kvm/x86.c        |  3 ++-=0D
 4 files changed, 51 insertions(+), 13 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

