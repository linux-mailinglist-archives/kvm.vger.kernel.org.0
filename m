Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC159C87
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 15:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF1NFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 09:05:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726590AbfF1NFQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jun 2019 09:05:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SD3eDM034064
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 09:05:15 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tdjtt1pgd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 09:05:15 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Fri, 28 Jun 2019 14:05:14 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Jun 2019 14:05:12 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5SD5BXk7209600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 13:05:11 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28B34112065;
        Fri, 28 Jun 2019 13:05:11 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 022B311206B;
        Fri, 28 Jun 2019 13:05:10 +0000 (GMT)
Received: from [9.80.218.122] (unknown [9.80.218.122])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jun 2019 13:05:10 +0000 (GMT)
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1561055076.git.alifm@linux.ibm.com>
 <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
 <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
 <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
 <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
 <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
 <20190624114231.2d81e36f.cohuck@redhat.com>
 <20190624120514.4b528db5.cohuck@redhat.com>
 <20190624134622.2bb3bba2.cohuck@redhat.com>
 <20190624140723.5aa7b0b1.cohuck@redhat.com>
 <3e93215c-c11a-d0bb-8982-be3f2b467e13@linux.ibm.com>
 <20190624170937.4c76de8d.cohuck@redhat.com>
 <7841b312-13ad-a4b3-85d9-1f5a4991f7fd@linux.ibm.com>
 <20190627111456.3e6da01c.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Fri, 28 Jun 2019 09:05:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190627111456.3e6da01c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062813-0052-0000-0000-000003D80424
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011346; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01224482; UDB=6.00644477; IPR=6.01005674;
 MB=3.00027507; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-28 13:05:13
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062813-0053-0000-0000-0000617E2016
Message-Id: <f42fa379-470a-c14a-a120-c4221029076d@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/27/2019 05:14 AM, Cornelia Huck wrote:
> On Mon, 24 Jun 2019 11:24:16 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> On 06/24/2019 11:09 AM, Cornelia Huck wrote:
>>> On Mon, 24 Jun 2019 10:44:17 -0400
>>> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>>>> But even if we don't remove the cp_free from vfio_ccw_sch_io_todo, I am
>>>> not sure if your suggestion will fix the problem. The problem here is
>>>> that we can call vfio_ccw_sch_io_todo (for a clear or halt interrupt) at
>>>> the same time we are handling an ssch request. So depending on the order
>>>> of the operations we could still end up calling cp_free from both from
>>>> threads (i refer to the threads I mentioned in response to Eric's
>>>> earlier email).
>>>
>>> What I don't see is why this is a problem with ->initialized; wasn't
>>> the problem that we misinterpreted an interrupt for csch as one for a
>>> not-yet-issued ssch?
>>>    
>>
>> It's the order in which we do things, which could cause the problem.
>> Since we queue interrupt handling in the workqueue, we could delay
>> processing the csch interrupt. During this delay if ssch comes through,
>> we might have already set ->initialized to true.
>>
>> So when we get around to handling the interrupt in io_todo, we would go
>> ahead and call cp_free. This would cause the problem of freeing the
>> ccwchain list while we might be adding to it.
>>
>>>>
>>>> Another thing that concerns me is that vfio-ccw can also issue csch/hsch
>>>> in the quiesce path, independently of what the guest issues. So in that
>>>> case we could have a similar scenario to processing an ssch request and
>>>> issuing halt/clear in parallel. But maybe I am being paranoid :)
>>>
>>> I think the root problem is really trying to clear a cp while another
>>> thread is trying to set it up. Should we maybe use something like rcu?
>>>
>>>    
>>
>> Yes, this is the root problem. I am not too familiar with rcu locking,
>> but what would be the benefit over a traditional mutex?
> 
> I don't quite remember what I had been envisioning at the time (sorry,
> the heat seems to make my brain a bit slushy :/), but I think we might
> have two copies of the cp and use an rcu-ed pointer in the private
> structure to point to one of the copies. If we make sure we've
> synchronized on the pointer at interrupt time, we should be able to
> free the old one in _todo and act on the new on when doing ssch. And
> yes, I realize that this is awfully vague :)
> 
> 

Sorry for the delayed response. I was trying out few ideas, and I think 
the simplest one for me that worked and that makes sense is to 
explicitly add the check to see if the state == CP_PENDING when trying 
to free the cp (as mentioned by Halil in a separate thread).

When we are in the CP_PENDING state then we know for sure that we have a 
currently allocated cp and no other thread is working on it. So in the 
interrupt context, it should be okay to free cp.

I have prototyped with the mutex, but the code becomes too hairy. I 
looked into the rcu api and from what I understand about rcu it would 
provide advantage if we more readers than updaters. But in our case we 
really have 2 updaters, updating the cp at the same time.

In the meantime I also have some minor fixes while going over the code 
again :). I will post a v2 soon for review.

Thanks
Farhan

