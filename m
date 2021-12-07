Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18AF46B906
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 11:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhLGKcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 05:32:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235123AbhLGKcI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 05:32:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638872917;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d58w/O9tmt4TQ0yEa0JhGzxmg+sZ/WD5ifzH3Bv9Ixg=;
        b=IOM5Is90cwql3d86jczDjOD67f0Jcw/ucdZw/Nx56hqdnC6YeU87Y3WBulVOhZPyyDAqiL
        7S4JuJiCA38UWpNQDTJ7BEg0WMZEkBmCPAWxx3zyAcvUgNeuvB8p8qJpJCArAJPpvdeWII
        T4EXGG20VXYnOKZMkzd+VpbTxFFewPU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-hWpDltQwNnyAWNp9qo9JTw-1; Tue, 07 Dec 2021 05:28:36 -0500
X-MC-Unique: hWpDltQwNnyAWNp9qo9JTw-1
Received: by mail-wm1-f70.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so1012356wmc.7
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 02:28:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=d58w/O9tmt4TQ0yEa0JhGzxmg+sZ/WD5ifzH3Bv9Ixg=;
        b=aWCki4rQDC9gKujt0LVAv9W+DublGtlfEvjoVGWXpQjA+LlEnL5bp5FzP/fvJn4Xd5
         MeykX4qar8rB3x5jvcAC2MEoiCoXoHAhbyKh3NWCNG+2L+2NgThBMjbko23g/vsjLWYm
         mB6kSKi3cZjKc6w8hI0IhnYwQx1LuObwP8ZxZrgaa3aICCS93MOKTOI1tvoo4ytQDACZ
         RwfA3UToiDpMqNuJ7Dq+i4JnJLzC77k316kO9l982RadpXzqepakjp18FC9k8IXXLsKj
         hgduErZKra+K/3wpnvhRDsPvoqHzvvmTF05obt9qdpoXZU1apRwud97gEF3fCoanP6Gx
         kREQ==
X-Gm-Message-State: AOAM533AJBj2vhGLuAX0iqtx7uy0At9h+r7EUjEgbVZwVGXz4KHPOhvj
        WrD6z21jGrjjC8eQPLx0bTBbvTpgXSJ54Aoaiwct4xoVWLtar06479ThhwLRT1ExxyV7ql0Pk4F
        Rch+4mpppCiqK
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr50103334wrd.33.1638872915668;
        Tue, 07 Dec 2021 02:28:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9yqgtAotyRXCF75l+LBkff1xoYlfGD7TQ/mCawQyzCBi7p3cdMYW9aV0zdVcyfpRAAKmK1g==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr50103308wrd.33.1638872915426;
        Tue, 07 Dec 2021 02:28:35 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id e24sm14675252wra.78.2021.12.07.02.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 02:28:34 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Sumit Gupta <sumitg@nvidia.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
        zhukeqian1@huawei.com
Cc:     alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, kevin.tian@intel.com, ashok.raj@intel.com,
        maz@kernel.org, peter.maydell@linaro.org, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, wangxingang5@huawei.com,
        jiangkunkun@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, chenxiang66@hisilicon.com,
        nicolinc@nvidia.com, vdumpa@nvidia.com, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, lushenming@huawei.com, vsethi@nvidia.com,
        Sachin Nikam <Snikam@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <4921cd06-065d-951d-d396-ee9843882c40@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <780faf42-e035-4bfd-252d-8d009355bd6c@redhat.com>
Date:   Tue, 7 Dec 2021 11:28:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <4921cd06-065d-951d-d396-ee9843882c40@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sumit,

On 12/3/21 2:13 PM, Sumit Gupta wrote:
> Hi Eric,
>
>> This series brings the IOMMU part of HW nested paging support
>> in the SMMUv3.
>>
>> The SMMUv3 driver is adapted to support 2 nested stages.
>>
>> The IOMMU API is extended to convey the guest stage 1
>> configuration and the hook is implemented in the SMMUv3 driver.
>>
>> This allows the guest to own the stage 1 tables and context
>> descriptors (so-called PASID table) while the host owns the
>> stage 2 tables and main configuration structures (STE).
>>
>> This work mainly is provided for test purpose as the upper
>> layer integration is under rework and bound to be based on
>> /dev/iommu instead of VFIO tunneling. In this version we also get
>> rid of the MSI BINDING ioctl, assuming the guest enforces
>> flat mapping of host IOVAs used to bind physical MSI doorbells.
>> In the current QEMU integration this is achieved by exposing
>> RMRs to the guest, using Shameer's series [1]. This approach
>> is RFC as the IORT spec is not really meant to do that
>> (single mapping flag limitation).
>>
>> Best Regards
>>
>> Eric
>>
>> This series (Host) can be found at:
>> https://github.com/eauger/linux/tree/v5.15-rc7-nested-v16
>> This includes a rebased VFIO integration (although not meant
>> to be upstreamed)
>>
>> Guest kernel branch can be found at:
>> https://github.com/eauger/linux/tree/shameer_rmrr_v7
>> featuring [1]
>>
>> QEMU integration (still based on VFIO and exposing RMRs)
>> can be found at:
>> https://github.com/eauger/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
>> (use iommu=nested-smmuv3 ARM virt option)
>>
>> Guest dependency:
>> [1] [PATCH v7 0/9] ACPI/IORT: Support for IORT RMR node
>>
>> History:
>>
>> v15 -> v16:
>> - guest RIL must support RIL
>> - additional checks in the cache invalidation hook
>> - removal of the MSI BINDING ioctl (tentative replacement
>>    by RMRs)
>>
>>
>> Eric Auger (9):
>>    iommu: Introduce attach/detach_pasid_table API
>>    iommu: Introduce iommu_get_nesting
>>    iommu/smmuv3: Allow s1 and s2 configs to coexist
>>    iommu/smmuv3: Get prepared for nested stage support
>>    iommu/smmuv3: Implement attach/detach_pasid_table
>>    iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
>>    iommu/smmuv3: Implement cache_invalidate
>>    iommu/smmuv3: report additional recoverable faults
>>    iommu/smmuv3: Disallow nested mode in presence of HW MSI regions
> Hi Eric,
>
> I validated the reworked test patches in v16 from the given
> branches with Kernel v5.15 & Qemu v6.2. Verified them with
> NVMe PCI device assigned to Guest VM.
> Sorry, forgot to update earlier.
>
> Tested-by: Sumit Gupta <sumitg@nvidia.com>

Thank you very much!

Best Regards

Eric
>
> Thanks,
> Sumit Gupta
>

