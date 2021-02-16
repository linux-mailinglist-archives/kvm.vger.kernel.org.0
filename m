Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8215F31D0DA
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 20:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhBPTTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 14:19:44 -0500
Received: from mail.skyhub.de ([5.9.137.197]:49528 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhBPTT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 14:19:29 -0500
Received: from zn.tnic (p200300ec2f07cd005a29834948e41e58.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:cd00:5a29:8349:48e4:1e58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1A8421EC026D;
        Tue, 16 Feb 2021 20:18:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613503128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LirkGUTDtrfE2EUpkZxgMtdWuNSxswNCfjqbDnlkDmg=;
        b=ECe+M8jtGj8U7AQs41e7hepvU4gF+c02vsBlCVfWzyvJqB4ZT61tz+P/5rZp0zVe3STEI3
        E09UFGOWJEluH5YKx01/jHJh9an7JD/pC38qP9Rwj+32nlmmURRlVNiIs6du5m0jxI+/Ug
        Jy5XHVqNyeMQcoRW3357Bn2HVPEdqO8=
Date:   Tue, 16 Feb 2021 20:18:47 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
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
Message-ID: <20210216191847.GF10592@zn.tnic>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
 <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic>
 <a792bf6271da4fddb537085845cf868f@intel.com>
 <20210216114851.GD10592@zn.tnic>
 <9dca76b9-a0f9-a7aa-5d85-f8b43f89a3d2@intel.com>
 <20210216184718.GE10592@zn.tnic>
 <b3966341-b777-fb89-e2f2-7aa4735cb28a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b3966341-b777-fb89-e2f2-7aa4735cb28a@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 10:53:03AM -0800, Dave Hansen wrote:
> Fine with me. It's just as easy to miss this comment as is would be to
> miss the comment at the top of sgx_arch.h. :)

Sure but SGX should try to keep it together and not plant headers
everywhere. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
