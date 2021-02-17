Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006C631E1FD
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 23:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhBQWVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 17:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:32968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233536AbhBQWV2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 17:21:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E83F64DFF;
        Wed, 17 Feb 2021 22:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613600447;
        bh=UYGkLLRxSgCWyallw/00M7Zbt1lN5wnAZcPj6AvPTOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rGmSqnJ/bgYlkbI/Nmb7BAnQfb6kbXWq1IKVGBxApOBZIzYYV9BnhtJM+c8auLnAo
         d1ZuikagYjN7DiHixRNG9hk9SCxBPY0tUPjG0vJZWW/4ZJDLBHP7KMFyUqCMFEm/pr
         79XXezqfmnzDtMt5fApn4S8fVtPJnx5BauXXMhNTH7+neaPO4GYIUANSVsOx07mIbO
         MRlOLLkEW4gU7DIYnWxrBnzu2C/XYj5DMOiiE+Q4YxySKFjuZJXGC3crocw3mvQvqG
         r4GJBDf0CPUjQIGI1NfWzzW7wzVlKnEmNdtj+TGoabHBb5n0o7jbjL+ri7g0B4iBip
         O5SyPnjspi2UQ==
Date:   Thu, 18 Feb 2021 00:20:35 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <YC2Ws68oxi3hizrG@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
 <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic>
 <a792bf6271da4fddb537085845cf868f@intel.com>
 <20210216114851.GD10592@zn.tnic>
 <9dca76b9-a0f9-a7aa-5d85-f8b43f89a3d2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dca76b9-a0f9-a7aa-5d85-f8b43f89a3d2@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 07:18:27AM -0800, Dave Hansen wrote:
> On 2/16/21 3:48 AM, Borislav Petkov wrote:
> > What I'm trying to point you at is, to not give some artificial reasons
> > why the headers should be separate - artificial as the SDM says it
> > is architectural and so on - but give a reason from software design
> > perspective why the separation is needed: better build times, less
> > symbols exposed to modules, blabla and so on.
> 
> I think I actually suggested this sgx_arch.h split for SGX in the first
> place.
> 
> I was reading the patches and I had a really hard time separating the
> hardware and software structures.  There would be a 'struct sgx_foo {}'
> and some chit chat about what it did...  and I still had no idea if it
> was an architectural structure or not.
> 
> This way, it's 100% crystal clear what Linux is defining and what the
> hardware defines from the diff context.

Let's worry about split later on when we add "big" SGX specific
features like EDMM, and consider this more like "move and rename".

/Jarkko
