Return-Path: <kvm+bounces-7342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA2E840946
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:05:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38A64B2543B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 15:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4FA153BCF;
	Mon, 29 Jan 2024 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="CscN1g84"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FADC153511;
	Mon, 29 Jan 2024 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706540719; cv=none; b=qnJO7QsOT9vRtRHURhWe6Gk0WPaGvvhHuPXh4C1vN86bXmAUE9e3R7IK045QyY8yFzUuWQFVtlzm6jlM4CbEmNICZBKX/M+mFxhihVZmmkt3lnbOMoqDAskcWFmHWKg3rHsndRpw4XtaT3Ux8Gmdrw8e9mVnU/QeF9+jXWdl15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706540719; c=relaxed/simple;
	bh=sahI5XjE7lWXzvKerXYEtEDtCcFMfvCcQmTm4D/LJMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbYA8Cm1JmsTT5MuwtO0hEMtxu62lHAAnnwmwiuBy/nwXrtO7/j6auT9fb3YNAGnmCVDtE1QquETyDt1YUg10xFJ7ZTBE3l/FiE8oCo3OvwNXrABIXykVbKmnfRSmfZShNp0FtT6aEL42zXxhiuLCrrd+3mkcpPd82ck3Omu0/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=CscN1g84; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AFA5A40E01B3;
	Mon, 29 Jan 2024 15:05:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id AeIofEyGjJAP; Mon, 29 Jan 2024 15:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1706540710; bh=NCl5u2FekjETRT5G3FwgEZxEDuY5V1BwprwchryS7pY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CscN1g84Lfzvg/ZWyKLJuDdOFkStLxTKQHBb1MMVPjZqy4KxBdN9ZvjC43Q69JeSA
	 3oYoodsgMhia18fCuIoESMY/o/ZsrmtCtfHCjMNXWURim7qXAYDVWlvB2lbPJ2ug2Z
	 onpxo2BfJiQKdDhZ+VCP6QaSOR6dkYt6GSM+OOxjKQ4UoJNKfevCQnWSVt2HfGD7ew
	 /snFshyQRle9DmawuzURsgfAywzfhqaD3Wc8SJQQf2eEpQzEIbxeoFvdWKjZEVlRKB
	 ef60bRFEKOLE4CJb8OFe4Gcg2s1uELNkDhx3INgCJmCWvnRxQzBLnUotzUBXggxc2b
	 rElueYi3cuSNsCcmFo/3uudn2n3WLSQSxUZlfv6+gkv23/HkvhsTHhAk9aTgF7rI07
	 obj/Qh4SOcn0LphecJYVAFZg4jv7j4DVd7aVTk+LicBg3PbHRqEE9pxNLqvrw1Lidv
	 tfneaRkKpfosz6bOu5WYHFf0KrunrtJD53z16LzWUO9WIbY03sHw8wA/AXLFU+sf4h
	 naQ4m1mFdnvWiigZDcbzgKbWcNOT41dCBNWWIrY7V6/EgUTFDlE+wUy64PLhpk1uCw
	 z8IKfXSmxdp7bVjuV8ZReog4XY646Zo7splvX460RWro5J4OngMiTHglrGQCn266eY
	 pqvB7cVnZN9Zjn+Rofg8dBlA=
Received: from zn.tnic (pd953033e.dip0.t-ipconnect.de [217.83.3.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1888B40E016C;
	Mon, 29 Jan 2024 15:04:33 +0000 (UTC)
Date: Mon, 29 Jan 2024 16:04:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 16/25] crypto: ccp: Handle the legacy TMR allocation
 when SNP is enabled
Message-ID: <20240129150428.GZZbe-fMDSu-dy0cPy@fat_crate.local>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-17-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126041126.1927228-17-michael.roth@amd.com>

On Thu, Jan 25, 2024 at 10:11:16PM -0600, Michael Roth wrote:
> @@ -641,14 +774,16 @@ static int __sev_platform_init_locked(int *error)

That function - especially when looking at the next patch - becomes too
big and hard to follow.

Let's add subfunctions for each thing, diff ontop:

---
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fa992ce57ffe..70aabd1d3d5f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -759,6 +759,22 @@ static int __sev_snp_init_locked(int *error)
 	return rc;
 }
 
+static void __sev_platform_init_handle_tmr(struct sev_device *sev)
+{
+	if (sev_es_tmr)
+		return;
+
+	/* Obtain the TMR memory area for SEV-ES use */
+	sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
+	if (sev_es_tmr) {
+		/* Must flush the cache before giving it to the firmware */
+		if (!sev->snp_initialized)
+			clflush_cache_range(sev_es_tmr, sev_es_tmr_size);
+	} else {
+			dev_warn(sev->dev, "SEV: TMR allocation failed, SEV-ES support unavailable\n");
+	}
+}
+
 static int __sev_platform_init_locked(int *error)
 {
 	int rc, psp_ret = SEV_RET_NO_FW_CALL;
@@ -772,18 +788,7 @@ static int __sev_platform_init_locked(int *error)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	if (!sev_es_tmr) {
-		/* Obtain the TMR memory area for SEV-ES use */
-		sev_es_tmr = sev_fw_alloc(sev_es_tmr_size);
-		if (sev_es_tmr) {
-			/* Must flush the cache before giving it to the firmware */
-			if (!sev->snp_initialized)
-				clflush_cache_range(sev_es_tmr, sev_es_tmr_size);
-		} else {
-			dev_warn(sev->dev,
-				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
-		}
-	}
+	__sev_platform_init_handle_tmr(sev);
 
 	if (sev_init_ex_buffer) {
 		rc = sev_read_init_ex_file();

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

