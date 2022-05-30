Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CEE537815
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiE3J4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 05:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbiE3J4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 05:56:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FEFDEFE;
        Mon, 30 May 2022 02:56:49 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U9Xv6k013234;
        Mon, 30 May 2022 09:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mrpw9EoOdmJuTX1YI5A7euisicnVYUkv7euUozmyLu4=;
 b=gqi4Ujb/pB4lOI12h7g3u1FGDomaDLVwPInfCftJZ5LinVr8h1wapGtTjDJMFFyjmoWW
 wtJN/BQdM5A1jjTQoVyhZJMBkrloBt8D73pxBm/cy++pPcqfYBZjiOzNOiUjMLK7eNsE
 5CDtehH2WTEyabGB7TC9LY8uX+ukE7Y/7pJ1GzX6bfy/UtoCjvKWQuC6VAKczhGKPCyQ
 4qc8d+jAGtq922VSXiYWQo5sRMNqs6nKsqRgLcEhdKhrw0mz+9LN1W87MHioyDI1dtng
 Qva+c+iLZ4X4rtciJW77CY7CAMN3VFmC/kCErTvJbf7SR/VJh9zCISZsXRM9LQt7dePX vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcudggcg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:56:48 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U9r617020603;
        Mon, 30 May 2022 09:56:48 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcudggcfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:56:47 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U9pjhJ014734;
        Mon, 30 May 2022 09:56:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3gbcb7hva6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 09:56:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U9uhZZ21823866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 09:56:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F19A4AE051;
        Mon, 30 May 2022 09:56:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 631DAAE045;
        Mon, 30 May 2022 09:56:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.149])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 09:56:42 +0000 (GMT)
Date:   Mon, 30 May 2022 11:56:40 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [PATCH 2/2] s390/pgtable: use non-quiescing sske for KVM switch
 to keyed
Message-ID: <20220530115640.2447b7dd@p-imbrenda>
In-Reply-To: <20220530092706.11637-3-borntraeger@linux.ibm.com>
References: <20220530092706.11637-1-borntraeger@linux.ibm.com>
        <20220530092706.11637-3-borntraeger@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -iL5-Ps-FmexovZnoEiFDCRI6PyR4sCP
X-Proofpoint-ORIG-GUID: bC-QFm8ZOH8U1avhjJxmw-QC0pU-3s95
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 May 2022 11:27:06 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> The switch to a keyed guest does not require a classic sske as the other
> guest CPUs are not accessing the key before the switch is complete.
> By using the NQ SSKE things are faster especially with multiple guests.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Suggested-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/mm/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 697df02362af..4909dcd762e8 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -748,7 +748,7 @@ void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>  	pgste_val(pgste) |= PGSTE_GR_BIT | PGSTE_GC_BIT;
>  	ptev = pte_val(*ptep);
>  	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
> -		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 1);
> +		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 0);
>  	pgste_set_unlock(ptep, pgste);
>  	preempt_enable();
>  }

