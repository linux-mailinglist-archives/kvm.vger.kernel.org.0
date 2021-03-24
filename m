Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A00A347495
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 10:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhCXJ1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 05:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231853AbhCXJ1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 05:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B160619FF;
        Wed, 24 Mar 2021 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616578028;
        bh=oxpG75srpKd55D9h43W41NZwTiHebk84Xt19Ctgl830=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JbgVoipKJU0xRW4XXHjnjo7O8b5hHW6iIB1drH2Oq4v+vIglgOwdXnYeQxoGarPCC
         yV7jDrBR1YWwjzExlBUxIJiWhSWW2qeZuSwp9lvPJ3dq82HjdfvzLIzt/hO0R4iyrY
         jVnB1s5PiptLVRKxu4L0LLsIpcTG40eIS6ea6dEdIAWnYJq1k8J7SvdIg5aScQFqus
         a52MB1wc/7/GT+IXnknPjwBMAJtPe6hrk/TwAC/r2COHEoqonoB53EGJh4XjCU12Kx
         HCANn6KgiyAk+UsCiaJKmlUZsR/EzN0H3BT3Q1hLUjBHz9whSdm6pA4Y+Xa49mJ5v6
         FNd3IsH94eZHg==
Date:   Wed, 24 Mar 2021 11:26:37 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFsFzV58w/UdjP/P@kernel.org>
References: <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323160604.GB4729@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 05:06:04PM +0100, Borislav Petkov wrote:
> On Tue, Mar 23, 2021 at 03:45:14PM +0000, Sean Christopherson wrote:
> > Practically speaking, "basic" deployments of SGX VMs will be insulated from
> > this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
> > exhausted, new VMs will fail to launch, but existing VMs will continue to chug
> > along with no ill effects....
> 
> Ok, so it sounds to me like *at* *least* there should be some writeup in
> Documentation/ explaining to the user what to do when she sees such an
> EREMOVE failure, perhaps the gist of this thread and then possibly the
> error message should point to that doc.
> 
> We will of course have to revisit when this hits the wild and people
> start (or not) hitting this. But judging by past experience, if it is
> there, we will hit it. Murphy says so.
> 
> Thx.

We had recently a steady flush of bug reports about a WARN() in tpm_tis
driver, from all levels of involvement with the kernel. Even people who
don't know what kernel documentation is, got their message through.

When a WARN() triggers anywhere in the kernel, what people tend to do is
that they go to the distro bugzilla, and the issue is quickly escalated
to the corresponding maintainer.

So, what is the part missing from the equation that should be documented
to the kernel documentation. This not a counter argument per se, I just
don't fully understand what is the missing piece that should be put there.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

/Jarkko
