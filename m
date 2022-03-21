Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1AF4E2F0C
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351868AbiCUR3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351871AbiCUR3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:29:10 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C20618617D;
        Mon, 21 Mar 2022 10:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1647883665; x=1679419665;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T4h/d62nZ4ujburIkeEBuCEXVQx5jRD/jHSjGcMR4MM=;
  b=inTzYqVHtTvxFEZyDVBP8FwGIodjys8er0aH7wrdOnLLJo0PFNnhY4KY
   ldenQZ51SMMuYrxBXrBfgJvY44FAeDKlNFFNTTNbwOxbrHYnm5hBwTdjL
   67YNgkuCq0/7flk/xtKSMjfLcJhInr+dzJwXd39VSWZiQNTSxqK/mqQPv
   Q=;
X-IronPort-AV: E=Sophos;i="5.90,199,1643673600"; 
   d="scan'208";a="72800917"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 21 Mar 2022 17:27:29 +0000
Received: from EX13D32EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com (Postfix) with ESMTPS id EAB0D95052;
        Mon, 21 Mar 2022 17:27:26 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D32EUB002.ant.amazon.com (10.43.166.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Mon, 21 Mar 2022 17:27:25 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.033;
 Mon, 21 Mar 2022 17:27:25 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/1] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Thread-Topic: [PATCH v2 1/1] KVM: x86/xen: add support for 32-bit guests in
 SCHEDOP_poll
Thread-Index: AQHYPUc6LvcJQy+oDUqe5JacL/SQ1KzKFpQm
Date:   Mon, 21 Mar 2022 17:27:25 +0000
Message-ID: <1647883644964.29736@amazon.com>
References: <1647881191688.60603@amazon.com>,<1647882914508.15309@amazon.com>
In-Reply-To: <1647882914508.15309@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.124]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-13.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Metin Kaya <metikaya@amazon.com>=0A=
=0A=
This patch introduces compat version of struct sched_poll for=0A=
SCHEDOP_poll sub-operation of sched_op hypercall, reads correct amount=0A=
of data (16 bytes in 32-bit case, 24 bytes otherwise) by using new=0A=
compat_sched_poll struct, copies it to sched_poll properly, and lets=0A=
rest of the code run as is.=0A=
=0A=
Signed-off-by: Metin Kaya <metikaya@amazon.com>=0A=
---=0A=
 arch/x86/kvm/xen.c | 31 +++++++++++++++++++++++++++----=0A=
 arch/x86/kvm/xen.h |  7 +++++++=0A=
 2 files changed, 34 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c=0A=
index 7d01983d1087..2d0a5d2ca6f1 100644=0A=
--- a/arch/x86/kvm/xen.c=0A=
+++ b/arch/x86/kvm/xen.c=0A=
@@ -998,20 +998,43 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcp=
u, bool longmode,=0A=
 	evtchn_port_t port, *ports;=0A=
 	gpa_t gpa;=0A=
 =0A=
-	if (!longmode || !lapic_in_kernel(vcpu) ||=0A=
+	if (!lapic_in_kernel(vcpu) ||=0A=
 	    !(vcpu->kvm->arch.xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_EVTCHN_SE=
ND))=0A=
 		return false;=0A=
 =0A=
 	idx =3D srcu_read_lock(&vcpu->kvm->srcu);=0A=
 	gpa =3D kvm_mmu_gva_to_gpa_system(vcpu, param, NULL);=0A=
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);=0A=
-=0A=
-	if (!gpa || kvm_vcpu_read_guest(vcpu, gpa, &sched_poll,=0A=
-					sizeof(sched_poll))) {=0A=
+	if (!gpa) {=0A=
 		*r =3D -EFAULT;=0A=
 		return true;=0A=
 	}=0A=
 =0A=
+	if (IS_ENABLED(CONFIG_64BIT) && longmode) {=0A=
+		if (kvm_vcpu_read_guest(vcpu, gpa, &sched_poll,=0A=
+					sizeof(sched_poll))) {=0A=
+			*r =3D -EFAULT;=0A=
+			return true;=0A=
+		}=0A=
+	} else {=0A=
+		struct compat_sched_poll sp;=0A=
+=0A=
+		/*=0A=
+		 * Sanity check that __packed trick works fine and size of=0A=
+		 * compat_sched_poll is 16 bytes just like in the real Xen=0A=
+		 * 32-bit case.=0A=
+		 */=0A=
+		BUILD_BUG_ON(sizeof(struct compat_sched_poll) !=3D 16);=0A=
+=0A=
+		if (kvm_vcpu_read_guest(vcpu, gpa, &sp, sizeof(sp))) {=0A=
+			*r =3D -EFAULT;=0A=
+			return true;=0A=
+		}=0A=
+		sched_poll.ports =3D (evtchn_port_t *)(unsigned long)(sp.ports);=0A=
+		sched_poll.nr_ports =3D sp.nr_ports;=0A=
+		sched_poll.timeout =3D sp.timeout;=0A=
+	}=0A=
+=0A=
 	if (unlikely(sched_poll.nr_ports > 1)) {=0A=
 		/* Xen (unofficially) limits number of pollers to 128 */=0A=
 		if (sched_poll.nr_ports > 128) {=0A=
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h=0A=
index ee5c4ae0755c..8b36d346fc9c 100644=0A=
--- a/arch/x86/kvm/xen.h=0A=
+++ b/arch/x86/kvm/xen.h=0A=
@@ -196,6 +196,13 @@ struct compat_shared_info {=0A=
 	struct compat_arch_shared_info arch;=0A=
 };=0A=
 =0A=
+struct compat_sched_poll {=0A=
+	/* This is actually a guest virtual address which points to ports. */=0A=
+	uint32_t ports;=0A=
+	unsigned int nr_ports;=0A=
+	uint64_t timeout;=0A=
+} __packed;=0A=
+=0A=
 #define COMPAT_EVTCHN_2L_NR_CHANNELS (8 *				\=0A=
 				      sizeof_field(struct compat_shared_info, \=0A=
 						   evtchn_pending))=0A=
-- =0A=
2.32.0=0A=
