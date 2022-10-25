Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A078860C704
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 10:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiJYI4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 04:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJYI4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 04:56:52 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DB1E6F7A;
        Tue, 25 Oct 2022 01:56:50 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e753329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e753:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D25271EC0682;
        Tue, 25 Oct 2022 10:56:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666688206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jzZuHCRT8tCn7Q/Cc28ysAO72/F5QJaLOhFhC2xnWuo=;
        b=F6nuzK5egVyOWZD7QTs1xY//bjUly+5gwu9iPkQkz3X/qmkffNZ+tq/+xSuJ/Wqzc5kdt2
        HdnHTNzbHU0q2syd5lZ0gmy6OoUpJIkNBXYWeExX9OSOkX1CBAVRA38ylozzbFg+2kf8Me
        mnuYUA7WKZ+r2b5WPJ2HMfbPIAzXGI0=
Date:   Tue, 25 Oct 2022 10:56:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 12/49] crypto: ccp: Add support to initialize
 the AMD-SP for SEV-SNP
Message-ID: <Y1ekyzdjUtpE1Z4n@zn.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <87a0481526e66ddd5f6192cbb43a50708aee2883.1655761627.git.ashish.kalra@amd.com>
 <Yzh558vy+rJfsBBq@zn.tnic>
 <f997dd38-a615-e343-44cd-a7aeb9447a1e@amd.com>
 <fac90493-fb40-d1dd-e40e-d522bf0f33cb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fac90493-fb40-d1dd-e40e-d522bf0f33cb@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 04:31:42PM -0500, Kalra, Ashish wrote:
> so that means we can't combine the IPIs.

Ok, thanks for checking.

> Also, this is not a performance critical path, so should we really be so
> concerned about it?

Not that concerned but we're always trying to be as optimal as possible.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
