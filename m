Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131E1429F70
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbhJLIOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:14:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234368AbhJLIOO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 04:14:14 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C880Ut012738;
        Tue, 12 Oct 2021 04:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BUMb2/kAjRsYiMesUqmEMSFpUQzDJjgE9lCagYJ4+48=;
 b=UY8NOLGTQIa2U5CeBhq/FRrPMmI7Ezel3tByI3SHbl7qS32fqxDML7l6MHGEvLn+5fFd
 2MBU9jnlxpG4GBgv9rTsZiTN+L7szRKdNNcwB3b2q3DZ54yXIYdrtnCKnbF1bTFdtt0p
 IXEBq62R6ZGhNVDyt2qXIF8WHI6Mv3uAkB2YaVGgRzCIfZfHjF6xrpNx6m/k+4skFR/U
 LaqfpXOqtje9/K6JR5FfY5tGWiQh9H/k0RRlXxfsNf/vnf0yXo5KWOWK0gefMU2tkzeU
 RILss3Zxypkp54hNmqopvK5wy5Y/AQfSv1ONIjXnA3E+Zcb2O2ZN8TGec1iMZT044usi FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn5apsng9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:12:12 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19C8C9Zl005759;
        Tue, 12 Oct 2021 04:12:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn5apsnff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 04:12:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19C8BPtB031345;
        Tue, 12 Oct 2021 08:12:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2q9wwd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:12:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19C8Bw0E40567280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 08:11:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A16BF42054;
        Tue, 12 Oct 2021 08:11:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 338CF4204B;
        Tue, 12 Oct 2021 08:11:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.7.88])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 08:11:58 +0000 (GMT)
Date:   Tue, 12 Oct 2021 09:35:36 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/6] KVM: s390: Simplify SIGP Set Arch handling
Message-ID: <20211012093536.43b0571c@p-imbrenda>
In-Reply-To: <20211008203112.1979843-2-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
        <20211008203112.1979843-2-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S_vB3yTtfayXsZQMA5Rw2-wANFtLXS_R
X-Proofpoint-GUID: i6npN7L0-ZEjX0GXp1fficYwCRZxmh72
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  8 Oct 2021 22:31:07 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> The Principles of Operations describe the various reasons that
> each individual SIGP orders might be rejected, and the status
> bit that are set for each condition.
> 
> For example, for the Set Architecture order, it states:
> 
>   "If it is not true that all other CPUs in the configu-
>    ration are in the stopped or check-stop state, ...
>    bit 54 (incorrect state) ... is set to one."
> 
> However, it also states:
> 
>   "... if the CZAM facility is installed, ...
>    bit 55 (invalid parameter) ... is set to one."
> 
> Since the Configuration-z/Architecture-Architectural Mode (CZAM)
> facility is unconditionally presented, there is no need to examine
> each VCPU to determine if it is started/stopped. It can simply be
> rejected outright with the Invalid Parameter bit.
> 
> Fixes: b697e435aeee ("KVM: s390: Support Configuration z/Architecture Mode")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

I like removing and simplifying code while staying architecturally
correct :)

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/sigp.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
> index 683036c1c92a..cf4de80bd541 100644
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -151,22 +151,10 @@ static int __sigp_stop_and_store_status(struct kvm_vcpu *vcpu,
>  static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter,
>  			   u64 *status_reg)
>  {
> -	unsigned int i;
> -	struct kvm_vcpu *v;
> -	bool all_stopped = true;
> -
> -	kvm_for_each_vcpu(i, v, vcpu->kvm) {
> -		if (v == vcpu)
> -			continue;
> -		if (!is_vcpu_stopped(v))
> -			all_stopped = false;
> -	}
> -
>  	*status_reg &= 0xffffffff00000000UL;
>  
>  	/* Reject set arch order, with czam we're always in z/Arch mode. */
> -	*status_reg |= (all_stopped ? SIGP_STATUS_INVALID_PARAMETER :
> -					SIGP_STATUS_INCORRECT_STATE);
> +	*status_reg |= SIGP_STATUS_INVALID_PARAMETER;
>  	return SIGP_CC_STATUS_STORED;
>  }
>  

