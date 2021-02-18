Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C14731EE3F
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhBRS07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhBRQP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 11:15:58 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C689C061786
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 08:15:18 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fy5so1614343pjb.5
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 08:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A+5Mc6ykPR3IfEGP3VJhjfuAa6Mt0cwNEOHk30v0jf0=;
        b=fB/FEapaxzigjjLl4zCOhSefLUVMNN8EIBtfR3LcJMrIBiN1ygW37Yp90vjur8e2l/
         Rr67H0uSayNyzQvc5iqeWMHIF97c3L4gAn/rpoljICsBWcQRri2t71UkFqDh5RxIWziF
         3szYWiawplZ+b9mPuUh/g5KKqNl2S5whlTKyQBFQwuz6yZ5dXXGh0yLJDFqEbdNa3Xdg
         2o7kwGpImm9612ADEZ93vAgOblfdr9d4hNfiwowyKvcY4/6kAGgGVa+5M+NLNJgy5lzE
         4lCrwXeniJcjgTaqVRxnIwZRC/pgETc51xEX+U7l7hgd55HHA5GtGGuud84uZu02j7fB
         2ypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A+5Mc6ykPR3IfEGP3VJhjfuAa6Mt0cwNEOHk30v0jf0=;
        b=pmzSH9sXSNLYlG4jeH59KN0DPKtAHMgLMHL/ycSuGJi3d48Q/oG3H//Gy7eQm38CBq
         /nrNvqqmVOMZ8NbVIzihSMvC2R6fVgsEqKOytNx7DxzkVC/Vb+LAgZnGpKIwiacI2ytK
         ii9s/PEvnWq3Ro+P9lyY5YT9YvLxpoTpt/EqXXXKQWwe2CMDVxZj9khMl2e9Fhg56jSw
         +mUjjFkSN1x9gCCKPRGOCbKrdMV4XOYivHCep7ChD6kSnQjHMdl0HNydMvCvv91IK54L
         tzz4YeS31r+jpinOxIQs2g4C0Y0TaEkwkmTHhJnaaFGHXwx1QgOYkBZ/YwQ9OqtuNwhD
         Fcbw==
X-Gm-Message-State: AOAM533tmb5VBt/XHf72MVXzIEabaJXUwZMx6u3f6Zz205325KhAB6X3
        42O+4qB70Z6y8ntw+RcdFP0GhQ==
X-Google-Smtp-Source: ABdhPJw7zrGsk3lH2nKUm+BUZrpwqWXxQ9G6LFBM6DAkMYfBsxP0EaJZZuH7PLr/Hwh8lSeUWEHqAw==
X-Received: by 2002:a17:90b:3886:: with SMTP id mu6mr4574793pjb.153.1613664917480;
        Thu, 18 Feb 2021 08:15:17 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id dw4sm6227643pjb.13.2021.02.18.08.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 08:15:16 -0800 (PST)
Date:   Thu, 18 Feb 2021 08:15:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Subject: Re: [PATCH 10/14] KVM: x86: Further clarify the logic and comments
 for toggling log dirty
Message-ID: <YC6SjgYTi+Dr1l0d@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
 <20210213005015.1651772-11-seanjc@google.com>
 <2d455c2e-1db4-5aff-45eb-529e68127fe7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d455c2e-1db4-5aff-45eb-529e68127fe7@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021, Paolo Bonzini wrote:
> On 13/02/21 01:50, Sean Christopherson wrote:
> > 
> > -	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
> > -	 * See comments below.
> > +	 * Nothing to do for RO slots (which can't be dirtied and can't be made
> > +	 * writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
> >  	 */
> >  	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
> >  		return;
> > +	/*
> > +	 * READONLY and non-flags changes were filtered out above, and the only
> > +	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
> > +	 * logging isn't being toggled on or off.
> > +	 */
> > +	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
> > +		return;
> > +
> 
> What about readonly -> readwrite changes?

Not allowed without first deleting the memslot.  See commit 75d61fbcf563 ("KVM:
set_memory_region: Disallow changing read-only attribute later").  RW->RO is
also not supported.

	if (!old.npages) {
		change = KVM_MR_CREATE;
		new.dirty_bitmap = NULL;
		memset(&new.arch, 0, sizeof(new.arch));
	} else { /* Modify an existing slot. */
		if ((new.userspace_addr != old.userspace_addr) ||
		    (new.npages != old.npages) ||
		    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
			return -EINVAL;

