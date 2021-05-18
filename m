Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD210387A77
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 15:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbhERNz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 09:55:58 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34604 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244964AbhERNzz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 09:55:55 -0400
Received: from zn.tnic (p200300ec2f0ae2009a42d70f2967689e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e200:9a42:d70f:2967:689e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 029101EC050D;
        Tue, 18 May 2021 15:54:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621346075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=u4eUluMRW6ql/XQGfzXi2XvOmvNCHQYvmwNvCKSF5go=;
        b=e4A7xV00ipPerZAZZnidO8rIuXqQAptdKeIWdGsdBGFlbifHKflSDj18yhEkxz5tzO+PDh
        4JCIEWF9hMQr7Ebg7T+hLJoF1fiWWp2E5XBV16Yf7wJdzih/Y46+1BBVmcE5SKS6PhaTm2
        DnZf9es6K4iwVxQ/NKStQkq1+QF5TBk=
Date:   Tue, 18 May 2021 15:54:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 06/20] x86/sev: Define SNP guest request NAE
 events
Message-ID: <YKPHFXR+3t1HM38S@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-7-brijesh.singh@amd.com>
 <YKOaxBBAB/BJZmbY@zn.tnic>
 <d6736f33-721d-cbe5-eda2-eab7730db962@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6736f33-721d-cbe5-eda2-eab7730db962@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021 at 08:42:44AM -0500, Brijesh Singh wrote:
> This VMGEXIT is optional and is available only when the SNP feature is
> advertised through HV_FEATURE VMGEXIT. The GHCB specification spells it
> with the "SNP" prefix" to distinguish it from others. The other
> "VMGEXIT's" defined in this file are available for both the SNP and ES
> guests, so we don't need any prefixes.

Sure but are there any other VMGEXIT guest requests besides those two?
If not, then they're unique so we can just as well drop the SNP prefix.
Bottom line is, I'd like the code to be short and readable at a glance.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
