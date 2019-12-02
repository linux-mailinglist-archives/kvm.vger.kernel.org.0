Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D444F10ED87
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 17:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfLBQwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 11:52:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727418AbfLBQwz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 11:52:55 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2GlOVf089429
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 11:52:53 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wm6g8p0vg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 11:52:53 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 16:52:51 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 16:52:50 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2Gqn9347120786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 16:52:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20B8AA4051;
        Mon,  2 Dec 2019 16:52:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4A7EA4040;
        Mon,  2 Dec 2019 16:52:48 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 16:52:48 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/9] s390x: Define the PSW bits
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, cohuck@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-3-git-send-email-pmorel@linux.ibm.com>
 <489b43a4-6f71-71bf-b936-e4c94e52387b@redhat.com>
 <7daddc03-35ec-f376-c80a-a849f9e11714@linux.ibm.com>
 <3ce5d72d-ed1d-c689-a13f-6f409d085df7@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 17:52:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <3ce5d72d-ed1d-c689-a13f-6f409d085df7@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120216-4275-0000-0000-00000389E9FC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120216-4276-0000-0000-0000389D8500
Message-Id: <2f1383bf-15f0-b2f5-96d4-a4a443f33a96@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_03:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912020144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 12:17, David Hildenbrand wrote:
> On 02.12.19 12:11, Janosch Frank wrote:
>> On 11/28/19 3:36 PM, David Hildenbrand wrote:
>>> On 28.11.19 13:46, Pierre Morel wrote:
>>>> Let's define the PSW bits  explicitly, it will clarify their
>>>> usage.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   lib/s390x/asm/arch_bits.h | 20 ++++++++++++++++++++
>>>>   lib/s390x/asm/arch_def.h  |  6 ++----
>>>
>>> I'm sorry, but I don't really see a reason to move these 4/5 defines to
>>> a separate header. Can you just keep them in arch_def.h and extend?
>>>
>>> (none of your other patches touch arch_bits.h - and it is somewhat a
>>> weird name. Where to put something new: arch_def.h or arch_bits.h? I
>>> would have understood "psw.h", but even that, I don't consider necessary)
>>>
>>
>> On a related note:
>> I'd still like to split up the file soonish, maybe moving the functions
>> into a new file?
>>
>> @Thomas/David: What's your opinion on that?
> 
> Sure, as long as the file header is not longer as its actual content :D
> 

No problem for me.
What should the file header be?

-- 
Pierre Morel
IBM Lab Boeblingen

