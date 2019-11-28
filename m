Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69BF10CEC7
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 20:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfK1TQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 14:16:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbfK1TQj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 14:16:39 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASJCGIi130975
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 14:16:38 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxsdsd4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 14:16:38 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 28 Nov 2019 19:16:37 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 19:16:35 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASJGYVW47775906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 19:16:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A42752051;
        Thu, 28 Nov 2019 19:16:34 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.185.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C8E9852050;
        Thu, 28 Nov 2019 19:16:33 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/9] s390x: Define the PSW bits
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-3-git-send-email-pmorel@linux.ibm.com>
 <489b43a4-6f71-71bf-b936-e4c94e52387b@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 28 Nov 2019 20:16:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <489b43a4-6f71-71bf-b936-e4c94e52387b@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19112819-0028-0000-0000-000003C1461A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112819-0029-0000-0000-00002484521B
Message-Id: <7abb4725-b814-8b43-8a4f-e0e2cf7a44f8@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_06:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-28 15:36, David Hildenbrand wrote:
> On 28.11.19 13:46, Pierre Morel wrote:
>> Let's define the PSW bits  explicitly, it will clarify their
>> usage.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/asm/arch_bits.h | 20 ++++++++++++++++++++
>>   lib/s390x/asm/arch_def.h  |  6 ++----
> I'm sorry, but I don't really see a reason to move these 4/5 defines to
> a separate header. Can you just keep them in arch_def.h and extend?

no because arch_def.h contains C structures and inline.


>
> (none of your other patches touch arch_bits.h - and it is somewhat a
> weird name. Where to put something new: arch_def.h or arch_bits.h? I
> would have understood "psw.h", but even that, I don't consider necessary)
>
I can use a name like psw.h or let fall and keep the hexa.


-- 
Pierre Morel
IBM Lab Boeblingen

