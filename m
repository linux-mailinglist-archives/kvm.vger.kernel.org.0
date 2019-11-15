Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46FEDFDB75
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfKOKel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:34:41 -0500
Received: from mail.skyhub.de ([5.9.137.197]:46080 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfKOKel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:34:41 -0500
Received: from zn.tnic (p200300EC2F0CC3006D2B69FDD4279DE4.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:c300:6d2b:69fd:d427:9de4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C8A391EC0D09;
        Fri, 15 Nov 2019 11:34:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1573814079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=a9B35wF3gsxxqMQXD1ETi5MQJXf/8mWK2qZGuxNCwCQ=;
        b=rj46EbQQL5L7jy8/0T1PXvpRTOIcbgJJjoemvP6lq36tNcSb4ueOLTXXASlUy/ZGsa2LA6
        OWAY+7B/RePNpayREk9EhI/fiDYW+XiDU+bmLQi51eNsdIDWjrW3gkpQ+tzU/lZQiQlOcB
        lk1ejT8Di5AhD5H88/azPB/66koFlNQ=
Date:   Fri, 15 Nov 2019 11:34:34 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 06/16] x86/cpu: Clear VMX feature flag if VMX is not
 fully enabled
Message-ID: <20191115103434.GH18929@zn.tnic>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000836.1907-1-sean.j.christopherson@intel.com>
 <20191025163858.GF6483@zn.tnic>
 <20191114183238.GH24045@linux.intel.com>
 <5aacaba0-76e2-9824-ebd4-fa510bce712d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5aacaba0-76e2-9824-ebd4-fa510bce712d@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 11:05:24AM +0100, Paolo Bonzini wrote:
> On 14/11/19 19:32, Sean Christopherson wrote:
> >>> +			pr_err_once("x86/cpu: VMX disabled, IA32_FEATURE_CONTROL MSR unsupported\n");
> > 
> > My thought for having the print was to alert the user that something is
> > royally borked with their system.  There's nothing the user can do to fix
> > it per se, but it does indicate that either their hardware or the VMM
> > hosting their virtual machine is broken.  So maybe be more explicit about
> > it being a likely hardware/VMM issue?
> 
> Yes, good idea.

Yah, let's make sure it has some merit for users and doesn't make them
only shrug and ignore it.

Btw, Sean, are you sending a new version of this ontop of latest
tip/master or linux-next or so? I'd like to look at the rest of the bits
in detail.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
