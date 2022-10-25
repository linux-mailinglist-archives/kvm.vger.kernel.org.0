Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DACA60CAA6
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiJYLJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiJYLJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:09:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010F763F8;
        Tue, 25 Oct 2022 04:09:23 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8WQv018328;
        Tue, 25 Oct 2022 11:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3YOfkDKP0CcPTdIou62mwWmTAAg5NpH7eKPR5+Q7rIA=;
 b=HqXlShKDuOJwqTvTqblzrkFK8Dd5o6zMfP9rmS7JoE4glbsjY8OOUs6MSUk3pBrxoMCC
 vWwswMJZ0p8SMv+IdJk/nRJOUjjOEJVWQNBZQeZ48YfWsGkoN2Ut3FwU3/GvKdCE6z8X
 8MMmA2PSJ8GaSui0TP1xsnuwZIB/rwlGzIGS3RJRqFnFpa6M4ptqazEA9k19VlUTJY54
 el3kxyBNzpNmKPoxZsfSoRCUz1MBsawW4Licv8Nt15msQEVev1o478ZGxgPCYsI06dDU
 sQRDl1/SeRKAGMtr7wA2Ttoz6dSzsRZpkZgrYRuTVex1fL5FImWkToqjLA3kkQeYGzTN 7w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keea78sbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:09:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PB6ckA030332;
        Tue, 25 Oct 2022 11:09:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugat3sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:09:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PB9H9K59113862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:09:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3E0FAE05A;
        Tue, 25 Oct 2022 11:09:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70837AE056;
        Tue, 25 Oct 2022 11:09:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:09:17 +0000 (GMT)
Date:   Tue, 25 Oct 2022 13:09:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [v2 1/1] KVM: s390: VSIE: sort out virtual/physical address in
 pin_guest_page
Message-ID: <20221025130916.1aa39c28@p-imbrenda>
In-Reply-To: <20221025082039.117372-2-nrb@linux.ibm.com>
References: <20221025082039.117372-1-nrb@linux.ibm.com>
        <20221025082039.117372-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0VrH9kXRNF8ANmR9_8_bwx6-S877A378
X-Proofpoint-GUID: 0VrH9kXRNF8ANmR9_8_bwx6-S877A378
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 adultscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Oct 2022 10:20:39 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> pin_guest_page() used page_to_virt() to calculate the hpa of the pinned
> page. This currently works, because virtual and physical addresses are
> the same. Use page_to_phys() instead to resolve the virtual-real address
> confusion.
> 
> One caller of pin_guest_page() actually expected the hpa to be a hva, so
> add the missing phys_to_virt() conversion here.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/vsie.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 94138f8f0c1c..0e9d020d7093 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -654,7 +654,7 @@ static int pin_guest_page(struct kvm *kvm, gpa_t gpa, hpa_t *hpa)
>  	page = gfn_to_page(kvm, gpa_to_gfn(gpa));
>  	if (is_error_page(page))
>  		return -EINVAL;
> -	*hpa = (hpa_t) page_to_virt(page) + (gpa & ~PAGE_MASK);
> +	*hpa = (hpa_t)page_to_phys(page) + (gpa & ~PAGE_MASK);
>  	return 0;
>  }
>  
> @@ -869,7 +869,7 @@ static int pin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>  		WARN_ON_ONCE(rc);
>  		return 1;
>  	}
> -	vsie_page->scb_o = (struct kvm_s390_sie_block *) hpa;
> +	vsie_page->scb_o = phys_to_virt(hpa);
>  	return 0;
>  }
>  

