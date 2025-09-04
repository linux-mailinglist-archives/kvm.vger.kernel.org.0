Return-Path: <kvm+bounces-56842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E54B44584
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AB381893053
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374D03314C2;
	Thu,  4 Sep 2025 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwYAXrRt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8993093DE
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010937; cv=none; b=UBqT0iZy20so1xEbjG0/JFh7yj9PkUCoczyirW58Kv/XPkQeTVzo+KJWPBP23pFD7HqBIrHnApt0vszxM+hGjQiNlzqmmhUmXhfxo37ywDyCPLGrCLkw0DOv3fM0g6D20Eap3tchreiuiCqVLzt2G+OZLzJqL3wIJUZxyh8coE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010937; c=relaxed/simple;
	bh=pkLVk7/ghlFYoW2YE9bbRF6C4quISNpbzNHQ6QBDCBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RbHR78/TLhYsEJOFrvha4d2o46gShuXga9fYo0z6WTQSqdxZmp7UfkBtSxERiPZ4tbuSmUVzGVkLWfXYKuP0Tf29FMXj15jn5VRTndrh6v8u3L9/D0qfjkJ+EsdpEE7zCjemHbDOcjp5mPscp/77xaouK4M1x5Y0myx2rNe2VxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CwYAXrRt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F31C4CEF0;
	Thu,  4 Sep 2025 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757010936;
	bh=pkLVk7/ghlFYoW2YE9bbRF6C4quISNpbzNHQ6QBDCBA=;
	h=From:To:Cc:Subject:Date:From;
	b=CwYAXrRtOUa4feGobMuO5XB52uDD679fa1gDZU6Wv9F60i60b3LGCnO5qNETeKitZ
	 QMxSlmZuV+ggvUrjENgCaszOHCy/J4oAw2CDs3yceES4Pc2qXWhjscW2huhddjlih9
	 g6dmiRcUwMgeZVWodei4Gk31Okgai/pJ3u1M/CcnTZXYVfUMfkxuu44RCUg4vDiQZH
	 kPB9olfgiMF/ZAdvGTFQznkhnOeDY3Ic8JZgxUzwXbYkYEZAhe0Aw6h2py7QhgHJP9
	 sC6UwtWrV7O+XBjF8ZkcAcHNPuRTgS9q4RdR+cpXr6uPWCcK725uJlg4XdH9Nrs5js
	 xbsu8vIoBssvg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>,
	<kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RESEND v4 0/7] KVM: SVM: Add support for 4k vCPUs with x2AVIC
Date: Fri,  5 Sep 2025 00:03:00 +0530
Message-ID: <cover.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nikunj pointed out that I have missed copying the x86 maintainers though 
I am adding a new CPUID feature bit. Re-sending this series for that 
reason.

--
This is v4 of the series posted here:
http://lkml.kernel.org/r/cover.1740036492.git.naveen@kernel.org

This series has been significantly re-worked based on the feedback 
received on v3, as well as to accommodate upstream changes to SVM and 
AVIC code. I have not picked up Vasant's and Pankaj's review tags for 
that purpose. Kindly review again.


- Naveen


Naveen N Rao (AMD) (7):
  KVM: SVM: Limit AVIC physical max index based on configured
    max_vcpu_ids
  KVM: SVM: Add a helper to look up the max physical ID for AVIC
  KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
  KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
  KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
  x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
  KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  5 +-
 arch/x86/kvm/svm/svm.h             |  1 +
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/svm/avic.c            | 76 ++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.c             |  9 ++++
 6 files changed, 78 insertions(+), 15 deletions(-)


base-commit: ecbcc2461839e848970468b44db32282e5059925
-- 
2.50.1


