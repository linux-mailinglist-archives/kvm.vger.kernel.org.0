Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00B51B2580
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 14:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgDUMDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 08:03:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgDUMDY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 08:03:24 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LC3F4F101213;
        Tue, 21 Apr 2020 08:03:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gfebf55j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 08:03:23 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03LC3L3e101752;
        Tue, 21 Apr 2020 08:03:21 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gfebf4xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 08:03:20 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03LC2bAg014530;
        Tue, 21 Apr 2020 12:03:08 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 30fs668vbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Apr 2020 12:03:08 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03LC37DL34472332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 12:03:07 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABC6AC605B;
        Tue, 21 Apr 2020 12:03:07 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD7D4C6055;
        Tue, 21 Apr 2020 12:03:06 +0000 (GMT)
Received: from [9.65.251.67] (unknown [9.65.251.67])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Apr 2020 12:03:06 +0000 (GMT)
Subject: Re: [PATCH v3 5/8] vfio-ccw: Introduce a new CRW region
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
 <20200417023001.65006-6-farman@linux.ibm.com>
 <20200421114114.672f35a4.cohuck@redhat.com>
 <e24dfccc-d2b7-9a47-3cef-323c01797ee1@linux.ibm.com>
 <20200421130829.49144c72.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <51ab4052-7958-2968-b91f-c7e06f1f1a2c@linux.ibm.com>
Date:   Tue, 21 Apr 2020 08:03:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200421130829.49144c72.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_04:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/21/20 7:08 AM, Cornelia Huck wrote:
> On Tue, 21 Apr 2020 07:02:03 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 4/21/20 5:41 AM, Cornelia Huck wrote:
>>> On Fri, 17 Apr 2020 04:29:58 +0200
>>> Eric Farman <farman@linux.ibm.com> wrote:
> 
>>>> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
>>>> index 98832d95f395..3338551ef642 100644
>>>> --- a/Documentation/s390/vfio-ccw.rst
>>>> +++ b/Documentation/s390/vfio-ccw.rst
>>>> @@ -247,6 +247,22 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
>>>>  Reading this region triggers a STORE SUBCHANNEL to be issued to the
>>>>  associated hardware.
>>>>  
>>>> +vfio-ccw crw region
>>>> +---------------------
>>>> +
>>>> +The vfio-ccw crw region is used to return Channel Report Word (CRW)
>>>> +data to userspace::
>>>> +
>>>> +  struct ccw_crw_region {
>>>> +         __u32 crw;
>>>> +  } __packed;
>>>> +
>>>> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_CRW.
>>>> +
>>>> +Currently, space is provided for a single CRW. Handling of chained
>>>> +CRWs (not implemented in vfio-ccw) can be accomplished by re-reading
>>>> +the region for additional CRW data.  
>>>
>>> What about the following instead:
>>>
>>> "Reading this region returns a CRW if one that is relevant for this
>>> subchannel (e.g. one reporting changes in channel path state) is
>>> pending, or all zeroes if not. If multiple CRWs are pending (including
>>> possibly chained CRWs), reading this region again will return the next
>>> one, until no more CRWs are pending and zeroes are returned. This is
>>> similar to how STORE CHANNEL REPORT WORD works."  
>>
>> Sounds good to me.
>>
>> Hrm...  Maybe coffee hasn't hit yet.  Should I wire STCRW into this, or
>> just rely on the notification from the host to trigger the read?
> 
> Userspace is supposed to use this to get crws to inject into the guest,
> no stcrw involved until the guest actually got the machine check for it.
> 

Ah, yes.  Thanks!
