Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F094B4DCE0A
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 19:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiCQSxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 14:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237666AbiCQSxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 14:53:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD00221BBF;
        Thu, 17 Mar 2022 11:52:22 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22HGA5i9001293;
        Thu, 17 Mar 2022 18:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AQwtyhv7u4jjFpfrN5RAEteV2hqGptEPoejBb+YABXE=;
 b=rgUPGTIEIbdE4SFQusnyo0PLGn5H5QdjWIq+wdTNqYnVxKxoS/Fyw1wz4DKaUrCgHPbV
 4NJQlezP1RokvPtYLAT1n7SDet4P1x5+UQ9fcN0XjUbEeARReVtWNLojBgA1EJoUo8ML
 PL1yqaC+FVuc9hnJ6r4KAUuDdPyNpzbTMkyK4doFIjnyDJ2eOE25SkMcQpjfr4C4IPuq
 gEQyELT1susg4Cw76LfqRVKni9RUeFJAGhM2Ohla0CIXuLLfm6cjhShufl34cYKKqhVp
 p9fjvf4ICvxH1Znuu4JUh0cXiIpxwa5ouw2qA+IjNgtlJkI1Y7dxjLXlWbBMq+Mhuyy2 eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev1vq3peq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 18:52:15 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22HIHWe4020959;
        Thu, 17 Mar 2022 18:52:15 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev1vq3peb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 18:52:15 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22HIltAc002410;
        Thu, 17 Mar 2022 18:52:13 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3erk5a59u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 18:52:13 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22HIqCAc24903946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 18:52:12 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFFAC6A054;
        Thu, 17 Mar 2022 18:52:11 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9285C6A05D;
        Thu, 17 Mar 2022 18:52:09 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 17 Mar 2022 18:52:09 +0000 (GMT)
Message-ID: <494fe1b2-cf44-23a6-a494-52a44041ad79@linux.ibm.com>
Date:   Thu, 17 Mar 2022 14:51:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314213808.GI11336@nvidia.com>
 <decc5320-eb3e-af25-fd2b-77fabe56a897@linux.ibm.com>
 <20220315143858.GY11336@nvidia.com>
 <5a1c64ac-df10-fb66-ad6d-39adf786f32b@linux.ibm.com>
 <20220315172555.GJ11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220315172555.GJ11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kuQpxA9M7txDOpig1s9KywXmLwC1zk1i
X-Proofpoint-ORIG-GUID: mz6xbnGtBK1Vtsvhdc1q5_yO2bxU49u5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_07,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203170104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 1:25 PM, Jason Gunthorpe wrote:
> On Tue, Mar 15, 2022 at 12:29:02PM -0400, Matthew Rosato wrote:
>> On 3/15/22 10:38 AM, Jason Gunthorpe wrote:
>>> On Tue, Mar 15, 2022 at 09:49:01AM -0400, Matthew Rosato wrote:
>>>
>>>> The rationale for splitting steps 1 and 2 are that VFIO_SET_IOMMU doesn't
>>>> have a mechanism for specifying more than the type as an arg, no?  Otherwise
>>>> yes, you could specify a kvm fd at this point and it would have some other
>>>> advantages (e.g. skip notifier).  But we still can't use the IOMMU for
>>>> mapping until step 3.
>>>
>>> Stuff like this is why I'd be much happier if this could join our
>>> iommfd project so we can have clean modeling of the multiple iommu_domains.
>>>
>>
>> I'd certainly be willing to collaborate so feel free to loop me in on the
>> discussions;
> 
> Sure, I have you on my list. I've been waiting for Eric to get a bit
> further along on his ARM work so you have something appropriate to
> look at.
> 
> In the mean time you can certainly work out the driver details as
> you've been doing here and hacking through VFIO. The iommu_domain
> logic is the big work item in this series, not the integration with
> the uAPI.
>

A subset of this series (enabling some s390x firmware-assist facilities) 
is not tied to the iommu and would still provide value while continuing 
to use vfio_iommu_type1 for all mapping -- so I think I'll look into a 
next version that shrinks down to that subset (+ re-visit the setup API).

Separate from that, I will continue looking at implementing the nested 
iommu_domain logic for s390, and continue to hack through VFIO for now. 
I'll use an RFC series when I have something more to look at, likely 
starting with the fully-pinned guest as you suggest; ultimately I'm 
interested in both scenarios (pinned kvm guest & dynamic pinning during 
shadow)

Thanks,
Matt
