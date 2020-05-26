Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EB51E2097
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389126AbgEZLFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:05:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48118 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389132AbgEZLFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 07:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590491135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wxo/6JU4Ay6RfuSzG9nMM1AaC69gbyAXb63u8KjD7Xg=;
        b=Wxv5qK9GYQY9rCR7q7W3Owntctwr0qH/E7MrsabvA07arIOI4ieCiEPWBi4ScRxmln/TSU
        cHCH2bavfCGr7caMAcCLUI+q6KgtGVZKNYqRdkCMeAEOdV6NpJqzE3cEyHmbOCTdqd6s1b
        MNyR0p7dv6/SCDJV5gakZkql9ZzVF0U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-ZBrTc4AkML-gcWa_samzJA-1; Tue, 26 May 2020 07:05:34 -0400
X-MC-Unique: ZBrTc4AkML-gcWa_samzJA-1
Received: by mail-wr1-f71.google.com with SMTP id e1so7192244wrm.3
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 04:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wxo/6JU4Ay6RfuSzG9nMM1AaC69gbyAXb63u8KjD7Xg=;
        b=mhVijKii9DZCDrr/IX0bWM7KA7+biK7J0ka+dZwMaLbR31vuAXr+67dByUR5RAPPfq
         A5dxKGwKWNMs9xCefL7yA/fr18DN6rx6oStGvqJjmLdOyJ/u4r6t7++IpmjOKWu0wEKY
         +N3ZKJgRW52nleSs6r2WKkjFVZgRaDxyPHD6yR9cr21KqFqRjApFyAn/vh2U29VkGnad
         VVe5io2s5f4ndgp0JJXtyhjeEUkaIOtX5H0CQLWwuvp0pb+AtA9AzD2PbhJxuPAmORG+
         HJXHWdFspzB9M+2bcpidyIsdLl4dTh0+Q4VTyJY8NCyNUgczxgyLwaWU9ddBOus4XRXe
         gpRw==
X-Gm-Message-State: AOAM530nWS40jzMv0GCBIIGp3J5WkhYR/7g7oVrGelgpuG68KjhgVqnN
        nSc1Smd5fvs+76zccIVBLtNhRia2kRZA7woywQhf2jeeEkZqOnHFW1vR4SPgsZUbXtZR4sF+L1i
        ju+JA+cRBLgyn
X-Received: by 2002:adf:a41a:: with SMTP id d26mr3564297wra.324.1590491132513;
        Tue, 26 May 2020 04:05:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtQPejIzuIOGlk59w68WJzfZKAuFRIeGqcFi7BVaubrvbOSzWLRRAG5Ol3GCpsl8mHBwP8Og==
X-Received: by 2002:adf:a41a:: with SMTP id d26mr3564265wra.324.1590491132283;
        Tue, 26 May 2020 04:05:32 -0700 (PDT)
Received: from localhost.localdomain.com ([194.230.155.118])
        by smtp.gmail.com with ESMTPSA id d6sm22928240wrj.90.2020.05.26.04.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 04:05:23 -0700 (PDT)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v3 6/7] [not for merge] kvm: example of stats_fs_value show function
Date:   Tue, 26 May 2020 13:03:16 +0200
Message-Id: <20200526110318.69006-7-eesposit@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200526110318.69006-1-eesposit@redhat.com>
References: <20200526110318.69006-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an example of the show function using the mp_state value.

mp_state is an enum that represents the VCPU state,
so instead of displaying its integer representation,
the show function takes care of translating the integer into a
more meaningful string representation.

The VCPU status is shown in the kvm/<vmid>/vcpu<cpuid>/mp_state file

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/stats_fs.c | 54 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/x86/kvm/stats_fs.c b/arch/x86/kvm/stats_fs.c
index f6edebb9c559..902be18562da 100644
--- a/arch/x86/kvm/stats_fs.c
+++ b/arch/x86/kvm/stats_fs.c
@@ -39,11 +39,65 @@ struct stats_fs_value stats_fs_vcpu_arch_tsc_frac[] = {
 	{ NULL } /* base is &kvm_tsc_scaling_ratio_frac_bits */
 };
 
+char *stats_fs_vcpu_get_mpstate(uint64_t state)
+{
+	char *state_str;
+
+	state_str = kzalloc(20, GFP_KERNEL);
+	if (!state_str)
+		return ERR_PTR(-ENOMEM);
+
+	switch (state) {
+	case KVM_MP_STATE_RUNNABLE:
+		strcpy(state_str, "RUNNABLE");
+		break;
+	case KVM_MP_STATE_UNINITIALIZED:
+		strcpy(state_str, "UNINITIALIZED");
+		break;
+	case KVM_MP_STATE_INIT_RECEIVED:
+		strcpy(state_str, "INIT_RECEIVED");
+		break;
+	case KVM_MP_STATE_HALTED:
+		strcpy(state_str, "HALTED");
+		break;
+	case KVM_MP_STATE_SIPI_RECEIVED:
+		strcpy(state_str, "SIPI_RECEIVED");
+		break;
+	case KVM_MP_STATE_STOPPED:
+		strcpy(state_str, "STOPPED");
+		break;
+	case KVM_MP_STATE_CHECK_STOP:
+		strcpy(state_str, "CHECK_STOP");
+		break;
+	case KVM_MP_STATE_OPERATING:
+		strcpy(state_str, "OPERATING");
+		break;
+	case KVM_MP_STATE_LOAD:
+		strcpy(state_str, "LOAD");
+		break;
+	default:
+		strcpy(state_str, "UNRECOGNIZED");
+		break;
+	}
+
+	return state_str;
+}
+
+struct stats_fs_value stats_fs_vcpu_mp_state[] = {
+	VCPU_ARCH_STATS_FS("mp_state", kvm_vcpu_arch, mp_state,
+			   .type = &stats_fs_type_u32,
+			   .show = stats_fs_vcpu_get_mpstate),
+	{ NULL }
+};
+
 void kvm_arch_create_vcpu_stats_fs(struct kvm_vcpu *vcpu)
 {
 	stats_fs_source_add_values(vcpu->stats_fs_src, stats_fs_vcpu_tsc_offset,
 				   &vcpu->arch, 0);
 
+	stats_fs_source_add_values(vcpu->stats_fs_src, stats_fs_vcpu_mp_state,
+				   &vcpu->arch, 0);
+
 	if (lapic_in_kernel(vcpu))
 		stats_fs_source_add_values(vcpu->stats_fs_src,
 					   stats_fs_vcpu_arch_lapic_timer,
-- 
2.25.4

