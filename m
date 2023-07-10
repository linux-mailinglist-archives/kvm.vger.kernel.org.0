Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDB674D857
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjGJODR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 10:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjGJODQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 10:03:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E94EC;
        Mon, 10 Jul 2023 07:03:15 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ADlBjm032659;
        Mon, 10 Jul 2023 14:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hU1OX7zTiM/1ciYBu2XGASr6qx9CnAuGpAIo5Y18TQ4=;
 b=THMdTvnyamCS7RKZkO2fFqozFc4vplNjJkJmAfmkjgA1spsD9UdTyNadbWeQtu9tClfl
 9aRcYWGZYBHFZtC1uE8YDk2g6tvAuJXfwtq3PseQ3vU6jbbrVq5vpJtUzSoOO7qXaj2z
 pRh2AdTu41qCsIXnD49/wkjCZUmH+xpnHR9p+LoCh4Ubbg33tvsNZSc4y828EJgfSKRn
 3GqCyeo5VKoTE8h9Q8pd+b5c6tX3t4hv6im9DZ2Kv2wqBxi2aoHfYHC/pOT5WCM200i4
 O+GfSl3DwyUUpbbPB1X00Q9+El3HYjcGcXOqzeZ0EPoPdvZaU6zu3PqBtdJzekNpT5xU Kg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rrk62gf4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 14:03:13 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36AAsBip025953;
        Mon, 10 Jul 2023 14:03:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3rpy2e8xj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jul 2023 14:03:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36AE36M825363146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 14:03:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB2FC20043;
        Mon, 10 Jul 2023 14:03:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2BAE20040;
        Mon, 10 Jul 2023 14:03:06 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jul 2023 14:03:06 +0000 (GMT)
Date:   Mon, 10 Jul 2023 16:03:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH] KVM: s390: Don't WARN on PV validities
Message-ID: <20230710160304.729a8c51@p-imbrenda>
In-Reply-To: <20230706145335.136910-1-frankja@linux.ibm.com>
References: <20230706145335.136910-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wOOOQ-xnU2AgOCnYwKI7Z_fNjd5APGGy
X-Proofpoint-ORIG-GUID: wOOOQ-xnU2AgOCnYwKI7Z_fNjd5APGGy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_10,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jul 2023 14:53:35 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Validities usually indicate KVM errors and as such we want to print a
> message with a high priority to alert users that a validity
> occurred. With the introduction of Protected VMs it's become very easy
> to trigger validities via IOCTLs if the VM is in PV mode.
> 
> An optimal solution would be to return EINVALs to all IOCTLs that
> could result in such a situation. Unfortunately there are quite a lot
> of ways to trigger PV validities since the number of allowed SCB data
> combinations are very limited by FW in order to provide the guest's
> security.
> 
> Let's only log those validities to the KVM sysfs log and skip the
> WARN_ONCE(). This way we get a longish lasting log entry.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> 
> int -> ext:
>  * Fixed range
>  * Extended commit message 
> 
> ---
>  arch/s390/kvm/intercept.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 954d39adf85c..f3c1220fd1e2 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -97,9 +97,15 @@ static int handle_validity(struct kvm_vcpu *vcpu)
>  	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
>  		  current->pid, vcpu->kvm);
>  
> -	/* do not warn on invalid runtime instrumentation mode */
> -	WARN_ONCE(viwhy != 0x44, "kvm: unhandled validity intercept 0x%x\n",
> -		  viwhy);
> +	/*
> +	 * Do not warn on:
> +	 *  - invalid runtime instrumentation mode
> +	 *  - PV related validities since they can be triggered by userspace
> +	 *    PV validities are in the 0x2XXX range
> +	 */
> +	WARN_ONCE(viwhy != 0x44 &&
> +		  ((viwhy < 0x2000) || (viwhy >= 0x3000)),
> +		  "kvm: unhandled validity intercept 0x%x\n", viwhy);
>  	return -EINVAL;
>  }
>  

