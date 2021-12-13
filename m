Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9CE4732EE
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240749AbhLMRam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbhLMRal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:30:41 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB88C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 09:30:41 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m24so11650099pls.10
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 09:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JLl9NBjWhC8ycFWNbwA1xe7cz0lo/vfYPVBrYSBn0zQ=;
        b=kHQfPRtJy95Q3BTzS0nITHh7PKHGRCYTW7MbSbqmRtJPWWv96ES5/2t3Nyx6lMjnL1
         NmKrHkpIG5YHkWb+py2doU5OzOS1Pjt1xdAKGaKT4KeEOfDq1koiO6J+/g7iIDe8tfy/
         Morf2+k56PdVNWRQA0ipFSu8z5LiVfu8tdNebySj/Osc0f5rVwqOmeBJFq1p2R5OgKIb
         +Gg9VdpL3GfYrozJQWFPRlavhlmhZ1BetwAuuXB74BS6rvqTCsGp6gNUf+cU70gQZYW+
         MbU/B7aNM+8fzfBFVyE3S5s1IMFd9HZW5PfsUxOrxYlKNFLOxjebCWfHS+QCsn46vfjd
         DT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLl9NBjWhC8ycFWNbwA1xe7cz0lo/vfYPVBrYSBn0zQ=;
        b=E4wj4klH39X1wHLeObXGQMoZZa1uKUH+4sh4Xv4mxKLGqDvD0axProOISJ0timdtEK
         48JP3U/PNn+UTcPX0jIe8QQeuURcwKAZDG+1bStEOIlF6dVg4yltnfYUd/5cK8rEQom7
         r4uzTpUufI6g7U+Pi0yFWhj/13+wl2CaybZRBazvT6g6bTp3nNAtsCLVW95xElglSemA
         cD+p/SguUU1gRgNqcqRFE5n9SbB9hlMe6AyGSwKTCo7GRiNhzUcDfOAKx7FurHAOSCYz
         7YMzfgRBSr0JF5coKXJ8JvMq88qgDMcJT5F8moPh0kvj2ElnpIDaL2fIwZH8zQ1n0FOi
         VMuA==
X-Gm-Message-State: AOAM5323qi60OUfd/nawPekAf1jH3W21oii3oHnJ41+lhD8ZB5uJoIPx
        JtszUArtAxCH3DvQm99nDhatBQ==
X-Google-Smtp-Source: ABdhPJyB2C91wLSzzIMpfR+iEbCKqIGvUxk0irgmd2CZCEZjmCAgPiOl9dvAamgDlWeyfWdcv2KWvw==
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr45572990pjb.62.1639416640628;
        Mon, 13 Dec 2021 09:30:40 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h8sm14368696pfh.10.2021.12.13.09.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 09:30:40 -0800 (PST)
Date:   Mon, 13 Dec 2021 17:30:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sachin Sant <sachinp@linux.vnet.ibm.com>
Cc:     kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org
Subject: Re: [next-20211210] Build break powerpc/kvm: unknown member wait
Message-ID: <YbeDPEx2/DgmZExK@google.com>
References: <496ECBB3-36F3-4F07-83B2-875F683BC446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496ECBB3-36F3-4F07-83B2-875F683BC446@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021, Sachin Sant wrote:
> next-20211210 ( commit ea922272cbe547) powerpc build fails due to following error:
> 
> arch/powerpc/kvm/book3s_hv.c: In function 'kvmhv_run_single_vcpu':
> arch/powerpc/kvm/book3s_hv.c:4591:27: error: 'struct kvm_vcpu' has no member named 'wait'
>    prepare_to_rcuwait(&vcpu->wait);
>                            ^~
> arch/powerpc/kvm/book3s_hv.c:4608:23: error: 'struct kvm_vcpu' has no member named 'wait'
>    finish_rcuwait(&vcpu->wait);
>                        ^~ 
> 
> commit 510958e997217: KVM: Force PPC to define its own rcuwait object 
> introduced the error. 

This is a silent merge conflict between the above commit in the KVM tree and
commit ecb6a7207f92 ("KVM: PPC: Book3S HV P9: Remove most of the vcore logic")
in the PPC tree.

I'll send a patch for the PPC tree that is resolves the issue and is a standalone
cleanup.
