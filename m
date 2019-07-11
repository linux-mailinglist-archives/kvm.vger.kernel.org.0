Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741BF656DF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 14:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfGKM2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 08:28:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbfGKM2s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 08:28:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BCSgsY072220;
        Thu, 11 Jul 2019 08:28:45 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp3r3m8cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 08:28:44 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6BCPI7O016119;
        Thu, 11 Jul 2019 12:28:29 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 2tjk96v285-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jul 2019 12:28:29 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BCSTKR32964928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 12:28:29 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18776AC059;
        Thu, 11 Jul 2019 12:28:29 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1C10AC05E;
        Thu, 11 Jul 2019 12:28:28 +0000 (GMT)
Received: from [9.60.89.60] (unknown [9.60.89.60])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 12:28:28 +0000 (GMT)
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Farhan Ali <alifm@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <cover.1562616169.git.alifm@linux.ibm.com>
 <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
 <20190709121613.6a3554fa.cohuck@redhat.com>
 <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
 <20190709162142.789dd605.pasic@linux.ibm.com>
 <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
 <20190710154549.5c31cc0c.cohuck@redhat.com>
 <75e71cc4-7552-b9e5-5649-4de2cdd8f59a@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <076c223c-d21c-634e-72d2-2de2fe082530@linux.ibm.com>
Date:   Thu, 11 Jul 2019 08:28:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <75e71cc4-7552-b9e5-5649-4de2cdd8f59a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110143
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/19 12:10 PM, Farhan Ali wrote:
> 
> 
> On 07/10/2019 09:45 AM, Cornelia Huck wrote:
>> On Tue, 9 Jul 2019 17:27:47 -0400
>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>
>>> On 07/09/2019 10:21 AM, Halil Pasic wrote:
>>>> Do we need to use atomic operations or external synchronization to
>>>> avoid
>>>> this being another gamble? Or am I missing something?
>>>
>>> I think we probably should think about atomic operations for
>>> synchronizing the state (and it could be a separate add on patch?).
>>
>> +1 to thinking about some atomicity changes later.

+1

>>
>>>
>>> But for preventing 2 threads from stomping on the cp the check should be
>>> enough, unless I am missing something?
>>
>> I think so. Plus, the patch is small enough that we can merge it right
>> away, and figure out a more generic change later.
> 
> I will send out a v3 soon if no one else has any other suggestions.
> 

I thumbed through them and think they look good with Conny's
suggestions.  Nothing else jumps to mind for me.
