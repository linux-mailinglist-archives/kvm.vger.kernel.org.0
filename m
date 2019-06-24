Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1473509CF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfFXLbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 07:31:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbfFXLbQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jun 2019 07:31:16 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OBRjdb008401
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:31:15 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2taumrdwy8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:31:14 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Mon, 24 Jun 2019 12:31:12 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Jun 2019 12:31:11 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5OBV07K36831602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 11:31:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9450511C054;
        Mon, 24 Jun 2019 11:31:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E16211C04C;
        Mon, 24 Jun 2019 11:31:09 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.137])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jun 2019 11:31:09 +0000 (GMT)
Date:   Mon, 24 Jun 2019 13:31:07 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing
 a channel program
In-Reply-To: <20190624114231.2d81e36f.cohuck@redhat.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
        <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
        <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
        <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
        <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
        <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
        <20190624114231.2d81e36f.cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062411-0008-0000-0000-000002F683D8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062411-0009-0000-0000-00002263AF0F
Message-Id: <20190624133107.791601be.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jun 2019 11:42:31 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> > > It can issue whatever it wants, but shouldn't the SSCH get a CC2 until
> > > the halt/clear pending state is cleared?  Hrm, fsm_io_request() doesn't
> > > look.  Rather, it (fsm_io_helper()) relies on the CC2 to be signalled
> > > from the SSCH issued to the device.  There's a lot of stuff that happens
> > > before we get to that point.

Yes CC2 would be the correct thing to do in this situation. Doesn't QEMU
do some sort of logic of this kind already. AFAIR QEMU should reject the
SSCH because it knows that the halt/clear function is in progress or
pending. Or am I worng?

Even if QEMU does it, the kernel must not rely on QEMU or
whatever userspace doing it correctly. What I'm trying to say, if QEMU
can do it vfio_ccw should do it as well.

I'm almost always in favor of sticking close to what PoP says.

    
> > 
> > Yes, and stuff that happens is memory allocation, pinning and other 
> > things which can take time.
> >   
> > > 
> > > I'm wondering if there's a way we could/should return the SSCH here
> > > before we do any processing.  After all, until the interrupt on the
> > > workqueue is processed, we are busy.
> > >     
> > 
> > you mean return the csch/hsch before processing the ssch? Maybe we could 
> > extend CP_PENDING state, to just PENDING and use that to reject any ssch 
> > if we have a pending csch/hsch?  
> 
> I'd probably not rely on the state for this. Maybe we could look at the
> work queue? But it might be that the check for the intparm I suggested
> above is already enough.

PoP says function control bits are what matter here:
"""
Condition code 2 is set, and no other action is
taken, when a start, halt, or clear function is currently
in progress at the subchannel (see “Function Control
(FC)” on page 13).
"""

Regards,
Halil

