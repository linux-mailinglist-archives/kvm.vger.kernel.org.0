Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A18447E9E
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhKHLPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:15:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64840 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237275AbhKHLPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 06:15:04 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8A5jDX032137;
        Mon, 8 Nov 2021 11:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vrlk0DS0skMbOGcYGgIPcDTU+NzVsDROiDGC5k5glBc=;
 b=i30LgdhnRa1eWremX06x7eF3/0wJZ2VXe03AjfpIC70lu7sw4aQLgwuB2v0cCbz/uePV
 KAOvpQWk6zj3RcuK3xJsUUgEgH5oK/DLxLDLEfeTUJGcygVnhaIELjXV0XIlrqJf23Bp
 JfUK6FTLQnXFdmoeqlEovo37lj0iM/wsjj6WTDcNadEunE7THb15+lijKaRD140GnigL
 p9nEuEL7ZIc7ZL8d/eP/JwP1VhcJUNJkblw0BIkVFRjrP/AAnvJqALKXJJFvv5DAiA1S
 etXCf7xc0sbcnr3pOI917S983xhHx16X3tmVa7YW7umMz8iTF3DnCrWWDI1j0Wlvy2B9 Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6gxdcdah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 11:12:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8Awshf002043;
        Mon, 8 Nov 2021 11:12:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6gxdcd9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 11:12:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8B8CkW022035;
        Mon, 8 Nov 2021 11:12:17 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3c5hb9uyrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 11:12:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8B5dLj64815458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 11:05:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E7D452050;
        Mon,  8 Nov 2021 11:12:14 +0000 (GMT)
Received: from [9.145.83.128] (unknown [9.145.83.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B8F0152059;
        Mon,  8 Nov 2021 11:12:13 +0000 (GMT)
Message-ID: <4488b572-11bf-72ff-86c0-395dfc7b3f71@linux.ibm.com>
Date:   Mon, 8 Nov 2021 12:12:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
Content-Language: en-US
To:     Collin Walling <walling@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, imbrenda@linux.ibm.com
References: <20211027025451.290124-1-walling@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211027025451.290124-1-walling@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yL9cOTcnWbK5eDssAy75CIaSZgiIOHR4
X-Proofpoint-GUID: nxJhD1ra3RzQ9TPpFGZHEPHC-GpJT9q3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080070
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/21 04:54, Collin Walling wrote:
> The diag 318 data contains values that denote information regarding the
> guest's environment. Currently, it is unecessarily difficult to observe
> this value (either manually-inserted debug statements, gdb stepping, mem
> dumping etc). It's useful to observe this information to obtain an
> at-a-glance view of the guest's environment, so lets add a simple VCPU
> event that prints the CPNC to the s390dbf logs.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..da3ff24eabd0 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4254,6 +4254,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
>   	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>   		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>   		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
> +		VCPU_EVENT(vcpu, 2, "setting cpnc to %d", vcpu->arch.diag318_info.cpnc);
>   	}
>   	/*
>   	 * If userspace sets the riccb (e.g. after migration) to a valid state,
> 

Won't that turn up for every vcpu and spam the log?
