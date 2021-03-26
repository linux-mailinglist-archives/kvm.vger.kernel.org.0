Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5DC34AD0F
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhCZRC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:02:28 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36396 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhCZRC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 13:02:27 -0400
Received: from zn.tnic (p200300ec2f075f00aa13db561e4cebd5.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:5f00:aa13:db56:1e4c:ebd5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 654371EC0535;
        Fri, 26 Mar 2021 18:02:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616778145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sHOGguuzDH6sV8Z2HSE7+eZGYEGC0SLY0CFm8dGQwks=;
        b=j13EEC6IU5Z7bV6rdxof2YU+QNTvItS+gCGT4HsJ0ePPAo2I3SEXRZgyflHMFSFRsY2/ra
        o+zabsZWlRpEIirMjY8sxtLsjHZBWmr1MNQ67/RZCB4MlLhonYZWDNJgqmBy8DuWjZN1X5
        4clLSOp+IzGinwRsvBxXOm3rGQ/AboU=
Date:   Fri, 26 Mar 2021 18:02:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     seanjc@google.com, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <20210326170223.GH25229@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
 <20210326150320.GF25229@zn.tnic>
 <db27d34f-60f9-a8e8-270e-7152bce81a12@intel.com>
 <20210326152931.GG25229@zn.tnic>
 <dc7ac02e-857a-b1ce-f444-0d244405a099@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc7ac02e-857a-b1ce-f444-0d244405a099@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 08:35:34AM -0700, Dave Hansen wrote:
> We could do it in the SGX core, but I think what we end up with will end
> up looking a lot like a cgroup controller.  It seems like overkill, but
> I think there's enough infrastructure to leverage that it's simpler to
> do it with cgroups versus anything else.

Right.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
