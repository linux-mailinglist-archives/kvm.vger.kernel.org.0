Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9656A333
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 15:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiGGNLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 09:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiGGNLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 09:11:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A13220E1;
        Thu,  7 Jul 2022 06:11:39 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267D42AX017143;
        Thu, 7 Jul 2022 13:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0u3cw8qnLPhH+rDFw145eM7xNajBL24vYjGRXTXk0Zc=;
 b=IaLpKmxlNu8WaB3kpQhcJn8SCR0NrCg97QclNFu4x9yAUxC4NboLr/VgwV9BM/IC6/sB
 /aG0FoiYBUUrY1Zi+Qb/yT4DE7aT/Eby6t3VW4B2T+Zne1NyOt01A4uDKQraxWBTbv22
 NU9fzgtKqXO90GgK/2FMoF8sT5JqGrHzuldhY0ra49Q+mWsC1ysDxJpiXYjPKj7eOGSs
 x3ELoQGRDZjGIOXNoQpbhdydWcuL3HIXTgz5DLwZ2671SqnKl/jtjzAXgDY2ZeMss+D8
 CtGH6tisBfuvPT4ulghL8vjW9pnkYtjvtzPCAvOOz1ixkoM0FlhHBTUOT5Gu89BV/s1R tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5w5adg5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:11:37 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267BUGRP021844;
        Thu, 7 Jul 2022 13:11:36 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5w5adg4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:11:35 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267D6g8v002555;
        Thu, 7 Jul 2022 13:11:35 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3h4ucnueuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 13:11:35 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267DBYHq33816944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 13:11:34 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F1F128060;
        Thu,  7 Jul 2022 13:11:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB74D2805C;
        Thu,  7 Jul 2022 13:11:31 +0000 (GMT)
Received: from [9.211.36.1] (unknown [9.211.36.1])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jul 2022 13:11:31 +0000 (GMT)
Message-ID: <28f45fa6-0f0f-b854-9b07-c78a3fadff62@linux.ibm.com>
Date:   Thu, 7 Jul 2022 09:11:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630234411.GM693670@nvidia.com>
 <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
 <f21307d9-6490-c39d-cff0-2a50c5f1cb35@linux.ibm.com>
 <20220704112511.GO693670@nvidia.com>
 <e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com>
 <145a84e4-e228-0f18-eebe-7488f8b07d67@linux.ibm.com>
 <0b2501e7-0e5c-9bf6-3317-611b96f44c58@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0b2501e7-0e5c-9bf6-3317-611b96f44c58@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MgA-y3qizdvoAAjMnqtxoVrNZUWHcVM5
X-Proofpoint-GUID: eLqi_GcsBQjbV5y4-uMsM2LbJMWDqmhv
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 spamscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/22 9:04 AM, Christian Borntraeger wrote:
> Am 07.07.22 um 14:34 schrieb Matthew Rosato:
>> On 7/7/22 5:06 AM, Christian Borntraeger wrote:
>>>
>>>
>>> Am 04.07.22 um 13:25 schrieb Jason Gunthorpe:
>>>> On Fri, Jul 01, 2022 at 02:48:25PM +0200, Christian Borntraeger wrote:
>>>>
>>>>> Am 01.07.22 um 14:40 schrieb Eric Farman:
>>>>>> On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
>>>>>>> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
>>>>>>>> Here's an updated pass through the first chunk of vfio-ccw rework.
>>>>>>>>
>>>>>>>> As with v2, this is all internal to vfio-ccw, with the exception of
>>>>>>>> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
>>>>>>>>
>>>>>>>> There is one conflict with the vfio-next branch [2], on patch 6.
>>>>>>>
>>>>>>> What tree do you plan to take it through?
>>>>>>
>>>>>> Don't know. I know Matt's PCI series has a conflict with this same
>>>>>> patch also, but I haven't seen resolution to that. @Christian,
>>>>>> thoughts?
>>>>>
>>>>>
>>>>> What about me making a topic branch that it being merged by Alex 
>>>>> AND the KVM tree
>>>>> so that each of the conflicts can be solved in that way?
>>>>
>>>> It make sense, I would base it on Alex's VFIO tree just to avoid
>>>> some conflicts in the first place. Matt can rebase on this, so lets
>>>> get things going?
>>>
>>> So yes. Lets rebase on VFIO-next. Ideally Alex would then directly 
>>> pick Eric
>>> patches.
>>
>> @Christian to be clear, do you want me to also rebase the zPCI series 
>> on vfio-next then?
> 
> For that we are probably better of me having a topic branch that is then 
> merged by Alex
> and Paolo. Alex, Paolo, would be make sense?

For reference if needed, the zPCI series in question:
https://lore.kernel.org/linux-s390/20220606203325.110625-1-mjrosato@linux.ibm.com/

> 
> As an alternative: will the vfio patches build without the KVM patches 
> and vice versa,
> I assume not?

No, there are dependencies in both directions.

At this point if the topic branch is how we will proceed then I suggest 
just taking v9 as-is; the few minor nit comments from Pierre can be 
addressed as follow-ons if desired.
