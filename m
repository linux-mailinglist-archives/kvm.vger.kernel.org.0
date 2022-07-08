Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E261956BAD7
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 15:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbiGHNbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 09:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238180AbiGHNbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 09:31:02 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271732ED41
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 06:31:01 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x184so10160933pfx.2
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 06:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=agmImm7M/e7knYeBADeaOmcU8r38h0Z30aSlpuIYjxU=;
        b=rlaoRUb7b/fi0yI2l5KeHsPs/EZ3lsYwF/bv1lIu4ZPZvmJFqplzQlx3c3agNHp3DE
         doW41t0gA0aIxjS4LIkoUzcBa622NQdSEIAkWo8tHCJYPEVkJtKgifdosMDijSDrDrEa
         PFAIvyiBZtwCwxvaXuvlNIccZWVBNOGgchoA0vY50KYbzKx6yL9/hLPndBZT28dsloIU
         9IeileIeiNAa9JskW508VNMhIukUs8tU63v6COkC3kYLRaOEu75h+9kcCXRL1prPBbwh
         WTyGZt+g5wIXgJ4oWE/RzeE0RRg29NY3mLUEnrZsnsIdylPEQdOL1pgM8pvkEB/UgSWs
         6HcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=agmImm7M/e7knYeBADeaOmcU8r38h0Z30aSlpuIYjxU=;
        b=XU3M4Ny/qI60x2QXjLbPFQ9+5SFcvgTgDxT+tt+kBPO29XLIfPxMwtoppxewn17wK0
         o5v+BLC8p7ZDNlXojyuNI+pudqXyiYCmZ2gJUW5KA2HabhRsSUky/Ahwtp27PQxXSXOU
         toQWjoOFZbB24AQcgICKTJheHmebUimh1BAfYyT1ROTDrjss8Yp3lRBo7VPa8VvdL9EC
         L/4f5vfc8Ypfx2264Z2XqQGmhwXofSs4oBYkrs+ZbFCfUWuUJJrecNLhB/ksp12cKYUD
         ZUDGCBVpjOwgfHQ4JLevD10DpA6Dfucyc4OblgjGUHVz82QaqObdTm3F408lcHnIdzc9
         NHrA==
X-Gm-Message-State: AJIora9u8LksBo+EDlXgUPa1BCJJJirYbzfA45JQuS/amHZFLC2h/Ncw
        nBmCBHUg+Mr1PnIxMJ/sXioaUQ==
X-Google-Smtp-Source: AGRyM1upwSFrCfIxNTP4nwK3Ju2pXSF0iht0K/vsLnPtfkyabxUn/zfIfAOWj334Dv/aJ5hCm7KLaQ==
X-Received: by 2002:a63:4756:0:b0:412:88b5:2a23 with SMTP id w22-20020a634756000000b0041288b52a23mr3334765pgk.442.1657287060587;
        Fri, 08 Jul 2022 06:31:00 -0700 (PDT)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id c20-20020a656754000000b003fcf1279c84sm27371159pgu.33.2022.07.08.06.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 06:30:59 -0700 (PDT)
Message-ID: <f2b51230-90b8-ecf0-8011-446e2f526bb4@ozlabs.ru>
Date:   Fri, 8 Jul 2022 23:32:58 +1000
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
        Nicholas Piggin <npiggin@gmail.com>
References: <20220707135552.3688927-1-aik@ozlabs.ru>
 <20220707151002.GB1705032@nvidia.com>
 <bb8f4c93-6cbc-0106-d4c1-1f3c0751fbba@ozlabs.ru>
 <bbe29694-66a3-275b-5a79-71237ad7388f@ozlabs.ru>
 <20220708115522.GD1705032@nvidia.com>
 <e24d91fb-3da9-d60a-3792-bca0fe550cc7@ozlabs.ru>
 <20220708131910.GA3744@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220708131910.GA3744@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/07/2022 23:19, Jason Gunthorpe wrote:
> On Fri, Jul 08, 2022 at 11:10:07PM +1000, Alexey Kardashevskiy wrote:
>>
>>
>> On 08/07/2022 21:55, Jason Gunthorpe wrote:
>>> On Fri, Jul 08, 2022 at 04:34:55PM +1000, Alexey Kardashevskiy wrote:
>>>
>>>> For now I'll add a comment in spapr_tce_iommu_attach_dev() that it is fine
>>>> to do nothing as tce_iommu_take_ownership() and
>>>> tce_iommu_take_ownership_ddw() take care of not having active DMA mappings.
>>>
>>> That will still cause a security problem because
>>> tce_iommu_take_ownership()/etc are called too late. This is the moment
>>> in the flow when the ownershift must change away from the DMA API that
>>> power implements and to VFIO, not later.
>>
>> It is getting better and better :)
>>
>> On POWERNV, at the boot time the platforms sets up PHBs, enables bypass,
>> creates groups and attaches devices. As for now attaching devices to the
>> default domain (which is BLOCKED) fails the not-being-use check as enabled
>> bypass means "everything is mapped for DMA". So at this point the default
>> domain has to be IOMMU_DOMAIN_IDENTITY or IOMMU_DOMAIN_UNMANAGED so later on
>> VFIO can move devices to IOMMU_DOMAIN_BLOCKED. Am I missing something?
> 
> For power the default domain should be NULL
> 
> NULL means that the platform is using the group to provide its DMA
> ops. IIRC this patch was already setup correctly to do this?
> 
> The transition from NULL to blocking must isolate the group so all DMA
> is blocked. blocking to NULL should re-estbalish platform DMA API
> control.
> 
> The default domain should be non-NULL when the normal dma-iommu stuff is
> providing the DMA API.
> 
> So, I think it is already setup properly, it is just the question of
> what to do when entering/leaving blocking mode.



Well, the patch calls iommu_probe_device() which calls 
iommu_alloc_default_domain() which creates IOMMU_DOMAIN_BLOCKED (==0) as 
nothing initialized iommu_def_domain_type. Need a different default type 
(and return NULL when IOMMU API tries creating this type)?



> 
> Jason

-- 
Alexey
