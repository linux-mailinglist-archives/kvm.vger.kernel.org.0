Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD0637F0C4
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 03:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhEMBHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 21:07:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231185AbhEMBHB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 21:07:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14D150C7087267;
        Wed, 12 May 2021 21:05:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=LBtSkqQLQFso9TmdaoND0DnKEsuHjYlHgN/IrGvt/NY=;
 b=bHB8KlxJlTBq9kM3fZ29Cj8ouyPW54/1gii7I7RhIR9N+nwyCEqPcGjwaBrwTz9V+8rV
 HCR1uwQkgt7rCYxZA6878CJXdVewV+0bJ9e+LqNvYnGuqDC8n4/rWWp56SwOFZ2y8aRE
 QXtCRaGDKdvfTlER80ytESPUtSKxki7ro04ES5GCTqcEbxrSv+a+4O3QnHae4xcMQGku
 B7nFIe72gnW3vnPEC6HDb0vB/WihjH9eZebYWBGBDV3CyeVBhpm/AVsY1zHLvcjVt28l
 /Cq5co/4ay9j+S0K1Ahpw2wKZmQY+Jh5PDPsCOj7eWhaslnD0bNkC+erdUBa+ft6FMPr mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38grxmhkpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 21:05:51 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14D15pwk094199;
        Wed, 12 May 2021 21:05:51 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38grxmhknt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 May 2021 21:05:51 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14D12FlS032528;
        Thu, 13 May 2021 01:05:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 38ef37h559-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 01:05:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14D15kNM14024986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 01:05:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 055E842045;
        Thu, 13 May 2021 01:05:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80DB94203F;
        Thu, 13 May 2021 01:05:45 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.63.111])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 13 May 2021 01:05:45 +0000 (GMT)
Date:   Thu, 13 May 2021 03:05:43 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 0/3] vfio-ccw: Fix interrupt handling for HALT/CLEAR
Message-ID: <20210513030543.67601a8c.pasic@linux.ibm.com>
In-Reply-To: <20210511195631.3995081-1-farman@linux.ibm.com>
References: <20210511195631.3995081-1-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: D-gxEDFciGC1-ajuw9Jlr1KCSQHQA1t8
X-Proofpoint-ORIG-GUID: ZTUDcHIp6Hdmj_hzrBzfUIGr84wIQV2k
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-12_13:2021-05-12,2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 21:56:28 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Hi Conny, Matt, Halil,
>=20
> Here's one (last?) update to my proposal for handling the collision
> between interrupts for START SUBCHANNEL and HALT/CLEAR SUBCHANNEL.
>=20
> Only change here is to include Conny's suggestions on patch 3.
>=20
> Thanks,

I believe these changes are beneficial, although I don't understand
everything about them. In that sense I'm happy with the these getting
merged.

Let me also spend some words answering the unasked question, what I'm
not understanding about these.

Not understanding how the problem stated in the cover letter of v4 is
actually resolved is certainly the most important one. Let me cite
the relevant part of it (your cover letter already contains a link to
the full version).

"""

	CPU 1			CPU 2
 1	CLEAR SUBCHANNEL
 2	fsm_irq()
 3				START SUBCHANNEL
 4	vfio_ccw_sch_io_todo()
 5				fsm_irq()
 6				vfio_ccw_sch_io_todo()

=46rom the channel subsystem's point of view the CLEAR SUBCHANNEL (step 1)
is complete once step 2 is called, as the Interrupt Response Block (IRB)
has been presented and the TEST SUBCHANNEL was driven by the cio layer.
Thus, the START SUBCHANNEL (step 3) is submitted [1] and gets a cc=3D0 to
indicate the I/O was accepted. However, step 2 stacks the bulk of the
actual work onto a workqueue for when the subchannel lock is NOT held,
and is unqueued at step 4. That code misidentifies the data in the IRB
as being associated with the newly active I/O, and may release memory
that is actively in use by the channel subsystem and/or device. Eww.
"""

The last sentence clearly states "may release memory that is actively
used by ... the device", and I understood it refers to the invocation
of cp_free() from vfio_ccw_sch_io_todo(). Patch 3 of this series does
not change the conditions under which cp_free() is called.

Looking at the cited diagram, since patch 3 changes things in
vfio_ccw_sch_io_todo() it probably ain't affecting steps 1-3 and
I understood the description so that bad free happens in step 4.

My guess is that your change from patch 3 somehow via the fsm prevents
the SSCH on CPU 2 (using the diagram) from being executed  if it actually
happens to be after vfio_ccw_sch_io_todo(). And patch 1 is supposed to
prevent the SSCH on CPU2 from being executed in the depicted case because
if there is a cp to free, then we would bail out form if we see it
while processing the new IO request.

In any case, I don't want to hold this up any further.

Regards,
Halil
