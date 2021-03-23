Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A309F346465
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhCWQG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:06:26 -0400
Received: from mail.skyhub.de ([5.9.137.197]:48220 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233070AbhCWQGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:06:07 -0400
Received: from zn.tnic (p200300ec2f0be1003a038ae7f2775171.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e100:3a03:8ae7:f277:5171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 28E761EC0473;
        Tue, 23 Mar 2021 17:06:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616515566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=48Tq1KSF9gZcQwrvYVZ/vG/u92KavUsXm8/JdQcuEFA=;
        b=E6+BXLlwX95o8DPfZtqpE5xuogIXh7IFHVRS/iJ5MepQ5UgpS8qeGzvpW2wzXUI3Wv7wVf
        9F7NsGzVlj/TfznJN4GIdD8yN0RNP5dQoiasQWwEJVdCYoyp/4n2SXFENQULvxTZpVK2OL
        tcruxzJ/FdpMsm1q8MHbxO87YVdfTfg=
Date:   Tue, 23 Mar 2021 17:06:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210323160604.GB4729@zn.tnic>
References: <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
 <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFoNCvBYS2lIYjjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 03:45:14PM +0000, Sean Christopherson wrote:
> Practically speaking, "basic" deployments of SGX VMs will be insulated from
> this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
> exhausted, new VMs will fail to launch, but existing VMs will continue to chug
> along with no ill effects....

Ok, so it sounds to me like *at* *least* there should be some writeup in
Documentation/ explaining to the user what to do when she sees such an
EREMOVE failure, perhaps the gist of this thread and then possibly the
error message should point to that doc.

We will of course have to revisit when this hits the wild and people
start (or not) hitting this. But judging by past experience, if it is
there, we will hit it. Murphy says so.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
