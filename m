Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6037CBDB
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 19:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhELQiX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:38:23 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43374 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238323AbhELQYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 12:24:45 -0400
Received: from zn.tnic (p200300ec2f0bb80077d55d62652951c8.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:b800:77d5:5d62:6529:51c8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7E2BA1EC0473;
        Wed, 12 May 2021 18:23:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620836614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0X58j7/TAcR/6ydoMQr78dKigX0U3Iwk3UeXo3z7hE=;
        b=m3FkKJtCFmkZ0gJVjd9JdKC3IotegfXp85I2WiSv2lbm3mvKMFuExkVUUTDXwQC5Gn31Gp
        8ogIClxXx7noylqZmMsBEO6JGz9wGoYegx1hNCSAcYrGI/H44XdpuvQfWZkkMHGDENIx+f
        sJKF3O2PjMFOzMfJhr6Xi2c2iH0jTIg=
Date:   Wed, 12 May 2021 18:23:27 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <YJwA/+0+LYtRzahr@zn.tnic>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <YJv5bjd0xThIahaa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YJv5bjd0xThIahaa@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 03:51:10PM +0000, Sean Christopherson wrote:
>   TL;DR: I think the KVM hypercall should be something like this, so that it can
>   be used for SNP and TDX, and possibly for other purposes, e.g. for paravirt
>   performance enhancements or something.

Ok, good, I was only making sure this is on people's radar but it
actually is more than that. I'll let Tom and Jörg comment on the meat
of the thing - as always, thanks for the detailed explanation.

From my !virt guy POV, I like the aspect of sharing stuff as much as
possible and it all makes sense to me but what the hell do I know...

>     8. KVM_HC_MAP_GPA_RANGE
>     -----------------------
>     :Architecture: x86
>     :Status: active
>     :Purpose: Request KVM to map a GPA range with the specified attributes.
> 
>     a0: the guest physical address of the start page
>     a1: the number of (4kb) pages (must be contiguous in GPA space)
>     a2: attributes
> 
>   where 'attributes' could be something like:
> 
>     bits  3:0 - preferred page size encoding 0 = 4kb, 1 = 2mb, 2 = 1gb, etc...
>     bit     4 - plaintext = 0, encrypted = 1
>     bits 63:5 - reserved (must be zero)

Yah, nice and simple. I like.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
