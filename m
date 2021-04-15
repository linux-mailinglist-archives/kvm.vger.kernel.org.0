Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C59360751
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 12:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhDOKjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 06:39:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229481AbhDOKjl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 06:39:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FAXmM5008654;
        Thu, 15 Apr 2021 06:38:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=psn3DZgaprlJLV0BRJ/BAVGKz59VmYfg2eUMYc2+zS4=;
 b=jCHrO7la0kfaud/8GLiCl3bYA0PeNVY5T4wUo8iFVA0wkJh5EMq1mOwpyFzNbHnoXuZ4
 71UHRqy3RhRHVV0gEKj6NkivCvxLQsIQ7LtSq1jIbMiXfk6UQYeQ75S4AB6tk0UbgDOc
 p0+9Dx7kfKLlDpMnTppC7saA9uP0P04ry2Dk7QiE8gbVrshbWRuR643Rins+PssnhvWE
 miOmsYkcnYwnjSXJzD2Be6IhqS2jTgzdy4SQmakLu3fOQTsLPz7yTZvXf4JbMRhBAkjd
 XVn4g7yC0HO3wSzn5sslRzDr0H2esBUAboxlUPok35Hbqcnaq7ba6apn5zUTjRcj71xz 5Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xbqk3rdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 06:38:58 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FAXt48018949;
        Thu, 15 Apr 2021 10:38:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 37u39ha245-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 10:38:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FAcsQR9830768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 10:38:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E81F611C054;
        Thu, 15 Apr 2021 10:38:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E6B11C04A;
        Thu, 15 Apr 2021 10:38:53 +0000 (GMT)
Received: from osiris (unknown [9.171.3.254])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 15 Apr 2021 10:38:53 +0000 (GMT)
Date:   Thu, 15 Apr 2021 12:38:52 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        nathan@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 3/5] s390: Get rid of oprofile leftovers
Message-ID: <YHgXvFCLh0Ls0b9t@osiris>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414134409.1266357-4-maz@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0anE4PGcxBYlU4oJrE2IcbTp6vUyz4kt
X-Proofpoint-ORIG-GUID: 0anE4PGcxBYlU4oJrE2IcbTp6vUyz4kt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_03:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 spamscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=721 bulkscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 14, 2021 at 02:44:07PM +0100, Marc Zyngier wrote:
> perf_pmu_name() and perf_num_counters() are unused. Drop them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/s390/kernel/perf_event.c | 21 ---------------------
>  1 file changed, 21 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>

...or do you want me to pick this up and route via the s390 tree(?).
