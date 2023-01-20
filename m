Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B9067615D
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 00:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjATXR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 18:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjATXR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 18:17:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D153472B8;
        Fri, 20 Jan 2023 15:17:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 591FCB82AA6;
        Fri, 20 Jan 2023 23:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7510DC433D2;
        Fri, 20 Jan 2023 23:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674256643;
        bh=SoqwK6Lbe/mngQK8/Z0v1FXpq/aJOBcKcs9SVP31/ss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HAucgctXzN9/951JWEJjbzvwMgSm5mu/FK37EvGSRiIsqcGwiwm0Sd2MMd+k58d9G
         Fp0qyJPu11GHZFkhDwIPCnhjqIlM0o13n/mq14ncbX/1ZNxhnX5nQdbv2s9DDIINdU
         zkynKCEzKf2AjpTOkByQy3zeIem0IvE7iniX+PDZ2Zcga80SXcyT6Cx9V/XJYFmqMW
         8xlCk1YB8+/16Wtm8akBQmfuMqE/uj4FKd8v2julqdoNeZv+InV1oBUkWNUHg/n+Y7
         w3Xu/Cx89Yyy8Ab+QikkvjG1ytxt2d3Pki9e+jRBI/Cop2LOoXGWd8r6aIjK57H9Ce
         WGCs8eUeLB8uQ==
Date:   Fri, 20 Jan 2023 23:17:20 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
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
        dgilbert@redhat.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Pavan Kumar Paluri <papaluri@amd.com>
Subject: Re: [PATCH RFC v7 37/64] KVM: SVM: Add KVM_SNP_INIT command
Message-ID: <Y8shAD2bPCK6nltn@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-38-michael.roth@amd.com>
 <Y7BG6pSuoZsBQYrx@kernel.org>
 <fd23ee51-ec47-717d-7cce-1d79db8b6bd3@amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Mwn5vxNlX4YIa3fN"
Content-Disposition: inline
In-Reply-To: <fd23ee51-ec47-717d-7cce-1d79db8b6bd3@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Mwn5vxNlX4YIa3fN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2023 at 05:37:20PM -0600, Kalra, Ashish wrote:
> Hello Jarkko,
> 
> On 12/31/2022 8:27 AM, Jarkko Sakkinen wrote:
> > On Wed, Dec 14, 2022 at 01:40:29PM -0600, Michael Roth wrote:
> > >   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >   {
> > >   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > @@ -260,13 +279,23 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > >   		return ret;
> > >   	sev->active = true;
> > > -	sev->es_active = argp->id == KVM_SEV_ES_INIT;
> > > +	sev->es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
> > > +	sev->snp_active = argp->id == KVM_SEV_SNP_INIT;
> > >   	asid = sev_asid_new(sev);
> > >   	if (asid < 0)
> > >   		goto e_no_asid;
> > >   	sev->asid = asid;
> > > -	ret = sev_platform_init(&argp->error);
> > > +	if (sev->snp_active) {
> > > +		ret = verify_snp_init_flags(kvm, argp);
> > > +		if (ret)
> > > +			goto e_free;
> > > +
> > > +		ret = sev_snp_init(&argp->error, false);
> > > +	} else {
> > > +		ret = sev_platform_init(&argp->error);
> > > +	}
> > 
> > Couldn't sev_snp_init() and sev_platform_init() be called unconditionally
> > in order?
> > 
> > Since there is a hardware constraint that SNP init needs to always happen
> > before platform init, shouldn't SNP init happen as part of
> > __sev_platform_init_locked() instead?
> > 
> 
> On Genoa there is currently an issue that if we do an SNP_INIT before an
> SEV_INIT and then attempt to launch a SEV guest that may fail, so we need to
> keep SNP INIT and SEV INIT separate.
> 
> We need to provide a way to run (existing) SEV guests on a system that
> supports SNP without doing an SNP_INIT at all.
> 
> This is done using psp_init_on_probe parameter of the CCP module to avoid
> doing either SNP/SEV firmware initialization during module load and then
> defer the firmware initialization till someone launches a guest of one
> flavor or the other.
> 
> And then sev_guest_init() does either SNP or SEV firmware init depending on
> the type of the guest being launched.

OK, got it, thank you. I have not noticed the init_on_probe for
sev_snp_init() before. Was it in earlier patch set version?

The benefit of having everything in __sev_platform_init_lock() would be first 
less risk of shooting yourself into foot, and also no need to pass
init_on_probe to sev_snp_init() as it would be internal to sev-dev.c, and
no need for special cases for callers. It is in my opinion internals of the
SEV driver to guarantee the order.

E.g. changes to svm/sev.c would be then quite trivial.

> > I found these call sites for __sev_platform_init_locked(), none of which
> > follow the correct call order:
> > 
> > * sev_guest_init()
> 
> As explained above, this call site is important for deferring the firmware
> initialization to an actual guest launch.
> 
> > * sev_ioctl_do_pek_csr
> > * sev_ioctl_do_pdh_export()
> > * sev_ioctl_do_pek_import()
> > * sev_ioctl_do_pek_pdh_gen()

What happens if any of these are called before sev_guest_init()? They only
call __sev_platform_init_locked().

> > * sev_pci_init()
> > 
> > For me it looks like a bit flakky API use to have sev_snp_init() as an API
> > call.
> > 
> > I would suggest to make SNP init internal to the ccp driver and take care
> > of the correct orchestration over there.
> > 
> 
> Due to Genoa issue, we may still need SNP init and SEV init to be invoked
> separately outside the CCP driver.
> 
> > Also, how it currently works in this patch set, if the firmware did not
> > load correctly, SNP init halts the whole system. The version check needs
> > to be in all call paths.
> > 
> 
> Yes, i agree with that.

Attached the fix I sent in private earlier.

> Thanks,
> Ashish

BR, Jarkko

--Mwn5vxNlX4YIa3fN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-crypto-ccp-Prevent-a-spurious-SEV_CMD_SNP_INIT-trigg.patch"

From f24054af9eeeb0314bbd0c37bd97ff38e2ded717 Mon Sep 17 00:00:00 2001
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
index 7c5698bde655..08787d998f15 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1387,6 +1387,12 @@ static int __sev_snp_init_locked(int *error)
 	if (sev->snp_initialized)
 		return 0;
 
+	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
+		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
+			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
+		return 0;
+	}
+
 	/*
 	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
 	 * across all cores.
@@ -2319,25 +2325,19 @@ void sev_pci_init(void)
 		}
 	}
 
+	rc = sev_snp_init(&error, true);
+	if (rc)
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


--Mwn5vxNlX4YIa3fN--
