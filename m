Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5A362366
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245595AbhDPPCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:02:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245542AbhDPPCh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Apr 2021 11:02:37 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GEXhNB172127;
        Fri, 16 Apr 2021 11:02:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=w/yMQKuVW9fDcWIKDNdoXX1DtC9RCc8+7zazJq8dg+w=;
 b=MY3fU53zminB1r0bRcZlHcp2yfq4FUAV6Hfji8QgWDY/2bm7q/+FbYuFVyBSqyk9Hmhk
 +uIBHQG8VgecOFzAkCA0RHKhDW3eCrF9NEyDisEtG3xLZ1TBmp95Y0L8NC30KfxuNLZ4
 /E2gUQmao0fISuP3J0/McVXR6x/n6fRmLW+vgln6N1SONdeHAm5HU+0nQGQInj5KqGJz
 j/kXTib9U0nNEcyaeTpgtH1ephba2yS+7bwA9tgQPv03opxsA83shiZ5gPKuh5KbYpPU
 gg6wlGaA9cVdRjS87pw40QPvSZBEO1RzTLpIZUZcks5tzTNgfR7k17LZcR36Mb9WpzRw Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xxnpnum1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 11:02:07 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13GEYxR4177223;
        Fri, 16 Apr 2021 11:02:06 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xxnpnuk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 11:02:06 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13GEwkLL005019;
        Fri, 16 Apr 2021 15:02:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8vha0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 15:02:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13GF227c40305106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 15:02:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3010311C050;
        Fri, 16 Apr 2021 15:02:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5E3811C04C;
        Fri, 16 Apr 2021 15:02:01 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.64.24])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 16 Apr 2021 15:02:01 +0000 (GMT)
Subject: Re: linux-next: Fixes tag needs some work in the kvm tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210416222731.3e82b3a0@canb.auug.org.au>
 <00222197-fb22-ab0a-97e2-11c9f85a67f1@de.ibm.com>
 <2b825142-fdd9-be35-6d88-bb3b9c985122@redhat.com>
 <20210417005831.3785688b@canb.auug.org.au>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d4928233-670a-8930-f581-8e7b765b3c00@de.ibm.com>
Date:   Fri, 16 Apr 2021 17:02:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210417005831.3785688b@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q6DfPmDgTMAAqyTRix6m6_ArjyHkJHDb
X-Proofpoint-ORIG-GUID: mOzbzfkBCG9X2lN1LUhO8of4u-bZWqiY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_07:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxscore=0 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16.04.21 16:58, Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 16 Apr 2021 16:02:01 +0200 Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 16/04/21 14:38, Christian Borntraeger wrote:
>>> On 16.04.21 14:27, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> In commit
>>>>
>>>>     c3171e94cc1c ("KVM: s390: VSIE: fix MVPG handling for prefixing and >> MSO")
>>>>
>>>> Fixes tag
>>>>
>>>>     Fixes: bdf7509bbefa ("s390/kvm: VSIE: correctly handle MVPG when in >> VSIE")
>>>>
>>>> has these problem(s):
>>>>
>>>>     - Subject does not match target commit subject
>>>>       Just use
>>>>      git log -1 --format='Fixes: %h ("%s")'
>>>
>>> Hmm, this has been sitting in kvms390/next for some time now. Is this a > new check?
>>>    
>>
>> Maybe you just missed it when it was reported for kvms390?
>>
>> https://www.spinics.net/lists/linux-next/msg59652.html
> 
> It was a different commit SHA then and was reported because the Fixes
> SHA did not exist.  It was fixed the next day, so I guess either I
> missed reporting this different problem, or I thought at least it had
> been fixed to use the correct SHA.  I am not completely consistent,
> sometimes :-)

Yeah, seems that my fix was only half-way correct then but it managed to get past your review.
