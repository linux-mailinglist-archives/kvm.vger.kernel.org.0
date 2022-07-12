Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C26657102C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 04:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGLC13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 22:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGLC12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 22:27:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFFF7358C
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 19:27:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q5so6024813plr.11
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 19:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aZB3UGhgPcDW1xV3kcl8kwXBo405C0t8FD0AZJD9BPE=;
        b=FOgGspsoBmU9j5Y9NmWK0vgVrEvFYwYk83edHfZHMIXqyKE6c0upC2vWfBw27zveUV
         vvXAl6YuNf3vYqsn7BtvNOHA5zuIUcwQPHneit6IdDDLOk0QTrVSCXRxXmqp6e0SxO9J
         qv751qwBjSkkIH9/6zm/NqfhoNjGadD+3c9SToEaa3cnZRlHuiduMRrftxN1Y/KcyLbn
         Qxs4PQoyuIOfqHYnhZ/cnT56JfJG3nDVmGEikAMJaWR6+74RDOqHombWs7odOl7XmFCm
         NvB9LWUQj89CwEJOOfVwHQwgaJvgRLOMZVwRzD8ZnsFTVsqbYQfuclB3O07Iu2Mh3rgQ
         RLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aZB3UGhgPcDW1xV3kcl8kwXBo405C0t8FD0AZJD9BPE=;
        b=cU7hSMaRdYefyPXja43QyWocl8SNaR2afe4FdHhbGLuf7r4LehBurKHXYqu+AYbwS7
         izj+KrcbCUYMqMM7Ck4TBG5xa9lXnD75EBop2ZKE4+OvpGMkewWv15ZHjKZnEjilqXX2
         rKqgXHaWty72pOybu7o1661wCBYxtU+cpfQJlk/UhnqDjIbQk6yfCYhhwVl0/VcC4bVw
         Mw1sW7KQ0dJGC89XcRvAnpgP1kmqnOax+wwCswZHUtdJm+RZnZnN88SzE1CZplbuNxhN
         EXnQVzp2+DGV/2ceGFO4kdZ7sFJAmXy3OybeHhXrnahe1VpbB52HNbU2vrs0snLMNeqo
         FwiQ==
X-Gm-Message-State: AJIora+pm4rTD4W79HKuZ/YaZ98NZLFZd6XSp1EbL9e4IbDRP8nK27vO
        yg/uSG5dl7adNB4nk3xxUVYZXw==
X-Google-Smtp-Source: AGRyM1sD9tHZyJixe85jL9snzEsUc0wIr1LqiIXQCwAcr3ekxqscZ41QdpY1hOTPrKnVI5X8+XXKrA==
X-Received: by 2002:a17:902:d48a:b0:16b:f0be:4e15 with SMTP id c10-20020a170902d48a00b0016bf0be4e15mr21573742plg.155.1657592845557;
        Mon, 11 Jul 2022 19:27:25 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id mr2-20020a17090b238200b001ef8912f763sm5486466pjb.7.2022.07.11.19.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 19:27:24 -0700 (PDT)
Message-ID: <b39583f2-e054-8fc7-430c-d52bf6ed5016@ozlabs.ru>
Date:   Tue, 12 Jul 2022 12:27:17 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101
 Thunderbird/103.0
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
 <8329c51a-601e-0d93-41b4-2eb8524c9bcb@ozlabs.ru>
 <Yspx307fxRXT67XG@nvidia.com>
 <861e8bd1-9f04-2323-9b39-d1b46bf99711@ozlabs.ru>
 <64bc8c04-2162-2e4b-6556-03b9dde051e2@ozlabs.ru>
 <YsxwDTBLxyo5W3uQ@nvidia.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <YsxwDTBLxyo5W3uQ@nvidia.com>
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



On 7/12/22 04:46, Jason Gunthorpe wrote:
> On Mon, Jul 11, 2022 at 11:24:32PM +1000, Alexey Kardashevskiy wrote:
> 
>> I really think that for 5.19 we should really move this blocked domain
>> business to Type1 like this:
>>
>> https://github.com/aik/linux/commit/96f80c8db03b181398ad355f6f90e574c3ada4bf
> 
> This creates the same security bug for power we are discussing here. If you

How so? attach_dev() on power makes uninitalizes DMA setup for the group 
on the hardware level, any other DMA user won't be able to initiate DMA.


> don't want to fix it then lets just merge this iommu_ops patch as is rather than
> mangle the core code.

The core code should not be assuming iommu_ops != NULL, Type1 should, I 
thought it is the whole point of having Type1, why is not it the case 
anymore?


-- 
Alexey
