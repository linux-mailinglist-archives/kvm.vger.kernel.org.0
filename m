Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709C732B5B2
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382757AbhCCHTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836011AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dy4gNJw15YtVaiyXAQHpjvgJqSs/amc17Z8gZOPexUI=;
        b=NwcYJ46PppJF67oUxXbM1m0wSAyAexnx904vYRDX0lBUNkjRpdRcEdWC/lukDXILcDxPoB
        RdR3faWiXVBZFW8+wLkJopHp2Hc32dpSGEME6APgZ8z3Q8Yg37cDJfS6l7a2dTy1+DXGvn
        dJgNPdEoQkB1DYNOlW/5YTL1/iDRZHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-7tkS4ex0ODmENB_ung2YuA-1; Tue, 02 Mar 2021 14:33:58 -0500
X-MC-Unique: 7tkS4ex0ODmENB_ung2YuA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACA34106BB23;
        Tue,  2 Mar 2021 19:33:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2102618996;
        Tue,  2 Mar 2021 19:33:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 22/23] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
Date:   Tue,  2 Mar 2021 14:33:42 -0500
Message-Id: <20210302193343.313318-23-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Babu Moger <babu.moger@amd.com>

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. Presence of this feature is indicated via CPUID
function 0x8000000A_EDX[20]: GuestSpecCtrl. When present, the
SPEC_CTRL MSR is automatically virtualized.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Borislav Petkov <bp@suse.de>
Message-Id: <161188100272.28787.4097272856384825024.stgit@bmoger-ubuntu>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f1957b3c8e4e..9ac7ad4d8239 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -338,6 +338,7 @@
 #define X86_FEATURE_AVIC		(15*32+13) /* Virtual Interrupt Controller */
 #define X86_FEATURE_V_VMSAVE_VMLOAD	(15*32+15) /* Virtual VMSAVE VMLOAD */
 #define X86_FEATURE_VGIF		(15*32+16) /* Virtual GIF */
+#define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
-- 
2.26.2


