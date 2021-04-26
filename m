Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F049F36B720
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhDZQoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 12:44:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234576AbhDZQoP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 12:44:15 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QGYAW2154981;
        Mon, 26 Apr 2021 12:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tXwPm6B6mjY/+Gg3PuHhnUHoeht5XBCcQiw63TM4dfk=;
 b=he2OOAEXUvXtp1C/Ubr/RyWeE1/G1zhdlwJHQN1kxxRupRnn4r4CMFJnsbwujLdFCr61
 39pN0SsNuFrrlVoKHm6ll4TrbsIk5LjbfHCtXBNVOOqhgGYLneYuUq54zUHhqN6ovssI
 LI3INLNcoc3oo3xXP+bKOcp5ri8euR+DQGjxT8JvpKP4zz0RCk6Y6l1+Qi+TyjyKAgTM
 SavLWuNumfN8Hl94k+EcEjGE9GjS8D7Oodm7fO19smqUmRL/0/ZASN8TFL2vjJmOF8sh
 +iNYJUpMmgtHfbh9YxGD/Wm5M/kVBPaHATqqgGqpZ6xwkWxQNQnmh+tpATvG1APyKh7f 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3860wqgppy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 12:43:24 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13QGYIBj155278;
        Mon, 26 Apr 2021 12:43:23 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3860wqgpp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 12:43:23 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13QGhLkK007911;
        Mon, 26 Apr 2021 16:43:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 384akh8grd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 16:43:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13QGhHID32833878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 16:43:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80ABCA4040;
        Mon, 26 Apr 2021 16:43:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31384A405D;
        Mon, 26 Apr 2021 16:43:15 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.9.59])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Apr 2021 16:43:15 +0000 (GMT)
Subject: Re: [PATCH 00/12] Remove vfio_mdev.c, mdev_parent_ops and more
To:     Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@linux.ie>,
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
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <5def83bb-599c-27fa-9daa-efa27b5ac1d4@de.ibm.com>
Date:   Mon, 26 Apr 2021 18:43:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wk_LhyhcEW_HuSA6wkGiwMQ4scpotOuq
X-Proofpoint-ORIG-GUID: V3yTNvs96WUujjSPPXP08OYezaP1rk50
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_09:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.04.21 01:02, Jason Gunthorpe wrote:
> Prologue
> ========
> 
> This is series #3 in part of a larger work that arose from the minor
> remark that the mdev_parent_ops indirection shim is useless and
> complicates things.
> 
> It applies on top of Alex's current tree and requires the prior two
> series.

Do you have a tree somewhere?
