Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6C346765
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCWSQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhCWSQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:16:28 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C6BC061574;
        Tue, 23 Mar 2021 11:16:27 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0be100bd101061d9ae0c74.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e100:bd10:1061:d9ae:c74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D538E1EC0473;
        Tue, 23 Mar 2021 19:16:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616523385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iePXLvndSD6O7Oj0ifbLZzka9HW/C8jqIzCJv9pGzig=;
        b=iIsUCFuJGla7lnRj0q2C3lly12AQU9uVLSjb/6nJy3Ats3SpyV3f8dg/iKVNbEoYlP/A40
        bkB4KbXvLVp6Qwy+Z6/OHV/YrrbyWyuIPyhmo8fWdtjEAnsGcubBYyUvN5O1n6nlq+yA4S
        sL6kC/pQu7seCxvEv5FY7nyWTLPo4Is=
Date:   Tue, 23 Mar 2021 19:16:25 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <20210323181625.GD4729@zn.tnic>
References: <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
 <41dd6e78-5fe4-259e-cd0b-209de452a760@redhat.com>
 <YFofNRLPGpEWoKtH@google.com>
 <5d5eacef-b43b-529f-1425-0ec27b60e6ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5d5eacef-b43b-529f-1425-0ec27b60e6ad@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 06:06:19PM +0100, Paolo Bonzini wrote:
> Very much, and for me this also settles the question of documentation.
> Borislav or Kai, can you add it to the commit message?

Not only the commit message - that will become hard to find over time. I
believe Documentation/x86/sgx.rst is a good place to put the gist of it
in and refer to it in the warning message.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
