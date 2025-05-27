Return-Path: <kvm+bounces-47770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F90AC4AB9
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:51:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CE1B3A2961
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D91CA24DCE0;
	Tue, 27 May 2025 08:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="qt1rPDQ3"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A96622541D;
	Tue, 27 May 2025 08:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748335891; cv=none; b=L7WT17H0j/q/9+Coq6keyZ8mum3AsVwEsIMS36fBzLugsQ+1WEZjsa0lzLQ1Ouz7XYx0sUV4v6XoDxdcXMMNszNO/D6O6EloUUaCBIK5ekR357IRNe1oLIRVWqiWtQnUjD2AT6fQiefnO0GIFLQEqXyAlj1Gh1prflf21bSdKps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748335891; c=relaxed/simple;
	bh=G9E6b2eMe3gQLWOjojspPE/uQWcRwmH81124oyQCZBw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=oktLicbyCe1+ZKEoUlMadOdBxaTUdWVGMqT5DyrH/fwDJion9R/z56OLbeoKkmyB4SJBD8rUOQkkvD67PjKGU6hTrMZ7qfLcbFWjWhxf/GqGv6tphSSYTe/I6cin1u8msQfWney217JKtCH4jc/CiZpimZIxkqoke/ktsGgm6zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=qt1rPDQ3; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1748335882; bh=oU+dRBArWttqaDqviyCVWOu/S2TOWxgoldJiv0jCODg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt1rPDQ34OyI5rFLOoVKGi3+e8cyn9rZ8a+ND8dB8lOb1CeI1wo4qUt80mDThNdAa
	 jVlAc5pjthDVmwFh7d406d53xn9oYTTZ8IYw/3A75qArNToBYmOHpAAjzssEPPugWt
	 T1yK9XSa55HtLsizKN9Gr70RrZu9xqX64VxJSQjA=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.228.63])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id B322BC82; Tue, 27 May 2025 16:44:50 +0800
X-QQ-mid: xmsmtpt1748335490tgj01aona
Message-ID: <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
X-QQ-XMAILINFO: No7DFzN00JnRdJgF1qwS0h4zqnzhwJaMHbctU50HU/vZKbMFw8dz6Na1dur3RQ
	 zQubCxmvVnwl0eQS/kn2glErxX/VKKBBKobS85GSq9mEuDeSgQwwudpIMRkRV1wtKg7SLDSxBgwD
	 I+t6ckg6yDmv7OtSW+aGL/UaKRyhxQ+TzTG1315Jp4NNmRMA5LYZ2NifyXZLS92OwZmtg+uTA/cQ
	 XDGLCEL8oWe7uxPMUxl1T53I3QwENV5BeCKZj+g1RkScxVrhuqTpNsHsSh0UzQj7b50idmhtilQ3
	 LV1fSGglk4TcPz0soIXLFsTtMXfkl15dHiNRySyyS/p/qpZua9T7jLx0t032OHIYaJRNO2k4TnjP
	 OOq2tixfplZ1lpDeFOvt7L5hiycmJOBx44FCN1QLZYGn8fbCDPeNdmAo1arXNJcUctxYBTkke7fB
	 +HzqqvQ6Zgz9QrbTuvz8WrqjxsQ9L1iubaEEaj9km0ByNnReUTq+P3OIuxiRvtM83v7flK64HYrH
	 LkNUC0LawbAhXBZFfR/cyimfYNRaXn4fwZu9n2h7v1FNFhMXIq8aJ/dToD4Dafp9sVuosjFyqzZi
	 lk4DELtb+ig4Ma685kVKRcbBl+C9zDE/qOa8JyKsEhRnfRJCUhg3PGgCxl7HjwGvHTY2wXVGNsZC
	 yIGkbposzhlOPY7kGnTR8UDyXSs0kkmsr62S9mrBHIMBOoqDphW109U93YMJ0g2S3mO/ORi3I0DP
	 T6qdiJIjwbcnFiX7L9Kd2Cbd9yM1wlqfjd94243Ki2lXs3bvBPEgtipFFngq65MaMOeszEfZcvTX
	 D0VZhzxahV4xj6g/GOyLqXeP2Ev6uLca4yeBtGF4FeHigxCvMWfcvbGgC1iVkB8PtwZcUB3pE6RA
	 vknwGDBaupyUDbJbSkjERzFh/EMWmGfxYw+eSA0eLrWHWO/jGdVg5jLcRsarKH1d01YqRALGZzp4
	 0auekTnMtYgwlMAfUgpxoxGjTD6MaetgJxV+ii4Dc=
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Edward Adam Davis <eadavis@qq.com>
To: binbin.wu@linux.intel.com
Cc: bp@alien8.de,
	dave.hansen@linux.intel.com,
	eadavis@qq.com,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org
Subject: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and is_td
Date: Tue, 27 May 2025 16:44:37 +0800
X-OQ-MSGID: <20250527084436.1829325-2-eadavis@qq.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

is_td() and is_td_vcpu() run in no instrumentation, so use __always_inline
to replace inline.

[1]
vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
        call to is_td_vcpu.isra.0() leaves .noinstr.text section

Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: using __always_inline to replace noinstr

 arch/x86/kvm/vmx/common.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 8f46a06e2c44..a0c5e8781c33 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -71,8 +71,8 @@ static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
 
 #else
 
-static inline bool is_td(struct kvm *kvm) { return false; }
-static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static __always_inline bool is_td(struct kvm *kvm) { return false; }
+static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
 
 #endif
 
-- 
2.43.0


