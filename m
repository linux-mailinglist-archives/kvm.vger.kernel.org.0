Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6211E3F56
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgE0Koe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:44:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726649AbgE0Kod (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 06:44:33 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04RAWAlF182318;
        Wed, 27 May 2020 06:44:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316ytunra1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 06:44:32 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04RAWH26182642;
        Wed, 27 May 2020 06:44:32 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316ytunr9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 06:44:32 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04RAfJQk024307;
        Wed, 27 May 2020 10:44:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 316uf8pegd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 May 2020 10:44:31 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04RAiTVU31457642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 10:44:29 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAFE96A047;
        Wed, 27 May 2020 10:44:30 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9B4F6A04F;
        Wed, 27 May 2020 10:44:29 +0000 (GMT)
Received: from [9.65.228.55] (unknown [9.65.228.55])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 27 May 2020 10:44:29 +0000 (GMT)
Subject: Re: [PATCH] vfio-ccw: document possible errors
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200407111605.1795-1-cohuck@redhat.com>
 <55932365-3d36-1629-5d65-06c71e8231f9@linux.ibm.com>
 <20200508125541.72adc626.cohuck@redhat.com>
 <ed9b7c9b-3dc7-e573-55a8-d52f28877da9@linux.ibm.com>
 <20200527081934.2dceda89.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <b9fe4698-c889-3480-9720-013c8af79c16@linux.ibm.com>
Date:   Wed, 27 May 2020 06:44:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527081934.2dceda89.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-27_03:2020-05-27,2020-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=905 cotscore=-2147483648
 spamscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/27/20 2:19 AM, Cornelia Huck wrote:
> On Tue, 26 May 2020 15:39:22 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 5/8/20 6:55 AM, Cornelia Huck wrote:
>>> On Fri, 17 Apr 2020 12:33:18 -0400
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>   
>>>> On 4/7/20 7:16 AM, Cornelia Huck wrote:  
>>>>> Interacting with the I/O and the async regions can yield a number
>>>>> of errors, which had been undocumented so far. These are part of
>>>>> the api, so remedy that.    
>>>>
>>>> (Makes a note to myself, to do the same for the schib/crw regions we're
>>>> adding for channel path handling.)  
>>>
>>> Yes, please :) I plan to merge this today, so you can add a patch on
>>> top.  
>>
>> I finally picked this up and realized that the io and async regions both
>> document the return codes that would be stored in a field within their
>> respective regions. The schib/crw regions don't have any such field, so
>> the only values to be documented are the ones that the .read callback
>> itself returns. What obvious thing am I missing?
> 
> The fact that you are right :)
> 
> No need to do anything, I might have spread my own confusion here ;)
> 

Oh, good. I was worried vacation was too long/short. :)

Thanks for confirming; will get back to the other things on the list
instead.
