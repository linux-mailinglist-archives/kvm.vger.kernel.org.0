Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2472FC9E1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKNPZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:25:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726997AbfKNPZm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 10:25:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEFOh4Z086326
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 10:25:40 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w9985s3hp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 10:25:40 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 15:25:34 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 15:25:30 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEFPTYx48300172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 15:25:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A295E5204F;
        Thu, 14 Nov 2019 15:25:29 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6AEC15204E;
        Thu, 14 Nov 2019 15:25:29 +0000 (GMT)
Subject: Re: [PATCH v1 2/4] s390x: Define the PSW bits
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
References: <1573647799-30584-1-git-send-email-pmorel@linux.ibm.com>
 <1573647799-30584-3-git-send-email-pmorel@linux.ibm.com>
 <5796f620-7ee6-6333-e4f4-5e904284a331@linux.ibm.com>
 <189f8129-86c5-8761-fdfe-d08c34fb1f18@linux.ibm.com>
 <e27023c2-5f9c-884d-e194-4420ec6e3023@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 16:25:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <e27023c2-5f9c-884d-e194-4420ec6e3023@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111415-0016-0000-0000-000002C3A4BD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111415-0017-0000-0000-00003325476C
Message-Id: <33163b34-247d-71b2-54a3-8a6b476b7157@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=763 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-14 09:53, Janosch Frank wrote:
> On 11/14/19 9:40 AM, Pierre Morel wrote:
>> On 2019-11-13 17:05, Janosch Frank wrote:
>>> On 11/13/19 1:23 PM, Pierre Morel wrote:
>>>> Instead of assigning obfuscated masks to the PSW dedicated to the
>>>> exceptions, let's define the masks explicitely, it will clarify the
>>> s/explicitely/explicitly/
>>> Try to break that up into sentences.
>> OK thx
...snip...
>>>> +
>>>> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
>>> That's not a bit anymore, shouldn't that be in arch_def.h?
>>> Also please add a comment, that this is 64 bit addressing.
>>
>> Don't we use the 64bit architecture only?
> architecture != addressing
> We can do 24 bit addressing on zArch...
> We mostly use ESAME (zArch), but old machines start up in the old mode
> and then we transition to zArch via a SIGP.


Yes, this is done during the first instructions of cstart.S:

- Setting the architecture to 64bit / ESAME using SIGP

- Set addressing mode to 64bit

After that AFAIK we never change the addressing mode.

The definitions in the file are intended for PSW flags which AFAIK are 
always 64bits.

I created arch_bits.h to avoid using arch_def.h which contains C 
structures and functions, so preventing to include it in assembler files.


Regards,

Pierre


>
>> Regards,
>>
>> Pierre
>>
>>
>
-- 
Pierre Morel
IBM Lab Boeblingen

