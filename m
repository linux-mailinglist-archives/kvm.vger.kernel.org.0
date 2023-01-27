Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E067E1CF
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 11:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjA0KiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 05:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjA0KiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 05:38:01 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEA59977D
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 02:37:48 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 434BB262DAE;
        Fri, 27 Jan 2023 11:37:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674815859;
        bh=R/vzonbPGqlI/fZmSZV7Oq3KpncVikgbGOtJc5uDHsA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uiyg7VAqvx1KvY6pAty0HyViBFPcPNKJa7yPW1NGoUvjsD/KZbw2NK8bf1v3p0bVG
         jcQSMu+XiQg8Qh5XzZvnyQ63ZLUp8Rzzr1OaPIssfgw7VRKjbqX/PVHKO7TRJlMMES
         0e+iuWQVzRR3UU8f7raFD7bhHsn1ILcyoAiHaZc0AmX1168uJHCZo6ocJEo+PXvhpM
         EqgjfxweSWpCZKwPpokCPzZBIJ9sKZ00feXY27b5sV1ns88FfocHRatiqO562iG7aC
         sQ6SmA57DlPOXDryPlYaO2YvJ238p96W5LqGxvU28h605f4T2coCgYS6C2tlrPA8sD
         ZcMfICSYsqTFQ==
Date:   Fri, 27 Jan 2023 11:37:38 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9OpcoSacyOkPkvl@8bytes.org>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 10:08:14AM +0100, Peter Zijlstra wrote:
> Welcome to the wonderful shit show that is x86 exceptions :/
> 
> I thought sev_es_*() is supposed to fix this. Joerg, any clue?

Hmm, no, not yet, the stack-trace doesn't make much sense to me. The
sev_es_* function calls in the NMI path are for re-enabling NMI and
adjusting the #VC IST stack to allow nested VCs.

Alexey, can you try to get a more stable backtrace? For example by
building the kernel with frame pointers?

Regards,

	Joerg
