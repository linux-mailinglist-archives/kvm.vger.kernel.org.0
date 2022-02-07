Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58884AB83A
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 11:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbiBGJ7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 04:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353269AbiBGJkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 04:40:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31B5C043181;
        Mon,  7 Feb 2022 01:40:36 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21791W14019419;
        Mon, 7 Feb 2022 09:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qVG4tU4H7fOaP1KwrYkrDs4hBEyqs2LYEUzncyFENFw=;
 b=nXrovFCpiZiYpm9LOaGEfg/GLoeMXCLKtaKv9uyypjzf3WUNxKYF8613dgmX5RHFItda
 jbzgVhSdlLuSDY02zlD5Kfd/bh+NvXzxK+mw0Jix5qE0OnT9wDRhGusHL5RYj5DI9BbE
 3EZf3btZvkyZBOc0xk99/hhYlfXkTTxDxPX2taaryzD53NI5Oxnbfnc5SrnpbyTo2TMf
 pPbG7GDMXKSdSxBoEJ59qB08iCRFB5LBW6L9DLPwfhBMyiSOAADRc7mPsKh6yr/vIg0a
 8VDPpl6BcLJRTbA3RxfUdhqIe++HckMUqLYripK+SxspqYIObjPu82HqkIFH7gBhkjwn rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23anq2gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 09:40:36 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2178vBI5017722;
        Mon, 7 Feb 2022 09:40:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23anq2fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 09:40:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2179bt1H018561;
        Mon, 7 Feb 2022 09:40:33 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjjm5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 09:40:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2179eT1E47120770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 09:40:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93F0242045;
        Mon,  7 Feb 2022 09:40:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36FC042049;
        Mon,  7 Feb 2022 09:40:29 +0000 (GMT)
Received: from [9.145.9.42] (unknown [9.145.9.42])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 09:40:29 +0000 (GMT)
Message-ID: <fe560369-8faa-876f-6c93-fc752a2a3b2d@linux.ibm.com>
Date:   Mon, 7 Feb 2022 10:40:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 03/17] KVM: s390: pv: handle secure storage exceptions
 for normal guests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
 <20220204155349.63238-4-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220204155349.63238-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8JDkixgk1Zo3b_9_S-ZGeULArmGCfv1p
X-Proofpoint-ORIG-GUID: d3JT9EDYHWzyyxBx0Z08UQm8STOxccDW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_03,2022-02-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=858 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 16:53, Claudio Imbrenda wrote:
> With upcoming patches, normal guests might touch secure pages.
> 
> This patch extends the existing exception handler to convert the pages
> to non secure also when the exception is triggered by a normal guest.
> 
> This can happen for example when a secure guest reboots; the first
> stage of a secure guest is non secure, and in general a secure guest
> can reboot into non-secure mode.
> 
> If the secure memory of the previous boot has not been cleared up
> completely yet (which will be allowed to happen in an upcoming patch),
> a non-secure guest might touch secure memory, which will need to be
> handled properly.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Once you fix the compiler warning:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/mm/fault.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 47b52e5384f8..bbd37e2c7962 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -770,6 +770,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	struct vm_area_struct *vma;
>   	struct mm_struct *mm;
>   	struct page *page;
> +	struct gmap *gmap;
>   	int rc;
>   
>   	/*
> @@ -799,6 +800,16 @@ void do_secure_storage_access(struct pt_regs *regs)
>   	}
>   
>   	switch (get_fault_type(regs)) {
> +	case GMAP_FAULT:
> +		gmap = (struct gmap *)S390_lowcore.gmap;
> +		mmap_read_lock(mm);
> +		addr = __gmap_translate(gmap, addr);
> +		mmap_read_unlock(mm);
> +		if (IS_ERR_VALUE(addr)) {
> +			do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
> +			break;
> +		}
> +		fallthrough;
>   	case USER_FAULT:
>   		mm = current->mm;
>   		mmap_read_lock(mm);
> @@ -827,7 +838,6 @@ void do_secure_storage_access(struct pt_regs *regs)
>   		if (rc)
>   			BUG();
>   		break;
> -	case GMAP_FAULT:
>   	default:
>   		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
>   		WARN_ON_ONCE(1);
> 

