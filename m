Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3A63ACC8
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiK1PlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 10:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiK1PlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 10:41:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569D81F2FF
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 07:40:59 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASF3GqK024715;
        Mon, 28 Nov 2022 15:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k9dv9QUnUE7rShQox6lT7Q/nRcVH1DhAzktVIIAYzMU=;
 b=sGghnoLrjTGUlVjwEPksJeq81IXnBS07g2bjxAu4ZZwvIFnP85YKQN936jWpTLyNPlll
 Ulju35OF3bHPa1dyCYM0FMiVG2pfRPK5ilKqff94iFVDgTh26AdNl2KcSZ3GjCrVA6rF
 iYhEZzNtqgwuPIAQxJIXuxxB3bWvFQom1zgZ+Ojtc026h0GdYVYisusCUIZhdKstYuzo
 ZhFh8KrTcS7NcG2iyi7KwlhUsf1OX7uYHAMLwOCObg+1luGLwTWE8Re/nFewvSOqs4QP
 cX2GOwn+s9FVFfDhEH62d+lomci97bzYyc2wAQ9732DBKqFESQ2WQAXIY51ySbNMPxzS UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vpm2eq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:40:54 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASF9qjc011542;
        Mon, 28 Nov 2022 15:40:53 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vpm2epm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:40:53 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASFZoYw001719;
        Mon, 28 Nov 2022 15:40:52 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 3m3ae9a0pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:40:52 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASFeo1K6423048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 15:40:51 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6894358068;
        Mon, 28 Nov 2022 15:40:50 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23CA05805A;
        Mon, 28 Nov 2022 15:40:49 +0000 (GMT)
Received: from [9.160.4.194] (unknown [9.160.4.194])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 15:40:48 +0000 (GMT)
Message-ID: <eb75c2bc-8142-116d-6b03-7a79bf7aef77@linux.ibm.com>
Date:   Mon, 28 Nov 2022 10:40:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger
 irq disable
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
 <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y39qrCtw0d0dfbLt@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y39qrCtw0d0dfbLt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FeMU5bF7xtFpZzoc0bD2EMhepD6qmM5V
X-Proofpoint-GUID: TeD4q_76smtK40Agk13sjW2RtbUHiud4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_11,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280115
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/22 7:59 AM, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2022 at 07:08:06AM +0000, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Wednesday, November 23, 2022 9:49 PM
>>>
>>> From: Matthew Rosato <mjrosato@linux.ibm.com>
>>>
>>> vfio_iommufd_bind() creates an access which has an unmap callback, which
>>> can be called immediately. So dma_unmap() callback should tolerate the
>>> unmaps that come before the emulated device is opened.
>>>
>>> To achieve above, vfio_ap_mdev_dma_unmap() needs to validate that
>>> unmap
>>> request matches with one or more of these stashed values before
>>> attempting unpins.
>>>
>>> Currently, each mapped iova is stashed in its associated vfio_ap_queue;
>>> Each stashed iova represents IRQ that was enabled for a queue. Therefore,
>>> if a match is found, trigger IRQ disable for this queue to ensure that
>>> underlying firmware will no longer try to use the associated pfn after
>>> the page is unpinned. IRQ disable will also handle the associated unpin.
>>>
>>> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
>>> Cc: Halil Pasic <pasic@linux.ibm.com>
>>> Cc: Jason Herne <jjherne@linux.ibm.com>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>> ---
>>>  drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++++++++++++-
>>>  1 file changed, 23 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
>>> b/drivers/s390/crypto/vfio_ap_ops.c
>>> index bb7776d20792..62bfca2bbe6d 100644
>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>> @@ -1535,13 +1535,35 @@ static int vfio_ap_mdev_set_kvm(struct
>>> ap_matrix_mdev *matrix_mdev,
>>>  	return 0;
>>>  }
>>>
>>> +static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova,
>>> u64 length)
>>> +{
>>> +	struct ap_queue_table *qtable = &matrix_mdev->qtable;
>>> +	u64 iova_pfn_end = (iova + length - 1) >> PAGE_SHIFT;
>>> +	u64 iova_pfn_start = iova >> PAGE_SHIFT;
>>> +	struct vfio_ap_queue *q;
>>> +	int loop_cursor;
>>> +	u64 pfn;
>>> +
>>> +	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
>>> +		pfn = q->saved_iova >> PAGE_SHIFT;
>>> +		if (pfn >= iova_pfn_start && pfn <= iova_pfn_end) {
>>> +			vfio_ap_irq_disable(q);
>>> +			break;
>>
>> does this need a WARN_ON if the length is more than one page?
> 
> The iova and length are the range being invalidated, the driver has no
> control over them and length is probably multiple pages.
> 
> But this test doesn't look right?
> 
>    if (iova > q->saved_iova && q->saved_iova < iova + length)> 
> Since the page was pinned we can assume iova and length are already
> PAGE_SIZE aligned.

Yeah, I think that would be fine with a minor tweak to pick up q->saved_iova at the very start of the iova range:

   if (iova >= q->saved_iova && q->saved_iova < iova + length)

