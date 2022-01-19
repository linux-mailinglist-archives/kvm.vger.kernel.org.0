Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D22493B2E
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 14:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbiASNiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 08:38:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbiASNiV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 08:38:21 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JBSog9005162;
        Wed, 19 Jan 2022 13:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=HbG6NWXqGqLalCu6NZEP7hHtQq8F8NOCoIRmlek7Bno=;
 b=SNSSV78S2GjtWceMDcycJ6VJ9AWL4E11EqTYNynwAasEj5DBs4ogyS8J2XCjHXDmV0Ve
 wjMatMIkU1jmIOsseB/l8dUPGNr4mN3qI+VXYiQOZIVJ0AhUVOFbGbBvDiCKMEoPPxMy
 DIyhKno3iF7Tr8nEyenIWOEoJG2V657zpLX+zwDHKVHMNhgDzBUALmPc+6po62qHPn6p
 31yN2dhB/iiYpKgpOmJzuqYIYfKqVdYNE8UCVxRazUgPo5mAC9lY4oFtKB4Ji9505XER
 9mLpmy1ioxbfe1bmrZlHUq1UUPw6KR6jAEPzwG+VJKCjnrPMfnk0Ga9KHXRdXxRmHcMC Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpht2jpfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 13:38:21 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JDLsxm011940;
        Wed, 19 Jan 2022 13:38:20 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpht2jpeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 13:38:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JDXKtb001327;
        Wed, 19 Jan 2022 13:38:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3dnm6rdhx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 13:38:17 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JDcE3s41746752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 13:38:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25B2DA4040;
        Wed, 19 Jan 2022 13:38:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30FADA405F;
        Wed, 19 Jan 2022 13:38:13 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 13:38:13 +0000 (GMT)
Message-ID: <27c5a295-8bb0-f6b2-bafe-9900e28403a7@linux.ibm.com>
Date:   Wed, 19 Jan 2022 14:39:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 29/30] KVM: s390: introduce CPU feature for zPCI
 Interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-30-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-30-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BN6ZRbAKBMcKcLIfc0phijYHIHjy_GNf
X-Proofpoint-ORIG-GUID: dUR76aNluFTFVqxfsaA22EhpFowP68QH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_08,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 adultscore=0
 clxscore=1015 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201190078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> KVM_S390_VM_CPU_FEAT_ZPCI_INTERP relays whether zPCI interpretive
> execution is possible based on the available hardware facilities.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/uapi/asm/kvm.h | 1 +
>   arch/s390/kvm/kvm-s390.c         | 4 ++++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> index 7a6b14874d65..ed06458a871f 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -130,6 +130,7 @@ struct kvm_s390_vm_cpu_machine {
>   #define KVM_S390_VM_CPU_FEAT_PFMFI	11
>   #define KVM_S390_VM_CPU_FEAT_SIGPIF	12
>   #define KVM_S390_VM_CPU_FEAT_KSS	13
> +#define KVM_S390_VM_CPU_FEAT_ZPCI_INTERP 14
>   struct kvm_s390_vm_cpu_feat {
>   	__u64 feat[16];
>   };
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b6c32fc3b272..3ed59fe512dd 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -434,6 +434,10 @@ static void kvm_s390_cpu_feat_init(void)
>   	if (test_facility(151)) /* DFLTCC */
>   		__insn32_query(INSN_DFLTCC, kvm_s390_available_subfunc.dfltcc);
>   
> +	if (test_facility(69) && test_facility(70) && test_facility(71) &&
> +	    test_facility(72)) /* zPCI Interpretation */
> +		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ZPCI_INTERP);
> +

Don't we want to start the support of ZPCI interpretation starting with 
Z14 ?

>   	if (MACHINE_HAS_ESOP)
>   		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
>   	/*
> 

-- 
Pierre Morel
IBM Lab Boeblingen
