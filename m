Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27904494508
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 01:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345476AbiATAqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 19:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiATAqJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 19:46:09 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F43CC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:46:09 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h13so3244213plf.2
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 16:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z1+U22Ey9LHJyAQychC6fcENsG+quV5jEHyAx5BylAw=;
        b=Bz0p8Zcp6TiQdxq+B7pfMnQ2uWc+Gwc7mIbxWuImGZ2IqYsA/+ua/R++MjT+bHOoYI
         alnQCi7yjl2wdnfo0WbFHLIcr4zLyV41sEiSwiqHjZXc2iilfficow6CsHu6tyxHgzgL
         kz3gskljZcQbzmPAB/E9Wq+ghCCL66hYLG0HXFqh4nEPnSateGWMQbC038uVQJ8AZXUP
         dKG8L5M0sX7qICEx1sogWejAvaeb6RnP2C5cN7AtvHwL0DFNBdUbf6y0/wpSDYussPJV
         S0af1oWoleTyG2Oc5FRml51gDGA6CJwbqbnNd1ikJ9G5G9ttFaD9UApTqIozc8tW8u9J
         wQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z1+U22Ey9LHJyAQychC6fcENsG+quV5jEHyAx5BylAw=;
        b=uhhGf9+L5wj8yZt+7z0FP1diG9Ng5nMryFEKU3tQIJhm3k9QL0AyS5Y/zC0fNaOTMC
         XGniy3MLAE4l19bY4480KCoHl23YNQxoNq32WsFWfhWU/nqlHmW2BxPmHIIaczfk7Cs6
         s+WaTki/jpfOuX/n3rQBOCN4CqT3HRNj2tUD1KymUHiHrB80cuCMo6A/l1aQMhJd4oYN
         KE5K/BCGUSzg4tZzLYGhc/s3fqrgGCTjM7u7OUmKPSEkLhduCmAZ9Eif2EGUQ6aH62Fq
         uQsrm2nyDT/ala+U72LwGsaVX3MElg/eYbB4JbyV1XTWpRtoqv6iZbT7EKOujLdBfRX9
         uIlw==
X-Gm-Message-State: AOAM5306zPvdDTRj2wWqqToJdLrNPoZMkJgIs0k9n9cfBI4+3DhkmraR
        HdoeA3EXmtdQ2X0Hnpx0KcaFhQ==
X-Google-Smtp-Source: ABdhPJxagGHiAunUi3cXKfBOcqeiMDzVCT/4wqGdFgLfzK2Qdj6qmm+STb8BuYXMNDY/gFtl4KfFEg==
X-Received: by 2002:a17:902:e84e:b0:14a:f05f:5897 with SMTP id t14-20020a170902e84e00b0014af05f5897mr6063562plg.108.1642639568765;
        Wed, 19 Jan 2022 16:46:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g7sm412266pjk.37.2022.01.19.16.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 16:46:08 -0800 (PST)
Date:   Thu, 20 Jan 2022 00:46:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [kvm-unit-tests PATCH v2 3/4] x86: Add a test framework for
 nested_vmx_reflect_vmexit() testing
Message-ID: <YeiwzMT/7AQcJsvd@google.com>
References: <20211214011823.3277011-1-aaronlewis@google.com>
 <20211214011823.3277011-4-aaronlewis@google.com>
 <Yd8+n+/2GCZtIhaB@google.com>
 <CAAAPnDG+eoE42se67ZFaeBG7H6QeAwx2LpZuVqKuXL_eY4eq=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAPnDG+eoE42se67ZFaeBG7H6QeAwx2LpZuVqKuXL_eY4eq=g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022, Aaron Lewis wrote:
> >
> > > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > > index 9fcdcae..0353b69 100644
> > > --- a/x86/unittests.cfg
> > > +++ b/x86/unittests.cfg
> > > @@ -368,6 +368,13 @@ arch = x86_64
> > >  groups = vmx nested_exception
> > >  check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
> > >
> > > +[vmx_exception_test]
> > > +file = vmx.flat
> > > +extra_params = -cpu max,+vmx -append vmx_exception_test
> > > +arch = x86_64
> > > +groups = vmx nested_exception
> > > +timeout = 10
> >
> > Why add a new test case instead of folding this into "vmx"?  It's quite speedy.
> > The "vmx" bucket definitely needs some cleanup, but I don't thinking adding a bunch
> > of one-off tests is the way forward.
> >
> 
> I'm not sure I follow.  The test does run in the "vmx" bucket
> AFAICT... Oh, do you mean it should be added to the extra_params here
> along with the other tests?

Yep, exactly.  "vmx" really needs to be split up and/or reworked so that it's
command line isn't so ridiculous, but that's a future problem.
