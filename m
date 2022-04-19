Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084F9506849
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350470AbiDSKHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 06:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350482AbiDSKHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 06:07:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF5D20BCD;
        Tue, 19 Apr 2022 03:05:09 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23J85rai004744;
        Tue, 19 Apr 2022 10:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pEhu7eU39faiAp1VdJ+LRBfdQWDgHmvH0O3z33FDIyo=;
 b=VXrC8E3LDMNr0WEkhK4Ly2S2wTHfU/t8KnUk2yOnN3zVDq5nmKCk0lrdJffF9ovxTI5J
 zXFUif0vvqT1RobXs92HYJ11tzKIrMcJKyR6C2NUB/7lKzS0KwZpuCSBmKjz3nF2CIFE
 10wrDWQaGS7iVAY9K9xH9ZUHsqE8xF6Pi5F0SZg+pQUPT4GITisG+CdfC+KWwMs1Rmpi
 7biRIHsqCfl61mDuPUWyYfJ0L2NBLOQlFwKQZB8eXxD24IYDiF/y56rxFG5N1sCqHbHo
 2VShLOYMHgKG7zXLzs4VxwF4wbv07Trxw5ah7GhfglZmZp3xxQcufj7+KELBsWx+1wXZ EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ekuug2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 10:05:07 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23J9jXDJ010429;
        Tue, 19 Apr 2022 10:05:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ekuuf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 10:05:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23JA2tx6017129;
        Tue, 19 Apr 2022 10:05:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne944qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 10:05:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23J9qGho37683646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 09:52:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 145B842045;
        Tue, 19 Apr 2022 10:05:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1F764203F;
        Tue, 19 Apr 2022 10:05:00 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 10:05:00 +0000 (GMT)
Message-ID: <492b49f4-7800-22af-2924-36f90f32e6b3@linux.ibm.com>
Date:   Tue, 19 Apr 2022 12:08:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 20/21] KVM: s390: introduce CPU feature for zPCI
 Interpretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-21-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404174349.58530-21-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nOtzjr1eQl6CD55HHe1tx75DzsmcJeNp
X-Proofpoint-GUID: 4pQ1VBQMxl8v1i9ETzLfLQVwu_nKIlSH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_03,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190052
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 19:43, Matthew Rosato wrote:
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
> index 65a53e22f686..d6988bd22df8 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -433,6 +433,10 @@ static void kvm_s390_cpu_feat_init(void)
>   	if (test_facility(151)) /* DFLTCC */
>   		__insn32_query(INSN_DFLTCC, kvm_s390_available_subfunc.dfltcc);
>   
> +	/* zPCI Interpretation */
> +	if (kvm_s390_pci_interp_allowed())
> +		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ZPCI_INTERP);
> +
>   	if (MACHINE_HAS_ESOP)
>   		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
>   	/*
> 

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

-- 
Pierre Morel
IBM Lab Boeblingen
