Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7C6341DF9
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 14:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCSNRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 09:17:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229806AbhCSNRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 09:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616159859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5QQKEU/ECNGh/RWYsjuchajrICEpdL+HW6a/qfkukk=;
        b=eYS0m5S32+Al0q8kORLSdX6DnEeQHGCLoPfVkVUllUFD9T+BaD6JKab7atw4ZI2S9qpQra
        26alMXUJHYI8shvBad9XpRLseM7gioB/QMdzVjrcrvi5wWo7sZTydaIuW3UVdLB/Qug2m5
        b7j9FHrCWoX3ShtCgHafa8kujP8BN0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-lsfkZekTOo6zDlQX4JVVhw-1; Fri, 19 Mar 2021 09:17:35 -0400
X-MC-Unique: lsfkZekTOo6zDlQX4JVVhw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E320108BD12;
        Fri, 19 Mar 2021 13:17:31 +0000 (UTC)
Received: from [10.36.113.141] (ovpn-113-141.ams2.redhat.com [10.36.113.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F306090F;
        Fri, 19 Mar 2021 13:17:22 +0000 (UTC)
Subject: Re: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Krishna Reddy <vdumpa@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "zhukeqian1@huawei.com" <zhukeqian1@huawei.com>
Cc:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        Bryan Huntsman <bhuntsman@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Yu-Huan Hsu <YHsu@nvidia.com>,
        Sachin Nikam <Snikam@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <BY5PR12MB3764A171D7C6E0DA9CDF0C29B3699@BY5PR12MB3764.namprd12.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <92bb2d75-0b9b-3810-4af4-4ffcc27ef245@redhat.com>
Date:   Fri, 19 Mar 2021 14:17:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB3764A171D7C6E0DA9CDF0C29B3699@BY5PR12MB3764.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Krishna,

On 3/18/21 1:16 AM, Krishna Reddy wrote:
> Tested-by: Krishna Reddy <vdumpa@nvidia.com>
> 
> Validated nested translations with NVMe PCI device assigned to Guest VM. 
> Tested with both v12 and v13 of Jean-Philippe's patches as base.

Many thanks for that.
> 
>> This is based on Jean-Philippe's
>> [PATCH v12 00/10] iommu: I/O page faults for SMMUv3
>> https://lore.kernel.org/linux-arm-kernel/YBfij71tyYvh8LhB@myrica/T/
> 
> With Jean-Philippe's V13, Patch 12 of this series has a conflict that had to be resolved manually.

Yep I will respin accordingly.

Best Regards

Eric
> 
> -KR
> 
> 

