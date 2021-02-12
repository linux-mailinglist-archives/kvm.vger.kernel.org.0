Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6533319C39
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 11:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBLJ7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 04:59:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhBLJ7r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 04:59:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613123895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2tD4mIs1UmiwLo4/LxlJpBgP6Pe688tzWKdKjHlFi0=;
        b=JpchevY6Jqa2nUEcBLKtbk+qU4C33dPhqa3SlsaSJoUzyPXws+OVVrewGh1FUtPKFk8ndk
        uVV8qGzPSYI0folVLBEhe8F8jsZKjX0DNWpHk+QihprlhpN4Et9+hrhLGd6dEsMD/XZcOF
        xh2htEkgdtO0uzRhU2bXo6DY6t08quw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-xyISVEXbOSO_KKe5qlVzsw-1; Fri, 12 Feb 2021 04:58:11 -0500
X-MC-Unique: xyISVEXbOSO_KKe5qlVzsw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE0681009618;
        Fri, 12 Feb 2021 09:58:09 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33DEA72F88;
        Fri, 12 Feb 2021 09:57:47 +0000 (UTC)
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
To:     Vivek Gautam <vivek.gautam@arm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, "Wu, Hao" <hao.wu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
 <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
 <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
 <6bcd5229-9cd3-a78c-ccb2-be92f2add373@redhat.com>
 <DM5PR11MB143531EA8BD997A18F0A7671C3BF9@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iGZZ9fANN_0-NFb31kHfiytD5=vcsk1_Q8gp-_6L7xQVw@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9b6d409b-266b-230a-800a-24b8e6b5cd09@redhat.com>
Date:   Fri, 12 Feb 2021 10:57:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAFp+6iGZZ9fANN_0-NFb31kHfiytD5=vcsk1_Q8gp-_6L7xQVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vivek, Yi,

On 2/12/21 8:14 AM, Vivek Gautam wrote:
> Hi Yi,
> 
> 
> On Sat, Jan 23, 2021 at 2:29 PM Liu, Yi L <yi.l.liu@intel.com> wrote:
>>
>> Hi Eric,
>>
>>> From: Auger Eric <eric.auger@redhat.com>
>>> Sent: Tuesday, January 19, 2021 6:03 PM
>>>
>>> Hi Yi, Vivek,
>>>
>> [...]
>>>> I see. I think there needs a change in the code there. Should also expect
>>>> a nesting_info returned instead of an int anymore. @Eric, how about your
>>>> opinion?
>>>>
>>>>     domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
>>>>     ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING,
>>> &info);
>>>>     if (ret || !(info.features & IOMMU_NESTING_FEAT_PAGE_RESP)) {
>>>>             /*
>>>>              * No need go futher as no page request service support.
>>>>              */
>>>>             return 0;
>>>>     }
>>> Sure I think it is "just" a matter of synchro between the 2 series. Yi,
>>
>> exactly.
>>
>>> do you have plans to respin part of
>>> [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing to VMs
>>> or would you allow me to embed this patch in my series.
>>
>> My v7 hasn’t touch the prq change yet. So I think it's better for you to
>> embed it to  your series. ^_^>>
> 
> Can you please let me know if you have an updated series of these
> patches? It will help me to work with virtio-iommu/arm side changes.

As per the previous discussion, I plan to take those 2 patches in my
SMMUv3 nested stage series:

[PATCH v7 01/16] iommu: Report domain nesting info
[PATCH v7 02/16] iommu/smmu: Report empty domain nesting info

we need to upgrade both since we do not want to report an empty nesting
info anymore, for arm.

Thanks

Eric
> 
> Thanks & regards
> Vivek
> 

