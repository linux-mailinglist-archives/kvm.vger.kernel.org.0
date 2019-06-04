Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6844A34B0E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfFDO4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 10:56:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41190 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727574AbfFDO4Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jun 2019 10:56:24 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54Eb4gg131109
        for <kvm@vger.kernel.org>; Tue, 4 Jun 2019 10:56:23 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2swr07902h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:56:22 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Tue, 4 Jun 2019 15:56:21 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 15:56:18 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x54EuFI151314830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 14:56:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C71E1A4059;
        Tue,  4 Jun 2019 14:56:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43716A404D;
        Tue,  4 Jun 2019 14:56:15 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.145])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 14:56:15 +0000 (GMT)
Date:   Tue, 4 Jun 2019 16:56:13 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, borntraeger@de.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        freude@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v9 0/4] vfio: ap: AP Queue Interrupt Control
In-Reply-To: <5b46f988-fa79-4d84-c81f-144daa0c4426@linux.ibm.com>
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
        <5b46f988-fa79-4d84-c81f-144daa0c4426@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060414-4275-0000-0000-0000033CA10B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060414-4276-0000-0000-0000384CB085
Message-Id: <20190604165613.4d2803b4.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=839 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 May 2019 11:36:12 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 5/21/19 11:34 AM, Pierre Morel wrote:
> > This patch series implements PQAP/AQIC interception in KVM.
> > 

[..]

> > 
> > Tony, I did not rebase this series above the dynamic configuration
> > patches because:
> > - This series do the work it needs to do without having to take
> >    care on the dynamic configuration.
> > - It is guarantied that interrupt will be shut off after removing
> >    the APQueue device
> > - The dynamic configuration series is not converging.  
> 
> Would you consider the following?
> 
> * Take dynconfig patch "s390: vfio-ap: wait for queue empty on queue

[..]

> 
> If you do the things above, then I can base the dynconfig series on
> the IRQ series without much of a merge issue. What say you?
> 
> Note: I've included review comments for patch 3/4 to match the
>        suggestions above.
> 
> > 
> > However Tony, the choice is your's, I won't be able to help
> > in a near future.

Since Pierre won't available for a while, and the patches look good
enough to me, I would like to pick these if nobody objects.

Any objection?

@Tony: Could you please have another look at patch 3? That is the only
one you haven't r-b yet...

Regards,
Halil

