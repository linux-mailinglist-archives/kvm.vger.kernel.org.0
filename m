Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB0F4227A7
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhJENWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:22:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233910AbhJENWG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:22:06 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195D9GI1009167;
        Tue, 5 Oct 2021 09:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JQ1BWJQcsv1HtLKYQ2w1VudWTh4ZhYtEll/PsefK1qk=;
 b=TVLAqvxGxQWkaZNVCnatO0YaDAm66Nec9PVmcKPZCduxpmBAAnTsl+kdNlCKHJebC2tb
 G8n8TzynRZX/yY361SrDB2tMiecWMLl9MRcLnhlCEq2jvL8z8C0Jmwl1xzgBMf9tDgzp
 dEIba2pKxvaWpolGRr8W9dnkr6tmHKVMqvKsXgiDKhwTHkcQfPagHMwVwm+FkooibhIn
 WLIcNXxWnjhcltbtZ6ReTNCM1LB4Kd98zfEhJmATFQhTTDh4YBOdt0/T/wfyolkmzkUz
 nfQ9yh8F+bSS4VFTEbf3ma6zwXILCalNw2B55lr4lLjpP9sBFvW/hIXYd2QoWiNjhg9+ vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgpbshuuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:20:15 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 195D9QQH009554;
        Tue, 5 Oct 2021 09:20:14 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bgpbshuu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 09:20:14 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195DCc1n018080;
        Tue, 5 Oct 2021 13:20:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3bef29rhev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 13:20:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195DK6gR64684464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 13:20:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 959ECA4055;
        Tue,  5 Oct 2021 13:20:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EC4BA405E;
        Tue,  5 Oct 2021 13:20:06 +0000 (GMT)
Received: from [9.145.45.132] (unknown [9.145.45.132])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 13:20:06 +0000 (GMT)
Message-ID: <20f6c2a0-5b27-479a-b4b9-14629bf97693@linux.ibm.com>
Date:   Tue, 5 Oct 2021 15:20:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v5 03/14] KVM: s390: pv: avoid stalls for
 kvm_s390_pv_init_vm
In-Reply-To: <20210920132502.36111-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ve01gRvWIZvi7kJ00EmUC64SIj9HUPcZ
X-Proofpoint-ORIG-GUID: nxSVCChr0awLj1E4UkEH_W3xLqWFeXnV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_01,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/21 15:24, Claudio Imbrenda wrote:
> When the system is heavily overcommitted, kvm_s390_pv_init_vm might
> generate stall notifications.
> 
> Fix this by using uv_call_sched instead of just uv_call. This is ok because
> we are not holding spinlocks.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Oops :)

> ---
>   arch/s390/kvm/pv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 0a854115100b..00d272d134c2 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -195,7 +195,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>   	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
>   	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
>   
> -	cc = uv_call(0, (u64)&uvcb);
> +	cc = uv_call_sched(0, (u64)&uvcb);
>   	*rc = uvcb.header.rc;
>   	*rrc = uvcb.header.rrc;
>   	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
> 

