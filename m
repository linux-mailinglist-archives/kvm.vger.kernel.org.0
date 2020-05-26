Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18011E2F37
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389647AbgEZTj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 15:39:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389582AbgEZTj1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 15:39:27 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QJWGWK147184;
        Tue, 26 May 2020 15:39:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316yqjgqfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 15:39:26 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QJWOEF147748;
        Tue, 26 May 2020 15:39:26 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 316yqjgqfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 15:39:25 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QJYst7000740;
        Tue, 26 May 2020 19:39:25 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 316ufa0vtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 19:39:25 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QJdNNx26345916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 19:39:23 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6D106A054;
        Tue, 26 May 2020 19:39:23 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19DFF6A047;
        Tue, 26 May 2020 19:39:23 +0000 (GMT)
Received: from [9.65.228.55] (unknown [9.65.228.55])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 19:39:22 +0000 (GMT)
Subject: Re: [PATCH] vfio-ccw: document possible errors
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200407111605.1795-1-cohuck@redhat.com>
 <55932365-3d36-1629-5d65-06c71e8231f9@linux.ibm.com>
 <20200508125541.72adc626.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <ed9b7c9b-3dc7-e573-55a8-d52f28877da9@linux.ibm.com>
Date:   Tue, 26 May 2020 15:39:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508125541.72adc626.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_02:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005260147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/8/20 6:55 AM, Cornelia Huck wrote:
> On Fri, 17 Apr 2020 12:33:18 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 4/7/20 7:16 AM, Cornelia Huck wrote:
>>> Interacting with the I/O and the async regions can yield a number
>>> of errors, which had been undocumented so far. These are part of
>>> the api, so remedy that.  
>>
>> (Makes a note to myself, to do the same for the schib/crw regions we're
>> adding for channel path handling.)
> 
> Yes, please :) I plan to merge this today, so you can add a patch on
> top.

I finally picked this up and realized that the io and async regions both
document the return codes that would be stored in a field within their
respective regions. The schib/crw regions don't have any such field, so
the only values to be documented are the ones that the .read callback
itself returns. What obvious thing am I missing?

> 
>>
>>>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  Documentation/s390/vfio-ccw.rst | 54 ++++++++++++++++++++++++++++++++-
>>>  1 file changed, 53 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
>>> index fca9c4f5bd9c..4538215a362c 100644
>>> --- a/Documentation/s390/vfio-ccw.rst
>>> +++ b/Documentation/s390/vfio-ccw.rst
>>> @@ -210,7 +210,36 @@ Subchannel.
>>>  
>>>  irb_area stores the I/O result.
>>>  
>>> -ret_code stores a return code for each access of the region.
>>> +ret_code stores a return code for each access of the region. The following
>>> +values may occur:
>>> +
>>> +``0``
>>> +  The operation was successful.
>>> +
>>> +``-EOPNOTSUPP``
>>> +  The orb specified transport mode or an unidentified IDAW format, did not
>>> +  specify prefetch mode, or the scsw specified a function other than the
> 
> 'did not specify prefetch mode' needs to be dropped now, will do so
> before queuing.
> 
>>> +  start function.
>>> +
>>> +``-EIO``
>>> +  A request was issued while the device was not in a state ready to accept
>>> +  requests, or an internal error occurred.
>>> +
>>> +``-EBUSY``
>>> +  The subchannel was status pending or busy, or a request is already active.
>>> +
>>> +``-EAGAIN``
>>> +  A request was being processed, and the caller should retry.
>>> +
>>> +``-EACCES``
>>> +  The channel path(s) used for the I/O were found to be not operational.
>>> +
>>> +``-ENODEV``
>>> +  The device was found to be not operational.
>>> +
>>> +``-EINVAL``
>>> +  The orb specified a chain longer than 255 ccws, or an internal error
>>> +  occurred.
>>>  
>>>  This region is always available.  
>>
>> Maybe move this little line up between the struct layout and "While
>> starting an I/O request, orb_area ..." instead of being lost way down here?
> 
> Good idea, that also would match the documentation for the async region.
> 
>>
>> But other than that suggestion, everything looks fine.
>>
>> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> 
> Thanks!
> 
>>
>>>  
>>> @@ -231,6 +260,29 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
>>>  
>>>  Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
>>>  
>>> +command specifies the command to be issued; ret_code stores a return code
>>> +for each access of the region. The following values may occur:
>>> +
>>> +``0``
>>> +  The operation was successful.
>>> +
>>> +``-ENODEV``
>>> +  The device was found to be not operational.
>>> +
>>> +``-EINVAL``
>>> +  A command other than halt or clear was specified.
>>> +
>>> +``-EIO``
>>> +  A request was issued while the device was not in a state ready to accept
>>> +  requests.
>>> +
>>> +``-EAGAIN``
>>> +  A request was being processed, and the caller should retry.
>>> +
>>> +``-EBUSY``
>>> +  The subchannel was status pending or busy while processing a halt request.
>>> +
>>> +
>>>  vfio-ccw operation details
>>>  --------------------------
>>>  
>>>   
>>
> 
