Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871163FFFB2
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 14:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349210AbhICMZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 08:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347765AbhICMZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 08:25:21 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0F7C061757
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 05:24:21 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id bn14so2994040qvb.12
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 05:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AjVVv2ndb2u5Bt4uUF9TlcBGvkr2yBKHs0BYvFEiwhM=;
        b=gGIslmjuvjmkuQE+MEw2D09EW4vDOuMlNxsSM/ktZ1WBAGN0rCOgOC0WBF8Pk+FMaE
         7i1joaB5gBAmJUqpqz9IMmHXWUaSQ+HttFLCkX4i/TTtxUI1WCJ+bIIbMTZoKG1P1PVP
         rRp5XhWoUPlhKABNFH+Z1T5wARWdSGlN0tqqXO84rUiWuaMeUFfgB8WQxzx0Lng+HFEw
         +hy0WhoOTknyTagvlH2TBDMgG5qEz2hTr3ob4IxVCA951tzGMvUJjg+muXTKr/02rEIS
         1Ydj6mmRRXAbe5t23lTGLiPPIzkKfPXKKTl94e4F7ZES4BTQdhObBaI+dHC5c2Vz/ysO
         15LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AjVVv2ndb2u5Bt4uUF9TlcBGvkr2yBKHs0BYvFEiwhM=;
        b=FJHYVRTCZ0Is8lcqQaGR2v+UCV5yun7MXrJkaqKcUsZxr60oYB56V5ByATVw9nlhCO
         mg12zql77WEQb+H1nc8K9PTLmX1La2w3IenyLCrB8UOjYcEqsX1dBTJ+Aoyx9m0dav+O
         r+7gOOZcSZthpjvvEqCvRu3DF2kM1bB2gyBzDY2y/3r+BBmbRnFiUGI14TwpkjY5Wg2j
         se8ABefreGRI87AgH2NlzmNDvIzaxej+rhTuEm6tC8ry/gYsp+X7IlAe8xRYMmhP2+k/
         HHP5v6HfQNsS83XOvS8KzjyW3q/6+/RdU4zl8ukzzXvD73O2WJmr0wsw3ZOTzcPtKGY7
         QFug==
X-Gm-Message-State: AOAM5332H31OPHLcNwOpskbOwHRk2gHKqbUU5il/oWdWmPSMUR9xU5sm
        sm8HbUaGWheFSr6hhkcXuXcQqw==
X-Google-Smtp-Source: ABdhPJx0ZRB4N7U15Yq2f7MIxv4JxXW05wcJNeaYCXXvbjwj/xN2sCap7XlcXbOyT6yjd1yWliCKqA==
X-Received: by 2002:a05:6214:21cc:: with SMTP id d12mr3132616qvh.22.1630671860349;
        Fri, 03 Sep 2021 05:24:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id c15sm3703514qka.46.2021.09.03.05.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 05:24:19 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mM8F0-00Agea-T2; Fri, 03 Sep 2021 09:24:18 -0300
Date:   Fri, 3 Sep 2021 09:24:18 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Colin King <colin.king@canonical.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] vfio/pci: add missing identifier name in argument
 of function prototype
Message-ID: <20210903122418.GU1200268@ziepe.ca>
References: <20210902212631.54260-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902212631.54260-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021 at 10:26:31PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The function prototype is missing an identifier name. Add one.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It seems fine, but is there a reason to just pick this one case and
not clean the whole subsystem?

Eg i see a couple more cases in the headers

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
