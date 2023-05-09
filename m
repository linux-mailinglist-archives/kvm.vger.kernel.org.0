Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61206FC4D3
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbjEILTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbjEILT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:19:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B59649C5;
        Tue,  9 May 2023 04:19:24 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349AS1Tc031800;
        Tue, 9 May 2023 11:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iQpx0kfN0t0EGjwEGpd/OQXFiXxcC0YZD335l9cifQI=;
 b=RLzHL7AErm65rXbL8rrLVDwMLFCX5iW70JdjdNJulax2yUXF67hB3ZjMl7y4hWS2y4Eb
 MNkXgB+f8uG1HrwBRY0l5HCOTqgQSRyN9D3MlhKPQSzzkFtl5AuUgMnZ1fbD0Y3lUd/c
 ibgyIlNCNuqg7Q8Wzn9i8OzU5BY5aStgLbbGO/+4lUWilz5oB6Fzk1DbUP8MZPz4CayG
 ite//l+bJWc9tFex3JA//jrRNduZoaqRyWCuoq5dy3l7LgY64E0PGSz6iBYlzTMfp9Cz
 XFW+k6jfDMq+KQw1iGYgsPvIoxyAE7YZ4D4OVyxCuIj4A0+hlwwRGGkNrgpopvT3P/VZ Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfjnhct93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:19:23 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349BECqH023742;
        Tue, 9 May 2023 11:19:23 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfjnhct7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:19:23 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3494oH2Z006449;
        Tue, 9 May 2023 11:19:21 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qf7s8gapg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:19:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349BJHsN24576578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 11:19:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 324332008D;
        Tue,  9 May 2023 11:19:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0398A20073;
        Tue,  9 May 2023 11:19:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 11:19:16 +0000 (GMT)
Date:   Tue, 9 May 2023 13:19:15 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/3] KVM: s390: fix space before open parenthesis
Message-ID: <20230509131915.3226dc93@p-imbrenda>
In-Reply-To: <20230509111202.333714-2-nrb@linux.ibm.com>
References: <20230509111202.333714-1-nrb@linux.ibm.com>
        <20230509111202.333714-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bKzHsYoBSFS9zFE6JzEC8Nbr9kjZjjfK
X-Proofpoint-ORIG-GUID: y-Feeb6E26UAnmNBQtsl73reQkJ40gMp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_07,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 adultscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305090088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 May 2023 13:12:00 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> There should be a space before the open parenthesis, fix that while at
> it.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 2bbc3d54959d..3c3fe45085ec 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -947,7 +947,7 @@ struct kvm_s390_pv {
>  	struct mmu_notifier mmu_notifier;
>  };
>  
> -struct kvm_arch{
> +struct kvm_arch {
>  	void *sca;
>  	int use_esca;
>  	rwlock_t sca_lock;

