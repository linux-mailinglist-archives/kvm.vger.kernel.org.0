Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2E73465E1
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCWRDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhCWRCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:02:50 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460FBC061763
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 10:02:50 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l76so253620pga.6
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 10:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ndoYppsutVe9wAfx1BDabw/4l2WnR7bXko0osmOYBwU=;
        b=OIKIT/y6gSqe2Cnk5qDFtFqcUKk3dlMgIKs/JNqqQrXTzAGj4jCBKtqNMmZ3gpmMA7
         koCpGE1L3LyuNSUcaG2YlBrZKxL9/4n/yiZAVRVp/InnNc/10yBWUoEX0k04NQfl6T2H
         VRhzhYtCYOk+W07tbtxyiM/mBpTj2ATZiTMTwiuPUyfyhkLPvE+IAP3q0+NxEmqUZJIZ
         4thJF93BgL4qPIeiQ+Z2qc3chfbNsvbMcgwhycJJzolwiqnvc4OGXVJhWwTimFWDW8ae
         QL00EPacqIL+3aDU22EZ+DX/xyFox8MPOKyMEsnHCoiz7QCdrb+XHM4EP4e0WMzSmLpB
         FNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ndoYppsutVe9wAfx1BDabw/4l2WnR7bXko0osmOYBwU=;
        b=THTUCl1NrM7mUT/OwGc+5bDicJQ4poa+zTDbwf4R8BOSz1Yx+mC/IwKpKecHHvLLcC
         mzD/577CQH6ubmHoheED0wIf2qxaWb4Ra5JybOEeSnbmqa07aeW5mtYd93PCUfCcSOKf
         tUYu7/sg5Zw5mb5PneuUxQx47bdj341fRclelTYMUVEUyGkXC4uUy8kd7XnrcR+4MCtV
         mQItpvqDslpQSqXy5GU7WC0brf42s7Ks7hIuZ/ZpU3ocOq/bMUodLE/YbvNGMvGpEFE5
         Z2W1s9x79EJtADBJ0KmWTUlQDvJnqKn7pWD3PeP+Xg1EN86Agtjrrg1h2XhyOgfEVDc9
         2GiA==
X-Gm-Message-State: AOAM533JXMqteTYhPVRZmVgaCgCmgxfICsUqH4o+2V0HwmYMpWvTDpZm
        0JY3mAcwVNCXpakry3445XB6Uw==
X-Google-Smtp-Source: ABdhPJwHWZyK5FMHigJVHSfxS3kAPRRK6LzWKYi9DS+twjjePYkh8ZTcr3ol8eh9A2GBzlLwoJGj/Q==
X-Received: by 2002:a05:6a00:2345:b029:20b:c007:f9a4 with SMTP id j5-20020a056a002345b029020bc007f9a4mr5708563pfj.42.1616518969617;
        Tue, 23 Mar 2021 10:02:49 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o9sm18628845pfh.47.2021.03.23.10.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 10:02:48 -0700 (PDT)
Date:   Tue, 23 Mar 2021 17:02:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFofNRLPGpEWoKtH@google.com>
References: <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
 <41dd6e78-5fe4-259e-cd0b-209de452a760@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41dd6e78-5fe4-259e-cd0b-209de452a760@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021, Paolo Bonzini wrote:
> On 23/03/21 17:06, Borislav Petkov wrote:
> > > Practically speaking, "basic" deployments of SGX VMs will be insulated from
> > > this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
> > > exhausted, new VMs will fail to launch, but existing VMs will continue to chug
> > > along with no ill effects....
> > 
> > Ok, so it sounds to me like*at*  *least*  there should be some writeup in
> > Documentation/ explaining to the user what to do when she sees such an
> > EREMOVE failure, perhaps the gist of this thread and then possibly the
> > error message should point to that doc.
> 
> That's important, but it's even more important *to developers* that the
> commit message spells out why this would be a kernel bug more often than
> not.  I for one do not understand it, and I suspect I'm not alone.
> 
> Maybe (optimistically) once we see that explanation we decide that the
> documentation is not important.  Sean, Kai, can you explain it?

Thought of a good analogy that can be used for the changelog and/or docs:

This is effectively a kernel use-after-free of EPC, and due to the way SGX works,
the bug is detected at freeing.  Rather than add the page back to the pool of
available EPC, the kernel intentionally leaks the page to avoid additional
errors in the future.

Does that help?
