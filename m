Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1452A30C792
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbhBBRYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237317AbhBBRVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 12:21:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1AFB64ECE;
        Tue,  2 Feb 2021 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612286462;
        bh=l1cr+1jzN0x/IKYQnemyT4VKd26L3hh91/hellYQCZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CSg8T3qYM37zuuK09VNExJwVbwaYW1fkDTMzfLqrzQuLGkAzERqk73BuBA/fFrJe1
         IWoW/hAhQyAI2vOpVuuBFGLyvimWirGbZBUpiWeWr8x+4w9xhjLIYlOKovB0J62GHW
         Dkyq6pfag/Gm/45bw9+xLZMDVWTcY8QcqZ1c8+Ag8h2Uhi/ZRnPu3bGhdOQ0LpTyXo
         8jrZn6W0dYXhYcjaWRzBf9txSX+XRcT26BIX6iI3cDqLuTTDLwO+Avd0PLSup/HIZ7
         iNJOr1yMpottyiUIV6fxeksgLw4sIjV2IDdIuUxhvERrbr2HX5AMiynP8NQvjp0bp6
         7jgqoJT92POwA==
Date:   Tue, 2 Feb 2021 19:20:54 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YBmJ9tvbw3RE63F6@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
 <YBVyfQQPo18Fyv64@kernel.org>
 <20210201131744.30530bd817ae299df92b8164@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201131744.30530bd817ae299df92b8164@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 01:17:44PM +1300, Kai Huang wrote:
> On Sat, 30 Jan 2021 16:51:41 +0200 Jarkko Sakkinen wrote:
> > On Tue, Jan 26, 2021 at 10:31:06PM +1300, Kai Huang wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > 
> > > The bare-metal kernel must intercept ECREATE to be able to impose policies
> > > on guests.  When it does this, the bare-metal kernel runs ECREATE against
> > > the userspace mapping of the virtualized EPC.
> > 
> > I guess Andy's earlier comment applies here, i.e. SGX driver?
> 
> Sure.
> 
> [...]
> 
> > > +	}
> > > +
> > > +	if (encls_faulted(ret)) {
> > > +		*trapnr = ENCLS_TRAPNR(ret);

Also here is an empty line needed.

> > > +		return -EFAULT;
> > > +	}
> > 
> > Empty line here before return. Applies also to sgx_virt_ecreate().
> 
> Yes I can remove, but I am just carious: isn't "having empty line before return"
> a good coding-style? Do you have any reference to the guideline?

In the initial SGX patch set, this was the review feedback that I got
from Boris, so I would presume it is tip tree convention. Also, looking
at a random selection of files under arch/x86, it is commonly done this
way.

> 
> > 
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> > > -- 
> > > 2.29.2
> > 
> > Great work. I think this patch sets is shaping up.
> > 
> > /Jarkko
> > > 
> > > 
> 

/Jarkko
