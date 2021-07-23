Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E6A3D36E9
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 10:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhGWH6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 03:58:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55324 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229907AbhGWH6k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 03:58:40 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16N8aau6131682;
        Fri, 23 Jul 2021 04:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AURgLZcq+PGnRLM9eNyRT8YvJ+Qv7YxFboCX2OOW/4k=;
 b=LW4i4BcBltdgcd9CYf90PkKXs0DGeDbyEQZ/+XLCkAbvWj//z/p4Fh2of5UaCFCV8KJz
 78R18ID3gTBarjnup5gSFT8VZf8BEXPVzyGB6ebMizVzNwuDs5Lw9hmoC5qq1HZFBRLo
 uszqNawUmct0kgB8xsve7/Pnxe5GuSjm8UFQDw41HtmJ93SMmNrzzt4adOF8Yva4Ti39
 m2hzeZhZTvsf1oaiJUc9SXuc3uC/Dkgw2MNnsp+sCiSuj91L60Z+CmrAXQpp/A/7xrij
 HMv06w4WnsfmhMMFZCqrg+vu+LuHkm21PpTDckELUkCCVPS7JLcKQEEizWNLkQ4N7DDO gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ypjedpg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 04:39:13 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16N8aoSt133323;
        Fri, 23 Jul 2021 04:39:13 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ypjedpfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 04:39:13 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16N8XCY7004112;
        Fri, 23 Jul 2021 08:34:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 39upu89s87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 08:34:11 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16N8Y78L29229448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 08:34:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 917C111C05E;
        Fri, 23 Jul 2021 08:34:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FE6111C052;
        Fri, 23 Jul 2021 08:34:07 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.25.128])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Jul 2021 08:34:06 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] s390x: KVM: accept STSI for CPU topology
 information
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
 <1626973353-17446-2-git-send-email-pmorel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <9af7e42f-2d01-08d6-f27f-9e7b5bec360f@de.ibm.com>
Date:   Fri, 23 Jul 2021 10:34:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1626973353-17446-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9DGc1GyTj-GwmXfl1qUJbxqyEbZ6IH-L
X-Proofpoint-ORIG-GUID: sULkz_THbiT9g3_tsk9utUx-RFz9_A4Z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_03:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107230049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.07.21 19:02, Pierre Morel wrote:
> STSI(15.1.x) gives information on the CPU configuration topology.
> Let's accept the interception of STSI with the function code 15 and
> let the userland part of the hypervisor handle it when userland
> support the CPU Topology facility.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   arch/s390/kvm/priv.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 9928f785c677..8581b6881212 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -856,7 +856,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>   	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>   		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>   
> -	if (fc > 3) {
> +	if ((fc > 3 && fc != 15) ||
> +	    (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {

Especially as you use test_kvm_facility here you really want to have the cpu
model in patch 2 (and not CAP).

>   		kvm_s390_set_psw_cc(vcpu, 3);
>   		return 0;
>   	}
> @@ -893,6 +894,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>   			goto out_no_data;
>   		handle_stsi_3_2_2(vcpu, (void *) mem);
>   		break;
> +	case 15:
> +		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
> +		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
> +		return -EREMOTE;
>   	}
>   	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>   		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
> 
