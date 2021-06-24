Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A9D3B357F
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhFXSSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXSSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 14:18:54 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6151C061760
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:16:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso3992515pjp.5
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K1Vvz0R8sB1MrhAUrVKdo5XFWAZZznbutBePEdxRrcc=;
        b=PPx52G7la9rHzbW0oKjBSV8cFqiqBh8ceNwTpux5CfVJy4tDbvFX8DTmOrpKinapS/
         3Bkf0giuIUahiy6uDkKq3YV1GUNsSkqfonG6kfgxXBgFa7c3Ehp54EtZhAH7e1cesXvD
         3GzqZnbgU0Mo6FfIe9zIItJNXO6Hcvl41m2mOsBiVw6HPOuaPWXUI1xPNCcoTbFAa1zk
         7ldV0kfRYWEMGlYt49D7Rqx0mFd5bJHpFYfpByFFXyutCchOh9QjgBBIEujaWZM3xF6P
         nGnSJzDVsszCUBcIXO6aX+XpgOHpefLPGQDxWmUb7i5fyME+dut7bdG7MUM2MBe/7VRc
         wsyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K1Vvz0R8sB1MrhAUrVKdo5XFWAZZznbutBePEdxRrcc=;
        b=iZCYUr3JhX/2HuDsgBmDHlMynih+tL/bgJj/dkuCdRxCMOO8FdkjJwgl3hktKGdpSy
         0m4S9xL+ugs4+Y6aoApzvpFEJfiFQKJTfiY/FF40n+4C4e4UfI5Ex8LVsUW7TeOUyoHY
         14I/xIUev+BmbYFyY+QSegnKuVahZ3BvpgsXJB9m96nGtVJqMw8ULyKLoz617P+D0jiK
         nOJvM+o1iNuGZrDWCQfPOfiVqLT3i5hi5d8nTey9aU3wounWl2yREWAL0h6cJsaTDVio
         0H4FSo5deCqWF+jLpvghq/km/oXho/fpoA2P6h/blQueu+qkHTQmOrgxpVBwZQntBlYh
         qo6g==
X-Gm-Message-State: AOAM531euK0HcFQjRFr6dwi6JF00WqpjrC1FHFQez6oYuMWwMiG4Fciz
        jxzMUoGThamTopU3CuoDRhRQ2qIx4VsPXw==
X-Google-Smtp-Source: ABdhPJypc7+VJoyZZjM9cUFg2OnFuuDA/oB2WudbdSM2FTssommGI8IeGUJzr6p8LzWuKJ35pIL+WA==
X-Received: by 2002:a17:90a:8b0d:: with SMTP id y13mr6857385pjn.88.1624558592002;
        Thu, 24 Jun 2021 11:16:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j3sm3556497pfe.98.2021.06.24.11.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:16:31 -0700 (PDT)
Date:   Thu, 24 Jun 2021 18:16:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 05/12] nSVM: Remove NPT reserved bits
 tests (new one on the way)
Message-ID: <YNTL/Lq2pYrbq3EJ@google.com>
References: <20210622210047.3691840-1-seanjc@google.com>
 <20210622210047.3691840-6-seanjc@google.com>
 <2f1c2605-e588-2eea-d2c1-ab2f4fdc531d@redhat.com>
 <YNTESd1rtU6RDDP0@google.com>
 <6ae872e2-0de6-9c17-89df-ff29c43228d0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae872e2-0de6-9c17-89df-ff29c43228d0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 24, 2021, Paolo Bonzini wrote:
> On 24/06/21 19:43, Sean Christopherson wrote:
> > > 	./x86/run x86/svm.flat -smp 2 -cpu max,+svm -m 4g \
> > > 		-append 'npt_rw npt_rw_pfwalk'
> > Any chance you're running against an older KVM version?  The test passes if I
> > run against a build with my MMU pile on top of kvm/queue, but fails on a random
> > older KVM.
> 
> I'm running it against the current kvm/queue.

Huh.  Still passes for me on 292fedba687b ("Merge branch 'kvm-c-bit' into HEAD").
I'm running on AMD EPYC 7B12 / Rome, if that helps at all.
