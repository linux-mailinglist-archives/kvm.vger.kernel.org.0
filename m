Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAFE193E53
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgCZLyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 07:54:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727994AbgCZLyX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 07:54:23 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02QBZMuI024060;
        Thu, 26 Mar 2020 07:54:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywd2u8668-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 07:54:22 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02QBkVPU064173;
        Thu, 26 Mar 2020 07:54:21 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywd2u865x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 07:54:21 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02QBoW3K030042;
        Thu, 26 Mar 2020 11:54:20 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 2ywawmbnqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 11:54:20 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02QBsKBf55378356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 11:54:20 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18827112067;
        Thu, 26 Mar 2020 11:54:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D45C112061;
        Thu, 26 Mar 2020 11:54:19 +0000 (GMT)
Received: from [9.160.3.123] (unknown [9.160.3.123])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Mar 2020 11:54:19 +0000 (GMT)
Subject: Re: [RFC PATCH v2 2/9] vfio-ccw: Register a chp_event callback for
 vfio-ccw
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200206213825.11444-1-farman@linux.ibm.com>
 <20200206213825.11444-3-farman@linux.ibm.com>
 <20200214131147.0a98dd7d.cohuck@redhat.com>
 <459a60d1-699d-2f16-bb59-23f11b817b81@linux.ibm.com>
 <20200324165854.3d862d5b.cohuck@redhat.com>
 <302a0650-99b0-22ef-b95d-cecdeb0f9f04@linux.ibm.com>
 <20200326074759.5808c945.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <7dd0d142-dad2-c5d9-fb84-237f99bd9e7b@linux.ibm.com>
Date:   Thu, 26 Mar 2020 07:54:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326074759.5808c945.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_02:2020-03-26,2020-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/26/20 2:47 AM, Cornelia Huck wrote:
> On Wed, 25 Mar 2020 22:09:40 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 3/24/20 11:58 AM, Cornelia Huck wrote:
>>> On Fri, 14 Feb 2020 11:35:21 -0500
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>   
>>>> On 2/14/20 7:11 AM, Cornelia Huck wrote:  
>>>>> On Thu,  6 Feb 2020 22:38:18 +0100
>>>>> Eric Farman <farman@linux.ibm.com> wrote:  
> 
>>>>>> +	case CHP_ONLINE:
>>>>>> +		/* Path became available */
>>>>>> +		sch->lpm |= mask & sch->opm;    
>>>>>
>>>>> If I'm not mistaken, this patch introduces the first usage of sch->opm
>>>>> in the vfio-ccw code.     
>>>>
>>>> Correct.
>>>>  
>>>>> Are we missing something?    
>>>>
>>>> Maybe?  :)
>>>>  
>>>>> Or am I missing
>>>>> something? :)
>>>>>     
>>>>
>>>> Since it's only used in this code, for acting as a step between
>>>> vary/config off/on, maybe this only needs to be dealing with the lpm
>>>> field itself?  
>>>
>>> Ok, I went over this again and also looked at what the standard I/O
>>> subchannel driver does, and I think this is fine, as the lpm basically
>>> factors in the opm already. (Will need to keep this in mind for the
>>> following patches.)  
>>
>> Just to make sure I don't misunderstand, when you say "I think this is
>> fine" ... Do you mean keeping the opm field within vfio-ccw, as this
>> patch does?  Or removing it, and only adjusting the lpm within vfio-ccw,
>> as I suggested in my response just above?
> 
> I meant the code change done in this patch: We update the lpm whenever
> the opm is changed, and use the lpm. I'd like to keep the opm separate,
> just so that we are clear where each value comes from.
> 

Great.  Thanks for that clarification.
