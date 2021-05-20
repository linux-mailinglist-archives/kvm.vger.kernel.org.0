Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E0A38B584
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbhETRx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhETRx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:53:28 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3580C061574;
        Thu, 20 May 2021 10:52:06 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0eb6009f35b1f88a592069.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:b600:9f35:b1f8:8a59:2069])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6A16B1EC064C;
        Thu, 20 May 2021 19:52:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621533125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QjVcZjqm5/10ZZQkty/TinnzjR8RRiru1ikOMqd1Ri0=;
        b=owNuv2xMy04KYoWQbdhnDa1orkCnNBBR3QKPzPJ2pOrqn01FoO7lMw8hmu062zokqFRuc7
        8TdPjT+CGeRmDT7p5b0WR9sMUH5u+dDXiq8x+dtBe2DtmKVrQcd+ztYo+ulXA5o8/e1U02
        SkYYPhbroDaJlvbQu/UILWw0tvWkO+Y=
Date:   Thu, 20 May 2021 19:51:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 10/20] x86/sev: Add a helper for the
 PVALIDATE instruction
Message-ID: <YKahvUZ3hAgWViqd@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-11-brijesh.singh@amd.com>
 <4ecbed35-aca4-9e30-22d0-f5c46b67b70a@amd.com>
 <YKadOnfjaeffKwav@zn.tnic>
 <8e7f0a86-55e3-2974-75d6-50228ea179b3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8e7f0a86-55e3-2974-75d6-50228ea179b3@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 12:44:50PM -0500, Brijesh Singh wrote:
> Hmm, I use the SIZEMISMATCH later in the patches.

You do, where? Maybe I don't see it.

> Since I was introducing the pvalidate in separate patch so decided to
> define all the return code.

You can define them in a comment so that it is clear what PVALIDATE
returns but not as defines when they're unused.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
