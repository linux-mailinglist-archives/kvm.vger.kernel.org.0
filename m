Return-Path: <kvm+bounces-3987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C84CC80B532
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 17:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82C692810FA
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 16:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4327A18023;
	Sat,  9 Dec 2023 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EKzYzcPu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F5710C4;
	Sat,  9 Dec 2023 08:21:08 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 31F6E40E00C6;
	Sat,  9 Dec 2023 16:21:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id p5DJ6hin4UHr; Sat,  9 Dec 2023 16:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1702138862; bh=HyDzrkPoCfW4PayZZjMMTzRt/urnsGOPJgwMOc9fuMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EKzYzcPuer8tSrZAB0fNhs7FnIOpN4mxmIrqVcEiCSbKlecHHLj/m5zD4jrsUb+uX
	 lOHSxV5iQJZvtPa+W+GaoYyhVYU4PbecAXzUWkWeQf/MD0qR6QGX/4jSb/NIHRJsNE
	 TqobEUwJLQpfPlj243QLLqPQ5Zj8iQcW3HvXcLpQi7XeaIqbAVB766/4lZaIR6B2tn
	 ugiddztA2CfiMsDKwmYLZ7Dqbyfoci5UZ5zd+LgnOdY3WqSfevLwy74F2W5samFLjB
	 yODqDWgs8mUG0DGrQrndyMf7qh/PizWiRMziSOOLUjXwU3Tt1l3TFLzwuTpBjLryWu
	 rI9hs7EpZPybT66NM260GDI1Uz3IzM9uOqZ+sCKMpCwWshQa5xFvgTO5B2K0Q4XQTA
	 CMHok9o+X8fUi0PYdfb5SizFgHbrQnAcSd8vUQ751dRBLvMzQBRAgtnsip59aRwnmE
	 HDphyIdN5o2jdbGEOwrCM1NUfcr35ozkcywmRRlh7Ib6OjB1tSD/jTAFedXDK6C9zx
	 RY7+4KRaFo7XX1d5EA13GG904GziO16r8M8rTm3kul9avChAItC1vNunWcFOb3ixec
	 PpLlM5i8J8lAsVlJXW3mZTt2aKW/eaOTZsBpniTohc/fA5UjHTYeVv0gIPi0ic0D0Z
	 tsnjY1f7MPLBAEmzKn5WAGno=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3144440E00A9;
	Sat,  9 Dec 2023 16:20:21 +0000 (UTC)
Date: Sat, 9 Dec 2023 17:20:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
	tony.luck@intel.com, marcorr@google.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
	liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>,
	Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH v10 14/50] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Message-ID: <20231209162015.GBZXSTv738J09Htf51@fat_crate.local>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-15-michael.roth@amd.com>
 <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
 <d5242390-8904-7ec5-d8a1-9e3fb8f6423c@amd.com>
 <20231206170807.GBZXCqd0z8uu2rlhpn@fat_crate.local>
 <9af9b10f-0ab6-1fe8-eaec-c9f98e14a203@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9af9b10f-0ab6-1fe8-eaec-c9f98e14a203@amd.com>

On Wed, Dec 06, 2023 at 02:35:28PM -0600, Kalra, Ashish wrote:
> The main use case for the probe parameter is to control if we want to do
> legacy SEV/SEV-ES INIT during probe. There is a usage case where we want to
> delay legacy SEV INIT till an actual SEV/SEV-ES guest is being launched. So
> essentially the probe parameter controls if we want to
> execute __sev_do_init_locked() or not.
> 
> We always want to do SNP INIT at probe time.

Here's what I mean (diff ontop):

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fae1fd45eccd..830d74fcf950 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -479,11 +479,16 @@ static inline int __sev_do_init_locked(int *psp_ret)
 		return __sev_init_locked(psp_ret);
 }
 
-static int ___sev_platform_init_locked(int *error, bool probe)
+/*
+ * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
+ * so perform SEV-SNP initialization at probe time.
+ */
+static int __sev_platform_init_snp_locked(int *error)
 {
-	int rc, psp_ret = SEV_RET_NO_FW_CALL;
+
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
+	int rc;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -493,10 +498,6 @@ static int ___sev_platform_init_locked(int *error, bool probe)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
 	rc = __sev_snp_init_locked(error);
 	if (rc && rc != -ENODEV) {
 		/*
@@ -506,8 +507,21 @@ static int ___sev_platform_init_locked(int *error, bool probe)
 		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n", rc, *error);
 	}
 
-	/* Delay SEV/SEV-ES support initialization */
-	if (probe && !psp_init_on_probe)
+	return rc;
+}
+
+static int __sev_platform_init_locked(int *error)
+{
+	int rc, psp_ret = SEV_RET_NO_FW_CALL;
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
+
+	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
 	if (!sev_es_tmr) {
@@ -563,33 +577,32 @@ static int ___sev_platform_init_locked(int *error, bool probe)
 	return 0;
 }
 
-static int __sev_platform_init_locked(int *error)
-{
-	return ___sev_platform_init_locked(error, false);
-}
-
-int sev_platform_init(int *error)
+static int _sev_platform_init_locked(int *error, bool probe)
 {
 	int rc;
 
-	mutex_lock(&sev_cmd_mutex);
-	rc = __sev_platform_init_locked(error);
-	mutex_unlock(&sev_cmd_mutex);
+	rc = __sev_platform_init_snp_locked(error);
+	if (rc)
+		return rc;
 
-	return rc;
+	/* Delay SEV/SEV-ES support initialization */
+	if (probe && !psp_init_on_probe)
+		return 0;
+
+	return __sev_platform_init_locked(error);
 }
-EXPORT_SYMBOL_GPL(sev_platform_init);
 
-static int sev_platform_init_on_probe(int *error)
+int sev_platform_init(int *error)
 {
 	int rc;
 
 	mutex_lock(&sev_cmd_mutex);
-	rc = ___sev_platform_init_locked(error, true);
+	rc = _sev_platform_init_locked(error, false);
 	mutex_unlock(&sev_cmd_mutex);
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sev_platform_init);
 
 static int __sev_platform_shutdown_locked(int *error)
 {
@@ -691,7 +704,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
 		return -EPERM;
 
 	if (sev->state == SEV_STATE_UNINIT) {
-		rc = __sev_platform_init_locked(&argp->error);
+		rc = _sev_platform_init_locked(&argp->error, false);
 		if (rc)
 			return rc;
 	}
@@ -734,7 +747,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = _sev_platform_init_locked(&argp->error, false);
 		if (ret)
 			goto e_free_blob;
 	}
@@ -1115,7 +1128,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = _sev_platform_init_locked(&argp->error, false);
 		if (ret)
 			goto e_free_oca;
 	}
@@ -1246,7 +1259,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 		if (!writable)
 			return -EPERM;
 
-		ret = __sev_platform_init_locked(&argp->error);
+		ret = _sev_platform_init_locked(&argp->error, false);
 		if (ret)
 			return ret;
 	}
@@ -1608,7 +1621,9 @@ void sev_pci_init(void)
 	}
 
 	/* Initialize the platform */
-	rc = sev_platform_init_on_probe(&error);
+	mutex_lock(&sev_cmd_mutex);
+	rc = _sev_platform_init_locked(&error, true);
+	mutex_unlock(&sev_cmd_mutex);
 	if (rc)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			error, rc);


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

