Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001D265B6F7
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 20:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjABTmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 14:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjABTmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 14:42:20 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E852B482;
        Mon,  2 Jan 2023 11:42:18 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A74C51EC050D;
        Mon,  2 Jan 2023 20:42:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672688536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+L+JdAD5fujGBQBI4oqQqpeb1zLWSL4pvB3LgNSB0fs=;
        b=W5YbOv7UBgUHPOdMItwgm1S76PCy+0cPBg6pySgudrO2FeQRmqaIJlpTGuYQTUkXCNfT2W
        GF20fbR/hMR6eRkchgSB1X/UNifSX6gsOc8lhqnPHInrA8CF8H2PDkaR1+qL/Jo+d2nacK
        GbKA3QaraMdmtS5wg5OSmhmRMtpTBA8=
Date:   Mon, 2 Jan 2023 20:42:11 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        stable@kernel.org
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y7Mzk3tDImk46xcu@zn.tnic>
References: <20230102083810.71178-1-nikunj@amd.com>
 <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
 <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 02, 2023 at 08:50:23PM +0530, Nikunj A. Dadhania wrote:
> I think the "why" part depends on the user. Whether or not the user needs a
> certain feature enabled for the confidential guest.
> 
> If the cloud provider(hypervisor) enables the feature on user request, the
> guest terminates with GHCB_SNP_FEAT_NOT_IMPLEMENTED when guest kernel does
> have corresponding code/implementation.

I think you mean "does not have" here.

In any case, I think this whole handling of SEV features could go both ways:

* Cloud provider could say: we've enabled features X, Y and Z and if the guest
doesn't have support for them, then it would fail booting.

There would optimally be some text sowewhere in the cloud provider documentation
stating why those features are enabled and thus required to be supported by the
guest.

* Guest owner could require a minimal subset of features which must be present
in the HV in order to even boot on that HV.

Of course, I'm only speculating here. How it ends up really playing out in
reality we will have to see...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
