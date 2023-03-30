Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D666B6CFD60
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 09:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjC3HwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 03:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjC3Hv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 03:51:58 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B3E4C13;
        Thu, 30 Mar 2023 00:51:56 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 769401EC0646;
        Thu, 30 Mar 2023 09:51:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1680162715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=85y0fV0TPNY7oY0asM/HkP7UM08aGmliioJjCdgcMFA=;
        b=Zkf2IKP8lpt2RwzZntPRe51hye1kQZOonrkvqfZjL6WblHi73ujVwzbscJMYX3VgbXIXxJ
        JiCubJdJX9fNCUarmzmhtlixYKhTbTpoe+FbmmMNCruHVHkmZNjrKnTcTl2/IFlN4XSgBC
        NXG2Woohmgriuq1C7ZjtkMvRKOxTWes=
Date:   Thu, 30 Mar 2023 09:51:50 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        kim.phillips@amd.com, brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Sabin Rapan <sabrapan@amazon.com>
Subject: Re: [PATCH v17 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
Message-ID: <20230330075150.GAZCU/loaUn406SXi5@fat_crate.local>
References: <20230328200725.GHZCNI/dHoUMwhsfiC@fat_crate.local>
 <871ql7t7xr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <871ql7t7xr.ffs@tglx>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 02:10:56AM +0200, Thomas Gleixner wrote:
> That's not really true. The series is based on the x86/apic branch as
> the prerequites are in that brnach and that commit is in x86/sev.
> 
> That's an x86 maintainer issue to sort out, really.

Why do you think I left this note?

So that when you decide to pick up the rest of the parallel bringup
stuff, you can see it, find me on IRC and we figure out how to do the
tip patch tetris.

:-P

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
