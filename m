Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FE51B655E
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgDWUZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:25:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDWUZo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 16:25:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03NJWXuU047357;
        Thu, 23 Apr 2020 16:25:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrj76a14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Apr 2020 16:25:43 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03NJidh0079219;
        Thu, 23 Apr 2020 16:25:43 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jrj76a0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Apr 2020 16:25:43 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03NKNJSM030716;
        Thu, 23 Apr 2020 20:25:42 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 30fs66m8se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Apr 2020 20:25:42 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03NKPfxF54198716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 20:25:41 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 480E913604F;
        Thu, 23 Apr 2020 20:25:41 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B103136053;
        Thu, 23 Apr 2020 20:25:40 +0000 (GMT)
Received: from [9.65.212.228] (unknown [9.65.212.228])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 23 Apr 2020 20:25:40 +0000 (GMT)
Subject: Re: [PATCH 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200417182939.11460-1-jrossi@linux.ibm.com>
 <20200417182939.11460-2-jrossi@linux.ibm.com>
 <20200423155620.493cb7cb.pasic@linux.ibm.com>
 <20200423171103.497dcd02.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <b6dc3d32-3e84-4ce1-59a2-d5de99716027@linux.ibm.com>
Date:   Thu, 23 Apr 2020 16:25:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423171103.497dcd02.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_13:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/23/20 11:11 AM, Cornelia Huck wrote:
> On Thu, 23 Apr 2020 15:56:20 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>> On Fri, 17 Apr 2020 14:29:39 -0400
>> Jared Rossi <jrossi@linux.ibm.com> wrote:
>>
>>> Remove the explicit prefetch check when using vfio-ccw devices.
>>> This check is not needed as all Linux channel programs are intended
>>> to use prefetch and will be executed in the same way regardless.  
>>
>> Hm. This is a guest thing or? So you basically say, it is OK to do
>> this, because you know that the guest is gonna be Linux and that it
>> the channel program is intended to use prefetch -- but the ORB supplied
>> by the guest that designates the channel program happens to state the
>> opposite.
>>
>> Or am I missing something?
> 
> I see this as a kind of architecture compliance/ease of administration
> tradeoff, as we none of the guests we currently support uses something
> that breaks with prefetching outside of IPL (which has a different
> workaround).>
> One thing that still concerns me a bit is debuggability if a future
> guest indeed does want to dynamically rewrite a channel program: the

+1 for some debuggability, just in general

> guest thinks it instructed the device to not prefetch, and then
> suddenly things do not work as expected. We can log when a guest
> submits an orb without prefetch set, but we can't find out if the guest
> actually does something that relies on non-prefetch.

Without going too far down a non-prefetch rabbit-hole, can we use the
cpa_within_range logic to see if the address of the CCW being fetched
exists as the CDA of an earlier (non-TIC) CCW in the chain we're
processing, and tracing/logging/messaging something about a possible
conflict?

(Jared, you did some level of this tracing with our real/synthetic tests
some time ago.  Any chance something of it could be polished and made
useful, without being overly heavy on the mainline path?)

> 
> The only correct way to handle this would be to actually implement
> non-prefetch processing, where I would not really know where to even
> start -- and then we'd only have synthetic test cases, for now. None of
> the options are pleasant :(
> 

And even if we knew where to start, it's quite a bit of effort for the
hypothetical.  From conversations I've had with long-time I/O folks,
non-prefetch seems to be the significant minority these days, dating
back to older CKD devices (and associated connectivity) in practice.
