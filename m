Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075C253F142
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiFFU7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbiFFU4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:56:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61411D336;
        Mon,  6 Jun 2022 13:45:26 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KZTWo009280;
        Mon, 6 Jun 2022 20:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/Nqq4nTpnREE1bO2MShNwp6k7mAETwQ61ZaqAvZ6vJE=;
 b=bjNwCp7MLKoZyFdJ8eZVG8rUwBDVVaEteClXit0d5eS1uNXsB6r8fvde1aX5yl5FFdM4
 422bPazV6K54RgqNnCysmJfuW6cmBEG0Gc1BgwZ99k/+0otFYdgIPLHxIOinJ9SkGW/Z
 QKeE8juXq3VFhnaks4S/TJQZJTecMNzxGGrUjuiGnYL/zc9QHhREL8lfZY5LFpZmQBk6
 ITLB4eZLRiV3C/D/Y/2MYVkg60PTSnij72nlqJrOAta+RnUL5VQMh3cPFWA7u0NJN8PT
 CTsvrNEWGezNniPx6kGxF09J3q5ZCP0Yu9WZrUeqTm6YsXTv3TzMAAgkfNro5BLnnWUk dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghrreg4kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:45:23 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KcWun020794;
        Mon, 6 Jun 2022 20:45:23 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghrreg4k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:45:23 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KL8wd013245;
        Mon, 6 Jun 2022 20:45:22 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04wdc.us.ibm.com with ESMTP id 3gfy19fwad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:45:22 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KjL7v11796960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:45:21 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BC7C6A047;
        Mon,  6 Jun 2022 20:45:21 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 752516A051;
        Mon,  6 Jun 2022 20:45:20 +0000 (GMT)
Received: from [9.163.20.188] (unknown [9.163.20.188])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:45:20 +0000 (GMT)
Message-ID: <54ae7d76-cf67-c77b-a7e9-608fb09674d9@linux.ibm.com>
Date:   Mon, 6 Jun 2022 16:45:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1 01/18] vfio/ccw: Remove UUID from s390 debug log
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-2-farman@linux.ibm.com>
 <715c1356-b700-f529-f7a8-bb917c8d95d5@linux.ibm.com>
 <a9ff5850a4964fe0238261c35591c3c18a4a8df3.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <a9ff5850a4964fe0238261c35591c3c18a4a8df3.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SrHLiSNjapbZxhEqYzLSdQVLebWgPnUX
X-Proofpoint-ORIG-GUID: TZtUwgXon9IcIuHTceSQxnnKmMdSaTaO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/22 3:03 PM, Eric Farman wrote:
> On Thu, 2022-06-02 at 15:51 -0400, Matthew Rosato wrote:
>> On 6/2/22 1:19 PM, Eric Farman wrote:
>>> From: Michael Kawano <mkawano@linux.ibm.com>
>>>
>>> As vfio-ccw devices are created/destroyed, the uuid of the
>>> associated
>>> mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost
>>> as
>>> they are created using pointers passed by reference.
>>>
>>> This is a deliberate design point of s390dbf, but it leaves the
>>> uuid
>>
>> This wording is confusing, maybe some re-wording would help here.
>>
>> Basically, s390dbf doesn't support values passed by reference today
>> (e.g. %pUl), it will just store that pointer (e.g. &mdev->uuid) and
>> not
>> its contents -- so a subsequent viewing of the s390dbf log at any
>> point
>> in the future will go peek at that referenced memory -- which might
>> have
>> been freed (e.g. mdev was removed).  So this change will fix
>> potential
>> garbage data viewed from the log or worse an oops when viewing the
>> log
>> -- the latter of which should probably be mentioned in the commit
>> message.
>>
>> I'm not sure if it was a deliberate design decision of s390dbf or
>> just a
>> feature that was never implemented, so I'd omit that altogether --
>> but
>> it IS pointed out in the s390dbf documentation as a limitation
>> anyway.
> 
> @Jason, @Matt...  All fair, I obviously got too verbose in whatever I
> was writing at the time. I've changed this to:
> 
> As vfio-ccw devices are created/destroyed, the uuid of the associated
> mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost.
> This is because a pointer to the UUID is stored instead of the UUID
> itself, and that memory may have been repurposed if/when the logs are
> examined. The result is usually garbage UUID data in the logs, though
> there is an outside chance of an oops happening here.
> 
> Simply remove the UUID from the traces, as the subchannel number will
> provide useful configuration information for problem determination,
> and is stored directly into the log instead of a pointer.
> 
> As we were the only consumer of mdev_uuid(), remove that too.
> 

Sounds good

