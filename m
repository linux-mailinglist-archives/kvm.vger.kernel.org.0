Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9633A1B0E
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 18:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhFIQg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 12:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbhFIQg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 12:36:27 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5564C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 09:34:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso1744860pjb.0
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 09:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2fp6Uuy6GSNvKepEDgRuQTao6to9O/zWUvKaMxtTuY4=;
        b=rJAYvImo8GqMKS2I8qxEWb0cR3WmfDKnRVZfann15BrfdcD6zdhw/QtCxha2yCBB1K
         Tw6UKVWjwwhuX+WrgIQ7xeIzzGUTB/i6Awd4KjcATD0X5NDYiSJvPTERk/sz2ohI53ey
         A7g++W3uHNTg+RjpJzLRBNbaAdvGsNNFTpDxxu861jwv5HjOYgWGdDTIjiOOcH/t1KBt
         Z0Hgx273qBsfsqSon4qwp3PlO/g6dvElYapSdkzlyDU0WUoaOL79zEWz4KZmzU7k7wZJ
         DSoU7Z3L2Z15lU0+ioJ5hkCEuKofiOyyL+HcdZq+DP5AQDWMEj9lUgaRox/tBZDtjbR4
         nMIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2fp6Uuy6GSNvKepEDgRuQTao6to9O/zWUvKaMxtTuY4=;
        b=Vcbz6hax16ThdZyrlGGUVsEUL9lrgw6GGEBj4QI9wAodIivMuLTmtd9QeIxgXT5fWF
         WPnuaM6XRZWD5+7cJ4hxMwdSoH6EeiKmgj21j50W6KaWPH/QD10n4drDKHpo/GnjIrYt
         iXeTCcr+9ybahDiA63wXAAWw3o1LO3lXTqnag+e+nhHPlKeMFf6mextHcFwjSfL1V8KK
         OFFCA9/1bvtfe2uJLMhlVqU7rNPC9hE03HmJ9aKHWA3ddRysfPjFbIq3HK+Lhsxs9ky8
         kK6LPDO2/UXI3wJcmD2Su+kNWraOloriUpzvdWtulpkHZ40yV3sl6/ERK1EdD7TUFoBg
         Bt0g==
X-Gm-Message-State: AOAM533ib/BtKiESLIlZCgtj0vqg4Yq/N0511xlygo4WJH5ktNJMHkki
        XMDzGyab71p7OA2b0mRd9bKoMFwlqcBb3g==
X-Google-Smtp-Source: ABdhPJxF8FSKckqpsOMeQdDomw9GOa31eWHF4SWhPDbbAhjn+xUSXWde5Q9m3XV7BCG2Toi7HDfqNg==
X-Received: by 2002:a17:902:6b8c:b029:ea:f54f:c330 with SMTP id p12-20020a1709026b8cb02900eaf54fc330mr458980plk.10.1623256472218;
        Wed, 09 Jun 2021 09:34:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f15sm316396pgg.23.2021.06.09.09.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:34:31 -0700 (PDT)
Date:   Wed, 9 Jun 2021 16:34:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YMDtk/Xyf/7wpIxx@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com>
 <YL/q/IJ41gO6kTIF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL/q/IJ41gO6kTIF@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021, Ricardo Koller wrote:
> On Fri, Jun 04, 2021 at 09:26:54PM +0000, Sean Christopherson wrote:
> > The multiple layers of routing is also confusing and a bit hard to wade through
> > for the uninitiated.  The whole thing can be made more straightfoward by doing
> > away with the intermediate routing, whacking ~50 lines of code in the process.
> > E.g. (definitely not functional code):
> 
> This works but it would remove the ability to replace the default sync
> handler with something else, like a handler that can cover all possible
> ec values. In this case we would have to call
> vm_install_exception_handler_ec 64 times.  On the other hand, the tests that
> we are planning don't seem to need it, so I will move on with the suggestion.

My objection to layering handlers is that it introduces ambiguity regarding
ordering and override functionality, e.g. if a test overrides both the "default"
handler and a specific exception handler, which handler will be invoked?  My
expectation would be that the more specific override would win, but someone else
might expect that overriding the default would win.

It should be relatively easy to provide helpers to override the handler for
multiple/all exceptions if we do end up with tests that want that functionality. 
But yeah, definitely a future problem :-)
