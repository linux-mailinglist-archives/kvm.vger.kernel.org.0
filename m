Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997DF60DCE8
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 10:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiJZISQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 04:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiJZISO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 04:18:14 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491294137;
        Wed, 26 Oct 2022 01:18:13 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q7912K028256;
        Wed, 26 Oct 2022 08:18:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MPfgZwv29DYJUEfpdJlIKjNHD5V5iJrN/pklKR3ByZM=;
 b=R1OmqoX7cibwzTkVJ3gssgrwcBPbzXu+0c3Bm2sObp1fVB4EeLVRf0rhTl16KdRuAKP0
 qdDjg6UFB7WLJrFBipZiQ0VIS/W+7TCzinCWZBfiJpsNY5g7UxqU5YDfAuXNqFkETSay
 4xCZZCL9rdPYnyteDesJ7Bm8cUfj3eRrnigTciVKObftlLlI5BBBiySRxEabmHejSISb
 gCGXygsJQ8ASBut1X4u112K07ibsnrjUJOfeqSbIeu1UkGAUxZh3bCkFXPnLuZAg3/Lv
 eupIE5wWz7fZyJrqroj/ZVMbZeSOZhhgT3HKFcnzgZiGSz4F17GcD+E4xPlAje6j9QY+ Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keydmucjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 08:18:13 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29Q7qoLk009174;
        Wed, 26 Oct 2022 08:18:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keydmuchr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 08:18:12 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29Q87095015288;
        Wed, 26 Oct 2022 08:18:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kc7sj71yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Oct 2022 08:18:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29Q8CqSe49873252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 08:12:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73613AE045;
        Wed, 26 Oct 2022 08:18:07 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8C16AE04D;
        Wed, 26 Oct 2022 08:18:06 +0000 (GMT)
Received: from [9.171.85.254] (unknown [9.171.85.254])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Oct 2022 08:18:06 +0000 (GMT)
Message-ID: <d29c3e4d-89cb-88dc-6809-5b52c8a2525e@linux.ibm.com>
Date:   Wed, 26 Oct 2022 10:18:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: clarifications on setting the
 APCB
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
References: <20221025091319.37110-1-pmorel@linux.ibm.com>
 <20221025091319.37110-2-pmorel@linux.ibm.com>
 <e9a237d7-3a34-11c8-1c5b-1a3c14e8cfb0@redhat.com>
 <0117e263-2856-b2fd-1e61-59b21e5da2e5@linux.ibm.com>
 <20221025182039.6dc82fbf@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20221025182039.6dc82fbf@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5ORTNsOH7MlL5NJCH4gDNehffBoQzs2H
X-Proofpoint-ORIG-GUID: zNGiCc8yTDMnVL6fxODyA9Rr4onSZQ4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_04,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=733
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/25/22 18:20, Claudio Imbrenda wrote:
> On Tue, 25 Oct 2022 15:17:36 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 10/25/22 11:30, David Hildenbrand wrote:
>>> On 25.10.22 11:13, Pierre Morel wrote:
>>>> The APCB is part of the CRYCB.
>>>> The calculation of the APCB origin can be done by adding
>>>> the APCB offset to the CRYCB origin.
>>>>
>>>> Current code makes confusing transformations, converting
>>>> the CRYCB origin to a pointer to calculate the APCB origin.
>>>>   
>>>
>>>
>>> While at it, can we rename "crycb_o" to "crycb_gpa" and "apcb_o" to
>>> "apcb_gpa".
>>>
>>> These are not pointers but guest physical addresses.
>>>    
>>
>> I can do that.
>> the _o came from the name in the documentation "origin"
>> but gpa is more obvious.
>>
> 
> with that fixed:
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
