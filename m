Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D2765A4EC
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 15:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiLaO2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Dec 2022 09:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiLaO17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Dec 2022 09:27:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979BB865;
        Sat, 31 Dec 2022 06:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0CE660BF9;
        Sat, 31 Dec 2022 14:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDD8C433D2;
        Sat, 31 Dec 2022 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672496877;
        bh=jX7t/7pWcgT0+yoR/7ahq3q/+SsZWh0IKJ3T0K1gAaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=npo5BGMbKb2iENgI/mq5/492rR3lvpwpX46SHkGAGkLCj2oo/g/g8koZBQElf5HUb
         DM1T8IprgnU65huNHLN53qWQwpD8SYZa9sEsu+zrmecuaLxQhA4Crvxymr/QfB4c/y
         jbsd8z33wq+/FJ+3+ttiWyZOvf5mZN8h9iz6/uWld8CMJDoEeN7SVDsK0EWbvVgFC5
         cUyxpq+VOcxLQHhEBdauqxcji25RZpmYX3fQNqG77qY7MC0Bmm8Tq/wS4xqMKBMc3g
         c98IZi5Z+arYBjHg7D1iNwSzqBQucVfUba3Gnpb1WtKIFSvqBsH5bshIuDV2JItIcW
         T9f8LoNJMpeYQ==
Date:   Sat, 31 Dec 2022 14:27:54 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Pavan Kumar Paluri <papaluri@amd.com>
Subject: Re: [PATCH RFC v7 37/64] KVM: SVM: Add KVM_SNP_INIT command
Message-ID: <Y7BG6pSuoZsBQYrx@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-38-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IsE/bX3OQifH/VY6"
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-38-michael.roth@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--IsE/bX3OQifH/VY6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 14, 2022 at 01:40:29PM -0600, Michael Roth wrote:
>  static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -260,13 +279,23 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		return ret;
>  
>  	sev->active = true;
> -	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> +	sev->es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
> +	sev->snp_active = argp->id == KVM_SEV_SNP_INIT;
>  	asid = sev_asid_new(sev);
>  	if (asid < 0)
>  		goto e_no_asid;
>  	sev->asid = asid;
>  
> -	ret = sev_platform_init(&argp->error);
> +	if (sev->snp_active) {
> +		ret = verify_snp_init_flags(kvm, argp);
> +		if (ret)
> +			goto e_free;
> +
> +		ret = sev_snp_init(&argp->error, false);
> +	} else {
> +		ret = sev_platform_init(&argp->error);
> +	}

Couldn't sev_snp_init() and sev_platform_init() be called unconditionally
in order?

Since there is a hardware constraint that SNP init needs to always happen
before platform init, shouldn't SNP init happen as part of
__sev_platform_init_locked() instead?

I found these call sites for __sev_platform_init_locked(), none of which
follow the correct call order:

* sev_guest_init()
* sev_ioctl_do_pek_csr
* sev_ioctl_do_pdh_export()
* sev_ioctl_do_pek_import()
* sev_ioctl_do_pek_pdh_gen()
* sev_pci_init()

For me it looks like a bit flakky API use to have sev_snp_init() as an API
call.

I would suggest to make SNP init internal to the ccp driver and take care
of the correct orchestration over there.

Also, how it currently works in this patch set, if the firmware did not
load correctly, SNP init halts the whole system. The version check needs
to be in all call paths.

BR, Jarkko

--IsE/bX3OQifH/VY6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-crypto-ccp-Prevent-a-spurious-SEV_CMD_SNP_INIT-trigg.patch"

From c189db485a4162f401f351d2b1842c7f66f17ae6 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@profian.com>
Date: Sun, 4 Dec 2022 06:17:07 +0000
Subject: [PATCH] crypto: ccp: Prevent a spurious SEV_CMD_SNP_INIT triggered by
 sev_guest_init()

Move the firmware version check from sev_pci_init() to sev_snp_init().

Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 drivers/crypto/ccp/sev-dev.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6c4fdcaed72b..462c9aaa2e7e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1381,6 +1381,12 @@ static int __sev_snp_init_locked(int *error)
 	if (sev->snp_initialized)
 		return 0;
 
+	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
+		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
+		return -ENODEV;
+	}
+
 	/*
 	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
 	 * across all cores.
@@ -2313,25 +2319,19 @@ void sev_pci_init(void)
 		}
 	}
 
+	rc = sev_snp_init(&error, true);
+	if (rc != -ENODEV)
+		/*
+		 * Don't abort the probe if SNP INIT failed,
+		 * continue to initialize the legacy SEV firmware.
+		 */
+		dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
+
 	/*
 	 * If boot CPU supports SNP, then first attempt to initialize
 	 * the SNP firmware.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
-		if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
-			dev_err(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
-				SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
-		} else {
-			rc = sev_snp_init(&error, true);
-			if (rc) {
-				/*
-				 * Don't abort the probe if SNP INIT failed,
-				 * continue to initialize the legacy SEV firmware.
-				 */
-				dev_err(sev->dev, "SEV-SNP: failed to INIT error %#x\n", error);
-			}
-		}
-
 		/*
 		 * Allocate the intermediate buffers used for the legacy command handling.
 		 */
-- 
2.38.1


--IsE/bX3OQifH/VY6--
