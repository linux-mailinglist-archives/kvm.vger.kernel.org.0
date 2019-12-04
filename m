Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC611356A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfLDTHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:07:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56662 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728465AbfLDTH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 14:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575486448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5z9DSSJjWBkwMoPX0AiQMG2lTnPniK2p7yuPt+JjwOw=;
        b=dW1/Yr9AjXRBv++0H2kZH7LV0QHuZyc3aw1cBRWAasn6dHNcbYw+pbLH7LXrSJubNWp54+
        MQjCU3eMGDhG6B8tgoPQR66czZS4hIPnEJKq6LQZUyNlHt+TNOpb/4pF0IzZ1WkAg/wnvP
        2VHSnqlS3kdIIULesHWj0x/xl4bj704=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-jBaVcA1BMuuhqDAbqYFOnQ-1; Wed, 04 Dec 2019 14:07:26 -0500
Received: by mail-qk1-f198.google.com with SMTP id q125so451018qka.1
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v2wRBhbJMNEdghlygF10/9hA60Iod/Z62OhKSAkteiI=;
        b=Axl2nvhV37wmGukV+VNB6PV9pKriuaQoI62DoFj3waWssp6tfK+PSRX3URwt3r8Ap5
         DAnJnHKwya8ZCUgRQuAvvDP7N/wLJYCj2YUpqVm5kX0O53V+q8Fade1PvgoynG4iepaA
         l17vL/I7XQbmZGwmQFMZhT/Aw16SXGApMV6og8LfWthXykFI0RrQU/UC6yySqTWyNcDG
         FVRIiLs2gC7rIDJvb2WhYNHgwwmHD1dB8BzANPNldmBvfcbJ7aAjmZjr6UOTTLGQNzV8
         sIPLOyD/3ZH2/dtv9MDfuNd9H2Hf63q2FAmcnHRr3vHsmNdKIr8OEzsQeR4jMXkytsUb
         0aYg==
X-Gm-Message-State: APjAAAW5RcD/sLkZDEIUpaz85E8nDfPr3EP0x/q1k/O1RCYAV/uZTFXE
        DWaQ3cxTA74z/DSgY/xJxq88ckVXXfwJWnKM+zfIdg/Dk8R02fTDABzhHwWHHudCG1zlxEWDRqS
        IZD73KAfI3blJ
X-Received: by 2002:a37:b283:: with SMTP id b125mr4764052qkf.352.1575486446404;
        Wed, 04 Dec 2019 11:07:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRevtH1T5mqVjOK0YkaXbvotY+Dzc53TaR3BgA35JFGZAZOoqoBMsySDC6Tdp4+EoNNPc1dA==
X-Received: by 2002:a37:b283:: with SMTP id b125mr4764022qkf.352.1575486446139;
        Wed, 04 Dec 2019 11:07:26 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id y18sm4072126qtn.11.2019.12.04.11.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:07:25 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v5 2/6] KVM: X86: Move irrelevant declarations out of ioapic.h
Date:   Wed,  4 Dec 2019 14:07:17 -0500
Message-Id: <20191204190721.29480-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191204190721.29480-1-peterx@redhat.com>
References: <20191204190721.29480-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: jBaVcA1BMuuhqDAbqYFOnQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_apic_match_dest() is declared in both ioapic.h and lapic.h.
Remove the declaration in ioapic.h.

kvm_apic_compare_prio() is declared in ioapic.h but defined in
lapic.c.  Move the declaration to lapic.h.

kvm_irq_delivery_to_apic() is declared in ioapic.h but defined in
irq_comm.c.  Move the declaration to irq.h.

hyperv.c needs to use kvm_irq_delivery_to_apic(). Include irq.h in
hyperv.c.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/hyperv.c | 1 +
 arch/x86/kvm/ioapic.h | 6 ------
 arch/x86/kvm/irq.h    | 3 +++
 arch/x86/kvm/lapic.h  | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 23ff65504d7e..c7d4640b7b1c 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -33,6 +33,7 @@
 #include <trace/events/kvm.h>
=20
 #include "trace.h"
+#include "irq.h"
=20
 #define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
=20
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index ea1a4e0297da..2fb2e3c80724 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -116,9 +116,6 @@ static inline int ioapic_in_kernel(struct kvm *kvm)
 }
=20
 void kvm_rtc_eoi_tracking_restore_one(struct kvm_vcpu *vcpu);
-bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
-=09=09int short_hand, unsigned int dest, int dest_mode);
-int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector,
 =09=09=09int trigger_mode);
 int kvm_ioapic_init(struct kvm *kvm);
@@ -126,9 +123,6 @@ void kvm_ioapic_destroy(struct kvm *kvm);
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_=
id,
 =09=09       int level, bool line_status);
 void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
-int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
-=09=09=09     struct kvm_lapic_irq *irq,
-=09=09=09     struct dest_map *dest_map);
 void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
 void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 7c6233d37c64..f173ab6b407e 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -113,5 +113,8 @@ int apic_has_pending_timer(struct kvm_vcpu *vcpu);
=20
 int kvm_setup_default_irq_routing(struct kvm *kvm);
 int kvm_setup_empty_irq_routing(struct kvm *kvm);
+int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+=09=09=09     struct kvm_lapic_irq *irq,
+=09=09=09     struct dest_map *dest_map);
=20
 #endif
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 39925afdfcdc..0b9bbadd1f3c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -83,7 +83,7 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset=
, int len,
 =09=09       void *data);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 =09=09=09   int short_hand, unsigned int dest, int dest_mode);
-
+int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
--=20
2.21.0

