Return-Path: <kvm+bounces-73225-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2BxxHAHaq2lWhQEAu9opvQ
	(envelope-from <kvm+bounces-73225-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 08:55:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A5222AA9E
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 08:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD82A3024470
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 07:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 921E6385515;
	Sat,  7 Mar 2026 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="SZhI9T0E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB8536A038;
	Sat,  7 Mar 2026 07:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772870140; cv=none; b=IfrNJh6voSBqQEqhbQmL+wo7aQBUXmG6dSynKj5UgirED7l+fQMt4OQTUhuh9zA+QxTzY64FSN8FPFw/bPGLQayvFPrm3Ndno6zmEIlPiaCoDW1jxQAaJn1OLPvLpUTTR229YXLyoXx0WpJnJ32zwqeTs3jsS/aY/J551yH2ooE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772870140; c=relaxed/simple;
	bh=m+kDAlHpZMgyzLCXzTnP2rLM+4ft45GgD67xyyvlZeY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EV0r3g50ilMNcWZml29aMVqrX7t0irXQLkkqa3K46artwPXhHRYdzsbRYS3NCDFfNA8rdHbMKRWmRDDWTtYlZn4piteou6EOtiJaiOqyd1pFz/NBV69+Vdd6GH3H2P514sp1a998pp9/Qe6J580d1nioE5m8Cz7z4aZTSBautvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=SZhI9T0E; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6277csat3020761
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 6 Mar 2026 23:38:55 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6277csat3020761
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026022301; t=1772869137;
	bh=/Ojkb0/5+828CnroCrUuMqypM5ZIVGO/UKtCTFnfxAc=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=SZhI9T0EmONOG2TCRzdn1v6sRq6xqyUqjnDmL/M4FH5jH3J20CkmsUJ9pOf8JizZK
	 5TNMbHJPPqsOotU9qkPzChGPcJC1n18QSbkeowY1Ohxr8Psh2rM8E8mxaBjZcR6VxS
	 azyrNY3xnjR9VNBrgkYnitXq9bjOfSzexTs7rHQbNAtPmrc36aeCZo53YSM858ahlf
	 MukF2eapx1Bp4cqg8/4dKVyT/v8ohNczbhuZ7gOFX4Hh0iy+22Z+FXi+uTN8h3I2XK
	 jshyih+kVd0ed6awjsv3LhJHRLQpjJ1OBti2YoYRzzrxXoCqwfxUbP7ayPxMFViIEm
	 7+fPQvHL7GOWg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v9 06/22] x86/cea: Export __this_cpu_ist_top_va() to KVM
From: Xin Li <xin@zytor.com>
In-Reply-To: <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local>
Date: Fri, 6 Mar 2026 23:38:44 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9C6FC4E7-DF8A-4583-93A8-3B82806D11CD@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-7-xin@zytor.com>
 <20260130134644.GUaXy2RNbwEaRSgLUN@fat_crate.local>
To: Borislav Petkov <bp@alien8.de>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 30A5222AA9E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026022301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73225-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.928];
	TAGGED_RCPT(0.00)[kvm];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:dkim,zytor.com:email,zytor.com:mid,alien8.de:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action



> On Jan 30, 2026, at 5:46=E2=80=AFAM, Borislav Petkov <bp@alien8.de> =
wrote:
>=20
> On Sun, Oct 26, 2025 at 01:18:54PM -0700, Xin Li (Intel) wrote:
>> @@ -36,6 +41,7 @@ noinstr unsigned long __this_cpu_ist_top_va(enum =
exception_stack_ordering stack)
>> {
>> return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
>> }
>> +EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_va, "kvm-intel");
>=20
> Why is this function name still kept with the "__" prefix but it is =
being
> exported at the same time?
>=20
> It looks to me like we're exporting the wrong thing as the "__" kinda =
says it
> is an internal helper.
>=20
> Just drop the prefix and call it something more sensible please. The =
caller
> couldn't care less about "ist_top_va".

Sean suggested to replace direct, raw use of __this_cpu_ist_top_va() =
with
a self-explanatory this_cpu_fred_rsp() helper for better readability.

https://lore.kernel.org/lkml/aahchI7oiFrjFAmb@google.com/

So __this_cpu_ist_top_va() no longer needs to be exported, thus no need =
to
do the renaming.

The new patch is below:

commit 7f0d77e48751bd2f3f65f93eaf466257382a25b9
Author: Xin Li <xin@zytor.com>
Date:   Fri Oct 24 11:52:32 2025 -0700

    x86/fred: Export this_cpu_fred_rsp() for KVM usage
   =20
    Introduce and export this_cpu_fred_rsp() to provide KVM with a self-
    explanatory interface for retrieving per-CPU FRED regular stacks for
    stack levels 1->3.
   =20
    FRED introduced new fields in the VMCS host-state area for stack =
levels
    1=E2=80=93>3 (HOST_IA32_FRED_RSP[123]), which correspond to the =
per-CPU FRED
    regular stacks for stack levels 1->3.  KVM must populate these =
fields
    each time a vCPU is loaded onto a CPU to ensure a complete valid =
FRED
    event delivery context immediately after any VM-Exits.
   =20
    Signed-off-by: Xin Li <xin@zytor.com>
    ---
   =20
    Change in v10:
    * Replace direct, raw use of __this_cpu_ist_top_va() with a self-
      explanatory this_cpu_fred_rsp() helper for better readability =
(Sean).

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2bb65677c079..7eea65bfc838 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -35,6 +35,13 @@
=20
 #ifndef __ASSEMBLER__
=20
+enum fred_stack_level {
+	FRED_STACK_LEVEL_0,
+	FRED_STACK_LEVEL_1,
+	FRED_STACK_LEVEL_2,
+	FRED_STACK_LEVEL_3
+};
+
 #ifdef CONFIG_X86_FRED
 #include <linux/kernel.h>
 #include <linux/sched/task_stack.h>
@@ -105,6 +112,8 @@ static __always_inline void fred_update_rsp0(void)
 		__this_cpu_write(fred_rsp0, rsp0);
 	}
 }
+
+unsigned long this_cpu_fred_rsp(enum fred_stack_level lvl);
 #else /* CONFIG_X86_FRED */
 static __always_inline unsigned long fred_event_data(struct pt_regs =
*regs) { return 0; }
 static inline void cpu_init_fred_exceptions(void) { }
@@ -113,6 +122,7 @@ static inline void =
fred_complete_exception_setup(void) { }
 static inline void fred_entry_from_kvm(unsigned int type, unsigned int =
vector) { }
 static inline void fred_sync_rsp0(unsigned long rsp0) { }
 static inline void fred_update_rsp0(void) { }
+static unsigned long this_cpu_fred_rsp(enum fred_stack_level lvl) { =
return 0; }
 #endif /* CONFIG_X86_FRED */
 #endif /* !__ASSEMBLER__ */
=20
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
index 433c4a6f1773..363c53701012 100644
--- a/arch/x86/kernel/fred.c
+++ b/arch/x86/kernel/fred.c
@@ -72,6 +72,23 @@ void cpu_init_fred_exceptions(void)
 	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
 }
=20
+unsigned long this_cpu_fred_rsp(enum fred_stack_level lvl)
+{
+	switch (lvl) {
+	case FRED_STACK_LEVEL_0:
+		return __this_cpu_read(fred_rsp0);
+	case FRED_STACK_LEVEL_1:
+		return __this_cpu_ist_top_va(ESTACK_DB);
+	case FRED_STACK_LEVEL_2:
+		return __this_cpu_ist_top_va(ESTACK_NMI);
+	case FRED_STACK_LEVEL_3:
+		return __this_cpu_ist_top_va(ESTACK_DF);
+	default:
+		BUG();
+	}
+}
+EXPORT_SYMBOL_FOR_MODULES(this_cpu_fred_rsp, "kvm-intel");
+
 /* Must be called after setup_cpu_entry_areas() */
 void cpu_init_fred_rsps(void)
 {
@@ -87,7 +104,7 @@ void cpu_init_fred_rsps(void)
 	       FRED_STKLVL(X86_TRAP_DF,  FRED_DF_STACK_LEVEL));
=20
 	/* The FRED equivalents to IST stacks... */
-	wrmsrq(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
-	wrmsrq(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
-	wrmsrq(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
+	wrmsrq(MSR_IA32_FRED_RSP1, =
this_cpu_fred_rsp(FRED_STACK_LEVEL_1));
+	wrmsrq(MSR_IA32_FRED_RSP2, =
this_cpu_fred_rsp(FRED_STACK_LEVEL_2));
+	wrmsrq(MSR_IA32_FRED_RSP3, =
this_cpu_fred_rsp(FRED_STACK_LEVEL_3));
 }=

