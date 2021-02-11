Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09B5318F28
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 16:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhBKPux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 10:50:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3937 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhBKPsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 10:48:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602551940000>; Thu, 11 Feb 2021 07:47:32 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 15:47:32 +0000
Received: from [172.27.0.87] (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 15:47:26 +0000
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Jason Gunthorpe <jgg@nvidia.com>, Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <20210202171021.GW4247@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <f49512dd-9a5c-b1d8-1609-da55e270635b@nvidia.com>
Date:   Thu, 11 Feb 2021 17:47:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210202171021.GW4247@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613058452; bh=UTOoJv9jmFrHAMyl7esEQ23+zBkmHWAQIZNkJ0IockI=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=jiIjxxbkXpvGXoJBCPSS1QO0ur9yeT8SMk8qDADTJAMPSOxQtx4Q6Q4YheC29tlDL
         G26g+TEkk/Khm1+5Fhn3hYOm9WI2AztDMNsqzyiI5+S1V2LwKcgXUYEYI1ueJxTOgO
         1WyYYNwFwWvFObVuhaBwl7DLc4TO4zKeAPZpCum/hPYNMOgP4sfRpBQfBLVcweY+wU
         a1LnINk0/MW2kMhVWDs0MZSbDLLm9FH2VMA8hBqQRgsBUmDzTya1+0+h21rJQH6WwI
         LbG4HtSKBFJ0WigqMhq2+kNNHFV/HEWmxAtEJd8JJBuX2eIR2Zp2OHKfU/+NyDLThJ
         EiLwufx3RZvNg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/2/2021 7:10 PM, Jason Gunthorpe wrote:
> On Tue, Feb 02, 2021 at 05:06:59PM +0100, Cornelia Huck wrote:
>
>> On the other side, we have the zdev support, which both requires s390
>> and applies to any pci device on s390.
> Is there a reason why CONFIG_VFIO_PCI_ZDEV exists? Why not just always
> return the s390 specific data in VFIO_DEVICE_GET_INFO if running on
> s390?
>
> It would be like returning data from ACPI on other platforms.

Agree.

all agree that I remove it ?

we already have a check in the code:

if (ret && ret !=3D -ENODEV) {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_warn(vdev->vpdev.pdev, "Failed =
to=20
setup zPCI info capabilities\n");
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
}

so in case its not zdev we should get -ENODEV and continue in the good flow=
.

>
> It really seems like part of vfio-pci-core
>
> Jason
