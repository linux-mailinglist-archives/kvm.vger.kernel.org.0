Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67446ED40
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 17:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbhLIQli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 11:41:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239658AbhLIQlh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 11:41:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639067883;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jNxrSJ7hA39700PK5sP9nWrntBLNr8e9xNebTOGiU18=;
        b=V63pxZpuD7hzv8Q4GmGqyQaTy10eKVvCZ4jc9kXDqFp3QXbFESU05wxqZ2wQzM/ZgcoPsq
        fLkQygHvLWSyNgrqnUEuojyRac/FOrcXMsIl1iPHiuatK3jg1oowkIarZvFVX75tzDidnH
        Og13WcJtBdKVfSFk21Uako5kkxvwC10=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-109-CXX6E9DfOSqeGDsUQ4s2OA-1; Thu, 09 Dec 2021 11:38:02 -0500
X-MC-Unique: CXX6E9DfOSqeGDsUQ4s2OA-1
Received: by mail-wr1-f72.google.com with SMTP id q5-20020a5d5745000000b00178abb72486so1590537wrw.9
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 08:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=jNxrSJ7hA39700PK5sP9nWrntBLNr8e9xNebTOGiU18=;
        b=rSIUns7t2zyvGqEPHzvpoJEnVx/vVhGRHskcKQmxK86+NT7ITG6lWI6DCDanvP9nmm
         xeUBPtHdD2p231I3L7FlRh42dr1ou0R+8ChZ3JCaopcKXqiB/8qzloiT2T6ZT4KTby3Y
         n0kIMdsT2C7c3eGyE6b3ddQz+TuMF+5nHqMksOKeA3Lje5Oi/f1NM6tk73P+SV+DRjjQ
         X6keLbk6GPgMls6guTXqyN/kNsLBfTfQwzxprEjkLxTlXUTWjofSBzdvXEiWLsDzPe2K
         GMUv9X2GTaWu0vHosRa4XWNaIpXswCLveF6vO0sNYF2r5gwrlUJwB5kMRi5CQdZc28Kx
         E9lg==
X-Gm-Message-State: AOAM533feM9nKDb8PW/vKBK/WPAgHE0k/4HvWI05HSenbwsAVOudBfQy
        fxAzP/Lk5X5HxJj7XCTa9g/fMQWpRlqX+UpRuFIZLeQtxCi6eXC3DNskK+9aewNVdHb1c61Ow58
        BSwtJpNeF1FFM
X-Received: by 2002:a5d:58ed:: with SMTP id f13mr7636086wrd.373.1639067881494;
        Thu, 09 Dec 2021 08:38:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaV0R+9HzYiSu0FZYalbofmj5ndV0Ij51Jvm3EMXiekkqz6rpjx+QrGmfxHOtUjUM3LxbGgQ==
X-Received: by 2002:a5d:58ed:: with SMTP id f13mr7636061wrd.373.1639067881306;
        Thu, 09 Dec 2021 08:38:01 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d7sm163025wrw.87.2021.12.09.08.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 08:38:00 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        ashok.raj@intel.com, maz@kernel.org, vsethi@nvidia.com,
        zhangfei.gao@linaro.org, kevin.tian@intel.com, will@kernel.org,
        alex.williamson@redhat.com, wangxingang5@huawei.com,
        linux-kernel@vger.kernel.org, lushenming@huawei.com,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <b576084b-482f-bcb7-35a6-d786dbb305e1@redhat.com>
 <20211209154046.GQ6385@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <f6e93350-e0ee-649a-bf97-314398481fc8@redhat.com>
Date:   Thu, 9 Dec 2021 17:37:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211209154046.GQ6385@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 12/9/21 4:40 PM, Jason Gunthorpe wrote:
> On Thu, Dec 09, 2021 at 08:50:04AM +0100, Eric Auger wrote:
>
>>> The kernel API should accept the S1ContextPtr IPA and all the parts of
>>> the STE that relate to the defining the layout of what the S1Context
>>> points to an thats it.
>> Yes that's exactly what is done currently. At config time the host must
>> trap guest STE changes (format and S1ContextPtr) and "incorporate" those
>> changes into the stage2 related STE information. The STE is owned by the
>> host kernel as it contains the stage2 information (S2TTB).
> [..]
>
>> Note this series only coped with a single CD in the Context Descriptor
>> Table.
> I'm confused, where does this limit arise?
>
> The kernel accepts as input all the bits in the STE that describe the
> layout of the CDT owned by userspace, shouldn't userspace be able to
> construct all forms of CDT with any number of CDs in them?
>
> Or do you mean this is some qemu limitation?
The upstream vSMMUv3 emulation does not support multiple CDs at the
moment and since I have no proper means to validate the vSVA case I am
rejecting any attempt from user space to inject guest configs featuring
mutliple PASIDs. Also PASID cache invalidation must be added to this series.

Nevertheless those limitations were tackled and overcomed by others in
CC so I don't think there is any blocking issue.

Thanks

Eric
>
> Jason
>

