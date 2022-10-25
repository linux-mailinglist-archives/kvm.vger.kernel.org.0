Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9554860C3E1
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 08:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiJYGhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 02:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJYGha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 02:37:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EE6FE92B;
        Mon, 24 Oct 2022 23:37:29 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P6EKFE023479;
        Tue, 25 Oct 2022 06:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zfrGsFpZfWvA5dGfkkX8JDm9CIZ8gkp0jNelTIsenRc=;
 b=GRHKuIIbBM27fJBT2XCyFyvKdIM6HrfWC96m1XKBwR/m8WcXAgawK0vv4wQ+yB3cKMVe
 Cbj70aIil46YafETZCqRYK529cy4H9bS/ZM8pqNEzG280aDm45bucx+diyZXhxfh+Thw
 C2der1ssW1K6eIdRrd/Ld1vj4SqS8gz/gRw2z13NL2WcKpPwYcKVmzpZ81DPxvWBhW7r
 lEuR0+QUU/iuXGjiiKGyREMRqv8BlptXtRdzSfC30a3VaKH/j931kuWNCoFliyyOb56+
 2wMPmfWUbcNTKTZtj28iJOZUAbGEburnj/dd/e9WzwEhq5P6uWBezpvBivrG5LoTkZoc OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3keabx0na5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 06:37:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29P6Iprj010549;
        Tue, 25 Oct 2022 06:37:27 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3keabx0n9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 06:37:27 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29P6Yj2h028545;
        Tue, 25 Oct 2022 06:37:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugas793-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 06:37:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29P6bMim7275056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 06:37:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7902052050;
        Tue, 25 Oct 2022 06:37:22 +0000 (GMT)
Received: from [9.171.5.17] (unknown [9.171.5.17])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 321BC5204E;
        Tue, 25 Oct 2022 06:37:22 +0000 (GMT)
Message-ID: <6dec3e0e-4b77-ffe9-533f-207606e327c4@linux.ibm.com>
Date:   Tue, 25 Oct 2022 08:37:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [v1] KVM: s390: VSIE: sort out virtual/physical address in
 pin_guest_page
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
References: <20221024160237.33912-1-nrb@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20221024160237.33912-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cQWvATlFSmi_dRwbY8oji6BSsfK0cc3w
X-Proofpoint-ORIG-GUID: rfzguxbY2ceRjvWOchT76oZ8trP5edvf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_01,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24.10.22 um 18:02 schrieb Nico Boehr:
> pin_guest_page() used page_to_virt() to calculate the hpa of the pinned
> page. This currently works, because virtual and physical addresses are
> the same. Use page_to_phys() instead to resolve the virtual-real address
> confusion.
> 
> One caller of pin_guest_page() actually expected the hpa to be a hva, so
> add the missing phys_to_virt() conversion here.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 94138f8f0c1c..c6a10ff46d58 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -654,7 +654,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
>   	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
>   	if (is_error_page(page))
>   		return -EINVAL;
> -	*hpa = (hpa_t) page_to_virt(page) + (gpa & ~PAGE_MASK);
> +	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
>   	return 0;
>   }
>   
> @@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>   		WARN_ON_ONCE(rc);
>   		return 1;
>   	}
> -	vsie_page->scb_o = (struct kvm_s390_sie_block *) hpa;
> +	vsie_page->scb_o = (struct kvm_s390_sie_block *)phys_to_virt(hpa);

Do we still need the cast here? phys_to_virt should return a void * and the assignment should succeed.


>   	return 0;
>   }
>   
