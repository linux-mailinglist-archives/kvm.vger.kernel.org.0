Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEB364F229
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 21:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiLPUKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 15:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiLPUKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 15:10:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8922561D5B;
        Fri, 16 Dec 2022 12:10:16 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGJg8Fa030419;
        Fri, 16 Dec 2022 20:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=+jxkp4hUTHYR2+0oYIB0cbljTTM52X87nX9JyIh1jH4=;
 b=WdGoJmbti6R8g4i5V3spQ1nUZAOlpo1S9C+W3UryZZoGctN69YQ1XsxxeY/3Z991b/Wh
 m53TygJJWmbbKeYl9s9Xe+9nJwyLcmKMrf2Nkc0p4BJl5xQEphDhwowcd7T4onOQ2Pi7
 yjQqDh2rhJyeaRx48wqSrdwDwSiFH6lrIT4t2DDYX08rhjsOUfjyEQhq3SqGfB0ZUbK5
 dA2qZJ3UzGDyxv6lZ5KFxncn8zHxN2qiR5oJY9t5wGKpm9LqmkFGky05OzHBVblgTNn+
 9Svts+ksetSPZEhT+3M908MfFl9S6qw6GHRsqY+kBKP7VvPXXeDeBCLg1xRg0cOtJHEA kg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mgy2f0kp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 20:10:16 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGI4SmR024724;
        Fri, 16 Dec 2022 20:10:14 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3meypkm8vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 20:10:14 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BGKADRt1966680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 20:10:13 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 860A058068;
        Fri, 16 Dec 2022 20:10:13 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AFAC58066;
        Fri, 16 Dec 2022 20:10:12 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 16 Dec 2022 20:10:12 +0000 (GMT)
Message-ID: <f814a82c-f1a6-4e90-4898-290dbbc73770@linux.ibm.com>
Date:   Fri, 16 Dec 2022 15:10:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 07/16] vfio/ccw: remove unnecessary malloc alignment
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
References: <20221121214056.1187700-1-farman@linux.ibm.com>
 <20221121214056.1187700-8-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-8-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1lhixyq_WO-g21wLLiOynh_M5lixckQc
X-Proofpoint-GUID: 1lhixyq_WO-g21wLLiOynh_M5lixckQc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_13,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212160177
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> Everything about this allocation is harder than necessary,
> since the memory allocation is already aligned to our needs.
> Break them apart for readability, instead of doing the
> funky artithmetic.
> 
> Of the structures that are involved, only ch_ccw needs the
> GFP_DMA flag, so the others can be allocated without it.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 39 ++++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index d41d94cecdf8..4b6b5f9dc92d 100644
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

I suppose you could consider a WARN_ONCE here if one of these kzalloc'd addresses has something in the low-order 3 bits; would probably make it more obvious if for some reason the alignment guarantee was broken vs some status after-the-fact in the IRB.  But as per our discussion off-list I think that can only happen if ARCH_KMALLOC_MINALIGN were to change.

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

These don't seem equivalent...  Before at each iteration you'd offset tic by i bytes, now you're treating i as an index of 8B ccw1 structs, so it seems like this went from tic = x + i to tic = x + (8 * i)?  Was the old code broken or am I missing something? 

>  
>  		if (!ccw_is_tic(tic))
>  			continue;
> @@ -739,8 +742,8 @@ int cp_prefetch(struct channel_program *cp)
>  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>  		len = chain->ch_len;
>  		for (idx = 0; idx < len; idx++) {
> -			ccw = chain->ch_ccw + idx;
> -			pa = chain->ch_pa + idx;
> +			ccw = &chain->ch_ccw[idx];
> +			pa = &chain->ch_pa[idx];

Same sort of question re: ch_pa

>  
>  			ret = ccwchain_fetch_one(ccw, pa, cp);
>  			if (ret)

