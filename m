Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1491A49D120
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243911AbiAZRsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbiAZRsN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:48:13 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D111C06173B
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:48:13 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d1so222032plh.10
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cNfxPUvWvaI1vHO/jmsIjiSEzNXExUCiFtH31cxBIdo=;
        b=LoqmHXH523JnCj+p+8Rc/S9F5Y06QO7Q0xw2slJ2Ei/D6SbNPbbHBQAMEnxOcutBHB
         Ju0IJZE4f2IWVpl2YW5W0bRsCRXRv5ANtlQf28JmbFRXOV5kbZY/4yUwqxOWbNHqKf+l
         lDbZZnOjZ08qpJVMISJiLzXgNjxUCG+yQhQ7K+aLI3qAWKv0i70R+zlADzFYVsICutYJ
         r2iPLS0593bUYMoURAqZxpeVu+m1XvDfZECG6CC6ifVRRXXg+keDo3vfkqieMtuaGX8E
         ifbtkzcQOeoVoQhzurv50K5samEA0tvwrl1DY5HO2RrhmkfavJJr0eB2WEHRl+BMVLzy
         m4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cNfxPUvWvaI1vHO/jmsIjiSEzNXExUCiFtH31cxBIdo=;
        b=V/6Ic4H+cBC5BD3SxEVypQu+MWHazeNcWmvs4v1ReQ3bn8/wI2e42l74jDB2OqFUtd
         9ScDwTjkTqW8g9xIIZUBK8Qn+zGYIcp138QjmRfceaJQS7zI0EELlAYtaeSCuIJHsgZw
         tQyn1gUx1324rZL0UH7yjb4t6MY09UGrc+8d2AxQP2L52Dbu7zCYLgqJmQwRFpOz9mGy
         0xO9R7ByL7cPQKFgG1kFAQbdybAIJ8/0hiNbfcSWzyrF9SbIIy0Ny9djXIMUMTzEFD0w
         mxgcp4oVpXIoCydCAKkc8uYlLtdET99xJYgE+QaSyj+FP0ehy+jxZu7+gOfntisMPk1+
         kwBw==
X-Gm-Message-State: AOAM531+c56CDQiL6mMhUdy0LZd1I2be7GmNr8DZHWMDiNbzbpdwbJ1Q
        RbL6+tUKIWvtMwtuEdFlwAK1Hw==
X-Google-Smtp-Source: ABdhPJxwsiEqrNgJNlq8u/NfwI/GMmXVNl3SBs8rnKUQWQw1WWtgCuYRSuQeqhARV4DBKFuSYR7tNQ==
X-Received: by 2002:a17:90a:ab91:: with SMTP id n17mr915pjq.238.1643219292505;
        Wed, 26 Jan 2022 09:48:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k12sm2822797pfc.107.2022.01.26.09.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:48:11 -0800 (PST)
Date:   Wed, 26 Jan 2022 17:48:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 0/3] KVM: x86: XSS and XCR0 fixes
Message-ID: <YfGJWNVuFYZ8kl2I@google.com>
References: <20220126172226.2298529-1-seanjc@google.com>
 <3e978189-4c9a-53c3-31e7-c8ac1c51af31@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e978189-4c9a-53c3-31e7-c8ac1c51af31@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Paolo Bonzini wrote:
> On 1/26/22 18:22, Sean Christopherson wrote:
> > For convenience, Like's patch split up and applied on top of Xiaoyao.
> > Tagged all for @stable, probably want to (retroactively?) get Xiaoyao's
> > patch tagged too?
> > Like Xu (2):
> >    KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS
> >    KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time
> > 
> > Xiaoyao Li (1):
> >    KVM: x86: Keep MSR_IA32_XSS unchanged for INIT
> > 
> >   arch/x86/kvm/x86.c | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > 
> > base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
> 
> Queued, though I'll note that I kinda disagree with the stable@ marking of
> patch 1 (and therefore with the patch order) as it has no effect in
> practice.

Hmm, that's not a given, is it?  E.g. the guest can configure XSS early on and
then expect the configured value to live across INIT-SIPI-SIPI.  I agree it's
highly unlikely for any guest to actually do that, but I don't like assuming all
guests will behave a certain way.
