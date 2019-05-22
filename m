Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4810261CD
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 12:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfEVKd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 06:33:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbfEVKd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 06:33:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 355C218DF44;
        Wed, 22 May 2019 10:33:53 +0000 (UTC)
Received: from 640k.localdomain.com (ovpn-112-65.ams2.redhat.com [10.36.112.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A311601B0;
        Wed, 22 May 2019 10:33:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests] vmx_tests: use enter_guest if guest state is valid
Date:   Wed, 22 May 2019 12:33:49 +0200
Message-Id: <1558521229-8770-1-git-send-email-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 22 May 2019 10:33:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change one remaining call site where the guest state is valid as far as
PAT is concerned; we should abort on both an early vmentry failure
as well as an invalid guest state.

Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a0b3639..b9bb169 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -6735,7 +6735,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 				report_prefix_pop();
 
 			} else {	// GUEST_PAT
-				enter_guest_with_invalid_guest_state();
+				enter_guest();
 				report_guest_pat_test("ENT_LOAD_PAT enabled",
 						       VMX_VMCALL, val);
 			}
-- 
1.8.3.1

