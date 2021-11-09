Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEADF44A9AF
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 09:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244518AbhKIIx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 03:53:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234536AbhKIIx6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 03:53:58 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A96IHVN024894
        for <kvm@vger.kernel.org>; Tue, 9 Nov 2021 08:51:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=quY43bOw0bY6ngLti0VDVEodPLT8BwkcsDnuVZBBu0I=;
 b=a0IzP8qwyU8TDFih0I0/rg3lgd6u0bTyjz78WA6/mtvuK+7/i92gqUJGN4fKeR38SpSC
 7nJn0ETneKP2o8/dKdXnM7+GN7lim9KZv53BeEpfyCGprzLbyXu76oLMQm4Zx0D4Nsit
 AGT1nCkh3aP3j2umX1GgdcU/ACc/LAEOB+LGe6Z312BZVE+8huNumISm94E0Vjab+Q5d
 FLIqUJ6Q23u0/ZjpIXgUIbAf9KL+tpnotPXnbaZOGzkRSJ6hgGeB7g+uXdyn92DyRVjo
 xCtuZ0IPxkCQjUKyMHcyKmNO6i2hxzY6lTMlJvCxWeTblc7cXkkMRkMYmbzoZz7N7Cvs JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c7kksb5re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 08:51:12 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A98Y2QD030308
        for <kvm@vger.kernel.org>; Tue, 9 Nov 2021 08:51:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c7kksb5qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 08:51:12 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A98mEO1018769;
        Tue, 9 Nov 2021 08:51:10 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3c5hba3tmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Nov 2021 08:51:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A98iR4e61604344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Nov 2021 08:44:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1CC442049;
        Tue,  9 Nov 2021 08:51:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 793454204C;
        Tue,  9 Nov 2021 08:51:06 +0000 (GMT)
Received: from [9.171.88.190] (unknown [9.171.88.190])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Nov 2021 08:51:06 +0000 (GMT)
Message-ID: <237b045d-6840-0df6-c358-5d4b34097f22@linux.ibm.com>
Date:   Tue, 9 Nov 2021 09:51:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport
 implementation
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
 <74901bd1-e69f-99d3-b11e-e0b541226d20@redhat.com>
 <509a8f4f-89cc-fe80-4200-6776c503adbf@linux.ibm.com>
 <92a0b4a1-0888-3b99-a089-d2096272eee7@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <92a0b4a1-0888-3b99-a089-d2096272eee7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3uTUXT2kRzEdw1uQ8rxlvtZ09aA_HQNl
X-Proofpoint-GUID: G40SMIWU62kUwcdmH_X0o9IhO28DYbS9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-09_02,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/9/21 08:01, Thomas Huth wrote:
> On 08/11/2021 13.34, Pierre Morel wrote:
>>
>>
>> On 11/3/21 08:49, Thomas Huth wrote:
>>> On 27/08/2021 12.17, Pierre Morel wrote:
>>>> This is the implementation of the virtio-ccw transport level.
>>>>
>>>> We only support VIRTIO revision 0.
>>>
>>> That means only legacy virtio? Wouldn't it be better to shoot for 
>>> modern virtio instead?
>>
>> Yes but can we do it in a second series?
> 
> Sure.
> 
>>>> +int virtio_ccw_read_features(struct virtio_ccw_device *vcdev, 
>>>> uint64_t *features)
>>>> +{
>>>> +    struct virtio_feature_desc *f_desc = &vcdev->f_desc;
>>>> +
>>>> +    f_desc->index = 0;
>>>> +    if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 
>>>> 0))
>>>> +        return -1;
>>>> +    *features = swap32(f_desc->features);
>>>> +
>>>> +    f_desc->index = 1;
>>>> +    if (ccw_send(vcdev, CCW_CMD_READ_FEAT, f_desc, sizeof(*f_desc), 
>>>> 0))
>>>> +        return -1;
>>>> +    *features |= (uint64_t)swap32(f_desc->features) << 32;
>>>
>>> Weren't the upper feature bits only available for modern virtio anyway?
>>
>> Yes.
>> I have the intention to upgrade to Rev. 1 when I get enough time for it.
>> Should I remove this? It does not induce problem does it?
> 
> No problem - maybe simply add a comment that the upper bits are for 
> virtio 1.0 and later.

OK,
Thanks,

Pierre

> 
>   Thomas
> 

-- 
Pierre Morel
IBM Lab Boeblingen
