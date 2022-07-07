Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6940356A20E
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 14:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbiGGMeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 08:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiGGMeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 08:34:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF9120BDA;
        Thu,  7 Jul 2022 05:34:09 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267Ap82d004427;
        Thu, 7 Jul 2022 12:34:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1vHgShsbwg2jnxELq/Ys8sNZMhkEsAgM8GeGHUfbsXA=;
 b=fpdb90G7YJueqaA1BaNi+3m3gLYv99zZF8cMM+45704DeqmYGVik6HybQVovJhPCTyhK
 DmEzvd6eI1Zt+dxOk4ZDOjUc+8wGLZICyhPxQLxrt9xhvx6g7AWtkOBEZAkBI81ChO7K
 zJgczW1yJ2aWnii7VBinp+C/E7h4ocwv5KS4zgybsbGScT8DoCJPSCTqRXBOrB9b47hb
 Nv0EME1RYhbL+XTwWWJv2cNBVC+3Sk4TgkZWvdJovsPW814Sc1873CK/BAiiDjFg2dmH
 JT9D0B5v4/aYWtTbDvefs+zl1bo738wvUwcqDUeKuef66hmINtSTkYG1GPJEbqKV0QW9 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5x3p2swb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 12:34:07 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 267CKdPc024779;
        Thu, 7 Jul 2022 12:34:07 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5x3p2svp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 12:34:07 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 267CKbi2000597;
        Thu, 7 Jul 2022 12:34:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3h4uqy5udm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 12:34:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 267CY5Q820775370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 12:34:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A42C2805A;
        Thu,  7 Jul 2022 12:34:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 311FA2805E;
        Thu,  7 Jul 2022 12:34:03 +0000 (GMT)
Received: from [9.211.36.1] (unknown [9.211.36.1])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jul 2022 12:34:02 +0000 (GMT)
Message-ID: <145a84e4-e228-0f18-eebe-7488f8b07d67@linux.ibm.com>
Date:   Thu, 7 Jul 2022 08:34:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220630203647.2529815-1-farman@linux.ibm.com>
 <20220630234411.GM693670@nvidia.com>
 <e8f1748eb1bae3e90521b0d5d4471266f4ea7c98.camel@linux.ibm.com>
 <f21307d9-6490-c39d-cff0-2a50c5f1cb35@linux.ibm.com>
 <20220704112511.GO693670@nvidia.com>
 <e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s6LJlfk9LR0M1-dhXCRd7rgqirjZ5167
X-Proofpoint-GUID: G3VVpAX-YjGPNW5OpgRkeBIcX7bxBUNa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/7/22 5:06 AM, Christian Borntraeger wrote:
> 
> 
> Am 04.07.22 um 13:25 schrieb Jason Gunthorpe:
>> On Fri, Jul 01, 2022 at 02:48:25PM +0200, Christian Borntraeger wrote:
>>
>>> Am 01.07.22 um 14:40 schrieb Eric Farman:
>>>> On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
>>>>> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
>>>>>> Here's an updated pass through the first chunk of vfio-ccw rework.
>>>>>>
>>>>>> As with v2, this is all internal to vfio-ccw, with the exception of
>>>>>> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
>>>>>>
>>>>>> There is one conflict with the vfio-next branch [2], on patch 6.
>>>>>
>>>>> What tree do you plan to take it through?
>>>>
>>>> Don't know. I know Matt's PCI series has a conflict with this same
>>>> patch also, but I haven't seen resolution to that. @Christian,
>>>> thoughts?
>>>
>>>
>>> What about me making a topic branch that it being merged by Alex AND 
>>> the KVM tree
>>> so that each of the conflicts can be solved in that way?
>>
>> It make sense, I would base it on Alex's VFIO tree just to avoid
>> some conflicts in the first place. Matt can rebase on this, so lets
>> get things going?
> 
> So yes. Lets rebase on VFIO-next. Ideally Alex would then directly pick 
> Eric
> patches.

@Christian to be clear, do you want me to also rebase the zPCI series on 
vfio-next then?
