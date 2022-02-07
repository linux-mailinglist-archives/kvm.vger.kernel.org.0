Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46B94AC691
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbiBGQ6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387845AbiBGQpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:45:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51ED6C0401E4;
        Mon,  7 Feb 2022 08:45:10 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217Gj8WJ017661;
        Mon, 7 Feb 2022 16:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Wn3cHGLsCkpLD1yN0zsIh2nyTxz13NTEr34OKOO5TiI=;
 b=sficCiC3VuMLOXAR9t1Jbk1x2ZhuBbwOv3pTRS19E4ILfFIx4EDTVG4kpkab//Nk4aOi
 KUkZeShaFgACP84ThgPXDyP5M+QS9o+b7krhI57MFiUZtHKiR92xWeuAby3u3zXCPBSq
 mek4hLoEfqq+7kf6ber6hgXM2mq3iMcmbgvOZl9YpWBynVPyJXVRr91QbEiz1pZITEQq
 5Df/Vdlqbczvw4mTxG7jaJRuAzAv5MQzNcznZaO+Ahvv5QqjdN5h0qkd6I+fPKFbcWVJ
 q8/L1t9SuDO2d1Av+/cQDgxcX67bcWcsbokltJgC5W4OsYcamiYupAOBcPIVkPipbPKr fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e1huxc5as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 16:45:09 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217Git9l016861;
        Mon, 7 Feb 2022 16:44:55 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e1huxc4dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 16:44:54 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217GWQrx023001;
        Mon, 7 Feb 2022 16:34:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3e1gghwwt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 16:34:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217GY5d838535480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 16:34:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DA72AE067;
        Mon,  7 Feb 2022 16:34:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E9D6AE051;
        Mon,  7 Feb 2022 16:34:04 +0000 (GMT)
Received: from [9.171.30.247] (unknown [9.171.30.247])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 16:34:04 +0000 (GMT)
Message-ID: <3fb40993-a560-16ce-f43b-d7bdf0a732ba@linux.ibm.com>
Date:   Mon, 7 Feb 2022 17:36:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 29/30] KVM: s390: introduce CPU feature for zPCI
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
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-30-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220204211536.321475-30-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hhmNDT0rBplMUMprQeP0ea9loEYek1hg
X-Proofpoint-GUID: YlhI5fVP3d-eS6cdDy_LxRJke81XdGk4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/4/22 22:15, Matthew Rosato wrote:
> KVM_S390_VM_CPU_FEAT_ZPCI_INTERP relays whether zPCI interpretive
> execution is possible based on the available hardware facilities.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>



> ---
>   arch/s390/include/uapi/asm/kvm.h | 1 +
>   arch/s390/kvm/kvm-s390.c         | 5 +++++
>   2 files changed, 6 insertions(+)
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
> index 208b09d08385..e20d9ac1935d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -434,6 +434,11 @@ static void kvm_s390_cpu_feat_init(void)
>   	if (test_facility(151)) /* DFLTCC */
>   		__insn32_query(INSN_DFLTCC, kvm_s390_available_subfunc.dfltcc);
>   
> +	/* zPCI Interpretation */
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV) && test_facility(69) &&
> +	    test_facility(70) && test_facility(71) && test_facility(72))
> +		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ZPCI_INTERP);
> +
>   	if (MACHINE_HAS_ESOP)
>   		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
>   	/*
> 

-- 
Pierre Morel
IBM Lab Boeblingen
