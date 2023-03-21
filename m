Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883B06C308B
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 12:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjCULl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 07:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCULlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 07:41:25 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FD51CBC5;
        Tue, 21 Mar 2023 04:41:22 -0700 (PDT)
Received: from zn.tnic (p5de8e687.dip0.t-ipconnect.de [93.232.230.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6F8B11EC0541;
        Tue, 21 Mar 2023 12:41:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1679398880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8KLj55BPQ3FZitIoW8lX/Qp9hlW111dUvVmDITZUavc=;
        b=Y7eebmCqh9rHwcCl1t0xVo1mnhE201G62vR7nEaGV+SsLSJvowWTJN87i/qctcyAWtXXq9
        qMPHJEBmUtUCiptoW58jCZo/mteIMAZh8qhwlS+ZYAtUH5rel3JK38kqPYGautcFdLAVfB
        C6spRZl57sRX4WUHZPOdXesuz6Qk21I=
Date:   Tue, 21 Mar 2023 12:41:15 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com, piotrgorski@cachyos.org,
        oleksandr@natalenko.name, arjan@linux.intel.com, mingo@redhat.com,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v15 04/12] x86/smpboot: Reference count on
 smpboot_setup_warm_reset_vector()
Message-ID: <20230321114115.GGZBmX270DI11eXvM+@fat_crate.local>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
 <20230316222109.1940300-5-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230316222109.1940300-5-usama.arif@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 10:21:01PM +0000, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When bringing up a secondary CPU from do_boot_cpu(), the warm reset flag
> is set in CMOS and the starting IP for the trampoline written inside the
> BDA at 0x467. Once the CPU is running, the CMOS flag is unset and the
> value in the BDA cleared.
> 
> To allow for parallel bringup of CPUs, add a reference count to track the
> number of CPUs currently bring brought up, and clear the state only when

s/bring //

> the count reaches zero.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
