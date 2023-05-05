Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4986F853B
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbjEEPDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjEEPDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:03:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B98517DDF
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:03:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9C20D20161;
        Fri,  5 May 2023 15:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683298979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cazz3fWUIPev4x3qnlhZI4nTSlnGcYjwyxYCH5Sp+0k=;
        b=HUBUzJLn9QVxYWn9XBnEnzGWIKM3BNdsLK4YmOxSoFEjWbG6xMOp8DTIYfOZylmG6/wn1d
        CFvKx0TLiiW56BE14vMMlf+uhgjq78LLPWLfqTrfr/iSr/AE2s1AW/Lc9s41+5hx42edH5
        wmgETVSEyB5Wd1o/vbzPWfv2KUVepzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683298979;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cazz3fWUIPev4x3qnlhZI4nTSlnGcYjwyxYCH5Sp+0k=;
        b=9eZYPpsGjjKNhhUsqWRlbn4QExQ7FNu7MiEZ9eStsdNWr4pvy+UkLbMghrLBtD2XDwVbFb
        p/+ozzNNjsRHqCBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6CB3113513;
        Fri,  5 May 2023 15:02:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2kE7GaMaVWTTBAAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 05 May 2023 15:02:59 +0000
Date:   Fri, 5 May 2023 17:02:58 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org, amd-sev-snp@lists.suse.com
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZFUaou1Ts5cwheHg@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com>
 <ZFJTDtMK0QqXK5+E@suse.de>
 <614e66054c58048f2f43104cf1c9dcbc8745f292.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <614e66054c58048f2f43104cf1c9dcbc8745f292.camel@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 04, 2023 at 01:04:09PM -0400, James Bottomley wrote:
> Crypto support in ring-0 is unavoidable if we want to retain control of
> the VMPCK0 key in ring-0.  I can't see us giving it to ring-3 because
> that would give up control of the SVSM identity and basically make the
> ring-0 separation useless because you can compromise ring-3 and get the
> key and then communicate with the PSP as the SVSM.

It all depends on what the SVSM allows ring-3 to do, or in other
words, how the security model is implemented which locks down the ring-3
services. For example, I can see an attestation service implemented in
ring-3 as the exclusive owner of the VMPCK0 key (enforced by SVSM ring-0
code).

> I think the above problem also indicates no-one really has a fully
> thought out security model that shows practically how ring-3 improves
> the security posture.

The security model is certainly not fully designed in all details, but
when comparing an all-ring-0 (with everything in one address space)
approach to a split-code model which moves functionality into separate
address spaces and less privileged execution contexts, my bet is that
the latter will always win. This is something we know already, so there
is no need to re-learn that by evolution.

> The next question that's going to arise is *where* the crypto libraries
> should reside.  Given they're somewhat large, duplicating them for
> every cpl-3 application plus cpl-3 seems wasteful, so some type of vdso
> model sounds better (and might work instead of a syscall interfaces for
> cpl-0 services that are pure code).

That, in contrast, is something I would leave to evolution. We can build
the services (attestation, TPM, ...) and see if they benefit from a
shared-lib for crypto. The dynamic linking for that is certainly not
trivial, but can also be fully done in ring-3.

> I'm not sure it will be.  If some cloud or distro wants to shoot for
> FIPS compliance of the SVSM, for instance, a requirement will likely be
> to use a FIPS certified crypto library ... and they're all currently in
> C.  That's not to say we shouldn't aim for minimizing the C
> dependencies, but I don't see a "pure rust or else" approach
> facilitating the initial utility of the project.

Another reason to move all of this to ring-3. Ring-3 services can be
written in C and use C libraries as needed without lowering the security
of the ring-0 rust code.

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

