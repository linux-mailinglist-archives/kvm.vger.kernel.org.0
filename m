Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05136C01E
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 09:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhD0He6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 03:34:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232824AbhD0He5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 03:34:57 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13R7XHHA076633;
        Tue, 27 Apr 2021 03:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dbwUouL94Tn6aMK5okMNidltYNKsURrD9rSSG24y+N8=;
 b=JlBYcGRZinkJQ1yL6heRHD3pud7q+grVvAnrNoVMNLWaK2KZOTrg7ISOe0e2zyBTewO2
 1Yq5+jH8spWiL4RGCY0ebeZKRkhbBBTXz4nJSrs+4HDL2ehS3Alpkd7dHPaV452wSF18
 4U191PPSIXGQuzZVE+ZQxTjDszgR1OSTHt9VdxybVLkWGnA34Ah1KytfPWIoKiGwbB5n
 gWjLyztpo8shuUBK+uxW2ZC2Qm5AhLBHuUpwHG47IoVT2LTt8DtersFVqNovqz0g00Kj
 TmnvSAAw+bGvEpM9NlyCwZdiiwvruwrXZ+jdNQkYd8uWLFU4McOxdbjRtbCDD8/NeVMR Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386cf2txe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 03:34:05 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13R7XlU4078010;
        Tue, 27 Apr 2021 03:34:05 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386cf2txc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 03:34:05 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13R7Rane009579;
        Tue, 27 Apr 2021 07:34:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 384ay88nbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 07:34:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13R7XYL128049826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 07:33:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0CDF4C046;
        Tue, 27 Apr 2021 07:33:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA4A24C040;
        Tue, 27 Apr 2021 07:33:56 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.69.120])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Apr 2021 07:33:56 +0000 (GMT)
Subject: Re: [PATCH 00/12] Remove vfio_mdev.c, mdev_parent_ops and more
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
 <5def83bb-599c-27fa-9daa-efa27b5ac1d4@de.ibm.com>
 <20210426174250.GW1370958@nvidia.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <2ca13efa-3876-9496-edbf-4b12b93d721c@de.ibm.com>
Date:   Tue, 27 Apr 2021 09:33:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210426174250.GW1370958@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u76BFO76MsdtScWYP9TmTAIjYZRDCeQ_
X-Proofpoint-ORIG-GUID: E3SdCeQ-8MC1eEvgYB2mhBcR57fsEB6B
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_02:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104270055
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.04.21 19:42, Jason Gunthorpe wrote:
> On Mon, Apr 26, 2021 at 06:43:14PM +0200, Christian Borntraeger wrote:
>> On 24.04.21 01:02, Jason Gunthorpe wrote:
>>> Prologue
>>> ========
>>>
>>> This is series #3 in part of a larger work that arose from the minor
>>> remark that the mdev_parent_ops indirection shim is useless and
>>> complicates things.
>>>
>>> It applies on top of Alex's current tree and requires the prior two
>>> series.
>>
>> Do you have a tree somewhere?
> 
> [..]
>>> A preview of the future series's is here:
>>>     https://github.com/jgunthorpe/linux/pull/3/commits
> 
> Has everything, you'll want to go to:
>    cover-letter: Remove vfio_mdev.c, mdev_parent_ops and more
> 
> As there are additional WIPs in that tree.

I gave this a quick spin on s390x vfio-ap and it seems to work ok.
This is really just a quick test, but no obvious problem.
