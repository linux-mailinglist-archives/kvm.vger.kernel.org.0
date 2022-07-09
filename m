Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E59356C61B
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 04:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGIC4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 22:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGIC4I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 22:56:08 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FDF7AB39
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 19:56:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y18so291888plb.2
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 19:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Iu4+SfGnILNyrtOPbZlqTPcN6ioiSauG+G5Viw8UbkE=;
        b=4OHZPXkZ7ZnQosBhh/5M+GPXDZj6PxbiJq6JyMh4JF5j0T25k04I3XCtO2DGGzdzOM
         IjtUMhFqx1+X7jM7QYfThlkXu5EuH46KBixGz4l0EcrTXQA3zU550VcPk3174I5shRkT
         YWetdbuD9iAa9m6dg9yOvt9CuavyH4vxvfTz+IqkLDDh2g5Rn2VszNv9UMocSs0lb9KM
         4zvYKkiVFijqRWuZpxM8xYQx20ipNLODpr0PZv9HHnvgHR3Jn/kflZZ5HU2qbPzC52Z+
         jhyP5kWoKIu9dO0gXB95VIwD00G2E25B5yG50CQjIhBLVhe9AgoNrPplYIgxGRGf95RO
         5imw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iu4+SfGnILNyrtOPbZlqTPcN6ioiSauG+G5Viw8UbkE=;
        b=XV7wrIOWAtj1p/rMUem2KZYIxpX79RbnrASnoAHsr4N7xQQHBXgwZBMUTmxK5YF2aK
         nAkD3wtnC69+2FE3dBOCYK3OG0HzOFNOwiJMlCgx4uk4pbDZcGfYsrlF0/k6fPGNzjpV
         H91eF1nBu1hTBHF5sWshAPWsPb9uzP+6cew4viP2gpSv9BaQ0uv9EupTzw2aVmAKNM6m
         RsaRewbPhBoQ7njTmfSh+fGzxyn3Jl653QKQl0e4a9YZO4tzeJtU7ap44sk5ls6EMKkb
         r/GWk4HAnjQ2vtEgIBEUUkgYrI8r0qLKA8uq12M9HARWATxikjrSH31bgSOYe2DCU5Qy
         gW3A==
X-Gm-Message-State: AJIora9WDYRhaGH/pQHZ4Tx5RYjePsQ6UpJZLnvBo6mWEqPv/1CIcrtV
        vNuum6Nl0LXpKfL1sDqzVw9t9Q==
X-Google-Smtp-Source: AGRyM1sNAKGtQSl3OJK31+VZwzSz+l9+Khv93qto99rzXrd44U4TeqYhciXpTToLUGk4X2v1dM98ng==
X-Received: by 2002:a17:90b:3b43:b0:1ef:d89b:3454 with SMTP id ot3-20020a17090b3b4300b001efd89b3454mr3432246pjb.87.1657335365511;
        Fri, 08 Jul 2022 19:56:05 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id z24-20020aa79498000000b0052542cbff9dsm309688pfk.99.2022.07.08.19.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 19:56:04 -0700 (PDT)
Message-ID: <8329c51a-601e-0d93-41b4-2eb8524c9bcb@ozlabs.ru>
Date:   Sat, 9 Jul 2022 12:58:00 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH kernel] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linuxppc-dev@lists.ozlabs.org, Robin Murphy <robin.murphy@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Joerg Roedel <jroedel@suse.de>, Joel Stanley <joel@jms.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <20220708115522.GD1705032@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220708115522.GD1705032@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/07/2022 21:55, Jason Gunthorpe wrote:
> On Fri, Jul 08, 2022 at 04:34:55PM +1000, Alexey Kardashevskiy wrote:
> 
>> For now I'll add a comment in spapr_tce_iommu_attach_dev() that it is fine
>> to do nothing as tce_iommu_take_ownership() and
>> tce_iommu_take_ownership_ddw() take care of not having active DMA mappings.
> 
> That will still cause a security problem because
> tce_iommu_take_ownership()/etc are called too late. This is the moment
> in the flow when the ownershift must change away from the DMA API that
> power implements and to VFIO, not later.

Trying to do that.

vfio_group_set_container:
     iommu_group_claim_dma_owner
     driver->ops->attach_group

iommu_group_claim_dma_owner sets a domain to a group. Good. But it 
attaches devices, not groups. Bad.

driver->ops->attach_group on POWER attaches a group so VFIO claims 
ownership over a group, not devices. Underlying API 
(pnv_ioda2_take_ownership()) does not need to keep track of the state, 
it is one group, one ownership transfer, easy.


What is exactly the reason why iommu_group_claim_dma_owner() cannot stay 
inside Type1 (sorry if it was explained, I could have missed)?



Also, from another mail, you said iommu_alloc_default_domain() should 
fail on power but at least IOMMU_DOMAIN_BLOCKED must be supported, or 
the whole iommu_group_claim_dma_owner() thing falls apart.
And iommu_ops::domain_alloc() is not told if it is asked to create a 
default domain, it only takes a type.



-- 
Alexey
