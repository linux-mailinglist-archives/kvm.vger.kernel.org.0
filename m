Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F32319011
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 17:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBKQdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 11:33:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26138 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231691AbhBKQaa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 11:30:30 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11BGDsOJ036022;
        Thu, 11 Feb 2021 11:29:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1VwQ7jEAKnvB8fLAJVSh63TrP4R5BIlh1FXfJ8lm3Ew=;
 b=JUQvUkV5B3gfrdV5fnpuaIwBJ/WysVIfYYdimsIH62BuCMeOVJ3llLnzuIpqbajCt2CO
 HrUOyOyveieFbbGX6RHUehoobDrTBq+ZkbrpMLzii3lQ+I5BL6cN0VJzxgXp6iHqiYSy
 H5ep5WLY/QgWLx0PbRFaoAaXMFbrJqZxldoIpYYSNA+dQYgxhSS3VoeJ1+3VtglFgFkW
 NuCd1r8WpXij8uGBkmzemGNlR5ocEczEog9f5AiMPpbe5pDDWokFzqf98ZPEAzAbykWs
 mMoaLG0eKL0lY3VNR5ZdDSWQRLQetR5Ycdtj/0DQh/oHwtJotul0vpdfciRRu/E3Gh+O sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n7wv0mth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 11:29:45 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11BGE3ce036934;
        Thu, 11 Feb 2021 11:29:45 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36n7wv0mst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 11:29:44 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11BGRBO8021576;
        Thu, 11 Feb 2021 16:29:43 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 36hjr9pxu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 16:29:43 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11BGTgHZ6488610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 16:29:42 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18B57BE058;
        Thu, 11 Feb 2021 16:29:42 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABBE0BE056;
        Thu, 11 Feb 2021 16:29:38 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.60.2])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 16:29:38 +0000 (GMT)
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, gmataev@nvidia.com,
        cjia@nvidia.com, yishaih@nvidia.com, aik@ozlabs.ru
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <20210202171021.GW4247@nvidia.com>
 <f49512dd-9a5c-b1d8-1609-da55e270635b@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <9fc2b752-88a3-0607-00fc-cb7414dcd5f6@linux.ibm.com>
Date:   Thu, 11 Feb 2021 11:29:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f49512dd-9a5c-b1d8-1609-da55e270635b@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/21 10:47 AM, Max Gurtovoy wrote:
> 
> On 2/2/2021 7:10 PM, Jason Gunthorpe wrote:
>> On Tue, Feb 02, 2021 at 05:06:59PM +0100, Cornelia Huck wrote:
>>
>>> On the other side, we have the zdev support, which both requires s390
>>> and applies to any pci device on s390.
>> Is there a reason why CONFIG_VFIO_PCI_ZDEV exists? Why not just always
>> return the s390 specific data in VFIO_DEVICE_GET_INFO if running on
>> s390?
>>
>> It would be like returning data from ACPI on other platforms.
> 
> Agree.
> 
> all agree that I remove it ?

I did some archives digging on the discussions around 
CONFIG_VFIO_PCI_ZDEV and whether we should/should not have a Kconfig 
switch around this; it was something that was carried over various 
attempts to get the zdev support upstream, but I can't really find (or 
think of) a compelling reason that a Kconfig switch must be kept for it. 
  The bottom line is if you're on s390, you really want zdev support.

So: I don't have an objection so long as the net result is that 
vfio_pci_zdev.o is always built in to vfio-pci(-core) for s390.

> 
> we already have a check in the code:
> 
> if (ret && ret != -ENODEV) {
>                                  pci_warn(vdev->vpdev.pdev, "Failed to 
> setup zPCI info capabilities\n");
>                                  return ret;
> }
> 
> so in case its not zdev we should get -ENODEV and continue in the good 
> flow.
> 
>>
>> It really seems like part of vfio-pci-core
>>
>> Jason

