Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF3A5607DA
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiF2Ryu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 13:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiF2Ryt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 13:54:49 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D412180E
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 10:54:48 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z16so7762820qkj.7
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 10:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1fsl8to06dogIPqUQjmSvbiVa6q0GzvolownxJAZN2o=;
        b=jmFVNkgq0O81qfLOajkc6SLpytRvNa3u/VcTc09RKl+SDNfWua4GjSHs5vRkwJQPps
         EtfEqGSzxQ1iGfThunfK1OHQu+iP+4vD+sTQBecS1fM6IXFQZRE43q8kk5/puKiCgSn9
         wA5ES2MLczklmjIYC/LaM8+piOb33PKGUQ1GkfRI0Hwav1pC7EFr45grNIRiane9T/UM
         5HwIj6ks3hoFw/sU0v7VuIJsq9s7ODXli3cWoHVnjP1hGkvWX1ZpBlmkfpiMLeZKxuHc
         PFIPjc51fUIe9IJ5atTBsELiYbQdPh56dy8GjXz0k1Izasu8A0wBwcmdCQunv9hT2mtg
         Ckwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1fsl8to06dogIPqUQjmSvbiVa6q0GzvolownxJAZN2o=;
        b=XEskpYeBKmB+4yVttGSCYxZWfj0LB5tqS9220gL0BNBege3tSmyzIiqWqEinNeOg9h
         mqzyJu5Q7r89tXXUPSWqiNwOlb0J/CmF4ukjNtKc+gKqPiy5bO/qb4NI+wCTCGc2+pb7
         ID5BZlTmFoE5CLqoWnt1IzcghCYrl4AkTNZnRhhn+fRwlztC6NeXy76TRhFq5b6cnOK0
         Vop5TA711L9vHvIF8MNrb70tVC3lvYHffzb8aLTSjEpBKRlHh9AFZPotkQj9zBSIfFby
         RP9SP2AA0d1NRK+5JElAjkGI4dRm/TE3RgRoyWy9AbYqLamzKeTvWvRza7Rg01aCwkDk
         YvNw==
X-Gm-Message-State: AJIora9le42TeYO1Yn1+F2/vTUfWK90DpKtyzZ8GJ1VB0I6ARpRaO/bH
        RK8LqR6uY3N4D7oSRujUhnqO5tRDGWEt/Q==
X-Google-Smtp-Source: AGRyM1s3giy4qA8reYkPdnnUv03x6Kvxir+MsCRluYDAZYS7sfECqklFOO+ac87j7/NQTnAgVwjSkQ==
X-Received: by 2002:a05:620a:4451:b0:6ae:fd29:149d with SMTP id w17-20020a05620a445100b006aefd29149dmr3115223qkp.724.1656525287652;
        Wed, 29 Jun 2022 10:54:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u16-20020a05620a431000b006a7284e5741sm13625849qko.54.2022.06.29.10.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:54:47 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o6btm-003b76-By; Wed, 29 Jun 2022 14:54:46 -0300
Date:   Wed, 29 Jun 2022 14:54:46 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: check iommu_group_set_name() return value
Message-ID: <20220629175446.GT23621@ziepe.ca>
References: <20220625114239.9301-1-zhiguangni01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625114239.9301-1-zhiguangni01@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 25, 2022 at 07:42:39PM +0800, Liam Ni wrote:
> As iommu_group_set_name() can fail,we should check the return value.
> 
> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> ---
>  drivers/vfio/vfio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

I prefer this - but notice it is not a bug because if
iommu_group_set_name() fails then iommu_group_add_device() will return
-ENOMEM.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
