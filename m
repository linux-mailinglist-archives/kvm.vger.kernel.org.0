Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B057D68BC
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 12:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbjJYKfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 06:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbjJYKeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 06:34:46 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B3D58
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 03:34:38 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BDDE140E01B1;
        Wed, 25 Oct 2023 10:34:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QhHASVTCwIga; Wed, 25 Oct 2023 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698230067; bh=18/mcvH27y89kOfWgOoc8il6KtQKA9GxDmtXxRzFDWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THlV6aVyPuO4ttcnuH/sGy+hWth3pFJ07cC8hdq9VyG+NrRs/JloOwG2eT09BBphI
         RlM67phHuDDqlYPZj44DIIVVPEP0IbQLF6FlE7kTMwDkM9ucCXtShvRTn3PURoC7+S
         71N3Cgs86GC7rspSy0IFg1kiTZX9AXS6TRlmhA8CchZBik8YxcJY2RHS8pQnaEgjcJ
         +UDXQ/F6AJ/wmNnWh6fGhA3s0cN1TiXtb3/aP30DNq1EGWpoG5dCVw54fe9CcSnTMw
         LkybLkvVkIJGj5Ax2VPWJsFlGPNwXoiUhtOo39O2PdqpH6rx6Z2f7d7lO3heV4q9Oj
         jmRV9D25H83khSsp3ccugLurO/iUhzlRD8aGNl2b7PkflskJnrV486d+8EOoJFDWup
         H36ii52EzVM/gC1PQheMUv9cNyPpZG3lsIY13i3B1b8uCCh8CwnK05i0M4kqjzyU8A
         v7yevDQlwKxc43uw/0QlTAdTA7sQ4CFT3aRpbSthtG4/CGwXlVRbkDEMUGrcMAMNyV
         SjhVKhf0madhWha83TWsjxX+DndfcCe06zn2F4TzrpxE0ccnwU5xNm0Ou4wP/w3BGq
         l2qJa88fiy1hYv+ux2UZyZustv7joHhOV5ves/f5olzL7HgQaoeDOo9ZaJ3lMal37F
         kiycBZsBh5nho7t4msMZd5IY=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B3E1740E0196;
        Wed, 25 Oct 2023 10:34:08 +0000 (UTC)
Date:   Wed, 25 Oct 2023 12:34:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <akaher@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 1/5] x86/paravirt: move some functions and defines to
 alternative
Message-ID: <20231025103402.GBZTjvGse9c0utZGO0@fat_crate.local>
References: <20231019091520.14540-1-jgross@suse.com>
 <20231019091520.14540-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231019091520.14540-2-jgross@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 11:15:16AM +0200, Juergen Gross wrote:
> +/* Low-level backend functions usable from alternative code replacements. */
> +DEFINE_ASM_FUNC(x86_nop, "", .entry.text);
> +EXPORT_SYMBOL_GPL(x86_nop);

This is all x86 code so you don't really need the "x86_" prefix - "nop"
is perfectly fine.

> +noinstr void x86_BUG(void)
> +{
> +	BUG();
> +}
> +EXPORT_SYMBOL_GPL(x86_BUG);

That export is needed for?

Paravirt stuff in modules?

It builds here without it - I guess I need to do an allmodconfig.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
