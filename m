Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A457646B8C6
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 11:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhLGK0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 05:26:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235024AbhLGK0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 05:26:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638872554;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIblGTzXX40hR9szafjbMCGgx30k6YagvsBGLTnN0YI=;
        b=BTDOiJ5TJMdVA0OeZUlCpys29dUUgn83u++Cd8E2huJfN8Z3qTb1VrxgkeAPbXm9tGWon3
        /2ZKpoQr8JXbzPU6d2+DcsUcR//Eklj4v70MZ03tXpsMUOdlhnRxN5bZ6wdohzgNKIUFMX
        CVRerwo4ZUgTAErBhPTr8f4ym+2/q0A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-109-h8xtBGv9N1KJ8b1txTzoRQ-1; Tue, 07 Dec 2021 05:22:33 -0500
X-MC-Unique: h8xtBGv9N1KJ8b1txTzoRQ-1
Received: by mail-wm1-f71.google.com with SMTP id ay34-20020a05600c1e2200b00337fd217772so1169103wmb.4
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 02:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=vIblGTzXX40hR9szafjbMCGgx30k6YagvsBGLTnN0YI=;
        b=S3DjKm1ooMeHPy4Pg7B7SzPaRJIOej7pVqeUK3qckYej+K3LX8N+L46wQ+M24+m/Fb
         L8KVBmS1w741sSo+QBuU/zir24DVE6rXCxX4vSCGPPu+V41XD3Yz+4W3PduAxqoCe8OC
         9y6n92KUF0w04LPrWKXobh+kxyUG5nwjuKaPpbN//lRISswjqvqVd08sCm3ilaKkxjtH
         bLnvRa5/KphhVGfgE0zWdWsI2PQkhq9tV4rUJlPitpj93tYr3KCQcnPUSuvY4Kckwcd7
         oTFTmivM3sBWuH+CZMn+HAFmT1chqyKcoanOo2b8fBraBkD2/2UrJ0JfLNODBoeqHtlf
         IW8A==
X-Gm-Message-State: AOAM532wsZCegC01tseJUcG7bprZvyFrF98bRxmDOHNqagR8x48HzlTL
        A+GceRh3wG9gVjiBOWTws3YKUXOIBARnq851vONKX78/iv7QAKSoeQimPP4DV9pimMijVjijk6F
        HGMYqq/iE9WZn
X-Received: by 2002:a05:600c:4f55:: with SMTP id m21mr5891521wmq.68.1638872552020;
        Tue, 07 Dec 2021 02:22:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOgIcH/ywM872FWWEzo4wI3r37JDW61iH1Cfi/iZw3pSmHii9bhQ9WabrWC9ggWBBYhH9xLg==
X-Received: by 2002:a05:600c:4f55:: with SMTP id m21mr5891493wmq.68.1638872551786;
        Tue, 07 Dec 2021 02:22:31 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id k8sm13945681wrn.91.2021.12.07.02.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 02:22:31 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To:     Joerg Roedel <joro@8bytes.org>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org,
        robin.murphy@arm.com, jean-philippe@linaro.org,
        zhukeqian1@huawei.com, alex.williamson@redhat.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        kevin.tian@intel.com, ashok.raj@intel.com, maz@kernel.org,
        peter.maydell@linaro.org, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, wangxingang5@huawei.com,
        jiangkunkun@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, chenxiang66@hisilicon.com,
        sumitg@nvidia.com, nicolinc@nvidia.com, vdumpa@nvidia.com,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
Date:   Tue, 7 Dec 2021 11:22:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Ya3qd6mT/DpceSm8@8bytes.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg,

On 12/6/21 11:48 AM, Joerg Roedel wrote:
> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
>> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
>> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> This Signed-of-by chain looks dubious, you are the author but the last
> one in the chain?
The 1st RFC in Aug 2018
(https://lists.cs.columbia.edu/pipermail/kvmarm/2018-August/032478.html)
said this was a generalization of Jacob's patch


  [PATCH v5 01/23] iommu: introduce bind_pasid_table API function


  https://lists.linuxfoundation.org/pipermail/iommu/2018-May/027647.html

So indeed Jacob should be the author. I guess the multiple rebases got
this eventually replaced at some point, which is not an excuse. Please
forgive me for that.
Now the original patch already had this list of SoB so I don't know if I
shall simplify it.


>
>> +int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
>> +				  void __user *uinfo)
>> +{
> [...]
>
>> +	if (pasid_table_data.format == IOMMU_PASID_FORMAT_SMMUV3 &&
>> +	    pasid_table_data.argsz <
>> +		offsetofend(struct iommu_pasid_table_config, vendor_data.smmuv3))
>> +		return -EINVAL;
> This check looks like it belongs in driver specific code.
Indeed, I will fix that in my next respin :-)

Thanks!

Eric
>
> Regards,
>
> 	Joerg
>

