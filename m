Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E6E1D5923
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 20:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEOSic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 14:38:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbgEOSib (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 14:38:31 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04FIWg4v016361;
        Fri, 15 May 2020 14:38:30 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3119daj3cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:38:30 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04FIWmEX017206;
        Fri, 15 May 2020 14:38:30 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3119daj3bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 14:38:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04FIUM31024250;
        Fri, 15 May 2020 18:38:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ube3uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 18:38:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04FIcP9C55640528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 18:38:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69413A405B;
        Fri, 15 May 2020 18:38:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0490EA405F;
        Fri, 15 May 2020 18:38:25 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.30.128])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 18:38:24 +0000 (GMT)
Date:   Fri, 15 May 2020 20:37:59 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] vfio-ccw: Fix interrupt handling for
 HALT/CLEAR
Message-ID: <20200515203759.4ffc6f31.pasic@linux.ibm.com>
In-Reply-To: <931b96fc-0bb5-cdc1-bb1c-102a96f346ea@linux.ibm.com>
References: <20200513142934.28788-1-farman@linux.ibm.com>
        <20200514154601.007ae46f.pasic@linux.ibm.com>
        <4e00c83b-146f-9f1d-882b-a5378257f32c@linux.ibm.com>
        <20200515165539.2e4a8485.pasic@linux.ibm.com>
        <931b96fc-0bb5-cdc1-bb1c-102a96f346ea@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_07:2020-05-15,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=979 spamscore=0
 priorityscore=1501 cotscore=-2147483648 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 clxscore=1015 adultscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150151
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 14:12:05 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> >>> Also why do we see the scenario you describe in the wild? I agree that
> >>> this should be taken care of in the kernel as well, but according to my
> >>> understanding QEMU is already supposed to reject the second SSCH (CPU 2)
> >>> with cc 2 because it sees that FC clear function is set. Or?  
> >>
> >> Maybe for virtio, but for vfio this all gets passed through to the
> >> kernel who makes that distinction. And as I've mentioned above, that's
> >> not happening.  
> > 
> > Let's have a look at the following qemu functions. AFAIK it is
> > common to vfio and virtio, or? Will prefix my inline   
> 
> My mistake, I didn't look far enough up the callchain in my quick look
> at the code.
> 
> ...snip...
> 

No problem. I'm glad I was at least little helpful.

> > 
> > So unless somebody (e.g. the kernel vfio-ccw) nukes the FC bits qemu
> > should prevent the second SSCH from your example getting to the kernel,
> > or?  
> 
> It's not so much something "nukes the FC bits" ... but rather that that
> the data in the irb_area of the io_region is going to reflect what the
> subchannel told us for the interrupt.

This is why the word composition came into my mind. If the HW subchannel
has FC clear, but QEMU subchannel does not the way things compose (or
superpose) is fishy.

> 
> Hrm... If something is polling on TSCH instead of waiting for a tap on
> the shoulder, that's gonna act weird too. Maybe the bits need to be in
> io_region.irb_area proper, rather than this weird private->scsw space.

Do we agree that the scenario you described with that diagram should not
have hit kernel in the first place, because if things were correct QEMU
should have fenced the second SSCH?

I think you do, but want to be sure. If not, then we need to meditate
some more on this.

I do tend to think that the kernel part is not supposed to rely on
userspace playing nice. Especially when it comes to integrity and
correctness. I can't tell  just yet if this is something we must
or just can catch in the kernel module. I'm for catching it regardless,
but I'm even more for everything working as it is supposed. :)

Regards,
Halil
