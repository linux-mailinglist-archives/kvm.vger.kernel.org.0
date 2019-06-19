Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8661B4C2D6
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 23:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFSVPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 17:15:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726175AbfFSVPY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 17:15:24 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JLEljw032513
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 17:15:22 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t7uukj5h7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 17:15:22 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Wed, 19 Jun 2019 22:15:22 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Jun 2019 22:15:20 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JLFJP68586120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 21:15:19 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F069AE060;
        Wed, 19 Jun 2019 21:15:19 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 300D3AE05C;
        Wed, 19 Jun 2019 21:15:19 +0000 (GMT)
Received: from [9.80.202.78] (unknown [9.80.202.78])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 21:15:19 +0000 (GMT)
Subject: Re: [RFC PATCH v1 0/5] s390: more vfio-ccw code rework
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190618202352.39702-1-farman@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Wed, 19 Jun 2019 17:15:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190618202352.39702-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061921-0072-0000-0000-0000043E8DA4
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011293; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01220388; UDB=6.00641986; IPR=6.01001530;
 MB=3.00027382; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-19 21:15:21
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061921-0073-0000-0000-00004CAE9A2E
Message-Id: <2eed767e-9e49-0dd5-6dcd-9e3ece84dc24@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/18/2019 04:23 PM, Eric Farman wrote:
> A couple little improvements to the malloc load in vfio-ccw.
> Really, there were just (the first) two patches, but then I
> got excited and added a few stylistic ones to the end.
> 
> The routine ccwchain_calc_length() has this basic structure:
> 
>    ccwchain_calc_length
>      a0 = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1))
>      copy_ccw_from_iova(a0, src)
>        copy_from_iova
>          pfn_array_alloc
>            b = kcalloc(len, sizeof(*pa_iova_pfn + *pa_pfn)
>          pfn_array_pin
>            vfio_pin_pages
>          memcpy(a0, src)
>          pfn_array_unpin_free
>            vfio_unpin_pages
>            kfree(b)
>      kfree(a0)
> 
> We do this EVERY time we process a new channel program chain,
> meaning at least once per SSCH and more if TICs are involved,
> to figure out how many CCWs are chained together.  Once that
> is determined, a new piece of memory is allocated (call it a1)
> and then passed to copy_ccw_from_iova() again, but for the
> value calculated by ccwchain_calc_length().
> 
> This seems inefficient.
> 
> Patch 1 moves the malloc of a0 from the CCW processor to the
> initialization of the device.  Since only one SSCH can be
> handled concurrently, we can use this space safely to
> determine how long the chain being processed actually is.
> 
> Patch 2 then removes the second copy_ccw_from_iova() call
> entirely, and replaces it with a memcpy from a0 to a1.  This
> is done before we process a TIC and thus a second chain, so
> there is no overlap in the storage in channel_program.
> 
> Patches 3-5 clean up some things that aren't as clear as I'd
> like, but didn't want to pollute the first two changes.
> For example, patch 3 moves the population of guest_cp to the
> same routine that copies from it, rather than in a called
> function.  Meanwhile, patch 4 (and thus, 5) was something I
> had lying around for quite some time, because it looked to
> be structured weird.  Maybe that's one bridge too far.
> 
> Eric Farman (5):
>    vfio-ccw: Move guest_cp storage into common struct
>    vfio-ccw: Skip second copy of guest cp to host
>    vfio-ccw: Copy CCW data outside length calculation
>    vfio-ccw: Factor out the ccw0-to-ccw1 transition
>    vfio-ccw: Remove copy_ccw_from_iova()
> 
>   drivers/s390/cio/vfio_ccw_cp.c  | 108 +++++++++++---------------------
>   drivers/s390/cio/vfio_ccw_cp.h  |   7 +++
>   drivers/s390/cio/vfio_ccw_drv.c |   7 +++
>   3 files changed, 52 insertions(+), 70 deletions(-)
> 

For this series:
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>

