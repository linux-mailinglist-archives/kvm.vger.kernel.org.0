Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14C365257D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiLTRWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiLTRWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:22:39 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71412E18;
        Tue, 20 Dec 2022 09:22:38 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHDYh7029703;
        Tue, 20 Dec 2022 17:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tYS1e4TnhbfIf1mDSMmXarZSXPWhCFTQzYU4BezwxMU=;
 b=BNibSCsqR/1CiXRv7KxNHV3Hddq5LfvN0fEUREfgc80tDGmTFW1qupUDNIFaRZPml/uP
 aNWRbjeEMYFJ7ya51A3wVDJmQUnE77kuG9Q+Rzbg2ZjYN0AWlUx9tQHndyHA7As7Lyrf
 MWk1DWU/sKMfC/AO7yUirkdPUEjwqwFj7RzN3Tsrm421wdzHd16lBeYeY+Me1j6O4Kho
 CMEckPyNG0bQ1LL0hRG8oMGgdrToHOtwACzdJs71eUnmiPwQWpLf5z8Afl7xFwBxunZR
 /cR4cfyQFYS3uusr3o/FRNHwTs2Ak3+wJRn3/w/nhC5RYoXI+bwaO/AnDZcRy2una602 eg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkh8u87nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:22:37 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKFQ08I007487;
        Tue, 20 Dec 2022 17:22:36 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxnpb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:22:36 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHMZsg26673598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:22:35 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A989B58055;
        Tue, 20 Dec 2022 17:22:35 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A705B58043;
        Tue, 20 Dec 2022 17:22:34 +0000 (GMT)
Received: from [9.160.107.82] (unknown [9.160.107.82])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 17:22:34 +0000 (GMT)
Message-ID: <b4f3ff08-9b34-643b-4049-92035e85375d@linux.ibm.com>
Date:   Tue, 20 Dec 2022 12:22:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 07/16] vfio/ccw: remove unnecessary malloc alignment
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20221220171008.1362680-1-farman@linux.ibm.com>
 <20221220171008.1362680-8-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221220171008.1362680-8-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3vgljeYftyFXEvXD0c1fJE7XXFhWjLw-
X-Proofpoint-GUID: 3vgljeYftyFXEvXD0c1fJE7XXFhWjLw-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200141
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/22 12:09 PM, Eric Farman wrote:
> Everything about this allocation is harder than necessary,
> since the memory allocation is already aligned to our needs.
> Break them apart for readability, instead of doing the
> funky artithmetic.

s/artithmetic/arithmetic/

> 
> Of the structures that are involved, only ch_ccw needs the
> GFP_DMA flag, so the others can be allocated without it.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 43 ++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index d41d94cecdf8..99332c6f6010 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -311,40 +311,41 @@ static inline int is_tic_within_range(struct ccw1 *ccw, u32 head, int len)
>  static struct ccwchain *ccwchain_alloc(struct channel_program *cp, int len)
>  {
>  	struct ccwchain *chain;
> -	void *data;
> -	size_t size;
> -
> -	/* Make ccw address aligned to 8. */
> -	size = ((sizeof(*chain) + 7L) & -8L) +
> -		sizeof(*chain->ch_ccw) * len +
> -		sizeof(*chain->ch_pa) * len;
> -	chain = kzalloc(size, GFP_DMA | GFP_KERNEL);
> +
> +	chain = kzalloc(sizeof(*chain), GFP_KERNEL);
>  	if (!chain)
>  		return NULL;
>  
> -	data = (u8 *)chain + ((sizeof(*chain) + 7L) & -8L);
> -	chain->ch_ccw = (struct ccw1 *)data;
> -
> -	data = (u8 *)(chain->ch_ccw) + sizeof(*chain->ch_ccw) * len;
> -	chain->ch_pa = (struct page_array *)data;
> +	chain->ch_ccw = kcalloc(len, sizeof(*chain->ch_ccw), GFP_DMA | GFP_KERNEL);
> +	if (!chain->ch_ccw)
> +		goto out_err;
>  
> -	chain->ch_len = len;
> +	chain->ch_pa = kcalloc(len, sizeof(*chain->ch_pa), GFP_KERNEL);
> +	if (!chain->ch_pa)
> +		goto out_err;
>  
>  	list_add_tail(&chain->next, &cp->ccwchain_list);
>  
>  	return chain;
> +
> +out_err:
> +	kfree(chain->ch_ccw);
> +	kfree(chain);
> +	return NULL;
>  }
>  
>  static void ccwchain_free(struct ccwchain *chain)
>  {
>  	list_del(&chain->next);
> +	kfree(chain->ch_pa);
> +	kfree(chain->ch_ccw);
>  	kfree(chain);
>  }
>  
>  /* Free resource for a ccw that allocated memory for its cda. */
>  static void ccwchain_cda_free(struct ccwchain *chain, int idx)
>  {
> -	struct ccw1 *ccw = chain->ch_ccw + idx;
> +	struct ccw1 *ccw = &chain->ch_ccw[idx];
>  
>  	if (ccw_is_tic(ccw))
>  		return;
> @@ -443,6 +444,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>  	chain = ccwchain_alloc(cp, len);
>  	if (!chain)
>  		return -ENOMEM;
> +
> +	chain->ch_len = len;
>  	chain->ch_iova = cda;
>  
>  	/* Copy the actual CCWs into the new chain */
> @@ -464,7 +467,7 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
>  	int i, ret;
>  
>  	for (i = 0; i < chain->ch_len; i++) {
> -		tic = chain->ch_ccw + i;
> +		tic = &chain->ch_ccw[i];
>  
>  		if (!ccw_is_tic(tic))
>  			continue;
> @@ -681,7 +684,7 @@ void cp_free(struct channel_program *cp)
>  	cp->initialized = false;
>  	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
>  		for (i = 0; i < chain->ch_len; i++) {
> -			page_array_unpin_free(chain->ch_pa + i, vdev);
> +			page_array_unpin_free(&chain->ch_pa[i], vdev);
>  			ccwchain_cda_free(chain, i);
>  		}
>  		ccwchain_free(chain);
> @@ -739,8 +742,8 @@ int cp_prefetch(struct channel_program *cp)
>  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>  		len = chain->ch_len;
>  		for (idx = 0; idx < len; idx++) {
> -			ccw = chain->ch_ccw + idx;
> -			pa = chain->ch_pa + idx;
> +			ccw = &chain->ch_ccw[idx];
> +			pa = &chain->ch_pa[idx];
>  
>  			ret = ccwchain_fetch_one(ccw, pa, cp);
>  			if (ret)
> @@ -866,7 +869,7 @@ bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length)
>  
>  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>  		for (i = 0; i < chain->ch_len; i++)
> -			if (page_array_iova_pinned(chain->ch_pa + i, iova, length))
> +			if (page_array_iova_pinned(&chain->ch_pa[i], iova, length))
>  				return true;
>  	}
>  

