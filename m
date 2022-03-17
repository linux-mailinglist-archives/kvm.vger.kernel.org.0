Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9349D4DC770
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 14:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbiCQNW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 09:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiCQNW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 09:22:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DD41760E9;
        Thu, 17 Mar 2022 06:21:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AAFF421108;
        Thu, 17 Mar 2022 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647523269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQSNVY5ry6JPZidVzTQekm/g7RGFWM3qtv5Uggb/ziA=;
        b=bwSOJ2vnD+dtYYUcUSM425vvrfLnK63Y6Of6LE2Lch+TeaVLiBQWfEJnxVMEPuWzAPJWS2
        T1RC/nJ8Pgk+wvrv6HRfB0RFeTlwJbK6J+KgmhX197lzYM6jcfCu55rvQgNDKDgBJUgKbJ
        KzHZzk+1K3EzFF4fdxr2Ki9XMyX/CVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647523269;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQSNVY5ry6JPZidVzTQekm/g7RGFWM3qtv5Uggb/ziA=;
        b=iL4+jc8bcuBD9X4xuAYrd/i6+tbXXhs3vl91B0j4W5tP/aHmqf5q/VCABCDNEkFooR2qdp
        5vDIeftzHCzeTEDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 631EB13BA9;
        Thu, 17 Mar 2022 13:21:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EpZKFsU1M2L4DQAAMHmgww
        (envelope-from <jroedel@suse.de>); Thu, 17 Mar 2022 13:21:09 +0000
Date:   Thu, 17 Mar 2022 14:21:08 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     linux-kernel@vger.kernel.org, bp@alien8.de, kvm@vger.kernel.org,
        x86@kernel.org, thomas.lendacky@amd.com,
        Varad Gautam <varad.gautam@suse.com>
Subject: Re: [PATCH v5 1/1] x86/test: Add a test for AMD SEV-ES #VC handling
Message-ID: <YjM1xOzRVRjtnNvP@suse.de>
References: <20220208162623.18368-1-vkarasulli@suse.de>
 <20220208162623.18368-2-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220208162623.18368-2-vkarasulli@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vasant,

thanks for submitting this.

On Tue, Feb 08, 2022 at 05:26:23PM +0100, Vasant Karasulli wrote:
> From: Varad Gautam <varad.gautam@suse.com>
> 
> Add a KUnit based test to validate Linux's VC handling, and introduce
> a new CONFIG_X86_TESTS to cover such tests. The test:
> 1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>    access GHCB before/after the resulting VMGEXIT).
> 2. triggers an NAE.
> 3. checks that the kretprobe was hit with the right exit_code available
>    in GHCB.
> 
> Since relying on kprobes, the test does not cover NMI contexts.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> ---
>  arch/x86/Kbuild              |   2 +
>  arch/x86/Kconfig.debug       |  16 ++++
>  arch/x86/kernel/Makefile     |   7 ++
>  arch/x86/tests/Makefile      |   3 +
>  arch/x86/tests/sev-test-vc.c | 154 +++++++++++++++++++++++++++++++++++
>  5 files changed, 182 insertions(+)
>  create mode 100644 arch/x86/tests/Makefile
>  create mode 100644 arch/x86/tests/sev-test-vc.c

Can we split this up a bit? Say into an initial patch which adds
arch/x86/tests/ and the Kconfig option and then three patches adding the
tests:

	1. Infrastructure and instruction-based tests (cpuid, wbinvd)
	2. Register access tests (MSR, DR7)
	3. IO tests (mmio, ioio)

> +static void sev_es_nae_mmio(struct kunit *test)
> +{
> +	unsigned long lapic_ver_pa = 0xfee00030; /* APIC_DEFAULT_PHYS_BASE + APIC_LVR */

Instead of the comment, please use the values directly to assign the
variable.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

