Return-Path: <kvm+bounces-71973-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yGgMO5JUoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71973-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:11:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5051A743D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3B39630E803E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A7C3D3D1A;
	Thu, 26 Feb 2026 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="FTxBjgm/"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8983D34A6
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114007; cv=none; b=GfSGG6P8gZ2gLl79yX4KcTr6xZuJ6P19fwm0RbEnJgeAAgvSI6XyrKQMQ1U3WxyTusN/LlKOsR1jFqYyZPPVIgNb8HJ9j9jpUjq+o11TpFHKXuhSR8Dq+xjQGPmYXrzwZDzXJ06+Ln1zZhc0dekvO1lD8REShZgc8/eNvGLAWZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114007; c=relaxed/simple;
	bh=sT5Ic4jxe1aZUFXKfEyIYK1KIotspdYUaGjNvoIo6h4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6geN5FQ3ncbYU/amh7FtT+Pa3eb7iUGz9atr0ua7ccZ6676XrW1shKopSVvirureTLMCeIVRqwkVS3Nszq7gx97S9KcFHlW38GKOiDAH0UdGO15INNuWek2EL7NnOx4zd0q8C2eUWhjwpC28Q9RIj4+AgYAy27lgkq8F6mb1T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=FTxBjgm/; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114005; x=1803650005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ixk6zb6iJnhHlexLaFuIXCzJUmXA9g8LyVMsN6iGXBY=;
  b=FTxBjgm/ocZ0snW45lzf3CKeNXw2RGQGOZjOoJuk5GxwfBICbux/adSu
   yCPdRabk3c9VjFqX7BBfpLdqaHOXmeD15jhiepZUk8dioRwERgclAh7CV
   fiDXbbLVqn+SllkSRl4uWbwwRJQ1ECrKaiAhXQJRJjzloN7UmNi+bW4Oc
   cbo4Eo0ATKaxVnfjXqCEyHcxCXYNcGlXUJKB4QXUhJBnjgAghGcYyJno9
   PJXAl5YljNaAj4MqLo0Lur5aMvkPy3vDiHsXVp5hRCChhXnphB4l9Gafm
   Y6NgpHXcUTg164XgZD4VkEQht6bvX9nZWyy/DeoYbnRk7mdSbS0N58Z9I
   Q==;
X-CSE-ConnectionGUID: 7sOae/lqSyywVJSgBoHZkg==
X-CSE-MsgGUID: wXpbiVaCR/GzC/mcmXoHsQ==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13665754"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:22 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:12835]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.162:2525] with esmtp (Farcaster)
 id d6920e8b-3bf3-4325-8421-6e7cc342910c; Thu, 26 Feb 2026 13:53:22 +0000 (UTC)
X-Farcaster-Flow-ID: d6920e8b-3bf3-4325-8421-6e7cc342910c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:21 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:19 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 1/7] KVM: x86: Avoid silent kvm-clock activation failures
Date: Thu, 26 Feb 2026 13:53:02 +0000
Message-ID: <20260226135309.29493-2-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226135309.29493-1-itazur@amazon.com>
References: <20260226135309.29493-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA004.ant.amazon.com (10.13.139.76) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71973-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0A5051A743D
X-Rspamd-Action: no action

kvm_write_system_time() previously ignored the return value of
kvm_gpc_activate().  As a result, kvm-clock activation could fail
silently, making debugging harder.

Propagate the return value so that the MSR write fail properly instead
of continuing silently.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a447663d5eff..a729b8419b61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2438,7 +2438,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa=
_t wall_clock, int sec_hi_o
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 }
=20
-static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
+static int kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 				  bool old_msr, bool host_initiated)
 {
 	struct kvm_arch *ka =3D &vcpu->kvm->arch;
@@ -2455,12 +2455,12 @@ static void kvm_write_system_time(struct kvm_vcpu *=
vcpu, gpa_t system_time,
=20
 	/* we verify if the enable bit is set... */
 	if (system_time & 1)
-		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL,
-				 sizeof(struct pvclock_vcpu_time_info));
-	else
-		kvm_gpc_deactivate(&vcpu->arch.pv_time);
+		return kvm_gpc_activate(&vcpu->arch.pv_time,
+					system_time & ~1ULL,
+					sizeof(struct pvclock_vcpu_time_info));
=20
-	return;
+	kvm_gpc_deactivate(&vcpu->arch.pv_time);
+	return 0;
 }
=20
 static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
@@ -4156,13 +4156,15 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struc=
t msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
 			return 1;
=20
-		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
+		if (kvm_write_system_time(vcpu, data, false, msr_info->host_initiated))
+			return 1;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
 			return 1;
=20
-		kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated);
+		if (kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated))
+			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
--=20
2.50.1


