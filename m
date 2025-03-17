Return-Path: <kvm+bounces-41182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F50DA647C8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:41:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5170D1890BD6
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 09:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F4F22689C;
	Mon, 17 Mar 2025 09:41:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C3E221DA4
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742204480; cv=none; b=Dh5XqvHVILT1NjqmaNZf2yXzcLyUG/BJmBUoSIinySK5YR/s1G1WmWREx8AqoVBQB87kAyjsoLhG5tUxxhDDcOCSMTwcXSuzclN90SEMZvneUjUifoSRfy0hqFb8WQ8WY0+hobzYJX+fk5ozNng5+ZI1bT1zWVOfrJpHbCFHM1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742204480; c=relaxed/simple;
	bh=H4siteXWed7GW9piyVqsqPjXCiIV2tIw/PyQTp4yIaU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nLzMeSdIBt+Lk5ey0H/n3Ceg7j4EbydkYvTERNnNWw9XpJJkVKFiuO7YMw3aFrkeoJ8pQv4GQHsA9bfqEkt3M5Umuy/P4vrDi6a2kRCM/axTTT66qnpLEwrDlzUWFzg9/TmWZ84GKjCxl6/vHvDKS5f7m6DswKobAbBUC/cszYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1742203375-086e236018216fa0001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id bApEZBNfsL8tVL9C (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 17 Mar 2025 17:22:55 +0800 (CST)
X-Barracuda-Envelope-From: LiamNi-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX2.zhaoxin.com (10.28.252.164) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 17 Mar
 2025 17:22:55 +0800
Received: from ZXSHMBX2.zhaoxin.com ([fe80::4dfc:4f6a:c0cf:4298]) by
 ZXSHMBX2.zhaoxin.com ([fe80::4dfc:4f6a:c0cf:4298%4]) with mapi id
 15.01.2507.044; Mon, 17 Mar 2025 17:22:55 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from aa-VirtualBox.zhaoxin.com (10.28.64.121) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 17 Mar 2025 17:19:17 +0800
From: Liam Ni <liamni-oc@zhaoxin.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <LiamNi@zhaoxin.com>, <CobeChen@zhaoxin.com>,
	<LouisQi@zhaoxin.com>, <EwanHai@zhaoxin.com>, <FrankZhu@zhaoxin.com>
Subject: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT state to reduce the performance overhead caused by hrtimer during guest stop.
Date: Mon, 17 Mar 2025 17:19:17 +0800
X-ASG-Orig-Subj: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT state to reduce the performance overhead caused by hrtimer during guest stop.
Message-ID: <20250317091917.72477-1-liamni-oc@zhaoxin.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 3/17/2025 5:22:54 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1742203375
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 1876
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.138618
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

When using the dump-guest-memory command in QEMU to dump
the virtual machine's memory,the virtual machine will be
paused for a period of time.If the guest (i.e., UEFI) uses
the PIT as the system clock,it will be observed that the
HRTIMER used by the PIT continues to run during the guest
stop process, imposing an additional burden on the system.
Moreover, during the guest restart process,the previously
established HRTIMER will be canceled,and the accumulated
timer events will be flushed.However, before the old
HRTIMER is canceled,the accumulated timer events
will "surreptitiously" inject interrupts into the guest.

SO during the process of saving the KVM PIT state,
the HRTIMER need to be canceled to reduce the performance overhead
caused by HRTIMER during the guest stop process.

i.e. if guest

Signed-off-by: Liam Ni <liamni-oc@zhaoxin.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 045c61cc7e54..75355b315aca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6405,6 +6405,8 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm, stru=
ct kvm_pit_state *ps)
=20
 	mutex_lock(&kps->lock);
 	memcpy(ps, &kps->channels, sizeof(*ps));
+	hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
+	kthread_flush_work(&kvm->arch.vpit->expired);
 	mutex_unlock(&kps->lock);
 	return 0;
 }
@@ -6428,6 +6430,8 @@ static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, str=
uct kvm_pit_state2 *ps)
 	memcpy(ps->channels, &kvm->arch.vpit->pit_state.channels,
 		sizeof(ps->channels));
 	ps->flags =3D kvm->arch.vpit->pit_state.flags;
+	hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
+	kthread_flush_work(&kvm->arch.vpit->expired);
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 	memset(&ps->reserved, 0, sizeof(ps->reserved));
 	return 0;
--=20
2.25.1


