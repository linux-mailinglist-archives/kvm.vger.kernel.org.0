Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0CC3F1B35
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 16:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240415AbhHSOHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 10:07:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240200AbhHSOHl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 10:07:41 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JE2kjZ126271;
        Thu, 19 Aug 2021 10:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=cJ/S1M1hg9zd6qWUv0l7ZRLFUiNJv5/lYnSw0pINsSA=;
 b=ak8LhFRtnfgH87kVqWeRblsnLMpVDy6L6Vn72pJ8x//Jo7QhuvOkSxv4jdL/Ejv/qrEp
 0NeNlEDTMqQRe6iwPsw6UQLoKn8bOt44XtYmadEqKI6uSUWhxVRt4irgrj0knVOAKSXM
 W+zibSP4/FSo0vr28vDJHAvL+u5wl9S3s1YFVCxbUZrJKQA7u7KQVBA0SWNUI8h3lvM4
 vI9rNvtX2ZAH9hYGKSU3ycEOePCqKvSeuaDkLfZvZ2FeYSOfo+VjjXMH0r7hj9+cQR/G
 k6lr59rcpcYUvOwOy2mCkUW9glPlKbvKt8JpR0tte/sLS2jpwRBhoaw25OyrRYQfUeBM +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvnrw2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:06:57 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17JE3ah1130177;
        Thu, 19 Aug 2021 10:06:57 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvnrw2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 10:06:57 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JDv3jM015857;
        Thu, 19 Aug 2021 14:06:56 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3ae5fexwft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 14:06:56 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JE6smx43712998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 14:06:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F3B78076;
        Thu, 19 Aug 2021 14:06:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7C7D7808C;
        Thu, 19 Aug 2021 14:06:51 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 14:06:51 +0000 (GMT)
Message-ID: <538733190532643cc19b6e30f0eda4dd1bc2a767.camel@linux.ibm.com>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, frankeh@us.ibm.com,
        dovmurik@linux.vnet.ibm.com
Date:   Thu, 19 Aug 2021 10:06:50 -0400
In-Reply-To: <YR4U11ssVUztsPyx@work-vm>
References: <cover.1629118207.git.ashish.kalra@amd.com>
         <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
         <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
         <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
         <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
         <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
         <YR1ZvArdq4sKVyTJ@work-vm>
         <c1d8dbca-c6a9-58da-6f95-b33b74e0485a@linux.ibm.com>
         <YR4U11ssVUztsPyx@work-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vnuA3H72Yed_XiAueAWi-AudofFAPh8v
X-Proofpoint-GUID: uJBNORBi0RtY44VsHzuVydBprpPJ_Zv-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_04:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108190083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-08-19 at 09:22 +0100, Dr. David Alan Gilbert wrote:
> * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> > On 8/18/21 3:04 PM, Dr. David Alan Gilbert wrote:
> > > * Tobin Feldman-Fitzthum (tobin@linux.ibm.com) wrote:
> > > > On 8/17/21 6:04 PM, Steve Rutherford wrote:
> > > > > Ahh, It sounds like you are looking into sidestepping the
> > > > > existing AMD-SP flows for migration. I assume the idea is to
> > > > > spin up a VM on the target side, and have the two VMs attest
> > > > > to each other. How do the two sides know if the other is
> > > > > legitimate? I take it that the source is directing the LAUNCH
> > > > > flows?
> > > >  
> > > > Yeah we don't use PSP migration flows at all. We don't need to
> > > > send the MH code from the source to the target because the MH
> > > > lives in firmware, which is common between the two.
> > >  
> > > Are you relying on the target firmware to be *identical* or
> > > purely for it to be *compatible* ?  It's normal for a migration
> > > to be the result of wanting to do an upgrade; and that means the
> > > destination build of OVMF might be newer (or older, or ...).
> > > 
> > > Dave
> > 
> > This is a good point. The migration handler on the source and
> > target must have the same memory footprint or bad things will
> > happen. Using the same firmware on the source and target is an easy
> > way to guarantee this. Since the MH in OVMF is not a contiguous
> > region of memory, but a group of functions scattered around OVMF,
> > it is a bit difficult to guarantee that the memory footprint is the
> > same if the build is different.
> 
> Can you explain what the 'memory footprint' consists of? Can't it
> just be the whole of the OVMF rom space if you have no way of nudging
> the MH into it's own chunk?

It might be possible depending on how we link it. At the moment it's
using the core OVMF libraries, but it is possible to retool the OVMF
build to copy those libraries into the MH DXE.

> I think it really does have to cope with migration to a new version
> of host.

Well, you're thinking of OVMF as belonging to the host because of the
way it is supplied, but think about the way it works in practice now,
forgetting about confidential computing: OVMF is RAM resident in
ordinary guests, so when you migrate them, the whole of OVMF (or at
least what's left at runtime) goes with the migration, thus it's not
possible to change the guest OVMF by migration.  The above is really
just an extension of that principle, the only difference for
confidential computing being you have to have an image of the current
OVMF ROM in the target to seed migration.

Technically, the problem is we can't overwrite running code and once
the guest is re-sited to the target, the OVMF there has to match
exactly what was on the source for the RT to still function.   Once the
migration has run, the OVMF on the target must be identical to what was
on the source (including internally allocated OVMF memory), and if we
can't copy the MH code, we have to rely on the target image providing
this identical code and we copy the rest.

James


