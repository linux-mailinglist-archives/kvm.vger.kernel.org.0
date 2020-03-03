Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2151776BD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgCCNOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:14:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21568 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727872AbgCCNOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 08:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583241258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K6MYW0Cw8y8JjG5SoRIVtn0utAaLa/9boq4bliE04oQ=;
        b=E/D9AxX5y6fo7WvBvhjKkXA/LWgv/w0wwgPBif8WCHPY8UD5RIQAkRzRrbyEnTLYZcEZJd
        n35m9Y7j7aIyTPCesZqaNG44Kn/9wRfU1IqXHo/CM5mQ/NjGgPMV+lD7xyPG1o/y3FReRx
        /vumSyD8XnuCWwfdidZGmVsMTuWH9D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-hrEKN05ONsaAjIh7E5NlUA-1; Tue, 03 Mar 2020 08:14:14 -0500
X-MC-Unique: hrEKN05ONsaAjIh7E5NlUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B28A13E4;
        Tue,  3 Mar 2020 13:14:11 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00884277A4;
        Tue,  3 Mar 2020 13:14:02 +0000 (UTC)
Subject: Re: [PATCH v9 00/11] SMMUv3 Nested Stage Setup (VFIO part)
To:     zhangfei <zhangfei.gao@linaro.org>,
        Tomasz Nowicki <tnowicki@marvell.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc:     "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "vincent.stehle@arm.com" <vincent.stehle@arm.com>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "tina.zhang@intel.com" <tina.zhang@intel.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        Kenneth Lee <kenneth-lee-2012@foxmail.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
 <a35234a6-e386-fc8e-fcc4-5db4601b00d2@marvell.com>
 <3741c034-08f1-9dbb-ab06-434f3a8bd782@redhat.com>
 <e0133df5-073b-13e1-8399-ff48bfaef5e5@linaro.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f01c0690-4561-287f-a5c6-5eefc5be52b7@redhat.com>
Date:   Tue, 3 Mar 2020 14:14:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <e0133df5-073b-13e1-8399-ff48bfaef5e5@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On 3/3/20 1:57 PM, zhangfei wrote:
> Hi, Eric
>=20
> On 2019/11/20 =E4=B8=8B=E5=8D=886:18, Auger Eric wrote:
>>
>>>> This series brings the VFIO part of HW nested paging support
>>>> in the SMMUv3.
>>>>
>>>> The series depends on:
>>>> [PATCH v9 00/14] SMMUv3 Nested Stage Setup (IOMMU part)
>>>> (https://www.spinics.net/lists/kernel/msg3187714.html)
>>>>
>>>> 3 new IOCTLs are introduced that allow the userspace to
>>>> 1) pass the guest stage 1 configuration
>>>> 2) pass stage 1 MSI bindings
>>>> 3) invalidate stage 1 related caches
>>>>
>>>> They map onto the related new IOMMU API functions.
>>>>
>>>> We introduce the capability to register specific interrupt
>>>> indexes (see [1]). A new DMA_FAULT interrupt index allows to registe=
r
>>>> an eventfd to be signaled whenever a stage 1 related fault
>>>> is detected at physical level. Also a specific region allows
>>>> to expose the fault records to the user space.
>>>>
>>>> Best Regards
>>>>
>>>> Eric
>>>>
>>>> This series can be found at:
>>>> https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9
>>> I think you have already tested on ThunderX2, but as a formality, for
>>> the whole series:
>>>
>>> Tested-by: Tomasz Nowicki <tnowicki@marvell.com>
>>> qemu: https://github.com/eauger/qemu/tree/v4.1.0-rc0-2stage-rfcv5
>>> kernel: https://github.com/eauger/linux/tree/v5.3.0-rc0-2stage-v9 +
>>> Shameer's fix patch
>>>
>>> In my test I assigned Intel 82574L NIC and perform iperf tests.
>> Thank you for your testing efforts.
>>> Other folks from Marvell claimed this to be important feature so I as=
ked
>>> them to review and speak up on mailing list.
>> That's nice to read that!=C2=A0 So it is time for me to rebase both th=
e iommu
>> and vfio parts. I will submit something quickly. Then I would encourag=
e
>> the review efforts to focus first on the iommu part.
>>
>>
> vSVA feature is also very important to us, it will be great if vSVA can
> be supported in guest world.
>=20
> We just submitted uacce for accelerator, which will be supporting SVA o=
n
> host, thanks to Jean's effort.
>=20
> https://lkml.org/lkml/2020/2/11/54
>=20
>=20
> However, supporting vSVA in guest is also a key component for accelerat=
or.
>=20
> Looking forward this going to be happen.
>=20
>=20
> Any respin, I will be very happy to test.

OK. Based on your interest and Marvell's interest too, I will respin
both iommu & vfio series.

Thanks

Eric
>=20
>=20
> Thanks
>=20
>=20
>=20
>=20

