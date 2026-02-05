Return-Path: <kvm+bounces-70307-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GHgqOzZDhGm/2AMAu9opvQ
	(envelope-from <kvm+bounces-70307-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:13:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99579EF599
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 08:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B16D33019906
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 07:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD8535BDD9;
	Thu,  5 Feb 2026 07:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="EXnfzp5J"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A745330D54;
	Thu,  5 Feb 2026 07:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770275532; cv=none; b=sjYL/Zi9dD+/1xIqgyCa54GaPe+Mku92ZRxpSW//Wq91ljEJGZQ2gK1QmNDFPn0EBj+IgChkCZ0mxCBi7w3C/0+jEfS+QolTjsBej9YpXUHg7HHTFbT8UQlKBt48HCasTJuXYT/3uXTbihgM0IFT6mwDWquxid/MVLqD5AXb2ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770275532; c=relaxed/simple;
	bh=+SgpBM1wt8fzDyxb1Mb/lCh5EyM467OZfKUOULjFlag=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pc0APpioNP6ldQ5CwdV5fbQtgt//MNDZD1vnEzYzWYN1BEITNmokF9Kym1uMY84O6d9vnTEf75IcYGtfzOshnWRL1invSvgBux6HeWRjstbaIAw+3K6wueNkaQc5I1g9jvTH4IHOy6oNiLOYpYD5oitqKvPE8DlTBYrkKIvat7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=EXnfzp5J; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6157BQ7I342018
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 4 Feb 2026 23:11:27 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6157BQ7I342018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770275488;
	bh=t5vl7rEljQtqYzx5YQxqo86uvVKDEblp7dz4uhZ8FXk=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=EXnfzp5JW8Ge1i3W/BT1b/L0MWeZ3ogRu/o+Cpm3CJu4zPaJxCoBxKSqdVIGAZBGR
	 Id25c4NCHxPC6vpclCGdPP/H34M3E28A361AHfYTX97JaHNK97Wwcwyxv5ZVHFOxU1
	 3CsKpKDvkUHNANKy5abU0ZWV8ZxK1p3GyQVHnvHy1B/KCOUOi9VwZeluTNt3MaM4bK
	 2RAAuOSEXDa2MnEgyuppGejcjSFC1q4ihk95xaIzjHxPmgs/9z4SnNxGRyeszowkC2
	 4I/i4VrFfemVzJeEN/UAGuc0lnlKHRCQ03A4HOfOr/XNMIoiljxx5qbvWOLItc9K38
	 THeR8pYhYcoUg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
From: Xin Li <xin@zytor.com>
In-Reply-To: <20260205051030.1225975-1-nikunj@amd.com>
Date: Wed, 4 Feb 2026 23:11:16 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        thomas.lendacky@amd.com, tglx@kernel.org, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, x86@kernel.org, jon.grimm@amd.com,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D313F34B-8463-4D48-B09C-07322D6808B0@zytor.com>
References: <20260205051030.1225975-1-nikunj@amd.com>
To: Nikunj A Dadhania <nikunj@amd.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70307-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,zytor.com:email,zytor.com:dkim,zytor.com:mid]
X-Rspamd-Queue-Id: 99579EF599
X-Rspamd-Action: no action



> On Feb 4, 2026, at 9:10=E2=80=AFPM, Nikunj A Dadhania <nikunj@amd.com> =
wrote:
>=20
> FRED enabled SEV-ES and SNP guests fail to boot due to the following
> issues in the early boot sequence:
>=20
> * FRED does not have a #VC exception handler in the dispatch logic


This should be a separate patch.


>=20
> * For secondary CPUs, FRED is enabled before setting up the FRED MSRs, =
and
>  console output triggers a #VC which cannot be handled

Yes, this is a problem.  I ever looked into it for TDX, and had the =
following patch:

Can you please check if it works for you (#VC handler is set in the =
bringup IDT on AMD)?


    x86/smp: Set up exception handling before cr4_init()
   =20
    The current AP boot sequence initializes CR4 before setting up
    exception handling.  With FRED enabled, however, CR4.FRED is set
    prior to initializing the FRED configuration MSRs, introducing a
    brief window where a triple fault could occur.  This isn't
    considered a problem, as the early boot code is carefully designed
    to avoid triggering exceptions.  Moreover, if an exception does
    occur at this stage, it's preferable for the CPU to triple fault
    rather than risk a potential exploit.
   =20
    However, under TDX, printk() triggers a #VE, so any logging during
    this small window results in a triple fault.
   =20
    Swap the order of cr4_init() and cpu_init_exception_handling(),
    since cr4_init() only involves reading from and writing to CR4,
    and setting up exception handling does not depend on any specific
    CR4 bits being set (Arguably CR4.PAE, CR4.PSE and CR4.PGE are
    related but they are already set before start_secondary() anyway).
   =20
    Notably, this triple fault can still occur before FRED is enabled,
    while the bringup IDT is in use, since it lacks a #VE handler.
   =20
    BTW, on 32-bit systems, loading CR3 with swapper_pg_dir is moved
    ahead of cr4_init(), which appears to be harmless.
   =20
    Signed-off-by: Xin Li (Intel) <xin@zytor.com>

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eb289abece23..24497258c16b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -231,13 +231,6 @@ static void ap_calibrate_delay(void)
  */
 static void notrace __noendbr start_secondary(void *unused)
 {
-	/*
-	 * Don't put *anything* except direct CPU state initialization
-	 * before cpu_init(), SMP booting is too fragile that we want to
-	 * limit the things done here to the most necessary things.
-	 */
-	cr4_init();
-
 	/*
 	 * 32-bit specific. 64-bit reaches this code with the correct =
page
 	 * table established. Yet another historical divergence.
@@ -248,8 +241,37 @@ static void notrace __noendbr start_secondary(void =
*unused)
 		__flush_tlb_all();
 	}
=20
+	/*
+	 * AP startup assembly code has setup the following before =
calling
+	 * start_secondary() on 64-bit:
+	 *
+	 * 1) CS set to __KERNEL_CS.
+	 * 2) CR3 switched to the init_top_pgt.
+	 * 3) CR4.PAE, CR4.PSE and CR4.PGE are set.
+	 * 4) GDT set to per-CPU gdt_page.
+	 * 5) ALL data segments set to the NULL descriptor.
+	 * 6) MSR_GS_BASE set to per-CPU offset.
+	 * 7) IDT set to bringup IDT.
+	 * 8) CR0 set to CR0_STATE.
+	 *
+	 * So it's ready to setup exception handling.
+	 */
 	cpu_init_exception_handling(false);
=20
+	/*
+	 * Ensure bits set in cr4_pinned_bits are set in CR4.
+	 *
+	 * cr4_pinned_bits is a subset of cr4_pinned_mask, which =
includes
+	 * the following bits:
+	 *         X86_CR4_SMEP
+	 *         X86_CR4_SMAP
+	 *         X86_CR4_UMIP
+	 *         X86_CR4_FSGSBASE
+	 *         X86_CR4_CET
+	 *         X86_CR4_FRED
+	 */
+	cr4_init();
+
 	/*
 	 * Load the microcode before reaching the AP alive =
synchronization
 	 * point below so it is not part of the full per CPU serialized
@@ -275,6 +297,11 @@ static void notrace __noendbr start_secondary(void =
*unused)
 	 */
 	cpuhp_ap_sync_alive();
=20
+	/*
+	 * Don't put *anything* except direct CPU state initialization
+	 * before cpu_init(), SMP booting is too fragile that we want to
+	 * limit the things done here to the most necessary things.
+	 */
 	cpu_init();
 	fpu__init_cpu();
 	rcutree_report_cpu_starting(raw_smp_processor_id());


