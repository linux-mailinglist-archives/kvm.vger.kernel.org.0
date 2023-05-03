Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A8C6F57DE
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 14:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjECM07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 08:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjECM06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 08:26:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681895597
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 05:26:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1073620338;
        Wed,  3 May 2023 12:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683116816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d730ov4NL1F3ERD4Dx+gWT7pT1JP4HjltOIN4DpqNdo=;
        b=ubJsLU/LNuy/0wAWYZgIFVyKZ03iTheu7JkJNA0/sInqG+4Q5lKL7bmHph5ny8dVjFwckF
        IEJm44hgIFppretpz/X58BQsJ/ngoDQVDH73r3pEUbaEawFYLv9dUenq1LhZ976NAFkkfH
        CMndOV1y6VXdhj010qV37qo9pArlzoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683116816;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d730ov4NL1F3ERD4Dx+gWT7pT1JP4HjltOIN4DpqNdo=;
        b=oVbTnGUSGUnGFdIimM0LGhz6Bnwr//a/Tx0264fN4+fe0EXnwszhb7yLdJRDJIMkwoPLcU
        ERy+OQ5umQNJgtCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C8CAA1331F;
        Wed,  3 May 2023 12:26:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wIWfLw9TUmQJfAAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 03 May 2023 12:26:55 +0000
Date:   Wed, 3 May 2023 14:26:54 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, Carlos Bilbao <carlos.bilbao@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZFJTDtMK0QqXK5+E@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tom,

thanks for that comparision!

On Tue, May 02, 2023 at 06:03:55PM -0500, Tom Lendacky wrote:
> While both SVSM implementations use the Qemu Firmware Configuration
> (fw_cfg) interface, the coconut-svsm relies on it a bit more than
> linux-svsm. In either case, other interfaces may need to be supported in
> order for an SVSM to work with a VMM other than Qemu.

Right, that is something I have been thinking about. After I talked to a
few others about it, I came to the conclusion that neither COCONUT nor
linux-svsm use an optimal interface to request information from the HV.
I think it would be best if we move to a model where the MADT and E820
tables from QEMU (or any other HV) are part of the measured initial
memory image, to make that data trusted. But we can discuss that
separately.

> - Both SVSMs end up located in a memory slot outside of memory that is
>   reported to the guest. Coconut-svsm gets the location and size from
>   fwcfg, which is customizable via the Qemu command line. Linux-svsm gets
>   the location and size from the build process and validates that location
>   and size.

Correct, COCONUT also has a fall-back where it just uses the last 16MB
of guest RAM if the fw_cfg file is not there. That needs OVMF support,
though.

>   - Pagetables:
>     Page table support can be tricky with the x86_64 crate. But in general
>     I believe it could still be used. Coconut-svsm uses a dynamic offset-
>     based approach for pagetables based on the final physical address
>     location. This offset could be utilized in the x86_64 crate
>     implementation. When CPL3 support comes around, that would require
>     further investigation.

Yeah, COCONUT does not only use an offset mapping, it also has specific
mappings for the per-cpu areas. Those are mapped at a fixed location,
same with stacks, so the needs already go beyond an offset mapping.

> - Coconut-svsm copies the original Secrets Page and the "frees" the memory
>   for it. I couldn't tell if the memory is zeroed out or not, but
>   something that should be looked at to ensure the VMPCK0 key is not
>   leaked.

Thanks, that is a real issue. I just wrote a fix for that.

> Some questions for coconut-svsm:
>   - Are there any concerns with using existing code/projects as submodules
>     within coconut-svsm (e.g. OpenSSL or a software TPM implementation)?
>     One of our design goals for linux-svsm was desirability to easily
>     allow downstream users or products to, e.g., use their own crypto
>     (e.g. company preferred)

No concerns from my side to run any code you want in a CPL-3 module.
This includes code which uses external libraries such as openssl or
libtpm. The modules will be in an archive file packaged with the SVSM
binary, so that everything that runs is measured at launch time.

>   - Are you open to having maintainers outside of SUSE? There is some
>     linux-svsm community concern about project governance and project
>     priorities and release schedules. This wouldn't have to be AMD even,
>     but we'd volunteer to help here if desired, but we'd like to foster a
>     true community model for governance regardless. We'd love to hear
>     thoughts on this from coconut-svsm folks.

Yes, I am definitely willing to make the project more open and move to a
maintainer-group model, no intention from my side to become a BDFL for
the project. I just have no clear picture yet how the model should look
like and how to get there. I will send a separate email to kick-start a
discussion about that.

>   - On the subject of priorities, the number one priority for the
>     linux-svsm project has been to quickly achieve production quality vTPM
>     support. The support for this is being actively worked on by
>     linux-svsm contributors and we'd want to find fastest path towards
>     getting that redirected into coconut-svsm (possibly starting with CPL0
>     implementation until CPL3 support is available) and the project
>     hardened for a release.  I imagine there will be some competing
>     priorities from coconut-svsm project currently, so wanted to get this
>     out on the table from the beginning.

That has been under discussion for some time, and honestly I think
the approach taken is the main difference between linux-svsm and
COCONUT. My position here is, and that comes with a big 'BUT', that I am
not fundamentally opposed to having a temporary solution for the TPM
until CPL-3 support is at a point where it can run a TPM module.

And here come the 'BUT': Since the goal of having one project is to
bundle community efforts, I think that the joint efforts are better
targeted at getting CPL-3 support to a point where it can run modules.
On that side some input and help is needed, especially to define the
syscall interface so that it suits the needs of a TPM implementation.

It is also not the case that CPL-3 support is out more than a year or
so. The RamFS is almost ready, as is the archive file inclusion[1]. We
will move to task management next, the goal is still to have basic
support ready in 2H2023.

[1] https://github.com/coconut-svsm/svsm/pull/27

If there is still a strong desire to have COCONUT with a TPM (running at
CPL-0) before CPL-3 support is usable, then I can live with including
code for that as a temporary solution. But linking huge amounts of C
code (like openssl or a tpm lib) into the SVSM rust binary kind of
contradicts the goals which made us using Rust for project in the first
place. That is why I only see this as a temporary solution.

> Since we don't want to split resources or have competing projects, we are
> leaning towards moving our development resources over to the coconut-svsm
> project.

Great move, much appreciated, thanks a lot for that! Let's work together
to make that happen.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany

(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman

