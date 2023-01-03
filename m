Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D365BEED
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 12:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbjACL3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 06:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237128AbjACL31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 06:29:27 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744D8DF10;
        Tue,  3 Jan 2023 03:29:25 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2040B1EC050B;
        Tue,  3 Jan 2023 12:29:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672745364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hHNeXXmIEWKAYHBGGQRDhAL79D6KkvMsBbRma5cfExU=;
        b=NNIoSo0twPIZ1qGXBAOvS6g0W76sdRRKJAUfcPEizOgk+DopUiobxXahbjbSM/UqS5oaij
        5IR4OoNV1AEVjL8M+pT+zcowSBdqyq5XWwoSes448KG+tY8ey0gB2A/tL7HE2BsRAEsNfe
        sqKiAjN4/vnBAsFmLLpUQfzPBxqtfR0=
Date:   Tue, 3 Jan 2023 12:29:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        stable@kernel.org
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y7QRkzxg1HW9wMCp@zn.tnic>
References: <20230102083810.71178-1-nikunj@amd.com>
 <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
 <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com>
 <Y7M4IzNYBtfEJe6Z@zn.tnic>
 <02a2e641-6b6d-e1c5-2c43-8815306d92a0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <02a2e641-6b6d-e1c5-2c43-8815306d92a0@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 09:07:14AM +0530, Nikunj A. Dadhania wrote:
> Currently, GHCBData[24:63] is unused. If we intend to use the bit range(40bits), GHCB spec 
> will need to be updated. And probably would not be enough.

My fear too...

> As the termination request is done using GHCB MSR protocol, exit codes cannot be used.

We need to figure out some other way of communicating to the guest owner because
of which feature the guest refused booting.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
