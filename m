Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 289AD10D872
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfK2Qcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 11:32:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55236 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727076AbfK2Qcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 11:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575045162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/xSejyaXzbtUL047a9u4nhEXzM8MndtKpPyPJyLXyY=;
        b=aiFTFfB93IDnCDUkPEswixX10FEAVKLviZKhBLPfg5MP0XOAQEPeTYJOSgNVe1mOnXraaX
        F+YWXahMyo0X6DfGgcEO3CeNH5A+RXYHFRtR3nvI4VuX1IDFo0owBJLoEwOzdJ1kEctJFl
        ngnOD42wrhoQZtB3eXSTSy2oeqIkclQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-IecRPUdPMdW86Qnmx3jKLg-1; Fri, 29 Nov 2019 11:32:38 -0500
Received: by mail-qt1-f199.google.com with SMTP id j18so19222853qtp.15
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 08:32:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JfYuhM68fjTSb2nWUh/a1XhHzPawVsK+0KYnkYwzzyg=;
        b=oum5uABSqb+gkdxI9KvLDm9x+0QBCnPscQ+zhc78v5QnLL1NgsCAN8nxPf5bRZLylT
         GPGXmvEZGBWCoJ8/ao6TyvTXblB1UzeMgPWo9YG6iVCejmTNR54tWFtiBw4cAxQiFVyx
         t3KOA/OGQHdvAZzqFEaCdgSevxTe9odlreyKv9tjhsGrAn/48jOxd58IVdzDue6usEmU
         QXB92sH/ZaQQATAiSrDKmETMbnTra99OcGYvV2NqoFhnDheS1mQU6Jc4WeWW+qr7Xv3U
         TKJ+Nb2YDu8E8kczfl1qSHsXaXrpd5FsHROdDqhcSZT5s8OetBzUXH5Ols+npPnkc/4y
         k7Lw==
X-Gm-Message-State: APjAAAUKbTU9fz8t/1YWHlcFGsNpl7BVw0BYXr6vefrtxZiSLko+pOp3
        VmaeBhoiNaB2ZcxPYba7aZet2MAdGVL1pUXJka+n5hj1XosJPKrMigqlW6JdXqQJ39IwipX1mlH
        nBKBtDHMcZwFL
X-Received: by 2002:a0c:ee91:: with SMTP id u17mr16535786qvr.245.1575045158014;
        Fri, 29 Nov 2019 08:32:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzmI9LDbhfjPk/kPBygYFre0p1EfkrO+8gFy85TuTM9UlPya9CAD4HYy130ni/hYFTuHHtkNw==
X-Received: by 2002:a0c:ee91:: with SMTP id u17mr16535759qvr.245.1575045157801;
        Fri, 29 Nov 2019 08:32:37 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d9sm4568329qtj.52.2019.11.29.08.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 08:32:36 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 1/3] KVM: X86: Some cleanups in ioapic.h/lapic.h
Date:   Fri, 29 Nov 2019 11:32:32 -0500
Message-Id: <20191129163234.18902-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129163234.18902-1-peterx@redhat.com>
References: <20191129163234.18902-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: IecRPUdPMdW86Qnmx3jKLg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both kvm_apic_match_dest() and kvm_irq_delivery_to_apic() should
probably suite more to lapic.h comparing to ioapic.h, moving.

kvm_apic_match_dest() is defined twice, once in each of the header.
Removing the one defined in ioapic.h.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/ioapic.h | 6 ------
 arch/x86/kvm/lapic.h  | 5 ++++-
 2 files changed, 4 insertions(+), 7 deletions(-)

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
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 39925afdfcdc..19b36196e2ff 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -83,7 +83,10 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offse=
t, int len,
 =09=09       void *data);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 =09=09=09   int short_hand, unsigned int dest, int dest_mode);
-
+int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
+int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
+=09=09=09     struct kvm_lapic_irq *irq,
+=09=09=09     struct dest_map *dest_map);
 bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
--=20
2.21.0

