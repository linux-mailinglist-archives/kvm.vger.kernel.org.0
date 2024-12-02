Return-Path: <kvm+bounces-32822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5687D9E01D2
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 13:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FB6016BA9B
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BD720CCF8;
	Mon,  2 Dec 2024 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fX6bjgMM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3448120CCE9;
	Mon,  2 Dec 2024 12:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733141070; cv=none; b=nqU6z2bk2abLSdlwIP2po97Q0TWFB10Tz/4HKqwVFPEPVF3SfWixK4Lgzm5Jc08Kl/3p6h+rq8CIfmQyXVwkgLwxKQyOreEdzUPjqqzXT8IlNjSZmAu8uAXKoIpQGXVM0Y+AiIDcyO2QIQ2kZyHPbjphehwRPXQ0HES/zXohaoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733141070; c=relaxed/simple;
	bh=ntyjtRQBzDCZOIUj0LJQ6UP3yD/2RxIZEvoUeHfG6AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV4c1Vt4NKyiY8MIVPHiB8Ayg/LwCKLYzrXRhPpzWe6M+qQbCZ9iwFmo3E0f3+78HEsqae2SWEqG3ZGjCt1nJQXMxPEr43so6Zniwul5fAYQrb1/P5/7qR2UoF+VUbVxVykUlcSx7iUGmFAIGZj2uyfqOe3GB5eVK8R6vd2Eolg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fX6bjgMM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E4FC4CED9;
	Mon,  2 Dec 2024 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733141069;
	bh=ntyjtRQBzDCZOIUj0LJQ6UP3yD/2RxIZEvoUeHfG6AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fX6bjgMMjsXlPDLo1IEsaQKWmPR4SblrZXCbeg37u/bq3D+InFtE7D4RJMLwq0AAu
	 wXmCZ4216vCdb+bKZam+RE6uemLAd52Fs+VBtnwNLaqI+lhw2OPtsczG835M5ym8q+
	 aXYWHX4y7rGURQCaldGPr0CnHYLOpoudCLB+7oVZBu2jGqXM1JgBZOr0p1hNpbZZ4M
	 SIPN+ua7mu/0m4u9L7qL8gHaubpuGcCWLVu25fCGsfkaUJsV3aGmy2Mf+ewNPyuz3F
	 QzHH33FaB3Sgxsj3uIojxEzQSy+8uN+qPCvmsW0r5QYhxEPm59rXxc83Ca8KShPCNN
	 WpkFxgFcxc9zw==
From: Borislav Petkov <bp@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	X86 ML <x86@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH v2 4/4] Documentation/kernel-parameters: Fix a typo in kvm.enable_virt_at_load text
Date: Mon,  2 Dec 2024 13:04:16 +0100
Message-ID: <20241202120416.6054-5-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241202120416.6054-1-bp@kernel.org>
References: <20241202120416.6054-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

s/lode/load/

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dc663c0ca670..e623e2b53be2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2695,7 +2695,7 @@
 			VMs, i.e. on the 0=>1 and 1=>0 transitions of the
 			number of VMs.
 
-			Enabling virtualization at module lode avoids potential
+			Enabling virtualization at module load avoids potential
 			latency for creation of the 0=>1 VM, as KVM serializes
 			virtualization enabling across all online CPUs.  The
 			"cost" of enabling virtualization when KVM is loaded,
-- 
2.43.0


