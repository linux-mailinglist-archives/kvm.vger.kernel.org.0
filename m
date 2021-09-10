Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1BD4070AF
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 19:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhIJR4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 13:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhIJR4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 13:56:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1928C061756
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 10:55:27 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bg1so1619387plb.13
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 10:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=74br1N0NBz3VAESrVPeVqbSv4KpvlUpZC5wb7BVH5bM=;
        b=PoMBT5PzZXpKtCxjsX/Fld3niyqTFQTJjrnbjxl22WWNvHGWfD3bdB0IiukTT5/T2m
         U5lyc00oHBvpOWjq2DGox4Cctkd4i6lRb2SoWvoH5pcIQEfkorPNdRgbzBmfmntSWKXV
         7iX1e/se+bux8EjhtPtfZ79ou55zlTOSM8B4FbWY1tDIwbmFhmY5xq05r0kfOOBllEQ6
         PLrpL4zQM89JZ8dNbS/NiOFb7fXms/Tp39FzOijmzTOmvd09isUJ8+S6rEOt17UD+xsL
         XtrUs17yUp+CTl+sP2ZrsAb8C1wzaPBcc84g1KC0c8pL6nz+BZ+P4/VOTsSSlJzhwrwH
         8/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=74br1N0NBz3VAESrVPeVqbSv4KpvlUpZC5wb7BVH5bM=;
        b=2EC5GeqquwCWA3ZyuV5wHwhnzu2UPX9wmYoXkvM9fPon0iO3jPsVXO9wpYSnOtE4mT
         70QKysIjM4L4eruHAGTW+nboXIBiTjdffnR+43GOVOooVLzR9P6U/g1f2pD1yLkXetU/
         KG6UcmcIG6Zj0QC8oVWcx3T8+w+bUSQW9VpbIqpnPxITSB63PJ6+bWBN5Q+TJkzs32IL
         nOEiXu7UVZw2rQfXO9LVrUjguS79kEQqAU7xLKaWgGDoQVbeVgaVy75Z2IYTxodKnLzQ
         fXq5NDIZCw9vKbAAvkALQ33bDaHANJ0HypH7dBtV4IVd+lXFgn1gddHg1MEGACVwcMRS
         gOPw==
X-Gm-Message-State: AOAM533L2UTBnyCJ1H20MvZ1+OB4AdDYHQ7xVqsfp/F2xwPGHhzUpHA/
        9mCte9RGKCoT9Nn0dg/InhM5Pg==
X-Google-Smtp-Source: ABdhPJx+wMohUP/daiNsbnsj/P33eYsOJ6z7uBSLf55XZZ3IuD7jQEyqiAzTKGYWyEzS0McFfWHsVA==
X-Received: by 2002:a17:902:ea11:b0:13a:db38:cfcf with SMTP id s17-20020a170902ea1100b0013adb38cfcfmr4790469plg.3.1631296527096;
        Fri, 10 Sep 2021 10:55:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b17sm5635774pfo.98.2021.09.10.10.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:55:26 -0700 (PDT)
Date:   Fri, 10 Sep 2021 17:55:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, Tao Xu <tao3.xu@intel.com>,
        pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: VMX: Enable Notify VM exit
Message-ID: <YTucCk8cVVvES2mx@google.com>
References: <20210525051204.1480610-1-tao3.xu@intel.com>
 <YQRkBI9RFf6lbifZ@google.com>
 <b0c90258-3f68-57a2-664a-e20a6d251e45@intel.com>
 <YQgTPakbT+kCwMLP@google.com>
 <080602dc-f998-ec13-ddf9-42902aa477de@intel.com>
 <4079f0c9-e34c-c034-853a-b26908a58182@intel.com>
 <YTD7+v2t0dSZqVHF@google.com>
 <c7ff247a-0046-e461-09bf-bcf8b5d0f426@intel.com>
 <YTpW3M8Iyh8kLpyx@google.com>
 <ce2dfc44-d1cf-8d09-6a38-9befb6f65885@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce2dfc44-d1cf-8d09-6a38-9befb6f65885@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021, Xiaoyao Li wrote:
> On 9/10/2021 2:47 AM, Sean Christopherson wrote:
> > On Tue, Sep 07, 2021, Xiaoyao Li wrote:
> > > On 9/3/2021 12:29 AM, Sean Christopherson wrote:
> > > > > After syncing internally, we know that the internal threshold is not
> > > > > architectural but a model-specific value. It will be published in some place
> > > > > in future.
> > > > 
> > > > Any chance it will also be discoverable, e.g. via an MSR?
> > > 
> > > I also hope we can expose it via MSR. If not, we can maintain a table per
> > > FMS in KVM to get the internal threshold. However, per FMS info is not
> > > friendly to be virtualized (when we are going to enable the nested support).
> > 
> > Yeah, FMS is awful.  If the built-in buffer isn't discoverable, my vote is to
> > assume the worst, i.e. a built-in buffer of '0', and have the notify_window
> > param default to a safe value, e.g. 25k or maybe even 150k (to go above what the
> > hardware folks apparently deemed safe for SPR).  It's obviously not idea, but
> > it's better than playing FMS guessing games.
> > 
> > > I'll try to persuade internal to expose it via MSR, but I guarantee nothing.
> > 
> > ...
> > 
> > > > On a related topic, this needs tests.  One thought would be to stop unconditionally
> > > > intercepting #AC if NOTIFY_WINDOW is enabled, and then have the test set up the
> > > > infinite #AC vectoring scenario.
> > > > 
> > > 
> > > yes, we have already tested with this case with notify_window set to 0. No
> > > false positive.
> > 
> > Can you send a selftest or kvm-unit-test?
> > 
> 
> Actually we implement the attacking case of CVE-2015-5307 with
> kvm-unit-test, while manually disabling the intercept of #AC.
> 
> First, it requires modification of KVM that only posting the kvm-unit-test
> doesn't help.

It helps in that hacking KVM to disable #AC interception is a lot easier than
re-writing a test from scratch.

> Second, release the attacking case is not the correct action.

As in it's irresponsible to provide code that can be used to DoS a hypervisor?
The CVE is six years old, IMO security-through-obscurity is unnecessary at this
point.
