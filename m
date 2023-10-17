Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35527CCB21
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbjJQSuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343980AbjJQSt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:49:57 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7899D90
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:49:54 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4C12540E01AF;
        Tue, 17 Oct 2023 18:49:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Tde3ZKMdYLfj; Tue, 17 Oct 2023 18:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1697568586; bh=8cR1vXAVZJX6o9yEH9RbbZtCo19vNnY535FPOckUKS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TA0v+0y3/gQn2lWLgu7AjZSkgrsLS6aYOK/zWSN3Q0UwkcgcejDzB1k4hRzuHUHJj
         7T6ZxbCc6l7RRog4jF+uYBhIxVxmJ04me3Y4et+gWS7VkMVub8G4fNSPVGdlw/B2Ti
         EEx21oot1jJQiAlGAjbGGO+c3Mw5+Odj1v5ej+zvp6WsSj85mcLi/aQMIveHKACBr6
         V5EFWF8RYYXzajWR4rmOw30IH50OjLOp3gvbfwa6miIq0OlFpNQgr12vGN3dkdWAmq
         BBHfgAWJKE+zaeiRWgt9LecJZsp8pT7+ikDO9RF16P56bBeRc/+Lj7yxCw7E21q0NN
         n4Vs9hFY3FK0S+vbd9+pDkZkS0XhIkq8onso2yg3dJUeQlleueNgZTNsbmRgfSysb2
         /2aqK8GTVh/4sJuEVlXis/JZC6tGV2sn50SxV6gZyM07HOodL44LkbwICRfdDXvchM
         bdgssSWb0VRvVN6yRwiyj6sA6RM6J3rxy3ch3orpQNvIe9uyKTT/QDLfOaPMN8DkrZ
         wNQrReiyJcxusW3h+dl6uFZyQ2idtvSb9rxuwGhwARCQL0i9UZLMyDtEQflqVV9UlY
         AWUm+V8tvV3xDlYyJo5bCDnd1dKV7B6bFvW4fcV726kiwbtKbrSQkNMA6xGv9bFccN
         PPG43oEuGWVbWyEhCcC3K5i8=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7386040E01AA;
        Tue, 17 Oct 2023 18:49:37 +0000 (UTC)
Date:   Tue, 17 Oct 2023 20:49:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [PATCH 7/9] x86/sev-es: Include XSS value in GHCB CPUID request
Message-ID: <20231017184932.GBZS7XPESSMgPoCysY@fat_crate.local>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-8-john.allen@amd.com>
 <20231012125924.GFZSftrGx43ALVCtfS@fat_crate.local>
 <ZS7OjlhJKI2xlbY/@johallen-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZS7OjlhJKI2xlbY/@johallen-workstation>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 01:12:30PM -0500, John Allen wrote:
> I looked into using __rdmsr in an earlier revision of the patch, but
> found that it causes a build warning:
> 
> ld: warning: orphan section `__ex_table' from `arch/x86/boot/compressed/sev.o' being placed in section `__ex_table'
> 
> This is due to the __ex_table section not being used during
> decompression boot. Do you know of a way around this?

Yeah, arch/x86/boot/msr.h.

We did those a while ago. I guess they could be moved to
asm/shared/msr.h and renamed to something that is not a
"boot_" prefix.

Something like

rdmsr_without_any_exception_handling_and_other_gunk_don_t_you_even_think_of_adding()

...

But srsly:

raw_rdmsr()
raw_wrmsr()

should be good, as tglx suggests offlist.

You can do that in one patch and prepend your set with it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
