Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D46739E499
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 18:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFGRAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 13:00:08 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:45020 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhFGRAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 13:00:07 -0400
Received: by mail-pj1-f45.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so420448pjq.3
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 09:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cMsZT5zKE7Lf53ne/OxHCuP0u91jCcIDQH5EV8YFGE0=;
        b=IZHdNs+ur7ut3ZUv87Wd541/vK/b/gq7FGmjeVJYDKNDzBQ2/t/ulGfgvj446oGxIb
         rFaLzjdkmrQhvv8SKPet13fsOxFrz0vvhuoRzuNqLJ6/7uAaHi2K3THsNjYWGl5GyeMf
         cyAULvTG2Z/Kl2L1kLbRv1oZoADLSn87cPyz/p7NtB1lI0gjsOIamnaMqCQ1W2uCh1s4
         p6drCWUmpyYVqxk1iOt1zrJ5axpYQkpT8kJa92cokMz2G7jgaj9cOR4oW4h7M+H6G+EB
         BoIeqK1iBpBPeohfxgReHGbv4eRnUQlo0WxR3T5agnVlo1CVvLxpWpplyXesyrTwtx9C
         1LJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cMsZT5zKE7Lf53ne/OxHCuP0u91jCcIDQH5EV8YFGE0=;
        b=hxKdKuNfmwK6gkDayzySbaH2SLa+d3oLLczl4rK1CmszWHMdUYLDMKd+1LRO774YHt
         h8dm7E4OkiqbXopMGmz7j1LrpS1tjm93hEo+BdKyhSPZDnR3cxLnnCXu94o6ZMezteyL
         euQDks5GFePFtgSKf3b0U+/A8NtUJDKABH3/35NkHBPSt+5ULAMni51pdTSL/Qz0FDFB
         +fRzm9f9+oc8VRBlUK4Ez1Yy7LQlMZip+i/6P/nSFRJvrt/wV+nvIip9ptFzSz5/Sd6f
         tGNFMngVhDg+VEWWzGtOpAfPGsKI0hKrwzaZ+ONW4QKuQwtgyJ3CXJvOqtFhYtWVkvXV
         dqXg==
X-Gm-Message-State: AOAM533uzxaO3WvqL5dsEXKi1LhMtCLiMI5KU6S0LJGRmyRSt9P6iAn/
        uGnSxr8E491NyVjgMEDJbcDaxQ==
X-Google-Smtp-Source: ABdhPJzNbGt0h4fAXPLjmNjb3atpTOnOk/5fD1cNXMVfYVBjFpEQn/NuP8ZLgcaz3nCrWIvY8iubXQ==
X-Received: by 2002:a17:90a:901:: with SMTP id n1mr116137pjn.44.1623085023134;
        Mon, 07 Jun 2021 09:57:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id a15sm8607897pff.128.2021.06.07.09.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 09:57:02 -0700 (PDT)
Date:   Mon, 7 Jun 2021 09:56:59 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YL5P28rvUcM3ohxx@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com>
 <YLqzI9THXBX2dWDE@google.com>
 <6d1f569a5260612eb0704e31655d168d@kernel.org>
 <YL5ETJatW+BM9vKS@google.com>
 <87mts1zlzc.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mts1zlzc.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 07, 2021 at 05:19:03PM +0100, Marc Zyngier wrote:
> On Mon, 07 Jun 2021 17:07:40 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Sun, Jun 06, 2021, Marc Zyngier wrote:
> > > This is becoming a bit messy. I'd rather drop the whole series from
> > > -next, and get something that doesn't break in the middle. Please
> > > resend the series tested on top of -rc4.
> > 
> > That'd be my preference too.  I almost asked if it could be (temporarily)
> > dropped, but I assumed the hashes in -next are intended to be stable.
> 
> I usually try and keep these commits stable.
> 
> But in this case, we end-up with a broken build at some point in the
> series. For such cases, I'm more than happy to drop the series and
> merge a clean version again (I keep each series on a separate branch
> for this exact purpose).

Thank you both. I will send a new series with the fix and Seans
suggestions (tested on the latest rc).

Apologies again for the mess.

Ricardo

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
