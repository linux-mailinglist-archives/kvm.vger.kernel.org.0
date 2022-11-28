Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BDC63ACAE
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 16:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiK1PdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 10:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiK1PdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 10:33:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8CCDFA4
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 07:32:59 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASFWSu8031865;
        Mon, 28 Nov 2022 15:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=s8zU5+BWRU2PlsOmINLAc0Kpbn5+znsTLMYvYuB5LM4=;
 b=sKIkpQ90gof4CDKn2kQWJNCnhi0Iut2YEPoekXIAy1VAEcCM7msJsqbgm+ZpvG2USEj/
 DUTFxMa3VnMa+0zS0pX/zFgzhxj9KP+bMW2YyKq+iYVFv5jU46iz4ux1MuMgkotE0Iea
 XpJNPO2nXn5+vrCeNn4spxnt2FYe0yRclvqTOhjmZuT+xEMzy3fumqkTrf8t53NN4a78
 kCWKcEWznhUldTqHOUYChs4QsI/n7W4ks+mtlJirVxMYibpYHzJhtrh+cc9SLmj8sw+A
 GZWp2djDHKjrMEdgTjvvjAU8UOBrZr0YgdmBUAEiJd4vPFOGfSco2fa6yjXAOz4p93gg rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vjdcnuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:32:55 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASCx4tP010211;
        Mon, 28 Nov 2022 15:32:55 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vjdcntr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:32:55 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASFL1LL024524;
        Mon, 28 Nov 2022 15:32:53 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3m3ae9pebx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:32:53 +0000
Received: from smtpav03.wdc07v.mail.ibm.com ([9.208.128.112])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASFWqBT35651886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 15:32:52 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8A1B5806E;
        Mon, 28 Nov 2022 15:32:51 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C4F758054;
        Mon, 28 Nov 2022 15:32:50 +0000 (GMT)
Received: from [9.160.4.194] (unknown [9.160.4.194])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 15:32:50 +0000 (GMT)
Message-ID: <9a2149d3-2a0b-2cfc-3345-b45288f57e20@linux.ibm.com>
Date:   Mon, 28 Nov 2022 10:32:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger
 irq disable
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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
 <BN9PR11MB5276902DF936A54E52A6EDBF8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <BN9PR11MB5276902DF936A54E52A6EDBF8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i6lpQ9bRSOnZlz8MUJJLSo-aD-lOZCjU
X-Proofpoint-ORIG-GUID: kYu1nwyD8uCv3nTFwUIq0n635lVn_XPU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_13,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=599 bulkscore=0 spamscore=0 suspectscore=0
 clxscore=1011 impostorscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280115
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/28/22 1:31 AM, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Thursday, November 24, 2022 8:59 PM
>>
>> On Thu, Nov 24, 2022 at 07:08:06AM +0000, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Wednesday, November 23, 2022 9:49 PM
>>>> +static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova,
>>>> u64 length)
>>>> +{
>>>> +	struct ap_queue_table *qtable = &matrix_mdev->qtable;
>>>> +	u64 iova_pfn_end = (iova + length - 1) >> PAGE_SHIFT;
>>>> +	u64 iova_pfn_start = iova >> PAGE_SHIFT;
>>>> +	struct vfio_ap_queue *q;
>>>> +	int loop_cursor;
>>>> +	u64 pfn;
>>>> +
>>>> +	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
>>>> +		pfn = q->saved_iova >> PAGE_SHIFT;
>>>> +		if (pfn >= iova_pfn_start && pfn <= iova_pfn_end) {
>>>> +			vfio_ap_irq_disable(q);
>>>> +			break;
>>>
>>> does this need a WARN_ON if the length is more than one page?
>>
>> The iova and length are the range being invalidated, the driver has no
>> control over them and length is probably multiple pages.
> 
> Yes. I'm misled by the 'break'. Presumably all queues covered by
> the unmapped range should have interrupt disabled while above only
> disables interrupt for the first covered queue.

Oops, yeah the break shouldn't be there; we want to disable any queue in the table that falls within the iova range.

