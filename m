Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D569D434AE6
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJTMOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:14:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhJTMOe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 08:14:34 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KBMepa000901;
        Wed, 20 Oct 2021 08:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZjTqC/bZ8j3NvcjsHygAq8zulju8Z5Cluk7D9Velp/o=;
 b=SF4XKNk1Wz24ehy+Ogvi43iuazYuAqR9hrzlPzxaaiu6+B91WMWTEbtqm1wJ0aKf9akI
 AomRqCZSzJNIaTHZbyzpXUCXTIOnGZ7xacyQjAOPb+pi62Kw+aFHn1QPVBoMh88eLj/T
 h+NpWPEJSHQYUX29nOXzIP/Tf7qUNei6IJplrNpcuJHzZhUTLKFsCmhz8CIoV8AHp6HG
 SFXlunfk7Zo7/ShQKIuqvDoc4WWGopczypRYlgaBnuvT9qsnfYK7kS+wjqdu5+ah2Cj9
 qrfWfcvEs2vxKnYIQVJJ5071eDUBme57Sp8QA9D+Yb5Rk8VSuTt/tT4GhqUyVdkO94qu 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btj6f908k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:12:19 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19KBbM4b001974;
        Wed, 20 Oct 2021 08:12:19 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btj6f907s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 08:12:19 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KC4L6E031867;
        Wed, 20 Oct 2021 12:12:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3bqp0k9q29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 12:12:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KCCDIh66585022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 12:12:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68AE952059;
        Wed, 20 Oct 2021 12:12:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.29.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 8A92152052;
        Wed, 20 Oct 2021 12:12:12 +0000 (GMT)
Date:   Wed, 20 Oct 2021 14:12:10 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 0/3] fixes for __airqs_kick_single_vcpu()
Message-ID: <20211020141210.557d4fa8.pasic@linux.ibm.com>
In-Reply-To: <66c52e65-4e4c-253f-45bc-69c041e1230c@de.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <66c52e65-4e4c-253f-45bc-69c041e1230c@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IS5dnlJjX6LdLHmkrZcDJBd1-RKyvz4O
X-Proofpoint-GUID: Yf3z6d2vJKq_fst8DLayHeJGTQ0Y8aOd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Oct 2021 13:04:05 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am 19.10.21 um 19:53 schrieb Halil Pasic:
> > The three fixes aren't closely related. The first one is the
> > most imporant one. They can be picked separately. I deciced to send them
> > out together so that if reviewers see: hey there is more broken, they
> > can also see the fixes near by.
> > 
> > Halil Pasic (3):
> >    KVM: s390: clear kicked_mask before sleeping again
> >    KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu
> >    KVM: s390: clear kicked_mask if not idle after set
> > 
> >   arch/s390/kvm/interrupt.c | 12 +++++++++---
> >   arch/s390/kvm/kvm-s390.c  |  3 +--
> >   2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > 
> > base-commit: 519d81956ee277b4419c723adfb154603c2565ba  
> 
> I picked and queued patches 1 and 2. Thanks a lot for fixing.
> I will need some time to dig through the code to decide about patch3.

Sure. In the meantime I think we can do slightly better for patch 3
by making the clear introduced by patch 1 conditional (in patch 3
as patch 3 makes that a safe move).

Regards,
Halil
