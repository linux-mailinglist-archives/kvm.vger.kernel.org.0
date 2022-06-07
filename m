Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D709E53FA19
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiFGJqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 05:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiFGJqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 05:46:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0E1E64DB;
        Tue,  7 Jun 2022 02:46:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9004821B7A;
        Tue,  7 Jun 2022 09:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654595161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7MSzLpvdj4J16D8mZWCR6FzSRkCoMkGtMMDOn4haUiU=;
        b=cgaiqxAaG+nF69jX8yA+BXHJupOM/6qMqNN0IiLMDUSHbsUFXm2nyV5sUFrYaI/NBZTSA2
        4QMKNQSBOmBQjKc6fd4RzDQc2WxJ1luimb6yYW3ZPwhQHiQxReOO3jSFOfrBvXda4FuHAi
        bB33DbNMKbBlobHXqS4qg58a73+P+OI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654595161;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7MSzLpvdj4J16D8mZWCR6FzSRkCoMkGtMMDOn4haUiU=;
        b=YR8zrD+OLLqasP66ahtxBQb1RTA+cb+tvstppYaP6Bbd9RjbHtApgCVTWwVsajwqKHWE7m
        4fnnBVqoaNgBXXDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 399B213638;
        Tue,  7 Jun 2022 09:46:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2e1rCVken2LFOwAAMHmgww
        (envelope-from <vkarasulli@suse.de>); Tue, 07 Jun 2022 09:46:01 +0000
Date:   Tue, 7 Jun 2022 11:45:59 +0200
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org,
        x86@kernel.org, thomas.lendacky@amd.com, varad.gautam@suse.com
Subject: Re: [PATCH v6 1/4] x86/tests: Add tests for AMD SEV-ES #VC handling
Message-ID: <Yp8eVwMYlQpct+Ta@vasant-suse>
References: <20220318104646.8313-1-vkarasulli@suse.de>
 <20220318104646.8313-2-vkarasulli@suse.de>
 <YlA8OiFKGT8wP2dZ@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlA8OiFKGT8wP2dZ@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fr 08-04-22 15:44:26, Borislav Petkov wrote:
> > Subject: Re: [PATCH v6 1/4] x86/tests: Add tests for AMD SEV-ES #VC handling
>
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 6aef9ee28a39..69472a576909 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -24,6 +24,13 @@ CFLAGS_REMOVE_sev.o = -pg
> >  CFLAGS_REMOVE_cc_platform.o = -pg
> >  endif
> >
> > +# AMD_SEV_TEST_VC registers a kprobe by function name. IPA-SRA creates
> > +# function copies and renames them to have an .isra suffix, which breaks kprobes'
> > +# lookup. Build with -fno-ipa-sra for the test.
> > +ifdef CONFIG_AMD_SEV_TEST_VC
>
> Why ifdef?
>
> I think you want this to be enabled unconditionally since the VC tests
> select KRPOBES.
>

VC tests added in this patch series depend on the configuration
option CONFIG_AMD_SEV_TEST_VC which in turn selects KPROBES.
I think compiler flag -fno-ipa-sra wouldn't be necessary if
configuration option CONFIG_AMD_SEV_TEST_VC is disabled.

> > +CFLAGS_sev.o	+= -fno-ipa-sra
> > +endif
> > +
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

--
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com

