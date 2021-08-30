Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F00C3FB36E
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 11:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhH3Jw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 05:52:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235464AbhH3Jw5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 05:52:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17U9XQgP095218;
        Mon, 30 Aug 2021 05:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FbO8gnqMrcAlzu0onQlb9s/bqdObD9KMbua+ueFaAZc=;
 b=lNidZhG36vemmOFvEJTn1jZEkMJiK+qSDVnCqOn80arNvJkWYYem+cevLOJget5+X0aP
 UZTGp9iUExxNPPXYL8BflfZqVPmw97E2f5Ia4591yXci8STWYw4R1Drw1ZiOz97g/qFf
 dOUIeH01RBnaO7vhg6VIRyr35fTRQXZmsZNFpEqugXQSG6zq3RanZxYxl6FVQQ7oapw+
 DFtdi9ZPxMl0JkN4PXfzcyl4Ri4MhgJF8xriZDrjFTYdhdOmYKUKOuBLdedTamdbJaOZ
 n1aI9MMseC0YRIFbWbeUJ68UwX21TRI0LmAye/sgRrLH9xnI9+Uxov5xSIfhbXy36iy2 bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3are857gd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 05:51:58 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17U9XvZ2096461;
        Mon, 30 Aug 2021 05:51:57 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3are857gc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 05:51:57 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17U9lX5t003244;
        Mon, 30 Aug 2021 09:51:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3aqcs8u847-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 09:51:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17U9lvUY55116238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Aug 2021 09:47:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F5114C046;
        Mon, 30 Aug 2021 09:51:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A02A4C040;
        Mon, 30 Aug 2021 09:51:51 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.78.133])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Aug 2021 09:51:51 +0000 (GMT)
Subject: Re: [PATCH 0/2] s390x: ccw: A simple test device for virtio CCW
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        Michael S Tsirkin <mst@redhat.com>
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, mst@redhat.com, qemu-devel@nongnu.org
References: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <fe2c0cbd-24a6-0785-6a64-22c6b6c01e6d@de.ibm.com>
Date:   Mon, 30 Aug 2021 11:51:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1630061450-18744-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HVxNOsCQi9V9Fw1jk6HxavDXyERoGWqO
X-Proofpoint-ORIG-GUID: yph-RShPm_2fm0OOuPfdGNQcvL8FyKJu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-30_03:2021-08-27,2021-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108300070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.08.21 12:50, Pierre Morel wrote:
> Hello All,
> 
> 
> This series presents a VIRTIO test device which receives data on its
> input channel and sends back a simple checksum for the data it received
> on its output channel.
>   
> The goal is to allow a simple VIRTIO device driver to check the VIRTIO
> initialization and various data transfer.
> 
> For this I introduced a new device ID for the device and having no
> Linux driver but a kvm-unit-test driver, I have the following
> questions:

I think we should reserve an ID in the official virtio spec then for such a device?
Maybe also add mst for such things.
  

> Is there another way to advertise new VIRTIO IDs but Linux?
> If this QEMU test meet interest, should I write a Linux test program?
> 
> Regards,
> Pierre
> 
> 
> Pierre Morel (2):
>    virtio: Linux: Update of virtio_ids
>    s390x: ccw: A simple test device for virtio CCW
> 
>   hw/s390x/meson.build                        |   1 +
>   hw/s390x/virtio-ccw-pong.c                  |  66 ++++++++
>   hw/s390x/virtio-ccw.h                       |  13 ++
>   hw/virtio/Kconfig                           |   5 +
>   hw/virtio/meson.build                       |   1 +
>   hw/virtio/virtio-pong.c                     | 161 ++++++++++++++++++++
>   include/hw/virtio/virtio-pong.h             |  34 +++++
>   include/standard-headers/linux/virtio_ids.h |   1 +
>   8 files changed, 282 insertions(+)
>   create mode 100644 hw/s390x/virtio-ccw-pong.c
>   create mode 100644 hw/virtio/virtio-pong.c
>   create mode 100644 include/hw/virtio/virtio-pong.h
> 
