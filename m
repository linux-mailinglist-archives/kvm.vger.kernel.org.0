Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2011E655438
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 21:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiLWUda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 15:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiLWUd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 15:33:28 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA82AE2;
        Fri, 23 Dec 2022 12:33:25 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFA6F1EC0354;
        Fri, 23 Dec 2022 21:33:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1671827604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=g4fBVP6B/mhnkNFZJu0f1SRCvVq/AKhj/YqOZGGwvF4=;
        b=I0K8TNt9L5H36UG2Ocm1J86itUmusbOXaZu7dcVD7JxZjkP1Z93AmpVNurMCJo8yU4QCvP
        95+QMVqRxViDu7ciW5TGuylqPeWaN8xy+KVf6aD0dL/YBbv5voXiSDo7cuAP69uOmYnTQ8
        xIBA3VHkmNwK4R3zzoNGHGU9/4yTrwY=
Date:   Fri, 23 Dec 2022 21:33:16 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com
Subject: Re: [PATCH RFC v7 00/64] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <Y6YQjJyoxKC5hfij@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 01:39:52PM -0600, Michael Roth wrote:
> This patchset is based on top of the following patchset:
> 
>   "[PATCH v10 0/9] KVM: mm: fd-based approach for supporting KVM"
>   https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/T/#me1dd3a4c295758b4e4ac8ff600f2db055bc5f987

Well, not quite.

There's also this thing which is stuck in there:

https://lore.kernel.org/r/20221205232341.4131240-1-vannapurve@google.com

and I would appreciate reading that in the 0th message so that I don't
scratch my head over why don't those patches apply and what else is
missing...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
