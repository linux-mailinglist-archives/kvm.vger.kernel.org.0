Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3BA3FC940
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhHaOCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 10:02:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32956 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235810AbhHaOAR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 10:00:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17VDrnvH130935;
        Tue, 31 Aug 2021 09:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mBOn8m8jCwLqf74Z7gm33BDn0C0gJvYkzhrNZyPdn54=;
 b=P/Heh59AyuFJHtYVL4zkLjHV4AbXZwPzcaWpNcLAxeezVAksg9fcn+e2Jf+CAApK0inm
 9ldta45wFjDfzw3O5FBjf/3d5ng03iljxs+HHaqMdl790dOzfABgRZusAt1rbJYVMECA
 wnhdURzt4ESScz5fF4nrcr+J1xGfYsDUHFxWil3PeeyEttdpZ3OC3VkSDHygYMGJn8rI
 k0mIuTVa26dK0jQrLp5o9/jHYrBhNuPPWxYKyEvlJDal28kfTmmT1GZWj9IL1u9c8vMk
 k2dFb9hLankYX0P6c2iBMbR+YRrCglteXyzsnjltsaRmREzRfVADqX7bTNfQYD55ShrX Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asjq46jgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 09:59:14 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17VDsRHY134140;
        Tue, 31 Aug 2021 09:59:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asjq46jf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 09:59:13 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VDwae3000367;
        Tue, 31 Aug 2021 13:59:11 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3aqcs9bp2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 13:59:11 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17VDx6PH25624836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 13:59:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCBE652050;
        Tue, 31 Aug 2021 13:59:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.178.107])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 401E35204E;
        Tue, 31 Aug 2021 13:59:06 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 02/14] KVM: s390: pv: avoid double free of sida page
Message-ID: <857732a7-906b-8275-a6fb-d2512f50c280@linux.ibm.com>
Date:   Tue, 31 Aug 2021 15:59:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Uha_fvIuA1uh8EQuTa41FHy9odmB21SU
X-Proofpoint-GUID: a3XvPIOo99UsjkxqLUDL6vXpfEyKU1Gb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_05:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 mlxlogscore=706 bulkscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/21 3:26 PM, Claudio Imbrenda wrote:
> If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
> free_page on a random page, since the sidad field is aliased with the
> gbea, which is not guaranteed to be zero.
> 
> The solution is to simply return successfully immediately if the vCPU
> was already non secure.

I have the feeling this has been completely inconsistent from the start.

If we can't destroy a cpu we also won't take the VM out of PV state
because that's only allowed if we have removed all PV CPUs. That means
KVM thinks the VM is in PV mode but most of the CPUs are not.

Granted if the destroy CPU fails it makes more sense to just kill the VM
but looking at QEMU we don't even check the return value of that call.

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")
> ---
>  arch/s390/kvm/pv.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index c8841f476e91..0a854115100b 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -16,18 +16,17 @@
>  
>  int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
>  {
> -	int cc = 0;
> +	int cc;
>  
> -	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
> -		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
> -				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +	if (!kvm_s390_pv_cpu_get_handle(vcpu))
> +		return 0;
> +
> +	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
> +
> +	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> +		     vcpu->vcpu_id, *rc, *rrc);
> +	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
>  
> -		KVM_UV_EVENT(vcpu->kvm, 3,
> -			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
> -			     vcpu->vcpu_id, *rc, *rrc);
> -		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
> -			  *rc, *rrc);
> -	}
>  	/* Intended memory leak for something that should never happen. */
>  	if (!cc)
>  		free_pages(vcpu->arch.pv.stor_base,
> 

