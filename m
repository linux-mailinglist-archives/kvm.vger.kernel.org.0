Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB9C6C24DB
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCTWnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCTWnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:43:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B1232E59;
        Mon, 20 Mar 2023 15:43:02 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 247641EC0531;
        Mon, 20 Mar 2023 23:43:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679352181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zZLjMsUyIr6umSUydv53ojEoMba8Prxh8iXXtZv2oXE=;
        b=NBKnNH2Zg78TFSxzhdnLoD2Ktv4tXw6pCa4j/58KSY1Kt53wMWx0L2mM2cLWzve3fvmYis
        1UHJJxULiXdNi+nwZz5x8KCvkSz3sjeDjrD87vtJKvbzvPQKRL2l182ysPZb61uSF/8Ieq
        Q1t5n2xZ6z26UZXr0AKq2xbvWYROWxA=
Date:   Mon, 20 Mar 2023 23:42:56 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
Message-ID: <20230320224256.GFZBjhcNIgnd7I02Qr@fat_crate.local>
References: <20230306163425.8324-1-jgross@suse.com>
 <20230306163425.8324-4-jgross@suse.com>
 <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>
 <f9511025-f815-c8fa-f6e7-80501e8c839f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f9511025-f815-c8fa-f6e7-80501e8c839f@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 02:47:30PM +0100, Juergen Gross wrote:
> > Since this code covers TDX guest too, I think eventually it makes sense for TDX
> > guest to use this function too (to avoid #VE IIUC).  If want to do that, then I
> > think TDX guest should have the same mutual understanding with *ALL* hypervisor,
> > as I am not sure what's the point of making the TDX guest's MTRR behaviour
> > depending on specific hypervisor.
> 
> This series tries to fix the current fallout.

We can relax the check so that it runs on TDX too. Along with a comment
above it why it needs to run on TDX.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
