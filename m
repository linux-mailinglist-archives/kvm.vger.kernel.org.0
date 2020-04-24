Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472BD1B75ED
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgDXMuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:50:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726849AbgDXMuQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 08:50:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OCZZi8015222;
        Fri, 24 Apr 2020 08:50:15 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5tey9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 08:50:14 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03OCa7QK017316;
        Fri, 24 Apr 2020 08:50:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30kk5tey91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 08:50:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OCkG6a027373;
        Fri, 24 Apr 2020 12:50:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30fs6593aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 12:50:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OCo9rr66126272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 12:50:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AF7BAE045;
        Fri, 24 Apr 2020 12:50:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39636AE053;
        Fri, 24 Apr 2020 12:50:09 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.37.140])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 12:50:09 +0000 (GMT)
Date:   Fri, 24 Apr 2020 14:50:07 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Message-ID: <20200424145007.75101d10.pasic@linux.ibm.com>
In-Reply-To: <b6dc3d32-3e84-4ce1-59a2-d5de99716027@linux.ibm.com>
References: <20200417182939.11460-1-jrossi@linux.ibm.com>
        <20200417182939.11460-2-jrossi@linux.ibm.com>
        <20200423155620.493cb7cb.pasic@linux.ibm.com>
        <20200423171103.497dcd02.cohuck@redhat.com>
        <b6dc3d32-3e84-4ce1-59a2-d5de99716027@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_05:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 16:25:39 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> 
> 
> On 4/23/20 11:11 AM, Cornelia Huck wrote:
> > On Thu, 23 Apr 2020 15:56:20 +0200
> > Halil Pasic <pasic@linux.ibm.com> wrote:
> > 
> >> On Fri, 17 Apr 2020 14:29:39 -0400
> >> Jared Rossi <jrossi@linux.ibm.com> wrote:
> >>
> >>> Remove the explicit prefetch check when using vfio-ccw devices.
> >>> This check is not needed as all Linux channel programs are intended
> >>> to use prefetch and will be executed in the same way regardless.  
> >>
> >> Hm. This is a guest thing or? So you basically say, it is OK to do
> >> this, because you know that the guest is gonna be Linux and that it
> >> the channel program is intended to use prefetch -- but the ORB supplied
> >> by the guest that designates the channel program happens to state the
> >> opposite.
> >>
> >> Or am I missing something?
> > 
> > I see this as a kind of architecture compliance/ease of administration
> > tradeoff, as we none of the guests we currently support uses something
> > that breaks with prefetching outside of IPL (which has a different
> > workaround).>

And that workaround AFAIR makes sure that we don't issue a CP that is
self-modifying or otherwise reliant on non-prefetch. So any time we see
a self-modifying program we know, we have an incompatible setup.

In any case I believe the commit message is inadequate, as it does not
reflect about the risks.

> > One thing that still concerns me a bit is debuggability if a future
> > guest indeed does want to dynamically rewrite a channel program: the
> 
> +1 for some debuggability, just in general
> 
> > guest thinks it instructed the device to not prefetch, and then
> > suddenly things do not work as expected. We can log when a guest
> > submits an orb without prefetch set, but we can't find out if the guest
> > actually does something that relies on non-prefetch.
> 
> Without going too far down a non-prefetch rabbit-hole, can we use the
> cpa_within_range logic to see if the address of the CCW being fetched
> exists as the CDA of an earlier (non-TIC) CCW in the chain we're
> processing, and tracing/logging/messaging something about a possible
> conflict?
> 
> (Jared, you did some level of this tracing with our real/synthetic tests
> some time ago.  Any chance something of it could be polished and made
> useful, without being overly heavy on the mainline path?)
> 

Back then I believe I made a proposal on how this logic could look like.
I think all we need is checking for self rewrites (ccw reads to the
addresses that comprise the  complete original channel program), and for
status-modifier 'skips'. The latter could be easily done by putting some
sort of poison at the end of the detected channel program segments.

> > 
> > The only correct way to handle this would be to actually implement
> > non-prefetch processing, where I would not really know where to even
> > start -- and then we'd only have synthetic test cases, for now. None of
> > the options are pleasant :(
> > 
> 

I don't think implementing non-prefetch processing is possible with
vfio-ccw. 

Regards,
Halil
