Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359524C1283
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240126AbiBWMNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiBWMNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:13:33 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF29AD86;
        Wed, 23 Feb 2022 04:13:05 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BBD201EC0513;
        Wed, 23 Feb 2022 13:12:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1645618379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=gteGd11Jt7h+QAGrW830hXTEMn1cy4DB46HZyBPZsmo=;
        b=Fj2YcrRUqhEaoJoKCeqK5tOBDRAl7PkHCVFguJVuhK8mci0/33tkpaPLwI+5KMjh5sF9u8
        JKSrOHJ9l5Y4peNMwgCDH/SP6++XxmA+5PVZCs8Fc2Espb1OUwO10WDQnaYBM9+VH7Ofb6
        BC6hBDm3wNNHvWviWHGbEUUhWsD/nC8=
Date:   Wed, 23 Feb 2022 13:13:03 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86/mm/cpa: Generalize __set_memory_enc_pgtable()
Message-ID: <YhYkz7wMON1o64Ba@zn.tnic>
References: <20220222185740.26228-1-kirill.shutemov@linux.intel.com>
 <20220223043528.2093214-1-brijesh.singh@amd.com>
 <YhYbLDTFLIksB/qp@zn.tnic>
 <20220223115539.pqk7624xku2qwhlu@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220223115539.pqk7624xku2qwhlu@black.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 02:55:39PM +0300, Kirill A. Shutemov wrote:
> This operation can fail for TDX. We need to be able to return error code
> here:
> 	/* Notify hypervisor that we have successfully set/clr encryption attribute. */
> 	if (!ret)
> 		ret = x86_platform.guest.enc_status_change_finish(addr, numpages, enc);

bool to state failure/success or you need to return a specific value?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
