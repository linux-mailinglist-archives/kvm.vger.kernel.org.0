Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C21BD143
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 02:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgD2Ai6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 20:38:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726363AbgD2Ai6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 20:38:58 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0Z4iX135750;
        Tue, 28 Apr 2020 20:38:56 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh341c6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 20:38:56 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03T0ZcmJ137823;
        Tue, 28 Apr 2020 20:38:56 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh341c6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 20:38:56 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03T0a0cp021093;
        Wed, 29 Apr 2020 00:38:55 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 30mcu6rk03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 00:38:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03T0crEh47382980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 00:38:53 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A75E56E04C;
        Wed, 29 Apr 2020 00:38:53 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F2A76E04E;
        Wed, 29 Apr 2020 00:38:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 00:38:53 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Apr 2020 20:38:53 -0400
From:   Jared Rossi <jrossi@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
In-Reply-To: <20200424145007.75101d10.pasic@linux.ibm.com>
References: <20200417182939.11460-1-jrossi@linux.ibm.com>
 <20200417182939.11460-2-jrossi@linux.ibm.com>
 <20200423155620.493cb7cb.pasic@linux.ibm.com>
 <20200423171103.497dcd02.cohuck@redhat.com>
 <b6dc3d32-3e84-4ce1-59a2-d5de99716027@linux.ibm.com>
 <20200424145007.75101d10.pasic@linux.ibm.com>
Message-ID: <0d413224be93719a149ce8a5a0aef77b@linux.vnet.ibm.com>
X-Sender: jrossi@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 suspectscore=0 clxscore=1015 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280185
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-24 08:50, Halil Pasic wrote:
> On Thu, 23 Apr 2020 16:25:39 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> 
>> 
>> On 4/23/20 11:11 AM, Cornelia Huck wrote:
>> > On Thu, 23 Apr 2020 15:56:20 +0200
>> > Halil Pasic <pasic@linux.ibm.com> wrote:
>> >
>> >> On Fri, 17 Apr 2020 14:29:39 -0400
>> >> Jared Rossi <jrossi@linux.ibm.com> wrote:
>> >>
>> >>> Remove the explicit prefetch check when using vfio-ccw devices.
>> >>> This check is not needed as all Linux channel programs are intended
>> >>> to use prefetch and will be executed in the same way regardless.
>> >>
>> >> Hm. This is a guest thing or? So you basically say, it is OK to do
>> >> this, because you know that the guest is gonna be Linux and that it
>> >> the channel program is intended to use prefetch -- but the ORB supplied
>> >> by the guest that designates the channel program happens to state the
>> >> opposite.
>> >>
>> >> Or am I missing something?
>> >
>> > I see this as a kind of architecture compliance/ease of administration
>> > tradeoff, as we none of the guests we currently support uses something
>> > that breaks with prefetching outside of IPL (which has a different
>> > workaround).>
> 
> And that workaround AFAIR makes sure that we don't issue a CP that is
> self-modifying or otherwise reliant on non-prefetch. So any time we see
> a self-modifying program we know, we have an incompatible setup.
> 
> In any case I believe the commit message is inadequate, as it does not
> reflect about the risks.
> 
>> > One thing that still concerns me a bit is debuggability if a future
>> > guest indeed does want to dynamically rewrite a channel program: the
>> 
>> +1 for some debuggability, just in general
>> 
>> > guest thinks it instructed the device to not prefetch, and then
>> > suddenly things do not work as expected. We can log when a guest
>> > submits an orb without prefetch set, but we can't find out if the guest
>> > actually does something that relies on non-prefetch.
>> 
>> Without going too far down a non-prefetch rabbit-hole, can we use the
>> cpa_within_range logic to see if the address of the CCW being fetched
>> exists as the CDA of an earlier (non-TIC) CCW in the chain we're
>> processing, and tracing/logging/messaging something about a possible
>> conflict?
>> 
>> (Jared, you did some level of this tracing with our real/synthetic 
>> tests
>> some time ago.  Any chance something of it could be polished and made
>> useful, without being overly heavy on the mainline path?)
>> 
> 
> Back then I believe I made a proposal on how this logic could look 
> like.
> I think all we need is checking for self rewrites (ccw reads to the
> addresses that comprise the  complete original channel program), and 
> for
> status-modifier 'skips'. The latter could be easily done by putting 
> some
> sort of poison at the end of the detected channel program segments.
> 

 From what I previously did with the tracing, I don't think that there is 
a
practical way to determine if a cp is actually doing something that 
relies
on non-prefetch.  It seems we would need to examine the CCWs to find 
reads
and also validate the addresses those CCWs access to check if there is a
conflict.  Probably this is too much overhead considering that we expect
it to be a rare occurrence?

Is it too simplistic to print a kernel warning stating that an ORB did 
not
have the p-bit set, but it is being prefetched anyway?

Regards,
Jared Rossi
