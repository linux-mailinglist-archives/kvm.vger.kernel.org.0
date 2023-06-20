Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4122A736B9C
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbjFTMKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 08:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjFTMKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 08:10:12 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62B7C6;
        Tue, 20 Jun 2023 05:10:10 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 52D6D1EC0589;
        Tue, 20 Jun 2023 14:10:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687263009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Ql+U7fdRXmA/T5FzVBClcEAj8T+8ofxD8UdRBhS4onc=;
        b=WjEsimMgK0SDv+cwlHliRtOENHTrsh91vMlUj76a3SY0Rc6H+E1QML4j0hkmoDQidVH8Jo
        iXeveYuyVhZCavOAbekzryJbODT1+1WzsAlpLWeLbvTXnmWdxcNWhwVhZgfkinI/0jEWz6
        GPtY+3bfzVSiL0QsI9sT/GtaoNxGfp0=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 18CQLNStf_-r; Tue, 20 Jun 2023 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687263006; bh=Ql+U7fdRXmA/T5FzVBClcEAj8T+8ofxD8UdRBhS4onc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hfOUBxtBtBjPXF39oOF3ZUvN61XjQe3LmVhjKtWxJsHC/101LS7/ZwEAyCLXrtDos
         6rV65BENcyyyWRLr06AnSLHuPXyYBP8k8Xku12SM1wyuoQ3Kt7xKdjkycFp66hKDeI
         tFuA9sZRcDfWPUaFLFmL9M3d8fJU46JD2A9HhsxeXeaEyPL1MYk7jgUgshZnl0oZAw
         OgRuwWp1I1HEPoirhwvgfY/c1X5by8s5P5gOw3pP8I8emQDdyYknlRJuLQgo31u10O
         Jk+ojyM8mG0G6b2kJ5L0JpD5WSMAWgQ0sytpzO/R9X8XJt4S4PLWWkg6QpaXqhaO6+
         X+XI3G+Wq8YDfZEGURuoru8FEWkLjNEwD6KAFabpurzjQPQbNuZOAMar3QqiqdycQ4
         uDOihd2sUnMyBYqaLil+kQxq+50zc+tis817YK1HglsVOg/HvJeyupBjjO2cT+gHMM
         dOR61duo+TRp5kxEpjcmIJQXulRbaURS/xFMoH7MoED/2Ky/h5xU7sUczEOG44CZFz
         1bjOrgBSvWNgYLNzPwUoG+11pqfR/yFvht+38G03bd5wsnae6D/9ccuMfHQ64U5wZ4
         tsmJXHXJbtLyApTEr6gMiQS/0RNFXcGdJzXW8hqDoM72Z/gUH4o1a2wvYS9PjVWPxB
         DtXgq+0bY4yEUrlbXMaWY9ug=
Received: from zn.tnic (p200300eA971dC592329C23ffFEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c592:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1E74440E01DE;
        Tue, 20 Jun 2023 12:09:26 +0000 (UTC)
Date:   Tue, 20 Jun 2023 14:09:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH RFC v9 05/51] x86/coco: move CONFIG_HAS_CC_PLATFORM check
 down into coco/Makefile
Message-ID: <20230620120920.GAZJGW8B6XHrsoLGCJ@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-6-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-6-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:13PM -0500, Michael Roth wrote:
> Currently CONFIG_HAS_CC_PLATFORM is a prereq for building anything in
					^^^^^^

Use proper english words pls.

> arch/x86/coco, but that is generally only applicable for guest support.
> 
> For SEV-SNP, helpers related purely to host support will also live in
> arch/x86/coco. To allow for CoCo-related host support code in
> arch/x86/coco, move that check down into the Makefile and check for it
> specifically when needed.

I have no clue what that means. Example?

The last time we talked about paths, we ended up agreeing on:

https://lore.kernel.org/all/Yg5nh1RknPRwIrb8@zn.tnic/

So your "helpers related purely to host support" should go to

arch/x86/virt/svm/sev*.c

And just to keep it simple, that should be

arch/x86/virt/svm/sev.c

and if there's real need to split that, we can do that later.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
