Return-Path: <kvm+bounces-68922-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IzoIxdqcmnckQAAu9opvQ
	(envelope-from <kvm+bounces-68922-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:19:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C909E6C39C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2F08A303FC3B
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B853994CE;
	Thu, 22 Jan 2026 17:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="D+K0JyFy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C491A2836A0;
	Thu, 22 Jan 2026 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102633; cv=none; b=WPEOcUgFU2PUujFJvoKAkQzD0vlFk7ReDvEVZGuxLcUO7oQSFmXHG5ayTxQ1QgzCxhWTVEWYGD8qggQpsGbrVdJLGaT+2XGcCeWvsK/TFSCS5yQJdnXhfOLVoTclcTQG1SfzRB9ETCujRwSAVZswkFP5irHf63J+yDFWFw72zoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102633; c=relaxed/simple;
	bh=dtP+nWWuVuJvJBsm0UWdgOskH8NVxjSmawrK0OInoLQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=H5JDtiOJXqIa782IVAD+Zgd43kv4gBwf2UUgyj9WA8021emffsyywAHDL9G+S+K0oLJNJqSMmrWJYr3y/67GObCpzgd31yjQJlSqUH2hPF65qlzikkEH3inM2ZXfjjqNhS4txJt3jQJa2e9gppVRQE32I7GMJEVhxuAHkwT49As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=D+K0JyFy; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60MHN6iv3506714
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 22 Jan 2026 09:23:07 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60MHN6iv3506714
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1769102588;
	bh=TtyxvCfx4emSFYxT/m1EqPy/Rz7N0cIcJjdvcncU9IU=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=D+K0JyFyeQ8CQlSNKXYg5TJHrH5fVyDppIWGktqNZ/Uu5vH/e3j+0plN+FJQ7GZLL
	 pK1ixbGRF5isEDGaoZcvzh1+dIB2aTpWkj5AfdyhjZ9Bc2BH0hIEbjuIGIEhl+kRIb
	 ZD5DQI1fbOtI7KRen+NXZ0Iv8LONibEDTfq0tb4FNr6A89584p4kj7n1Hm3KcsfcGn
	 /213Vag4+LiYWEMBFz6PuyXW840GnVfkthI6IQBcWmNy89FbYjGbxtnzW0DEc9R+Of
	 UQNLJSnhnyM7jsu24Z2OMZAPFjPtX6//EyQlg8l5k+WfaxXfCbVUZrgaP105j8Adom
	 /oDGhzuM+sc3Q==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
From: Xin Li <xin@zytor.com>
In-Reply-To: <c0d27d52-ae86-4a48-a942-980280542985@linux.intel.com>
Date: Thu, 22 Jan 2026 09:22:56 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E5D53B8D-5A2B-4F9C-9071-E0C56A44AE7D@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
 <9F630202-905B-43D7-9DBF-6E4551BAF082@zytor.com>
 <B01C8160-4999-43B9-B89C-45913E94DA55@zytor.com>
 <c0d27d52-ae86-4a48-a942-980280542985@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2025122301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68922-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,zytor.com:mid,zytor.com:dkim]
X-Rspamd-Queue-Id: C909E6C39C
X-Rspamd-Action: no action


>> The trouble comes from __this_cpu_ist_top_va():
>=20
> Oh, right!=20
> Sorry for the noise.

It=E2=80=99s absolutely NOT noise, because we don=E2=80=99t like #ifdef =
in C file.

With the following additional patch, we can remove this #ifdef =
CONFIG_X86_64:

diff --git a/arch/x86/include/asm/cpu_entry_area.h =
b/arch/x86/include/asm/cpu_entry_area.h
index 509e52fc3a0f..c35ef2cb9b8a 100644
--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -8,14 +8,6 @@
 #include <asm/intel_ds.h>
 #include <asm/pgtable_areas.h>
  -#ifdef CONFIG_X86_64
-
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-#define VC_EXCEPTION_STKSZ     EXCEPTION_STKSZ
-#else
-#define VC_EXCEPTION_STKSZ     0
-#endif
-
 /*
  * The exception stack ordering in [cea_]exception_stacks
  */
@@ -26,9 +18,19 @@ enum exception_stack_ordering {
        ESTACK_MCE,
        ESTACK_VC,
        ESTACK_VC2,
+#ifdef CONFIG_X86_64
        N_EXCEPTION_STACKS
+#endif
 };
  +#ifdef CONFIG_X86_64
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+#define VC_EXCEPTION_STKSZ     EXCEPTION_STKSZ
+#else
+#define VC_EXCEPTION_STKSZ     0
+#endif
+
 /* Macro to enforce the same ordering and stack sizes */
 #define ESTACKS_MEMBERS(guardsize, optional_stack_size)                =
\
        char    ESTACK_DF_stack_guard[guardsize];               \
@@ -75,6 +77,11 @@ struct doublefault_stack {
        unsigned long stack[(PAGE_SIZE - sizeof(struct x86_hw_tss)) / =
sizeof(unsigned long)];
        struct x86_hw_tss tss;
 } __aligned(PAGE_SIZE);
+
+static inline unsigned long __this_cpu_ist_top_va(enum =
exception_stack_ordering stack)
+{
+       return 0;
+}
 #endif
   /*


Another simpler way to define __this_cpu_ist_top_va() in a VMX header, =
but
I don=E2=80=99t think it=E2=80=99s the right way.


