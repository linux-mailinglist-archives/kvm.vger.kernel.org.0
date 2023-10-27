Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861667D9D13
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 17:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346126AbjJ0PhT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 11:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345688AbjJ0PhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 11:37:18 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C45AC;
        Fri, 27 Oct 2023 08:37:16 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2348C40E01A3;
        Fri, 27 Oct 2023 15:37:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id e_xtMHTcYW2r; Fri, 27 Oct 2023 15:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698421032; bh=pSfZSawGF2erhsaMKBAQQmhHgcUHNYh/nOy4mi1YlNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJGgrBU1u9OlxE0OcdrIT+jLGPBKhNZdX9rAwL9D/QGKjFZLii4FhNqScNyKD04kL
         Uy/nuJSbn05pPgQIYXEszIGQpHpG7kPfbK0nG4pgKp7TbBSU9QRo3A5jP7/UnHdaCa
         GhKWTqkL+87kE8jtcQoXI9nXHZCb946IeN2Mm9+5oc+NFWJl+vja4kvgfIT1tlSJZM
         x4hwLsjiNmd/4WS52pplhZFvFPjTuRnn9GrOgKdfaWteOIRtCbyMFGk/bSAkZlv0ji
         bbwUZ57Id7GxcDCTlJ/T/GjVmeZULTiaIkBAwsXkDfG6Y/YXSSa2JE5MLBLvBmKeu1
         uTUC9B71VtqcyaFfGsFK8iZ7feY6Y0HkVykKiliHHy5vdQZNdaWg3JNXnqwIfioGDe
         3ZvuFFD+JFB/XjpMgWjmRWet61FesiduDPHVonB4Augz4LZLn7WvF9OkaaynyxsioO
         NZpi6DQLXxws1XrEWaHUo1IsIT6E0XpNWh6t1L0cRLxTZL6s2e1HdG7muIniawky/P
         RewTk3vgWTUF4/6+xKAb+Zf6iN90N0Cwv+hVohd3dPe9uBqTCs42/lBFXLjtpxab7q
         VZJyjng0sKhsBL9KXgI1X3Ik9CzfLShGG22KB6fRPZrKOXWuQkvwIA+xY4QCpFHn49
         2YyUbpQ/yto41iDa4bnjz3Y0=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D107C40E0171;
        Fri, 27 Oct 2023 15:36:45 +0000 (UTC)
Date:   Fri, 27 Oct 2023 17:36:45 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alyssa Milburn <alyssa.milburn@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4 0/6] Delay VERW
Message-ID: <20231027153645.GNZTvZDR5YVXovEcJq@fat_crate.local>
References: <20231027-delay-verw-v4-0-9a3622d4bcf7@linux.intel.com>
 <20231027144848.GGZTvN0AtGIQ9kBtkA@fat_crate.local>
 <20231027150535.s4nlkppsvzeahm7t@desk>
 <20231027151226.GIZTvTWuQUXdsmt6v3@fat_crate.local>
 <20231027153242.ruabpxxywhq5upc7@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231027153242.ruabpxxywhq5upc7@desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 08:32:42AM -0700, Pawan Gupta wrote:
> I can imagine the amount emails maintainers get. I'll take care of this
> in future. But, its good to get some idea on how much is too much,
> specially for a security issue?

If it ain't really urgent, once a week like every other patchset. We
have all this documented in

Documentation/process/submitting-patches.rst

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
