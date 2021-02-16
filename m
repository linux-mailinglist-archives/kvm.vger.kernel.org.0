Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169BB31C8DF
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 11:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBPKdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 05:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBPKdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 05:33:01 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35637C06174A;
        Tue, 16 Feb 2021 02:32:21 -0800 (PST)
Received: from zn.tnic (p200300ec2f07cd0057261f4475df3a88.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:cd00:5726:1f44:75df:3a88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C46F01EC00F4;
        Tue, 16 Feb 2021 11:32:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613471539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=taujXJ9IVmPIpWmt0Yydj0ss/bNTkZSZhLwAF1A5sbY=;
        b=JK22ntLsPycUePc+z7w8QIeoZfHUyJs7dOHnrO7gKQp5fwOM7B+nBDoWgTnrQLfwgRAUy0
        uuVyssvlC2QK1Zzz7ieJic1BnkWCIX6cdu045o09e6wqm/WnmqTlEw/c20FYxjGZghMpid
        uEh9DHV8rERXOHvyuqKU52aSVchVbLk=
Date:   Tue, 16 Feb 2021 11:32:18 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
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
Message-ID: <20210216103218.GB10592@zn.tnic>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
 <cdc73d737d634e778de4c691ca4fd080@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cdc73d737d634e778de4c691ca4fd080@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 10:30:03AM +0000, Huang, Kai wrote:
> Because those contents are *architectural*. They are defined in SDM.
>
> And patch 13 (x86/sgx: Add helpers to expose ECREATE and EINIT to KVM)
> will introduce arch/x86/include/asm/sgx.h, where non-architectural
> functions will be declared.

Who cares about the SDM?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
