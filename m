Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F979415CED
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 13:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbhIWLjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 07:39:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238930AbhIWLjp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 07:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632397093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8izgnoQizDKC/tJ1PnUyIiHALQcaSL4hljiHYG7uKo=;
        b=c8qE/hVXK60CKrGys5zZsCE5Py1Cgtj6SOfP/HhZ2krwfYDp+7FSIJ8aM4pn88B91FmDTC
        fF4KgnbtTgMYjVOR8gyYa60WMO3yFwfjSSzMRmv21LlAXcaxDWw1bFC+iqfWVe4lXvgIeX
        l8Sy/H6SWfXobzSNpRYNijFw4Zw37Ds=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-vT2kdsUANYWkGZMm-vTpIA-1; Thu, 23 Sep 2021 07:38:12 -0400
X-MC-Unique: vT2kdsUANYWkGZMm-vTpIA-1
Received: by mail-ed1-f71.google.com with SMTP id r23-20020a50d697000000b003d824845066so6498221edi.8
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 04:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R8izgnoQizDKC/tJ1PnUyIiHALQcaSL4hljiHYG7uKo=;
        b=rqXKa/dINFm1q1MBGuU2cfookTFGCSGya7J6+3Gle6JgD7UEa0IS1nPkGCkv1XvqK4
         LDW5/GVwOvt6EPeZb7bySY9gEfneNrvix+NfSkLR25VJPvHg0Log6pirRvQyWD6+KXRB
         Y1SFhhm3/VWDRRXdU634CvtWauI7TCdInvvtchmWDVtkTFGwdWYBV/VOKMPRfmgQGZc2
         84lK/c07c8dZG4ASanvaLAyKMEn7kSophJTi9LllYFT/lACYwF6CKxdX/UAdWWg9hIaL
         3YBCAaUzntD/3fTKfzSUclsT+yTFFCIpE90tW7vI4LCo5sTcAFuWGtsoFNOT2sAbTNI1
         zOVw==
X-Gm-Message-State: AOAM5330zQS33obHQgHwI+I+mPvsWS1eDtqFIfDrsF+iH4GSav9sGqlq
        oCC98ItQcySTMPeZg3aVyokxo6kM4XfOVadwF8AUYFTnhwDEl+ZRMi3/gEC1EkTIVKnOU3z6J1n
        VTMWQPkXoxCv3
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr4377598ejg.132.1632397091223;
        Thu, 23 Sep 2021 04:38:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjqF0X0ovlhF/VZWay90g2e0L5U5dWggeMwHZrPc2ohg/VyksbDR/1iA7+yRKiLBbt3zzfcw==
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr4377566ejg.132.1632397090852;
        Thu, 23 Sep 2021 04:38:10 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id v21sm3207849edb.62.2021.09.23.04.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 04:38:10 -0700 (PDT)
Date:   Thu, 23 Sep 2021 13:38:08 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Daniele Ahmed <ahmeddan@amazon.com>,
        Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2] scripts: Add get_maintainer.pl
Message-ID: <20210923113808.wtegvmts7xvsid7r@gator.home>
References: <20210923112933.20476-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923112933.20476-1-graf@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 01:29:33PM +0200, Alexander Graf wrote:
> While we adopted the MAINTAINERS file in kvm-unit-tests, the tool to
> determine who to CC on patch submissions is still missing.
> 
> Copy Linux's version over and adjust it to work with and call out the
> kvm-unit-tests tree.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> 
> ---
> 
> v1 -> v2:
> 
>   - Remove Pengiun Chief logic
> ---
>  scripts/get_maintainer.pl | 2543 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 2543 insertions(+)
>  create mode 100755 scripts/get_maintainer.pl

You know a project is getting serious when it contains 2500 lines of perl.

Acked-by: Andrew Jones <drjones@redhat.com>

