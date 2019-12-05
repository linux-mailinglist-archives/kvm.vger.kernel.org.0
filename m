Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EC011447E
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 17:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbfLEQJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 11:09:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729817AbfLEQJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 11:09:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5G5jPQ057325
        for <kvm@vger.kernel.org>; Thu, 5 Dec 2019 11:09:41 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wq114nbd1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 11:09:41 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Thu, 5 Dec 2019 16:09:39 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Dec 2019 16:09:37 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB5G9Zcl26214642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Dec 2019 16:09:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A32604204C;
        Thu,  5 Dec 2019 16:09:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 500794203F;
        Thu,  5 Dec 2019 16:09:35 +0000 (GMT)
Received: from osiris (unknown [9.152.212.85])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  5 Dec 2019 16:09:35 +0000 (GMT)
Date:   Thu, 5 Dec 2019 17:09:30 +0100
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups
References: <20191205125147.229367-1-borntraeger@de.ibm.com>
 <087b1693-6ec0-94e3-d94a-f55c2e717438@redhat.com>
 <26f905be-3f09-3b3b-3008-ef64fc93e36c@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26f905be-3f09-3b3b-3008-ef64fc93e36c@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19120516-0016-0000-0000-000002D1B56C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120516-0017-0000-0000-00003333BB5F
Message-Id: <20191205160930.GA13800@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_05:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 phishscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=591 malwarescore=0 impostorscore=0 suspectscore=1
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912050134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 05, 2019 at 02:16:02PM +0100, Christian Borntraeger wrote:
> On 05.12.19 14:09, Thomas Huth wrote:
> > On 05/12/2019 13.51, Christian Borntraeger wrote:
> >> There is no ENOTSUPP for userspace
> >>
> >> Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >> -		return -ENOTSUPP;
> >> +		return -EOPNOTSUPP;
> > There seems to be another one in arch/s390/include/asm/uv.h, are you
> > going to fix that, too?
> I looked into that but it seemed that this is not exposed to
> userspace and just kept internal.

Could you remove that one as well, please? Otherwise people start
copy-pasting this (again). I thought we got rid of them all, and now
they crept in again.

Same for dasd ioctl code...

