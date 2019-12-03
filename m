Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53D11030D
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfLCQ7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40136 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727159AbfLCQ7M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Dec 2019 11:59:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5z9DSSJjWBkwMoPX0AiQMG2lTnPniK2p7yuPt+JjwOw=;
        b=KsxictvdNx9MTScpIwVs/ACT/BgSQ7btAVjU/wak6ALfrMo28pHEsqc1uWdXfDEVQqc9LB
        pD8EnYGlFVv3UrUmZ7TwhX1Stw9XdJAKPUIg6ZNuReuYQyYqt/ZL7b73JTllHLNkvkEVzX
        4IoM3ttGgRr2HQrN37UCTwb3I6yg2IY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-7mEpew6eMCq7HFS74tO4LQ-1; Tue, 03 Dec 2019 11:59:09 -0500
Received: by mail-qv1-f70.google.com with SMTP id q17so721540qvo.23
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v2wRBhbJMNEdghlygF10/9hA60Iod/Z62OhKSAkteiI=;
        b=kDlU9t/GRiaN8Rq30kg7YpVifXNBkZmvCQCoi7yIU5hj/jieWLdDlm3JSnKxHftm88
         6424yTVo/puv9rEH//0t+3Wjlv6hPjSff7YyH009JDhfOYjGMc+lyemS8BLDiUFhyXOe
         eqJ1KtLT5IbvFkaHQHEZf/usen+QG7qQc+o9QBfCR42ORTvv3jlpODHFLF5+bexHvUZx
         aZCLNcv1ymwOF+RrO8Y+ihJrUy2b0lke+3Q/D0WjAti7wr3SolgCPNW8w2lmK9OeYdHH
         WjMGP7PIb4oeNhq1qJC5m0srKstKtG0e2rOwp7xp9rQIimvPk5lPKERv2bRzjg7tMjJI
         T16Q==
X-Gm-Message-State: APjAAAXksGGXG/vyPYnzqbwr3Ij5GqYBPH7wFd/6M6iG9zDEeNSsBHks
        1nj8F/7TbQ9CaBVrGhap3Q11lWoddqkRgEMyhqNngeUWh3dDBs9+rrJgbnlVwbrEVY75QRhUDP9
        pl1bXwY7k+5gT
X-Received: by 2002:a37:a3c1:: with SMTP id m184mr6052522qke.49.1575392348558;
        Tue, 03 Dec 2019 08:59:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyG8wKpsZ7GEJ5gyhStD0FO722TIQr2qgwbQ3M/iVrKE5wtsIGvlcXpXI0BPSfAtXE+sbQMSg==
X-Received: by 2002:a37:a3c1:: with SMTP id m184mr6052500qke.49.1575392348302;
        Tue, 03 Dec 2019 08:59:08 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:07 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 2/6] KVM: X86: Move irrelevant declarations out of ioapic.h
Date:   Tue,  3 Dec 2019 11:58:59 -0500
Message-Id: <20191203165903.22917-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203165903.22917-1-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 7mEpew6eMCq7HFS74tO4LQ-1
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

