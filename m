Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47591469737
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 14:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244111AbhLFNix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 08:38:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26792 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240974AbhLFNiw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 08:38:52 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6BkrCp014929;
        Mon, 6 Dec 2021 13:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=laFtNKd/4jJtFp1QIZggWcepBXEGZGc17z4Y74H1+Z8=;
 b=f0q6z2yZe64Xg9SrWgFpHIONtn8DxInMgZMvAuFDsIDwh+sYL+OcUAfwhCs5/HS/VwIh
 TI+HCAr1qM5wZiIpdbQE0HlcU5hNU8Ck8E/sLiAng1EcnZ8VGpCou6MTzdhcgQ/uKK9Q
 Sb2ymNduYskk9mP94ehAM2zyOcdv1uP1u8zZtqGgZt4WlXLYr5aZks5Mot6iG+2MQ9Kj
 JvWg75+lbOI2NfblwMkUslPbQ8Y7fmBYshnWqY/JwwTBPVWpYjRHDbuQH3jiYTliXMpN
 qTlJZ+Eo5IAaXSOzHtsiDHHsiCdGnY0tOYJmLZublo0Fxd9rsHmmAhF7s2k6Ze+FoDEy bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cshxst2qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 13:35:22 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B6CULbu013103;
        Mon, 6 Dec 2021 13:35:22 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cshxst2qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 13:35:22 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B6DWNau004610;
        Mon, 6 Dec 2021 13:35:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3cqyy94mjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 13:35:20 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B6DZGMr26739036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Dec 2021 13:35:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAF674204D;
        Mon,  6 Dec 2021 13:35:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51D2F4204B;
        Mon,  6 Dec 2021 13:35:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Dec 2021 13:35:16 +0000 (GMT)
Date:   Mon, 6 Dec 2021 14:35:13 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sebastian Mitterle <smitterl@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/2] s390x: firq: floating interrupt
 test
Message-ID: <20211206143513.76a304f2@p-imbrenda>
In-Reply-To: <20211202123553.96412-1-david@redhat.com>
References: <20211202123553.96412-1-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a6pp4K1V2rFVN1S5G-Oc3WK9XUQniNjU
X-Proofpoint-ORIG-GUID: cR1_J50LfWewSng_PqDrwYcSAtN1fKWr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_04,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Dec 2021 13:35:51 +0100
David Hildenbrand <david@redhat.com> wrote:

> From patch #2:
> 
> "
> We had a KVM BUG fixed by kernel commit a3e03bc1368c ("KVM: s390: index
> kvm->arch.idle_mask by vcpu_idx"), whereby a floating interrupt might get
> stuck forever because a CPU in the wait state would not get woken up.
> 
> The issue can be triggered when CPUs are created in a nonlinear fashion,
> such that the CPU address ("core-id") and the KVM cpu id don't match.
> 
> So let's start with a floating interrupt test that will trigger a
> floating interrupt (via SCLP) to be delivered to a CPU in the wait state.
> "

ok I'll try picking this series

> 
> v1 -> v2:
> - Remove flag logic
> - Extend comments
> - Minor cleanups
> - sclp_clear_busy() before printing to the SCLP console
> 
> David Hildenbrand (2):
>   s390x: make smp_cpu_setup() return 0 on success
>   s390x: firq: floating interrupt test
> 
>  lib/s390x/sclp.c    |  11 ++--
>  lib/s390x/sclp.h    |   1 +
>  lib/s390x/smp.c     |   1 +
>  s390x/Makefile      |   1 +
>  s390x/firq.c        | 122 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  10 ++++
>  6 files changed, 143 insertions(+), 3 deletions(-)
>  create mode 100644 s390x/firq.c
> 

