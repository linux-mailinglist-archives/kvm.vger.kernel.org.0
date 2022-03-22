Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385714E4406
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 17:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbiCVQQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 12:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiCVQQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 12:16:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AF858397;
        Tue, 22 Mar 2022 09:15:17 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MFJ3AY003676;
        Tue, 22 Mar 2022 16:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tg4iRva/8rsOMLevdE6PLQwqdqhLmmHsLjsQ/hVp3PM=;
 b=JpHbSEd/9cimWiQ8rBklml9haSIxqaRL+1x7fUgE3+gm7wOWt/XW51fgCkhSF076Hsyj
 J5VEFKxmzPAcXOtUF8OKfQbFwJx+RodbeYwrelvjQTYttsdynX0+4oYzD+W/LopL3nUb
 oktFgJiKu+BpaOOyxVJwCjWbQuHnciyLIVYWPzrPm3Ykd7CCKaatwszdBor0NOWjELet
 c3IFF3JVNAyX93gcYyBtoc7QlLoh3XMYAebccJ2/6RObuiDXQdjKc+AUBDu2CGkQSAwt
 in59/6OunFMDsbq1sj3UvgNaNjA/koBRV8otMnQgGa9oxFs8Lu6tmzyPzaUBluv+DObg ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eybm6scyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 16:15:16 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MFL1Ra008686;
        Tue, 22 Mar 2022 16:15:16 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eybm6scxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 16:15:16 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MFx1Pm017855;
        Tue, 22 Mar 2022 16:15:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ehxmqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 16:15:14 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MGFBxH39649658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 16:15:11 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2768B52057;
        Tue, 22 Mar 2022 16:15:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.232])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7900452051;
        Tue, 22 Mar 2022 16:15:10 +0000 (GMT)
Date:   Tue, 22 Mar 2022 17:15:08 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Fix lockdep issue in vm memop
Message-ID: <20220322171508.4c0f7ef7@p-imbrenda>
In-Reply-To: <20220322153204.2637400-1-scgl@linux.ibm.com>
References: <20220322153204.2637400-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NhUnhAe_WFN6MI5dQ5APoUIladAO-R_R
X-Proofpoint-GUID: IzBr1jjtoKqXYLpSruS-LL78P-zqe25R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_07,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Mar 2022 16:32:04 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Issuing a memop on a protected vm does not make sense,
> neither is the memory readable/writable, nor does it make sense to check
> storage keys. This is why the ioctl will return -EINVAL when it detects
> the vm to be protected. However, in order to ensure that the vm cannot
> become protected during the memop, the kvm->lock would need to be taken
> for the duration of the ioctl. This is also required because
> kvm_s390_pv_is_protected asserts that the lock must be held.
> Instead, don't try to prevent this. If user space enables secure
> execution concurrently with a memop it must accecpt the possibility of
> the memop failing.
> Still check if the vm is currently protected, but without locking and
> consider it a heuristic.
> 
> Fixes: ef11c9463ae0 ("KVM: s390: Add vm IOCTL for key checked guest absolute memory access")
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ca96f84db2cc..53adbe86a68f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2385,7 +2385,16 @@ static int kvm_s390_vm_mem_op(struct kvm *kvm, struct kvm_s390_mem_op *mop)
>  		return -EINVAL;
>  	if (mop->size > MEM_OP_MAX_SIZE)
>  		return -E2BIG;
> -	if (kvm_s390_pv_is_protected(kvm))
> +	/*
> +	 * This is technically a heuristic only, if the kvm->lock is not
> +	 * taken, it is not guaranteed that the vm is/remains non-protected.
> +	 * This is ok from a kernel perspective, wrongdoing is detected
> +	 * on the access, -EFAULT is returned and the vm may crash the
> +	 * next time it accesses the memory in question.
> +	 * There is no sane usecase to do switching and a memop on two
> +	 * different CPUs at the same time.
> +	 */
> +	if (kvm_s390_pv_get_handle(kvm))
>  		return -EINVAL;
>  	if (mop->flags & KVM_S390_MEMOP_F_SKEY_PROTECTION) {
>  		if (access_key_invalid(mop->key))
> 
> base-commit: c9b8fecddb5bb4b67e351bbaeaa648a6f7456912

