Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2E33CFBC
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhCPIWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234633AbhCPIW1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 04:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615882946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jgBW73IfZOFUYHFY6ABzyMEw2s2SPKAK0wW2bLnOaus=;
        b=TMd72ltt3dvEQTqGkutwgvY7uw+WuZlFxoD1JxQhcOksf3NTzA1Juoa5x1Rz9gw536MyfD
        wdiwf+WSDhJW8vHY0iKbEufmbyZpgpzU1rB9Cui0O5Cg7IoShCxoV8A6y0BA3gGTBD+E/z
        H3YrD4B2K2tTFcBG1qwVLX8BEhljam0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-7iVAxc8DNEu8pHjCZoVk6w-1; Tue, 16 Mar 2021 04:22:23 -0400
X-MC-Unique: 7iVAxc8DNEu8pHjCZoVk6w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4F0993920;
        Tue, 16 Mar 2021 08:22:20 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB6BF690F0;
        Tue, 16 Mar 2021 08:22:12 +0000 (UTC)
Subject: Re: [PATCH v13 00/15] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Krishna Reddy <vdumpa@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Cc:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        Sachin Nikam <Snikam@nvidia.com>,
        Yu-Huan Hsu <YHsu@nvidia.com>,
        Bryan Huntsman <bhuntsman@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <BY5PR12MB3764285E7E8064B636132C65B36C9@BY5PR12MB3764.namprd12.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d9934ef7-3bf0-b004-3fe9-e0adbcae5c05@redhat.com>
Date:   Tue, 16 Mar 2021 09:22:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB3764285E7E8064B636132C65B36C9@BY5PR12MB3764.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Krishna,
On 3/15/21 7:04 PM, Krishna Reddy wrote:
> Tested-by: Krishna Reddy <vdumpa@nvidia.com>
> 
>> 1) pass the guest stage 1 configuration
> 
> Validated Nested SMMUv3 translations for NVMe PCIe device from Guest VM along with patch series "v11 SMMUv3 Nested Stage Setup (VFIO part)" and QEMU patch series "vSMMUv3/pSMMUv3 2 stage VFIO integration" from v5.2.0-2stage-rfcv8. 
> NVMe PCIe device is functional with 2-stage translations and no issues observed.
Thank you very much for your testing efforts. For your info, there are
more recent kernel series:
[PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part) (Feb 23)
[PATCH v12 00/13] SMMUv3 Nested Stage Setup (VFIO part) (Feb 23)

working along with QEMU RFC
[RFC v8 00/28] vSMMUv3/pSMMUv3 2 stage VFIO integration (Feb 25)

If you have cycles to test with those, this would be higly appreciated.

Thanks

Eric
> 
> -KR
> 

