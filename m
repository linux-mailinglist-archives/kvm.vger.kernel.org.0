Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270551DB8FA
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgETQH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:07:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35179 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726747AbgETQHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 12:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589990869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E7vWrkA41Lbp4gQucfyzJ2NA68KZJVdfSkrpXlefoOA=;
        b=SsVN176hbxT4S7Eu8lAkUfhoZkpsdOmo8rLSHLi/ii1DJ4FOmlJMGkWGodArQwT3JxM+u3
        QvZDfRPFCW1TV1StbfgfegQIUhKYJYJ1PmxKO3s2ELv+HV+8u8ltpR2XuyE+W/wVvw6iOc
        Fct69C4WApqybDAawEErl6M/48uswtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-vgoOO36qM3CobbxcYUw79g-1; Wed, 20 May 2020 12:07:46 -0400
X-MC-Unique: vgoOO36qM3CobbxcYUw79g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFD198015D2;
        Wed, 20 May 2020 16:07:45 +0000 (UTC)
Received: from starship.fedora32vm (unknown [10.35.207.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9168D341FD;
        Wed, 20 May 2020 16:07:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/2] kvm: cosmetic: remove wrong braces in kvm_init_msr_list switch
Date:   Wed, 20 May 2020 19:07:39 +0300
Message-Id: <20200520160740.6144-2-mlevitsk@redhat.com>
In-Reply-To: <20200520160740.6144-1-mlevitsk@redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I think these were added accidentally.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 471fccf7f8501..fe3a24fd6b263 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5299,7 +5299,7 @@ static void kvm_init_msr_list(void)
 				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
 				continue;
 			break;
-		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
+		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
 			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
 				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
 				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
@@ -5314,7 +5314,6 @@ static void kvm_init_msr_list(void)
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
-		}
 		default:
 			break;
 		}
-- 
2.26.2

