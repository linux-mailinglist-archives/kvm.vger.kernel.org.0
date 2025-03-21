Return-Path: <kvm+bounces-41697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A44A6C101
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AFE1484211
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F205722DF82;
	Fri, 21 Mar 2025 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="a/ykywHy"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B8922D7B8;
	Fri, 21 Mar 2025 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742577140; cv=none; b=m6MgFaf+tLa76H7C2gf6GDzVyFpaCjRN4gNLGfiamJuPa49EU2B2aKT4hbkXZXORZAMdFjeewmQi0sSTQ1BEADY6u+1ScrioUwW+vrqA99S7U3G3Vbo0TcmzFIGYMJfEF7bIcdugU+JGVg8iIocqij6UeKfrZLtnq+pexJXnuxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742577140; c=relaxed/simple;
	bh=kWNKP0qGk7dV9W7IBZLgPsOLJyb8Zr5cOs0SxH5lZiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fnwmTr++apZgjOkHylCf6A96UNJTV+SIYLuP96riC9H4zZKL5WGWQC/byV90mD/jsiTMrBQ0tRQ181ByvZERxW8f/RmsCrlEHZOxpBBeHYmaZL/PCzLw8UVIUozr/ik+HGvBf1Ve8nzXpxy0lKiptWhQvNxRsUbaPn0mYRFobI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=a/ykywHy; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 63B6F40E022E;
	Fri, 21 Mar 2025 17:12:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bNlJGYGSE1sq; Fri, 21 Mar 2025 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1742577124; bh=wEXfYjQNzLRX/ebGfIDoWU40Qh1I7/o9F9mMNSLxhL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/ykywHy9go6UdIIGD0rwQVqgEXiwxE3M4WOv1GqDvVL7T9UvVlVXJSTvc/2kwGv4
	 Nn/sLuwimSCSu/IyiWZNgB1ot54MgKv9IyHzfZi6DfmlKZeOgB9uztGiM4KHBgSHV8
	 uDtKVm5yN4wiqWAmw6Ih05i6a6el6jHtdx0cACAnNwLIb1IXQi7kdhpY/ECXew5TKS
	 LNhchYGxz/QBegL5J/qiruz/9MQo7wsSUl72A+k/A5umhc/eOMT+66nLVrkCd7yGIb
	 rw7/oQH/tT8FfGJ7Ohu7aZHuzFcVWtMrzV8XAZsEsoveohcqKvOheZIxAHMoma9nrM
	 MyTUBGbAvGQ1GwZDpWvsKM2vywJH1fHNv8cmiJN/X4vNt+oTioTKB9HMMW0Yy42SiO
	 D6i2WxmsW9Glk3Pqs6n64HWxetzQu1m6JQVqVMc3eWbyZJ3PQga5brDQpVhT3V5EWO
	 1vhQu8Ilsu4W3MqX3wmesvCiNhosUamXWCLtUQTTSScXEQyWBGmye2943iq2eRfqmC
	 sHyExC363cVw+vHIx8DdWPkeHilfpPgpeXL7a0I5PDGnmTYeO8sw6VhtKmgBfkfRon
	 aYmavSykxrl2v8flcecpSwumpFqcdtx2WrRPzMCliMTBa0xVAmJOeNeynKfD791qMd
	 x81+g6ZnQBOi090W+Y8oa764=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3BC3B40E021F;
	Fri, 21 Mar 2025 17:11:44 +0000 (UTC)
Date: Fri, 21 Mar 2025 18:11:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
Message-ID: <20250321171138.GDZ92dykj1kOmNrUjZ@fat_crate.local>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
 <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
 <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>

On Fri, Mar 21, 2025 at 09:39:22PM +0530, Neeraj Upadhyay wrote:
> Ok, something like below?

Or something like that:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 76b16a2b03ee..1a5fa10ee4b9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -476,7 +476,7 @@ config X86_X2APIC
 
 config AMD_SECURE_AVIC
 	bool "AMD Secure AVIC"
-	depends on X86_X2APIC
+	depends on AMD_MEM_ENCRYPT && X86_X2APIC
 	help
 	  This enables AMD Secure AVIC support on guests that have this feature.
 
@@ -1517,7 +1517,6 @@ config AMD_MEM_ENCRYPT
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
 	select CRYPTO_LIB_AESGCM
-	select AMD_SECURE_AVIC
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index edc31615cb67..ecf86b8a6601 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -685,8 +685,14 @@
 #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
 #define MSR_AMD64_SNP_SMT_PROT_BIT	17
 #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
+
 #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
-#define MSR_AMD64_SNP_SECURE_AVIC 	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
+#else
+#define MSR_AMD64_SNP_SECURE_AVIC	0
+#endif
+
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

