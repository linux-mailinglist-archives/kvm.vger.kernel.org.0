Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6873B42ED55
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhJOJP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:15:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231273AbhJOJP4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 05:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634289230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=im3jtM7QDycEHpy2D3uf5n3ALksflmwMlePPaUbujbk=;
        b=L9PF2uNQkdQ9XUk18J64cX8Js6ePsUyCTaLQqJFjP3s4fNqyzy3JiOAxkYu/5grRiyX+MO
        EC8HAW4Yduiu9A4OP3OPwoRI2ZZnN0GhDMswDn9GJ+9SlFUard+wAzGpoo7+k0iICPfpzM
        w5hMJQnNcCOXhRMyUeuf/qHithR98HU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-xISD9qBQO7q6uPg6Tz_ZMg-1; Fri, 15 Oct 2021 05:13:48 -0400
X-MC-Unique: xISD9qBQO7q6uPg6Tz_ZMg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FE7D1015DA0
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:13:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CFAD1981F
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 09:13:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] vmx: remove duplicate tests from vmx test suites
Date:   Fri, 15 Oct 2021 05:13:46 -0400
Message-Id: <20211015091346.69579-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The apic_reg_virt_test and virt_x2apic_mode_test tests are already run
separately by the "vmx_apicv_test" suite, remove them from the main
suite "vmx".

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d5efab0..3000e53 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -280,7 +280,7 @@ arch = i386
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
+extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test"
 arch = x86_64
 groups = vmx
 
-- 
2.27.0

