Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B13C113573
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbfLDTHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:07:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26415 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728883AbfLDTHd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Dec 2019 14:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575486452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14g8RaA5piWvH+2ustd/wNI5q+TQc8KxgzZhf+/2kiM=;
        b=Drq/KvQjAtk1pnoHS+iAq/3ejzViWgOUFx3BUGf0nepk5U7Zyx/TxJeTyKasdlr+OMl/SV
        EYy5ScqWWULOM94Rw2UGMmb8URPnHGttqtnrCyWXvLcSKqIMKp4PBk0/l22nMyoDtIiZjt
        QVGAVI6SsrKt9pr2INgk1YStm9XR0Bc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-45E4NY4nPH-NSSanuVtM-w-1; Wed, 04 Dec 2019 14:07:30 -0500
Received: by mail-qt1-f200.google.com with SMTP id t20so641098qtr.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:07:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMSAhkBc+XDUp7X0JKW/OfiFquvplAZgCqXULfdRF2I=;
        b=oX1IB/mnlR0C9mOeFhRAP9L6zIRWDeqNO2L2pmAuqYnwev87agkhZHjrW+ppob+vGP
         AkgGvlC++kfin1lB7SPFV9iqv6EJIuePs7MzaI7JXLBvpXOSTOW752/JYaOecpmpae6x
         t7iWd+8k5e5EiJfUKtmyRgbacS4UPryFjUBZSYlJplyuhDBnNywpt7x6pSog68n5C7WP
         vvSB5A4uklArGWe5RhaZfu0rVQHynO2My0Fj8+ew9UBtrrwfiFSOd8oFiNUmk3SVze4Y
         e4UCVsCGOT0nJb2E+3bd7o3r5XCQxP/hANIz7JfsOQNGvDs0GlliPWfROp0w/e2N1jF/
         crHA==
X-Gm-Message-State: APjAAAXpRugS0q6UjYIO7UjuQH0WNwm7hQ7wrA9rgp+u8X+Z6i3Ln6bD
        cCh8xpKGWLTgs2jnXB1X2+TOYtm9k1k7haqlhA0Ge8YRVKMCbg4w4j+Ne1mU4hBoOJdodtrt17n
        VU2G07n3OQ6/O
X-Received: by 2002:a37:62c4:: with SMTP id w187mr4623785qkb.121.1575486449611;
        Wed, 04 Dec 2019 11:07:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqx342LHgJ8Z4Al1qN577PBjCuf9DkQOJEwuuV8mZT8Sv3S0edfBKQdU7LsMR1sARS/2KXJbvQ==
X-Received: by 2002:a37:62c4:: with SMTP id w187mr4623754qkb.121.1575486449366;
        Wed, 04 Dec 2019 11:07:29 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id y18sm4072126qtn.11.2019.12.04.11.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:07:28 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v5 4/6] KVM: X86: Drop KVM_APIC_SHORT_MASK and KVM_APIC_DEST_MASK
Date:   Wed,  4 Dec 2019 14:07:19 -0500
Message-Id: <20191204190721.29480-5-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191204190721.29480-1-peterx@redhat.com>
References: <20191204190721.29480-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 45E4NY4nPH-NSSanuVtM-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have both APIC_SHORT_MASK and KVM_APIC_SHORT_MASK defined for the
shorthand mask.  Similarly, we have both APIC_DEST_MASK and
KVM_APIC_DEST_MASK defined for the destination mode mask.

Drop the KVM_APIC_* macros and replace the only user of them to use
the APIC_DEST_* macros instead.  At the meantime, move APIC_SHORT_MASK
and APIC_DEST_MASK from lapic.c to lapic.h.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/lapic.c | 3 ---
 arch/x86/kvm/lapic.h | 5 +++--
 arch/x86/kvm/svm.c   | 4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1eabe58bb6d5..805c18178bbf 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -56,9 +56,6 @@
 #define APIC_VERSION=09=09=09(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
 #define LAPIC_MMIO_LENGTH=09=09(1 << 12)
 /* followed define is not in apicdef.h */
-#define APIC_SHORT_MASK=09=09=090xc0000
-#define APIC_DEST_NOSHORT=09=090x0
-#define APIC_DEST_MASK=09=09=090x800
 #define MAX_APIC_VECTOR=09=09=09256
 #define APIC_VECTORS_PER_REG=09=0932
=20
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0b9bbadd1f3c..5a9f29ed9a4b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,8 +10,9 @@
 #define KVM_APIC_SIPI=09=091
 #define KVM_APIC_LVT_NUM=096
=20
-#define KVM_APIC_SHORT_MASK=090xc0000
-#define KVM_APIC_DEST_MASK=090x800
+#define APIC_SHORT_MASK=09=09=090xc0000
+#define APIC_DEST_NOSHORT=09=090x0
+#define APIC_DEST_MASK=09=09=090x800
=20
 #define APIC_BUS_CYCLE_NS       1
 #define APIC_BUS_FREQUENCY      (1000000000ULL / APIC_BUS_CYCLE_NS)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 362e874297e4..65a27a7e9cb1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4519,9 +4519,9 @@ static int avic_incomplete_ipi_interception(struct vc=
pu_svm *svm)
 =09=09 */
 =09=09kvm_for_each_vcpu(i, vcpu, kvm) {
 =09=09=09bool m =3D kvm_apic_match_dest(vcpu, apic,
-=09=09=09=09=09=09     icrl & KVM_APIC_SHORT_MASK,
+=09=09=09=09=09=09     icrl & APIC_SHORT_MASK,
 =09=09=09=09=09=09     GET_APIC_DEST_FIELD(icrh),
-=09=09=09=09=09=09     icrl & KVM_APIC_DEST_MASK);
+=09=09=09=09=09=09     icrl & APIC_DEST_MASK);
=20
 =09=09=09if (m && !avic_vcpu_is_running(vcpu))
 =09=09=09=09kvm_vcpu_wake_up(vcpu);
--=20
2.21.0

