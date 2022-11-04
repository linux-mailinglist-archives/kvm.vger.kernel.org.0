Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BBF619AC3
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 15:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiKDO7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 10:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiKDO6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 10:58:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9964CA4
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 07:58:20 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4DZAOc028673;
        Fri, 4 Nov 2022 14:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Fyuo93m4F2dIpXl+bNdSko4Nid5gkbEtt33cOeSzgKk=;
 b=lj8QmjEVXEuY2Uj/Vj2CAh9fbBRKl5Sf/swNcHq/qmMstG0p82vAesCYalZvnnAUsiwe
 SJWy7+YaBHs5hMumzvOaYVg14Xz//RYUDHXr3DMkT13NjiW35H4aMiFCTbjiPJjgoHeQ
 a50TorPyCjhToRcNb3DiHw/62yEG47kFxaKQQymKK2669HkZFkfVAPxJmUdoThyh6XW9
 gpnmy2Q6UyTKmDSZQqiu1Oq6Eaall/VF/z3MBIHla+MG5a/RIRDe59bGz69T4jGA33Hs
 3h3od2oBMGO3GQManrOSlf0Zc8BInxcBC4bdcfoLgaCkjDNQbe1GJu8uDpTOOajkMDwY 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmphftk1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 14:58:05 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A49PPmT002009;
        Fri, 4 Nov 2022 14:58:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kmphftk02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 14:58:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A4EpZ5R024229;
        Fri, 4 Nov 2022 14:58:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kguej2j7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Nov 2022 14:58:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A4EqOYK49676732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Nov 2022 14:52:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A328AE04D;
        Fri,  4 Nov 2022 14:57:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2ED35AE045;
        Fri,  4 Nov 2022 14:57:58 +0000 (GMT)
Received: from [9.171.69.218] (unknown [9.171.69.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Nov 2022 14:57:58 +0000 (GMT)
Message-ID: <7177da22-ca19-6510-9bf3-4120140f5431@linux.ibm.com>
Date:   Fri, 4 Nov 2022 15:57:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v11 01/11] s390x: Register TYPE_S390_CCW_MACHINE
 properties as class properties
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-2-pmorel@linux.ibm.com>
 <3f913a58-e7d0-539e-3bc0-6cbd5608db8e@redhat.com>
 <7d809617-67e0-d233-97b2-8534e2a4610f@linux.ibm.com>
 <6415cf08-e6a1-c72a-1c56-907d3a446a8c@kaod.org>
 <7a3c34dc-2c16-6fdd-e8bc-7a1c623823ae@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7a3c34dc-2c16-6fdd-e8bc-7a1c623823ae@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R9INAsguU-ve2zQKYO0f4SuJ9kpdZ2m_
X-Proofpoint-ORIG-GUID: Jqc-cGEB8wQb1HKSWrsARiGLpaER4zVX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_09,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211040095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/4/22 15:29, Thomas Huth wrote:
> On 04/11/2022 11.53, Cédric Le Goater wrote:
>> On 11/4/22 11:16, Pierre Morel wrote:
>>>
>>>
>>> On 11/4/22 07:32, Thomas Huth wrote:
>>>> On 03/11/2022 18.01, Pierre Morel wrote:
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> ---
>>>>>   hw/s390x/s390-virtio-ccw.c | 127 
>>>>> +++++++++++++++++++++----------------
>>>>>   1 file changed, 72 insertions(+), 55 deletions(-)
>>>>
>>>> -EMISSINGPATCHDESCRIPTION
>>>>
>>>> ... please add some words *why* this is a good idea / necessary.
>>>
>>> I saw that the i386 patch had no description for the same patch so...
>>>
>>> To be honest I do not know why it is necessary.
>>> The only reason I see is to be in sync with the PC implementation.
>>>
>>> So what about:
>>> "
>>> Register TYPE_S390_CCW_MACHINE properties as class properties
>>> to be conform with the X architectures
>>> "
>>> ?
>>>
>>> @Cédric , any official recommendation for doing that?
>>
>> There was a bunch of commits related to QOM in this series :
>>
>>    91def7b83 arm/virt: Register most properties as class properties
>>    f5730c69f0 i386: Register feature bit properties as class properties
>>
>> which moved property definitions at the class level.
>>
>> Then,
>>
>>    commit d8fb7d0969 ("vl: switch -M parsing to keyval")
>>
>> changed machine_help_func() to use a machine class and not machine
>> instance anymore.
>>
>> I would use the same kind of commit log and add a Fixes tag to get it
>> merged in 7.2
> 
> Ah, so this fixes the problem that running QEMU with " -M 
> s390-ccw-virtio,help" does not show the s390x-specific properties 
> anymore? ... that's certainly somethings that should be mentioned in the 
> commit message! What about something like this:
> 
> "Currently, when running 'qemu-system-s390x -M -M s390-ccw-virtio,help' 
> the s390x-specific properties are not listed anymore. This happens 
> because since commit d8fb7d0969 ("vl: switch -M parsing to keyval") the 
> properties have to be defined at the class level and not at the instance 
> level anymore. Fix it on s390x now, too, by moving the registration of 
> the properties to the class level"
> 
> Fixes: d8fb7d0969 ("vl: switch -M parsing to keyval")
> 
> ?
> 
>   Thomas
> 

That seems really good :)

Thank you Thomas!

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
