Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01245623344
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 20:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiKITNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 14:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiKITNg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 14:13:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D8F6328;
        Wed,  9 Nov 2022 11:13:35 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9Id9Me005218;
        Wed, 9 Nov 2022 19:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Wj5gLw/WjfL7aTPc5gojcjD5pl2mrG+cbeay+gqSGR4=;
 b=WjjQa5a/pAF6Sui/5CKTAA3a+vC8C0nFYAmKAfMw3PDgbSKAgx4FPZj2eVvcCcVQXxFC
 fSJVhmnycKpMsSHNETG2VOunM8Wf8H5G5zJx5H4GcMh3fP0WVMT+HeN2Byy46L2HA+QB
 n/dyHbItQcnz81q5cHej1RvANtrbPN5U9rR22YRlB7D6G55leMEUUi39ncFNGHwclVwT
 CDLouAh3OU/kjAmU3HAk8M+64Bs6d8RltGLsj/a6ao6PryN0HyCTWu3rX4wVsT+Q6GuM
 EaVx4BrvikerVjZJEdXX5oUHDjV7qJey4tAlrtuBFgVS3mEP1XjrEP1LaASIA9WuBX9a ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3krgmw2dnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 19:13:26 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A9It2r8027998;
        Wed, 9 Nov 2022 19:13:26 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3krgmw2dn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 19:13:26 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A9J5oAm010655;
        Wed, 9 Nov 2022 19:13:25 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 3kngs7fn0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 19:13:25 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A9JDP6U2425492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Nov 2022 19:13:26 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D662758065;
        Wed,  9 Nov 2022 19:13:23 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC2BD5805D;
        Wed,  9 Nov 2022 19:13:22 +0000 (GMT)
Received: from [9.160.53.158] (unknown [9.160.53.158])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  9 Nov 2022 19:13:22 +0000 (GMT)
Message-ID: <aef32076-6431-cdf2-4193-5e62549384ab@linux.ibm.com>
Date:   Wed, 9 Nov 2022 14:13:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: S390 testing for IOMMUFD
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
 <d814e245-2255-15ce-cf3d-65788aa61689@linux.ibm.com>
 <73dd6b0e-35c7-bb5d-b392-a9de012d4f92@linux.ibm.com>
 <Y2vRYUXvIG21ytkT@nvidia.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <Y2vRYUXvIG21ytkT@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yM0u9vrQT78X6GxEHh0I-Tj9VH395SA4
X-Proofpoint-ORIG-GUID: fRMfp2rrFJEZqNUiKzQgq3pcgtlQ4gug
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/9/22 11:12 AM, Jason Gunthorpe wrote:
> On Wed, Nov 09, 2022 at 09:49:01AM -0500, Anthony Krowiak wrote:
>> I cloned the https://lore.kernel.org/kvm/Y2q3nFXwOk9jul5u@nvidia.com/T/#m76a9c609c5ccd1494c05c6f598f9c8e75b7c9888
>> repo and ran the vfio_ap test cases. The tests ran without encountering the
>> errors related to the vfio_pin_pages() function
> I updated the git repos with this change now
>
>> but I did see two tests fail attempting to run crypto tests on the
>> guest. I also saw a WARN_ON stack trace in the dmesg output
>> indicating a timeout occurred trying to verify the completion of a
>> queue reset. The reset problem has reared its ugly head in our CI,
>> so this may be a good thing as it will allow me to debug why its
>> happening.
> Please let me know if you think this is iommufd related, from your
> description it sounds like an existing latent bug?


Just in case you missed my response to my previous email, the problems I 
was seeing were due to using a set regression tests that I patched to 
try to improve the tests performance. When I ran the vanilla tests they 
ran successfully without any problems with your patch. I will continue 
testing but as of now, it looks good to me.


>
> Thanks,
> Jason
