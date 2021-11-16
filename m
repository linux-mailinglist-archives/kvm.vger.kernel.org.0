Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C278453999
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 19:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbhKPSwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 13:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239621AbhKPSwD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 13:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637088546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SQ/0IH2PWPpJtuZWEwj8dBSpRlGRX28UcCMPmTRX3A8=;
        b=ZFmhEq1a4wHt+6VvhpYaVtFqOE9VyZXtFjVilb45njTwahuBYPSsRJX3LkJndTRJZb0uGL
        D/oErMiptkcAslq36y7qbhumTN28jLsnnkXLXmW67rghg0NHvXhWCxPXoXpRHvhweZ6kNp
        /3SZrL07huCtrPOEKZsZr19wyd/Cv4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-X0nuG_lLNwWd_-bKIA7DVA-1; Tue, 16 Nov 2021 13:49:04 -0500
X-MC-Unique: X0nuG_lLNwWd_-bKIA7DVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10F2018D6A25
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 18:49:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D36FA2AF6D
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 18:49:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: do not run vmx_pf_exception_test twice
Date:   Tue, 16 Nov 2021 13:49:03 -0500
Message-Id: <20211116184903.915158-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_pf_exception_test runs for quite some time, therefore it has its own
separate stanza in x86/unittests.cfg.  However, the main "vmx" test
does not skip it, thus causing the test to run twice.  Remove it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 27ecd31..4402287 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -286,7 +286,7 @@ arch = i386
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test"
+extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test"
 arch = x86_64
 groups = vmx
 
-- 
2.27.0

