Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940653B2206
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFWUvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWUvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 16:51:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864F7C061756
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:49:13 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l11so2178055pji.5
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SJKphL8uOUhd6liKj++z6WVQVSyBvdXtPp4yiTiG0+g=;
        b=PQlAN3JA0b1xAhCl8OBNeH+zKs/l2VBcECbikSgi+dHCFDxLK38FY+HyXZlWyV9WSJ
         6iUUCqtAXH1tDO2QR6+HRti3vBJ652t6wv3q8fodPa8fXxb51+wDyxRiqteiPRE7Zmbj
         4f9dOegBimsVqOBfmTcOkyNAyv+7WsrwZVF6ps3PNoGYNHJVRmF5BuyQi1BCIGdJ3bwS
         JUNPwEG5a6No7TUYJbk2DYO2+jUGLRiJhSeMIQ6KXgjYrUoHKCta+fOxuFOFY4rd1XZr
         gWffZjGebFM+1ZcFHn0KS64hoa0gJCEofpLZexuss3hJT+Hx4zE40uzVBJ74eDjeCbdp
         l+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SJKphL8uOUhd6liKj++z6WVQVSyBvdXtPp4yiTiG0+g=;
        b=jC00WKoG9HItjOvK4Asdn0OCjYmBTFQ74AY15OGjohS7mRniZWiJMiaFBoKVSFSXv+
         4LBL4N7HXQfXjzrsRiumqIvQZ7ntWqeyAtmK0alzo6LrrlX2tWmO2fReR7RkYhu+5vma
         /Z0zE1veL9BNC/USZYMx0kWa4Go7Oxt5FjVxgjxDPGur7pEgD2T4sgU39DNGidMcowav
         GPBXkQROEtLO/m1fOwTA0LvQSRxN/K1hzp9p0WvDjTu2LF0kfc7sPY+88q7YC8/13mm2
         QmNCsGGxfbVVhPH6KFRKyopHsQyrOxTqPJwRU18jV7TsX4wTPMNZf6gRKU3M3NYgCWth
         VA+Q==
X-Gm-Message-State: AOAM531ssYU36PXtU2rtr+x3Tyxf7HMsp0SQIYhgBtCGkcn1iuwLMrap
        Rovu2X6AKUclFGyB65AubWTKcQ==
X-Google-Smtp-Source: ABdhPJy4bUIJIg5BnVOL2fOwy2ZwQLeXBKBMHJPepyjsPHZYqtQS6DHJVMfo3EBMLjG+fDeYdpwAOg==
X-Received: by 2002:a17:90a:694d:: with SMTP id j13mr1526258pjm.99.1624481352832;
        Wed, 23 Jun 2021 13:49:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oc9sm173802pjb.43.2021.06.23.13.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:49:12 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:49:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 15/54] KVM: nSVM: Add a comment to document why nNPT uses
 vmcb01, not vCPU state
Message-ID: <YNOeRCntGwh5QVz2@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-16-seanjc@google.com>
 <b759e31b-6269-a401-9fbb-49227b8be009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b759e31b-6269-a401-9fbb-49227b8be009@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:57, Sean Christopherson wrote:
> > +	/*
> > +	 * L1's CR4 and EFER are stuffed into vmcb01 by the caller.  Note, when
> > +	 * called via KVM_SET_NESTED_STATE, that state may_not_  match current
> > +	 * vCPU state.  CR0.WP is explicitly ignored, while CR0.PG is required.
> > +	 */
> 
> "stuffed into" doesn't really match reality of vmentry, though it works for
> KVM_SET_NESTED_STATE.  What about a more neutral "The NPT format depends on
> L1's CR4 and EFER, which is in vmcb01"?

Ah, true.  Works for me.
