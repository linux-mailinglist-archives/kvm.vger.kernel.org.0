Return-Path: <kvm+bounces-483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1929D7E0278
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 13:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EBF8B21451
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 12:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3618215AE3;
	Fri,  3 Nov 2023 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fkRnU2AQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F3914F9F
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 12:01:38 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207F4D43;
	Fri,  3 Nov 2023 05:01:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3BoWgF001467;
	Fri, 3 Nov 2023 12:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tXdWCP6IvP9CCfwXmUw4Ls+/FsbFNc7XchVYpI+k12M=;
 b=fkRnU2AQOs8UXqSZ8FzeKzIT7YiBvbKlR1WP4dBqOUqFh+mAgk8gcdGJF5hRFzeCyr57
 BGre8D7yDAKHa0RQRgOJw8lYT6C79AMkUYCFuTDvV1rw/gr6fYuAAGJ+hNMM+1P+BzZi
 iYi/qwaY3r8Ba1CB4FeR2w9SuSbutR7JyYrfEu3cOTLvPmbc1cnuE7EZOmychgOgZR3s
 kyXmnYtOER5blCxPw1e7AmSPIut+olNzQRcXu5IixBDavUK76ZroJPQAW/1JaDZ5NWvW
 VQaVOUQulElI0zvOxymqIAOrIqYkOTB3/1F4dRjKWROrP2qtSWrbPKpCi9i6K+AQTSGY wA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u50bb09hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 12:01:02 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3BpISY003056;
	Fri, 3 Nov 2023 12:00:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u50bb09a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 12:00:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A39GltY007674;
	Fri, 3 Nov 2023 12:00:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmp5qw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 12:00:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3C0ci735783114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 12:00:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9B3520043;
	Fri,  3 Nov 2023 12:00:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A204A20040;
	Fri,  3 Nov 2023 12:00:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 12:00:37 +0000 (GMT)
Date: Fri, 3 Nov 2023 12:55:37 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sean
 Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 2/3] arch/s390/kvm: copy userspace-array safely
Message-ID: <20231103125537.037bb8c5@p-imbrenda>
In-Reply-To: <20231102181526.43279-3-pstanner@redhat.com>
References: <20231102181526.43279-1-pstanner@redhat.com>
	<20231102181526.43279-3-pstanner@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dvPBF6m8S3gwk57u1Rzys3oxgSAuDOic
X-Proofpoint-GUID: EmI6eegtLK_AUBAz3S7z00xHUhVjhFQV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 clxscore=1011
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2311030100

On Thu,  2 Nov 2023 19:15:25 +0100
Philipp Stanner <pstanner@redhat.com> wrote:

> guestdbg.c utilizes memdup_user() to copy a userspace array. This,
> currently, does not check for an overflow.
> 
> Use the new wrapper memdup_array_user() to copy the array more safely.
> 
> Suggested-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/guestdbg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
> index 3765c4223bf9..80879fc73c90 100644
> --- a/arch/s390/kvm/guestdbg.c
> +++ b/arch/s390/kvm/guestdbg.c
> @@ -213,8 +213,8 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
>  	else if (dbg->arch.nr_hw_bp > MAX_BP_COUNT)
>  		return -EINVAL;
>  
> -	bp_data = memdup_user(dbg->arch.hw_bp,
> -			      sizeof(*bp_data) * dbg->arch.nr_hw_bp);
> +	bp_data = memdup_array_user(dbg->arch.hw_bp, dbg->arch.nr_hw_bp,
> +				    sizeof(*bp_data));
>  	if (IS_ERR(bp_data))
>  		return PTR_ERR(bp_data);
>  


