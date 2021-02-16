Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9831CE11
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 17:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhBPQ3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 11:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhBPQ3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 11:29:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C66F964DAF;
        Tue, 16 Feb 2021 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613492930;
        bh=XM9oFKFsrmd7Ng/gs8fygyO2MLu/D7adod/GPL5WOF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vAzyS9EM/YGGAPT3VxnYxgAXvFfFRd0aDpu7Ofdk2aNtZlg7iEjZI3WvtIj4eJCk0
         i9bm6+hszA6EglQWIeBaW3OlgWZSDsw/xHjsLQaof0fC6G/ysMuZfvDfSZq2ayqo/J
         MaM9SYZUWHA1k5m0wVHXvUKZssZdcywj3UL2kRCl6YSqwx+NpALXPYtodA0cVUTagH
         tUwOpLyE7G2ryIZOqF1BlynZ4UBCe2+2M159P4Zm9pUs6HWsW9EaJ0iRXlkFfawMge
         J0UxE5pmjodCQccvVYEEHo9/L4RVbPzsrFfDAFeAzurC3xSPxwGgQWoY9jai67AwqC
         +huYGQW+BsxHw==
Date:   Tue, 16 Feb 2021 18:28:38 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <YCvytmBUO+j5t4zf@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
 <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216103218.GB10592@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 11:32:18AM +0100, Borislav Petkov wrote:
> On Tue, Feb 16, 2021 at 10:30:03AM +0000, Huang, Kai wrote:
> > Because those contents are *architectural*. They are defined in SDM.
> >
> > And patch 13 (x86/sgx: Add helpers to expose ECREATE and EINIT to KVM)
> > will introduce arch/x86/include/asm/sgx.h, where non-architectural
> > functions will be declared.
> 
> Who cares about the SDM?

I don't.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
