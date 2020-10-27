Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB0929ACB4
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 14:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751683AbgJ0NEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 09:04:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751668AbgJ0NEV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 09:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603803860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXXpUz3VnsL2Xy70mrZp5D4eUU9pHEsl4U/A+ZeUZVA=;
        b=LciIeeqabotGVFGb+lRk9WBcSPSVRAo86949gd5sxHajHAeHEKYMlZoaTuFgyiIwc4ZZaP
        N6B76vGPx4wdV3xZT21m7RmUwPNDhdwEreMQSckamZlzD8Kcd+iL2dTCjl5upfhs7OXAqp
        G6tnbfI6uMIDef2+Bxff1oYJrN0ZNHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-6ACk6zq5PEK2TZ_Z7S-pwA-1; Tue, 27 Oct 2020 09:04:15 -0400
X-MC-Unique: 6ACk6zq5PEK2TZ_Z7S-pwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D744FEC505;
        Tue, 27 Oct 2020 13:04:12 +0000 (UTC)
Received: from [10.36.112.194] (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3446F5B4A4;
        Tue, 27 Oct 2020 13:04:06 +0000 (UTC)
Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        yuzenghui <yuzenghui@huawei.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
 <20200320161911.27494-2-eric.auger@redhat.com>
 <2fba23af-9cd7-147d-6202-01c13fff92e5@huawei.com>
 <d3a302bb-34e8-762f-a11f-717b3bc83a2b@redhat.com>
 <cb5835e79b474e30af6702dbee0d46df@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <cde28d6d-c6cf-ef23-b293-f9959aba0a18@redhat.com>
Date:   Tue, 27 Oct 2020 14:04:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cb5835e79b474e30af6702dbee0d46df@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 10/27/20 1:20 PM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: iommu [mailto:iommu-bounces@lists.linux-foundation.org] On Behalf Of
>> Auger Eric
>> Sent: 23 September 2020 12:47
>> To: yuzenghui <yuzenghui@huawei.com>; eric.auger.pro@gmail.com;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; joro@8bytes.org;
>> alex.williamson@redhat.com; jacob.jun.pan@linux.intel.com;
>> yi.l.liu@intel.com; robin.murphy@arm.com
>> Subject: Re: [PATCH v10 01/11] vfio: VFIO_IOMMU_SET_PASID_TABLE
> 
> ...
> 
>>> Besides, before going through the whole series [1][2], I'd like to
>>> know if this is the latest version of your Nested-Stage-Setup work in
>>> case I had missed something.
>>>
>>> [1]
>>> https://lore.kernel.org/r/20200320161911.27494-1-eric.auger@redhat.com
>>> [2]
>>> https://lore.kernel.org/r/20200414150607.28488-1-eric.auger@redhat.com
>>
>> yes those 2 series are the last ones. Thank you for reviewing.
>>
>> FYI, I intend to respin within a week or 2 on top of Jacob's  [PATCH v10 0/7]
>> IOMMU user API enhancement. 
> 
> Thanks for that. Also is there any plan to respin the related Qemu series as well?
> I know dual stage interface proposals are still under discussion, but it would be
> nice to have a testable solution based on new interfaces for ARM64 as well.
> Happy to help with any tests or verifications.

Yes the QEMU series will be respinned as well. That's on the top of my
todo list right now.

Thanks

Eric
> 
> Please let me know.
> 
> Thanks,
> Shameer
>   
> 

