Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1FF7CC507
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343689AbjJQNo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbjJQNo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:44:58 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A26ED
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697550297; x=1729086297;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=PfPhl8HczGdWGA8323ZGo5XSu6sgbHcj7wBVRmr8RT8=;
  b=BEFtqzsnu5TJJgfNQhXFwPKcffQbyBDcTMKUmKS+qee/sD/k93l0qysY
   iQ6Y2opqMoH+m9+0cb7p/qKglGQm1wBmjJAL2iYGQzRdr0NZPxlWW04P6
   6YTFEcC6k2eMGrug+IJYg7cBIkxqkEEp95EkKzv9bwqNHFgX0Nek8LrBS
   Y=;
X-IronPort-AV: E=Sophos;i="6.03,232,1694736000"; 
   d="scan'208";a="364608996"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 13:44:54 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 8C43AABDB1;
        Tue, 17 Oct 2023 13:44:52 +0000 (UTC)
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:54018]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.41.73:2525] with esmtp (Farcaster)
 id ef60bf96-3ca8-46ec-9828-f25aff06605e; Tue, 17 Oct 2023 13:44:50 +0000 (UTC)
X-Farcaster-Flow-ID: ef60bf96-3ca8-46ec-9828-f25aff06605e
Received: from EX19D032EUB001.ant.amazon.com (10.252.61.13) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Tue, 17 Oct 2023 13:44:46 +0000
Received: from EX19D047EUB002.ant.amazon.com (10.252.61.57) by
 EX19D032EUB001.ant.amazon.com (10.252.61.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Tue, 17 Oct 2023 13:44:46 +0000
Received: from EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7]) by
 EX19D047EUB002.ant.amazon.com ([fe80::a00c:a6ac:280e:2ca7%3]) with mapi id
 15.02.1118.037; Tue, 17 Oct 2023 13:44:46 +0000
From:   "Mancini, Riccardo" <mancio@amazon.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Batalov, Eugene" <bataloe@amazon.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Farrell, Greg" <gffarre@amazon.com>
Subject: RE: [RFC PATCH 4.14] KVM: x86: Backport support for interrupt-based
 APF page-ready delivery in guest
Thread-Topic: [RFC PATCH 4.14] KVM: x86: Backport support for interrupt-based
 APF page-ready delivery in guest
Thread-Index: AdoBABVVenqgM5csS6OXoPToKGrxZA==
Date:   Tue, 17 Oct 2023 13:44:46 +0000
Message-ID: <ec949b37e92441f8bcaa4fade546f00a@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.51.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

Thank you both for the quick feedback.

> > I've backported the guest-side of the patchset to 4.14.326, could you=20
> > help us and take a look at the backport?
> > I only backported the original patchset, I'm not sure if there's any=20
> > other patch (bug fix) that needs to be included in the backpotrt.
>
> I remember us fixing PV feature enablement/disablement for hibernation/kd=
ump later, see e.g.
>
> commit 8b79feffeca28c5459458fe78676b081e87c93a4
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Wed Apr 14 14:35:41 2021 +0200
>
>     x86/kvm: Teardown PV features on boot CPU as well
>
> commit 3d6b84132d2a57b5a74100f6923a8feb679ac2ce
> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date:   Wed Apr 14 14:35:43 2021 +0200
>
>     x86/kvm: Disable all PV features on crash
>
> if you're interested in such use-cases. I don't recall any required fixes=
 for normal operation.

These look like issues already present in 4.14, not introduced by the
interrupt-based mechanism, correct?
If so, I wouldn't chase them.
Furthermore, I don't even think we hit those use cases in our scenario.

>=20
> Paolo Bonzini <pbonzini@redhat.com> writes:
>=20
> > On 10/16/23 16:18, Vitaly Kuznetsov wrote:
> >> In case keeping legacy mechanism is a must, I would suggest you
> >> somehow record the fact that the guest has opted for interrupt-based
> >> delivery (e.g. set a global variable or use a static key) and
> >> short-circuit
> >> do_async_page_fault() to immediately return and not do anything in
> >> this case.
> >
> > I guess you mean "not do anything for KVM_PV_REASON_PAGE_READY in this
> > case"?
>=20
> Yes, of course: KVM_PV_REASON_PAGE_NOT_PRESENT is always a #PF.

I agree this is a difference with the upstream asyncpf-int implementation a=
nd
it's theoretically incorrect. I think this shouldn't happen in a normal cas=
e,=20
but it's better to keep it consistent.
I'll add a check that asyncpf-int is _not_ enabled before processing=20
KVM_PV_REASON_PAGE_READY. Draft diff below.

Thanks,
Riccardo

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 582a366b82d8..bdfdffd35939 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -79,6 +79,8 @@ static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_re=
ason) __aligned(64);
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 static int has_steal_clock =3D 0;
=20
+static DEFINE_PER_CPU(u32, kvm_apf_int_enabled);
+
 /*
  * No need for any "IO delay" on KVM
  */
@@ -277,7 +279,8 @@ do_async_page_fault(struct pt_regs *regs, unsigned long=
 error_code)
                prev_state =3D exception_enter();
                kvm_async_pf_task_wait((u32)read_cr2(), !user_mode(regs));
                exception_exit(prev_state);
-       } else if (reason & KVM_PV_REASON_PAGE_READY) {
+       } else if (!__this_cpu_read(kvm_apf_int_enabled) && (reason & KVM_P=
V_REASON_PAGE_READY)) {
+               /* this event is only possible if interrupt-based mechanism=
 is disabled */
                rcu_irq_enter();
                kvm_async_pf_task_wake((u32)read_cr2());
                rcu_irq_exit();
@@ -367,6 +370,7 @@ static void kvm_guest_cpu_init(void)
                if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT)) {
                        pa |=3D KVM_ASYNC_PF_DELIVERY_AS_INT;
                        wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VE=
CTOR);
+                       __this_cpu_write(kvm_apf_int_enabled, 1);
                }
=20
                wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
@@ -396,6 +400,7 @@ static void kvm_pv_disable_apf(void)
=20
        wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
        __this_cpu_write(apf_reason.enabled, 0);
+       __this_cpu_write(kvm_apf_int_enabled, 0);
=20
        printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
               smp_processor_id());

