Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C3F569E45
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 11:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiGGJGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 05:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiGGJGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 05:06:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F1E25C54;
        Thu,  7 Jul 2022 02:06:53 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2677DUGm030511;
        Thu, 7 Jul 2022 09:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kgjOMPa6yjbwXLxBTAuadJII4LMA9XeBw81yHIcCvLU=;
 b=j9nzWRfXC8ksk64ANKkeeKtDbP7d/nJ0AJbzToUYhtAhaB7QbSd6k/kJcecI1/r7Q8c6
 Ml915/7lIGE1j9LOL93VmARr8L/2olCifAAsMCxSAfak9VdPOu6QhN64rQ1YFO1oLhv+
 NcmEdeoywIRYULn3Z+qpEP1UABd4i2h472xDDm5SYqYZFyyP05OQjpOaEfCsuSR6QJg2
 g/al2ZWFoWL/cTY5G6WbUv7JD7DLiSwSMql1jabHAtR+cINQNdyKCBlauWpCGSzSfbb4
 nkosibNJDY8Om1FZN6XBmJWIDdLkaD0pJo5sLeN+xOSHAIHdVPSjlI2xeOhcLZkpr/QV uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5twfax1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 09:06:51 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2677aHSB040599;
        Thu, 7 Jul 2022 09:06:51 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h5twfax0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 09:06:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26795vGx003843;
        Thu, 7 Jul 2022 09:06:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsjass-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 09:06:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26796j8v20709634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jul 2022 09:06:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE6A35204F;
        Thu,  7 Jul 2022 09:06:45 +0000 (GMT)
Received: from [9.171.47.29] (unknown [9.171.47.29])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 698AC5204E;
        Thu,  7 Jul 2022 09:06:45 +0000 (GMT)
Message-ID: <e1ead3e4-9e7d-f026-485b-157d7dc004d3@linux.ibm.com>
Date:   Thu, 7 Jul 2022 11:06:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 00/11] s390/vfio-ccw rework
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
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
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220704112511.GO693670@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dnid-XhmVeYI25EmBWvlJInu2VSmR5dU
X-Proofpoint-GUID: NAb9ZlT0ubbNZIX2xwoGHF-gXYWTE9Wq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207070036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 04.07.22 um 13:25 schrieb Jason Gunthorpe:
> On Fri, Jul 01, 2022 at 02:48:25PM +0200, Christian Borntraeger wrote:
> 
>> Am 01.07.22 um 14:40 schrieb Eric Farman:
>>> On Thu, 2022-06-30 at 20:44 -0300, Jason Gunthorpe wrote:
>>>> On Thu, Jun 30, 2022 at 10:36:36PM +0200, Eric Farman wrote:
>>>>> Here's an updated pass through the first chunk of vfio-ccw rework.
>>>>>
>>>>> As with v2, this is all internal to vfio-ccw, with the exception of
>>>>> the removal of mdev_uuid from include/linux/mdev.h in patch 1.
>>>>>
>>>>> There is one conflict with the vfio-next branch [2], on patch 6.
>>>>
>>>> What tree do you plan to take it through?
>>>
>>> Don't know. I know Matt's PCI series has a conflict with this same
>>> patch also, but I haven't seen resolution to that. @Christian,
>>> thoughts?
>>
>>
>> What about me making a topic branch that it being merged by Alex AND the KVM tree
>> so that each of the conflicts can be solved in that way?
> 
> It make sense, I would base it on Alex's VFIO tree just to avoid
> some conflicts in the first place. Matt can rebase on this, so lets
> get things going?

So yes. Lets rebase on VFIO-next. Ideally Alex would then directly pick Eric
patches.
