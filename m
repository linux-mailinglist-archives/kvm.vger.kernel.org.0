Return-Path: <kvm+bounces-70886-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yDFuBmK3jGnlsQAAu9opvQ
	(envelope-from <kvm+bounces-70886-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 18:07:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EC51266BB
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 18:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAF01302D526
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D033134575A;
	Wed, 11 Feb 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ML/qxoxz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A412C11D0
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770829604; cv=none; b=qODDMuR7hN+bp2BQAEBjc4Ri7D0vHK6FBCqwV/s1Ghab/Jv+MYWDuMa2816fwj0Kvv3rspJ22ytOS4a4PwSAi0l//CURE13M6SvWtKsg6R/qKEQy+2nuqmJSy2EnZll38u92MEDcW1Ekrn41rRA7JR/x6daZP8cOge6i90LvPU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770829604; c=relaxed/simple;
	bh=VL1sFXXr6YTLY4OBzKK7bVr6MM2/iC/NyxoRa97qJ+A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pE9XteSeHrUHz1Rvqr/eCBlLUHTkOZYzhxkX4rzFdL+Ur2lnsmzztzNUtVRhyKibynZBVdqZxiy+7Q7pqWp1EFC+Rm25TBO2X1g+DaQ45H4u65Yz279R9HE0bVvFgPBQXHVf/2Tutr44onQdJ8HNLHamq55rRf58fLCW5OFBxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ML/qxoxz; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4801c2fae63so58061875e9.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 09:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770829601; x=1771434401; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pmd+u0/xPJKkuHOdbpuNtfn5XV9tz6I4gvePT37PHqM=;
        b=ML/qxoxzK+XDFFBxANcWmHSaGOlM9xruMJj92s6widN//Vi2BMO6sdkwNzTiLCPbgt
         XTMK70/bltZTqCo4xtbMV6eEMx1fp8Fr9MX6UyqNX77316EQZvnxUWhYvqG5KoDxTX0r
         0oeQLY4f5fwd8Ci9cD8OMeEH1wYrOj1Jr0v8EYYMaaouI2XrsXvdsCO+995Z815A9cgT
         tpqFPKuv2EM+YE7YDaUSHqnlCvNklfBhWhxoHHLeY1PEbkiywfBdhHqIFki5Qb6ewoZS
         ijyA58yE8DkRujkkLjTX99oviHu9Q3vQarxsDcp0dg9qYEhJAuqlwxdrMv1rUy7EXLlT
         1Tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770829601; x=1771434401;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pmd+u0/xPJKkuHOdbpuNtfn5XV9tz6I4gvePT37PHqM=;
        b=k0tYclPgTOslTYgopuj56iUGNPB7Bt1T+SXeyEgrRX+LPq2R+PrxqUH+egKczFDo/1
         z+oYOplzZRx5kZyCD/8xpsuF9D9gIa2IfxEFmPvApEa+gXpOuiiCmRDPTLgWAnlgXhON
         h/H28d3uJUUNBvyQYd01qfpbEK16DFwfF+t4acp1NXKXe5pVSw7D1f5kqEhQVdi8nvAj
         afHdtv2XQqAQEGaoTe2E4rMNZfD6AlVi14ko9JfC6eENNIBv2qyWmV3IolaJu9OV5rSj
         6M1w4yq68V6PZiJMj1SKInnBY/E8opkAabfIoNnqqjpz3Y6KbCYj6hp0xiz/YhMOI5Cr
         +0Zw==
X-Gm-Message-State: AOJu0YzAfnXDuRs6nCcoRSYAGlkhCO3x7A7wS7zphdDjUosWCtn6ijAt
	iF7+BcJZ+FxtXo77ghCx82UMJ3I6jasThJccDnaPOP654mwwbE0MFAI=
X-Gm-Gg: AZuq6aLU77s98X6JFuEJ+WyOW6OjWHJMRY1nZ0Nxxii9H83d5fLH4xR8yNPQQ8PdxWz
	iGQE5mHsCWibfaHR+yZaKkFIJgfXU3fGEmenXsN+QDDbEZYjiyT2XHJ2rd0XMIlWVR8uhEn/6Nf
	GtlzwmDdG1+GbNONFoQ+GLip1Ge4UbdVnjR5BYCGZnYApQc03pjLCiEgYqdD4jLwcuTQY68hRVS
	Ytjmo1jBBh/Ls/VczAubbischopzLJoreAzzmrFx3nKJF9bQ6DHWpvgGk7Hf4WksqW0KgM3rLEO
	KMH4VBKvtrVt4JDYB263hgRrsluvAoXpfHM09B+LlIt2bGTbGDZtXnhmEnVUsVp9MLwJBlNMAst
	jeNlXIKqSXecUXDyWHiMBsKfH5ieTkZp1Or04abC/frNsg6ybyiTBKjlvCUuckqnxuwx3gok41W
	RCseWPGgFSboG1
X-Received: by 2002:a05:600c:8708:b0:480:25ae:9993 with SMTP id 5b1f17b1804b1-4835dfcff9dmr31108825e9.20.1770829601018;
        Wed, 11 Feb 2026 09:06:41 -0800 (PST)
Received: from p183 ([178.172.147.121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a4c4sm252965675e9.10.2026.02.11.09.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 09:06:40 -0800 (PST)
Date: Wed, 11 Feb 2026 20:07:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Subject: [PATCH] kvm: use #error instead of BUILD_BUG_ON
Message-ID: <b8efb256-8db8-42ed-a4b1-891aa5824251@p183>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70886-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[adobriyan@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81EC51266BB
X-Rspamd-Action: no action

Force preprocessing error instead of expanding BUILD_BUG_ON macro and
forcing compile error at later stage.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/include/asm/kvm-x86-ops.h     |    2 +-
 arch/x86/include/asm/kvm-x86-pmu-ops.h |    2 +-
 arch/x86/kvm/vmx/vmcs_shadow_fields.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_OPTIONAL)
-BUILD_BUG_ON(1)
+#error
 #endif
 
 /*
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_OPTIONAL)
-BUILD_BUG_ON(1)
+#error
 #endif
 
 /*
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -1,5 +1,5 @@
 #if !defined(SHADOW_FIELD_RO) && !defined(SHADOW_FIELD_RW)
-BUILD_BUG_ON(1)
+#error
 #endif
 
 #ifndef SHADOW_FIELD_RO

