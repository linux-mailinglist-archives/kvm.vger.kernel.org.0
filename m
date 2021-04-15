Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760F73608FF
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 14:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhDOMMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 08:12:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231590AbhDOMMy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 08:12:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FC4982064386;
        Thu, 15 Apr 2021 08:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=0qmyfG6khRpUOKcXpSEaC/J9TizHeX8zVO1F8w3sqWk=;
 b=joVs24R/42uPu6TAZl2eclklMxA31xdJPYE3bnVojAVNlLlmuCn/T+gxGAbCj1xALnMD
 BnGRroXfmU7QqX4j6AOj2BlraPJ0PxJz5Hy3Lee9ltHLDfvttJuFhTjMukZNU2DIsjtj
 MBJq25gtWdgS5GrCuFRwdO3ESuwnrIh+a4z8P1+WsncktYlGaYnSLU36c/EFay/thW/3
 sSs3/Jb1eJH0+AQUASbvpBKHIPHv2LoWRyRobQI1WCghg9uJGid4K5+0j8qIFhUfF5I5
 +gbHiv85aRMdgwb5GhAAHF7fzMRv4UtRYUIfR1IdLAiR2DWKyTev1sSR8qtWloR23zCq CA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xbqb6dv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 08:12:16 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13FC7YAO007426;
        Thu, 15 Apr 2021 12:12:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n8bv3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Apr 2021 12:12:14 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13FCCCQV26018220
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 12:12:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86AB042041;
        Thu, 15 Apr 2021 12:12:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC84E4203F;
        Thu, 15 Apr 2021 12:12:11 +0000 (GMT)
Received: from osiris (unknown [9.171.3.254])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 15 Apr 2021 12:12:11 +0000 (GMT)
Date:   Thu, 15 Apr 2021 14:12:10 +0200
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
Message-ID: <YHgtmjjtk9dDa7/R@osiris>
References: <20210414134409.1266357-1-maz@kernel.org>
 <20210414134409.1266357-4-maz@kernel.org>
 <YHgXvFCLh0Ls0b9t@osiris>
 <87fszrn7sx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fszrn7sx.wl-maz@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vARCqOoco7d3n4Ke2RUPNWmaue1niUQS
X-Proofpoint-ORIG-GUID: vARCqOoco7d3n4Ke2RUPNWmaue1niUQS
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_04:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=714
 suspectscore=0 phishscore=0 mlxscore=0 clxscore=1015 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 11:47:26AM +0100, Marc Zyngier wrote:
> On Thu, 15 Apr 2021 11:38:52 +0100,
> Heiko Carstens <hca@linux.ibm.com> wrote:
> > 
> > On Wed, Apr 14, 2021 at 02:44:07PM +0100, Marc Zyngier wrote:
> > > perf_pmu_name() and perf_num_counters() are unused. Drop them.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/s390/kernel/perf_event.c | 21 ---------------------
> > >  1 file changed, 21 deletions(-)
> > 
> > Acked-by: Heiko Carstens <hca@linux.ibm.com>
> > 
> > ...or do you want me to pick this up and route via the s390 tree(?).
> 
> Either way work for me, but I just want to make sure the last patch
> doesn't get applied before the previous ones.

Ok, I applied this one to the s390 tree. Thanks!
