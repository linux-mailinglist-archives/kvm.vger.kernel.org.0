Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F01D60F13A
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 09:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiJ0Hjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiJ0Hjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 03:39:40 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3030211C1F
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 00:39:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id io19so590851plb.8
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 00:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ea0hxXYFnPXaT0jl+FmZql4yNHr4Fyf6HAvktIBslno=;
        b=2ThwM1CdoeYroa+FUfTpj1Vp6/OxgPMaiL4s0FckhXA4OUMe7dceB7UU1bxyXDnuNT
         WRLa57sVacmjmOn6/3JMFN+P690O63TOweBHTnc9vTjCcsua1jCjyBEObGuG4JNkFcBX
         +X2VqROAzObgXJiUk/KP3G2MezF7+FVhsRLKfahh7SpBP5I2kkAUFIctsR2wVs0JG3vK
         4VwHwAZOftrzGJFOnvqwc+Ly/CAjReoxjQN+LPM8LImCcwKtGKGJds9D3FShYfvqiYRG
         5ukKRJWvxfdNdMk0OEOi3rMATxsR/6zvedd4U1Q16Rs72dRhSeHTQID9YYcB4VLBpaSL
         G8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ea0hxXYFnPXaT0jl+FmZql4yNHr4Fyf6HAvktIBslno=;
        b=42Sft3s/lUV+5Dzvs149sskhIzG2qI200TZzwSl++TBFdaTMkg6+mi3DL35h4fk3vZ
         Qcdibzd6kvSZehU+lIuI9MX3KRxt1vJkL6hILSVBYJbYZNOnmtOnx80Sh6g5FgBIBo0x
         D7vVm3ZjYgTUCiWy4YWSDvrLYLyc/2+Gt941341pVSg8e5F9bKJfYB0khin08S2FN43R
         y9nvYxlqPJ555YL6tAGPi+msdIUHmw/3UgJxMAGEKsoazUsefAALb3C4n5hxtmkP+G6D
         4F/3BQkW3f5iCxySXM/Fx25ayXm/feqij17+IVEqnC+8N/hfmyfwghdaUJTjDW3Y1iU7
         tyVA==
X-Gm-Message-State: ACrzQf3A9SYxXMOrarHM39HWPIQXKoTEtHpV4mKFTrFqv5/gwP2+cWA8
        bqljIzjzJ1J0He9brLWGSA60xj+FMjKyuA==
X-Google-Smtp-Source: AMsMyM5bFkKEzQ/H6gKUH7MQ0VVAtvEwIxKoZncGQIAFcNvoO2vHRJC/jD9FI81OF59vCOMa2psMJg==
X-Received: by 2002:a17:902:e845:b0:184:8078:be88 with SMTP id t5-20020a170902e84500b001848078be88mr47545935plg.99.1666856377744;
        Thu, 27 Oct 2022 00:39:37 -0700 (PDT)
Received: from [192.168.10.153] (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
        by smtp.gmail.com with ESMTPSA id u66-20020a627945000000b0056c814a501dsm594389pfc.10.2022.10.27.00.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 00:39:37 -0700 (PDT)
Message-ID: <737f1978-4f3c-40be-ed78-8fe525d04da8@ozlabs.ru>
Date:   Thu, 27 Oct 2022 18:39:30 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH kernel v2 0/3] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
Content-Language: en-US
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20220920130457.29742-1-aik@ozlabs.ru>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220920130457.29742-1-aik@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael, Fred, ping?


On 20/09/2022 23:04, Alexey Kardashevskiy wrote:
> Here is another take on iommu_ops on POWER to make VFIO work
> again on POWERPC64. Tested on PPC, kudos to Fred!
> 
> The tree with all prerequisites is here:
> https://github.com/aik/linux/tree/kvm-fixes-wip
> 
> The previous discussion is here:
> https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220707135552.3688927-1-aik@ozlabs.ru/
> https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/
> https://lore.kernel.org/all/20220714081822.3717693-3-aik@ozlabs.ru/T/
> 
> Please comment. Thanks.
> 
> 
> This is based on sha1
> ce888220d5c7 Linus Torvalds "Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi".
> 
> Please comment. Thanks.
> 
> 
> 
> Alexey Kardashevskiy (3):
>    powerpc/iommu: Add "borrowing" iommu_table_group_ops
>    powerpc/pci_64: Init pcibios subsys a bit later
>    powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>      domains
> 
>   arch/powerpc/include/asm/iommu.h          |   6 +-
>   arch/powerpc/include/asm/pci-bridge.h     |   7 +
>   arch/powerpc/platforms/pseries/pseries.h  |   4 +
>   arch/powerpc/kernel/iommu.c               | 247 +++++++++++++++++++++-
>   arch/powerpc/kernel/pci_64.c              |   2 +-
>   arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>   arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>   arch/powerpc/platforms/pseries/setup.c    |   3 +
>   drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>   9 files changed, 334 insertions(+), 94 deletions(-)
> 

-- 
Alexey
