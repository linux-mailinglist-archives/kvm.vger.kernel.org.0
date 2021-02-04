Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8166A30C6B2
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236970AbhBBQz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:55:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236865AbhBBQxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612284708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LV11/0c842FC4pXTtG9lqAW9PRJBf4lGS2WaCRXoDNM=;
        b=NlBVUnmm3j+MUtOt0Yj1yBjOiVfgsLrA3wJs7YAFsz23BMPRd8MU929UBjswfcedf2K38n
        l59jtm7A/IOreQyorJZ2ZLdikbNIbbh5KIgUF8M0PXuemDCjbs4f1A8HpKv+62rQ2ccAYR
        LTiPtr9UVK+CQl0rTAIUi5nkIuJkV04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91--oPDCLPCMAGVtpEc-aaSJQ-1; Tue, 02 Feb 2021 11:51:43 -0500
X-MC-Unique: -oPDCLPCMAGVtpEc-aaSJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36EDC195D56A;
        Tue,  2 Feb 2021 16:51:42 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD77460862;
        Tue,  2 Feb 2021 16:51:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 0/3] use kvm_complete_insn_gp more
Date:   Tue,  2 Feb 2021 11:51:38 -0500
Message-Id: <20210202165141.88275-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_complete_insn_gp is a nice little function that dates back to more
than 10 years ago but was almost never used.

This simple series continues what was done for RDMSR/WRMSR in preparation
for SEV-ES support, using it in XSETBV, INVPCID and MOV to DR intercepts.

Paolo

Paolo Bonzini (3):
  KVM: x86: move kvm_inject_gp up from kvm_set_xcr to callers
  KVM: x86: move kvm_inject_gp up from kvm_handle_invpcid to callers
  KVM: x86: move kvm_inject_gp up from kvm_set_dr to callers

 arch/x86/kvm/svm/svm.c | 32 +++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c | 35 ++++++++++++++++++-----------------
 arch/x86/kvm/x86.c     | 38 ++++++++++++--------------------------
 3 files changed, 45 insertions(+), 60 deletions(-)

-- 
2.26.2

