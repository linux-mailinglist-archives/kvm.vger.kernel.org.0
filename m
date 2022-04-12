Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5374FDE5F
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiDLLfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 07:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352812AbiDLLfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 07:35:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0BB120BD;
        Tue, 12 Apr 2022 03:14:26 -0700 (PDT)
Received: from zn.tnic (p200300ea97156149329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:6149:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CBE411EC04EC;
        Tue, 12 Apr 2022 12:14:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649758460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1y9k9BF/11Tgebze8Cu7hBybPrnkPeApW3AHQccJqdY=;
        b=BGVNu+bdg3YBBTmhOrP/jEStGZ9QQO4lJhXGz9Ir1o0Hyt4oK9hZnBZXee09pHXKyNTnG1
        lanog3mSb+1cuJdREvfDV5wXhvJrCVoHGiOKch5R7C8I57+v57+eivVn21mQ4Bg1xpvjdb
        pI6zQ+IQJA46ne78ACtQwcx+giC/Lcg=
Date:   Tue, 12 Apr 2022 12:14:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org,
        x86@kernel.org, thomas.lendacky@amd.com, varad.gautam@suse.com
Subject: Re: [PATCH v6 2/4] x86/tests: Add tests for AMD SEV-ES #VC handling
Message-ID: <YlVRALeMEv6IhhVr@zn.tnic>
References: <20220318104646.8313-1-vkarasulli@suse.de>
 <20220318104646.8313-3-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220318104646.8313-3-vkarasulli@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 11:46:44AM +0100, Vasant Karasulli wrote:
>  Add KUnit based tests to validate Linux's
>  VC handling for instructions cpuid and wbinvd.

This looks like a commit message title to me.

Also, please write x86 instructions in all caps: CPUID and WBINVD.

>  These tests:
>    1. install a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>       access GHCB before/after the resulting VMGEXIT).
>    2. trigger an NAE by executing either cpuid or wbinvd.
>    3. check that the kretprobe was hit with the right exit_code
>       available in GHCB.

Yes, I'd appreciate a short step-by-step thing how to run them or a
pointer to the docs.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
