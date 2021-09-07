Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB5402E49
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345874AbhIGSTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345809AbhIGSTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 14:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631038691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Y4ioFnJuisj2BTJf1/oHJdXHMcO8vnvhxc0AOo9EVM=;
        b=Zijclc+mTnRuNE+Gyunc+QeFW8I3l6/vepQPv62P6HLCKvRv0t6/LhC33QKg3LD9XOrU6n
        WOfWJqvZRYgNkfKAVv0yOAg7l8/FxdPUJ5a2/WE2O3EYbO4cYBLqvTaZPFVNsN2M9Xk6bG
        bE1/U3pBtROn7qrqASNRiFo7xUTc88w=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-eqLy5Qb8PdahlvPhGhe8Yw-1; Tue, 07 Sep 2021 14:18:09 -0400
X-MC-Unique: eqLy5Qb8PdahlvPhGhe8Yw-1
Received: by mail-ed1-f69.google.com with SMTP id ch11-20020a0564021bcb00b003c8021b61c4so5618528edb.23
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Y4ioFnJuisj2BTJf1/oHJdXHMcO8vnvhxc0AOo9EVM=;
        b=AQDgVLkPjcBRInijPRwdUX7uwH5V6ZzxC/BmZ97hs4zqT15wfsjWJXUHTvtNVvN5HG
         jYSVB7XjuOM0aLAWuAlMVj3nanWi+rMKC9VJSonmhx3bzXu1/GH1wWNOyt7bQ8ib6W8p
         IrzGlnHepPwfKwNUcOmeoYzkFsmIPEgzIzQfYMFQFWVQ2XXjNNpZoeDgQJxfnDnOUrUh
         z57TB+fKkYF91YQovmnAR6LvAzt3yh/xOG3j8WtQx1UroUl4//zj/lzsXiQ8Nx6vEERu
         7LS0R7IU83p4pTVesXRZZAZZ2P0YJBt+f79CJaJbr8WuIw31k+DIRgI+0tx02wTa/BFa
         DGOg==
X-Gm-Message-State: AOAM531DHeyuI05xPr1wFdHJ0mue6UI7PuKAhR2MzKdKFDhbgB7NKYL3
        zMEWP3C+NzkPAvVKic2PrxzXkZTDXCeVrNbgKzKnHpexJxnjzkqpbhJpBxwudO0yEhRFeUPZcWK
        guovnzWmG4pWz
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr844568edv.384.1631038688790;
        Tue, 07 Sep 2021 11:18:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2BAJqv2ikfIL9GSFYL9FGap4baDkbWIjl814C12RIpseaaxrMOITupVIIE6OrP+B3Y8wgKQ==
X-Received: by 2002:aa7:cd9a:: with SMTP id x26mr844557edv.384.1631038688652;
        Tue, 07 Sep 2021 11:18:08 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id be5sm6926257edb.57.2021.09.07.11.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 11:18:08 -0700 (PDT)
Date:   Tue, 7 Sep 2021 20:18:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v2 1/2] KVM: selftests: make memslot_perf_test arch
 independent
Message-ID: <20210907181806.wqlspjygukc574yz@gator.home>
References: <20210907180957.609966-1-ricarkol@google.com>
 <20210907180957.609966-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210907180957.609966-2-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 11:09:56AM -0700, Ricardo Koller wrote:
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need to know
> details like what kind of exit they generate on a specific arch.  More
> specifically, there is no need to check whether an exit is KVM_EXIT_IO
> in x86 for the host to know that the exit is ucall related, as
> get_ucall() already makes that check.
> 
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

