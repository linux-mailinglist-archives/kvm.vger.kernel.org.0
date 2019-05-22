Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32544263B5
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 14:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfEVMVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 08:21:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728971AbfEVMVG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 May 2019 08:21:06 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MCI69q088329;
        Wed, 22 May 2019 08:20:47 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sn67b098v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 08:20:47 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x4M7ivYP010118;
        Wed, 22 May 2019 07:50:48 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 2smks6sht6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 07:50:48 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4MCKiA07668004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 May 2019 12:20:44 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC0406E050;
        Wed, 22 May 2019 12:20:44 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 227B86E04C;
        Wed, 22 May 2019 12:20:44 +0000 (GMT)
Received: from [9.85.136.32] (unknown [9.85.136.32])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 22 May 2019 12:20:43 +0000 (GMT)
Subject: Re: [PATCH v3 0/3] s390: vfio-ccw fixes
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190516161403.79053-1-farman@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Message-ID: <0769d5bc-cf0b-3a66-7d35-381490a115b5@linux.ibm.com>
Date:   Wed, 22 May 2019 08:20:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190516161403.79053-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/16/2019 12:14 PM, Eric Farman wrote:
> Here are the remaining patches in my fixes series, to handle the more
> involved scenario of channel programs that do not move any actual data
> to/from the device.  They were reordered per feedback from v2, which
> means they received minor massaging because of overlapping code and
> some cleanup to the commit messages.
> 
> They are based on Conny's vfio-ccw tree.  :)
> 
> Changelog:
>   v2 -> v3:
>    - Patches 1-4:
>       - [Farhan] Added r-b
>       - [Cornelia] Queued to vfio-ccw, dropped from this version
>    - Patches 5/6:
>       - [Cornelia/Farhan] Swapped the order of these patches, minor
>         rework on the placement of bytes/idaw_nr variables and the
>         commit messages that resulted.
>   v2: https://patchwork.kernel.org/cover/10944075/
>   v1: https://patchwork.kernel.org/cover/10928799/
> 
> Eric Farman (3):
>    s390/cio: Don't pin vfio pages for empty transfers
>    s390/cio: Allow zero-length CCWs in vfio-ccw
>    s390/cio: Remove vfio-ccw checks of command codes
> 
>   drivers/s390/cio/vfio_ccw_cp.c | 92 ++++++++++++++++++++++++----------
>   1 file changed, 65 insertions(+), 27 deletions(-)
> 


Acked-by: Farhan Ali <alifm@linux.ibm.com> for the series.

Thanks
Farhan
