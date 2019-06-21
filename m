Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185D04EF45
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 21:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfFUTNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 15:13:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbfFUTNZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jun 2019 15:13:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LJBbul146586;
        Fri, 21 Jun 2019 15:13:09 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t93ha3ng7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 15:13:09 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5LItogH029772;
        Fri, 21 Jun 2019 19:13:08 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 2t8hrp68x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jun 2019 19:13:08 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LJD3bG57540866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:13:04 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDBC7136053;
        Fri, 21 Jun 2019 19:13:03 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7B62136051;
        Fri, 21 Jun 2019 19:13:02 +0000 (GMT)
Received: from [9.80.222.142] (unknown [9.80.222.142])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jun 2019 19:13:02 +0000 (GMT)
Subject: Re: [PULL 07/14] vfio-ccw: Remove pfn_array_table
To:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190621143355.29175-1-cohuck@redhat.com>
 <20190621143355.29175-8-cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <58e33772-280e-205b-ebfd-820c4f8d9f59@linux.ibm.com>
Date:   Fri, 21 Jun 2019 15:13:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621143355.29175-8-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Conny,

FYI, I missed a warning for unused label "out_init" after this patch
applies, which was fixed in patch 08.  This one needs the fixup below,
and patch 8 will still change it to "goto out_free_idaws;"

Not sure how to handle it on the pull request, but wanted to mention it.

My apologies,
Eric

On 6/21/19 10:33 AM, Cornelia Huck wrote:
> From: Eric Farman <farman@linux.ibm.com>
> 
> Now that both CCW codepaths build this nested array:
> 
>   ccwchain->pfn_array_table[1]->pfn_array[#idaws/#pages]
> 
> We can collapse this into simply:
> 
>   ccwchain->pfn_array[#idaws/#pages]
> 
> Let's do that, so that we don't have to continually navigate two
> nested arrays when the first array always has a count of one.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Message-Id: <20190606202831.44135-8-farman@linux.ibm.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 118 +++++++++------------------------
>  1 file changed, 33 insertions(+), 85 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index ab9f8f0d1b44..76ffcc823944 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -33,11 +33,6 @@ struct pfn_array {
>  	int			pa_nr;
>  };
>  
> -struct pfn_array_table {
> -	struct pfn_array	*pat_pa;
> -	int			pat_nr;
> -};
> -
>  struct ccwchain {
>  	struct list_head	next;
>  	struct ccw1		*ch_ccw;
> @@ -46,7 +41,7 @@ struct ccwchain {
>  	/* Count of the valid ccws in chain. */
>  	int			ch_len;
>  	/* Pinned PAGEs for the original data. */
> -	struct pfn_array_table	*ch_pat;
> +	struct pfn_array	*ch_pa;
>  };
>  
>  /*
> @@ -139,55 +134,23 @@ static void pfn_array_unpin_free(struct pfn_array *pa, struct device *mdev)
>  	kfree(pa->pa_iova_pfn);
>  }
>  
> -static int pfn_array_table_init(struct pfn_array_table *pat, int nr)
> -{
> -	pat->pat_pa = kcalloc(nr, sizeof(*pat->pat_pa), GFP_KERNEL);
> -	if (unlikely(ZERO_OR_NULL_PTR(pat->pat_pa))) {
> -		pat->pat_nr = 0;
> -		return -ENOMEM;
> -	}
> -
> -	pat->pat_nr = nr;
> -
> -	return 0;
> -}
> -
> -static void pfn_array_table_unpin_free(struct pfn_array_table *pat,
> -				       struct device *mdev)
> -{
> -	int i;
> -
> -	for (i = 0; i < pat->pat_nr; i++)
> -		pfn_array_unpin_free(pat->pat_pa + i, mdev);
> -
> -	if (pat->pat_nr) {
> -		kfree(pat->pat_pa);
> -		pat->pat_pa = NULL;
> -		pat->pat_nr = 0;
> -	}
> -}
> -
> -static bool pfn_array_table_iova_pinned(struct pfn_array_table *pat,
> -					unsigned long iova)
> +static bool pfn_array_iova_pinned(struct pfn_array *pa, unsigned long iova)
>  {
> -	struct pfn_array *pa = pat->pat_pa;
>  	unsigned long iova_pfn = iova >> PAGE_SHIFT;
> -	int i, j;
> +	int i;
>  
> -	for (i = 0; i < pat->pat_nr; i++, pa++)
> -		for (j = 0; j < pa->pa_nr; j++)
> -			if (pa->pa_iova_pfn[j] == iova_pfn)
> -				return true;
> +	for (i = 0; i < pa->pa_nr; i++)
> +		if (pa->pa_iova_pfn[i] == iova_pfn)
> +			return true;
>  
>  	return false;
>  }
> -/* Create the list idal words for a pfn_array_table. */
> -static inline void pfn_array_table_idal_create_words(
> -	struct pfn_array_table *pat,
> +/* Create the list of IDAL words for a pfn_array. */
> +static inline void pfn_array_idal_create_words(
> +	struct pfn_array *pa,
>  	unsigned long *idaws)
>  {
> -	struct pfn_array *pa;
> -	int i, j, k;
> +	int i;
>  
>  	/*
>  	 * Idal words (execept the first one) rely on the memory being 4k
> @@ -196,17 +159,12 @@ static inline void pfn_array_table_idal_create_words(
>  	 * there will be no problem here to simply use the phys to create an
>  	 * idaw.
>  	 */
> -	k = 0;
> -	for (i = 0; i < pat->pat_nr; i++) {
> -		pa = pat->pat_pa + i;
> -		for (j = 0; j < pa->pa_nr; j++) {
> -			idaws[k] = pa->pa_pfn[j] << PAGE_SHIFT;
> -			k++;
> -		}
> -	}
> +
> +	for (i = 0; i < pa->pa_nr; i++)
> +		idaws[i] = pa->pa_pfn[i] << PAGE_SHIFT;
>  
>  	/* Adjust the first IDAW, since it may not start on a page boundary */
> -	idaws[0] += pat->pat_pa->pa_iova & (PAGE_SIZE - 1);
> +	idaws[0] += pa->pa_iova & (PAGE_SIZE - 1);
>  }
>  
>  
> @@ -378,7 +336,7 @@ static struct ccwchain *ccwchain_alloc(struct channel_program *cp, int len)
>  	/* Make ccw address aligned to 8. */
>  	size = ((sizeof(*chain) + 7L) & -8L) +
>  		sizeof(*chain->ch_ccw) * len +
> -		sizeof(*chain->ch_pat) * len;
> +		sizeof(*chain->ch_pa) * len;
>  	chain = kzalloc(size, GFP_DMA | GFP_KERNEL);
>  	if (!chain)
>  		return NULL;
> @@ -387,7 +345,7 @@ static struct ccwchain *ccwchain_alloc(struct channel_program *cp, int len)
>  	chain->ch_ccw = (struct ccw1 *)data;
>  
>  	data = (u8 *)(chain->ch_ccw) + sizeof(*chain->ch_ccw) * len;
> -	chain->ch_pat = (struct pfn_array_table *)data;
> +	chain->ch_pa = (struct pfn_array *)data;
>  
>  	chain->ch_len = len;
>  
> @@ -575,7 +533,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  				 struct channel_program *cp)
>  {
>  	struct ccw1 *ccw;
> -	struct pfn_array_table *pat;
> +	struct pfn_array *pa;
>  	unsigned long *idaws;
>  	int ret;
>  	int bytes = 1;
> @@ -593,21 +551,17 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  	 * The number of pages actually is the count of the idaws which will be
>  	 * needed when translating a direct ccw to a idal ccw.
>  	 */
> -	pat = chain->ch_pat + idx;
> -	ret = pfn_array_table_init(pat, 1);
> -	if (ret)
> -		goto out_init;
> -
> -	ret = pfn_array_alloc(pat->pat_pa, ccw->cda, bytes);
> +	pa = chain->ch_pa + idx;
> +	ret = pfn_array_alloc(pa, ccw->cda, bytes);
>  	if (ret < 0)
>  		goto out_unpin;

-		goto out_unpin;
+		goto out_init;

>  
>  	if (ccw_does_data_transfer(ccw)) {
> -		ret = pfn_array_pin(pat->pat_pa, cp->mdev);
> +		ret = pfn_array_pin(pa, cp->mdev);
>  		if (ret < 0)
>  			goto out_unpin;
>  	} else {
> -		pat->pat_pa->pa_nr = 0;
> +		pa->pa_nr = 0;
>  	}
>  
>  	/* Translate this direct ccw to a idal ccw. */
> @@ -619,12 +573,12 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
>  	ccw->cda = (__u32) virt_to_phys(idaws);
>  	ccw->flags |= CCW_FLAG_IDA;
>  
> -	pfn_array_table_idal_create_words(pat, idaws);
> +	pfn_array_idal_create_words(pa, idaws);
>  
>  	return 0;
>  
>  out_unpin:
> -	pfn_array_table_unpin_free(pat, cp->mdev);
> +	pfn_array_unpin_free(pa, cp->mdev);
>  out_init:
>  	ccw->cda = 0;
>  	return ret;
> @@ -635,7 +589,7 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
>  			       struct channel_program *cp)
>  {
>  	struct ccw1 *ccw;
> -	struct pfn_array_table *pat;
> +	struct pfn_array *pa;
>  	unsigned long *idaws;
>  	u64 idaw_iova;
>  	unsigned int idaw_nr, idaw_len;
> @@ -655,15 +609,11 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
>  	idaw_len = idaw_nr * sizeof(*idaws);
>  
>  	/* Pin data page(s) in memory. */
> -	pat = chain->ch_pat + idx;
> -	ret = pfn_array_table_init(pat, 1);
> +	pa = chain->ch_pa + idx;
> +	ret = pfn_array_alloc(pa, idaw_iova, bytes);
>  	if (ret)
>  		goto out_init;
>  
> -	ret = pfn_array_alloc(pat->pat_pa, idaw_iova, bytes);
> -	if (ret)
> -		goto out_unpin;
> -
>  	/* Translate idal ccw to use new allocated idaws. */
>  	idaws = kzalloc(idaw_len, GFP_DMA | GFP_KERNEL);
>  	if (!idaws) {
> @@ -678,24 +628,24 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
>  	ccw->cda = virt_to_phys(idaws);
>  
>  	for (i = 0; i < idaw_nr; i++)
> -		pat->pat_pa->pa_iova_pfn[i] = idaws[i] >> PAGE_SHIFT;
> +		pa->pa_iova_pfn[i] = idaws[i] >> PAGE_SHIFT;
>  
>  	if (ccw_does_data_transfer(ccw)) {
> -		ret = pfn_array_pin(pat->pat_pa, cp->mdev);
> +		ret = pfn_array_pin(pa, cp->mdev);
>  		if (ret < 0)
>  			goto out_free_idaws;
>  	} else {
> -		pat->pat_pa->pa_nr = 0;
> +		pa->pa_nr = 0;
>  	}
>  
> -	pfn_array_table_idal_create_words(pat, idaws);
> +	pfn_array_idal_create_words(pa, idaws);
>  
>  	return 0;
>  
>  out_free_idaws:
>  	kfree(idaws);
>  out_unpin:
> -	pfn_array_table_unpin_free(pat, cp->mdev);
> +	pfn_array_unpin_free(pa, cp->mdev);
>  out_init:
>  	ccw->cda = 0;
>  	return ret;
> @@ -790,8 +740,7 @@ void cp_free(struct channel_program *cp)
>  	cp->initialized = false;
>  	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
>  		for (i = 0; i < chain->ch_len; i++) {
> -			pfn_array_table_unpin_free(chain->ch_pat + i,
> -						   cp->mdev);
> +			pfn_array_unpin_free(chain->ch_pa + i, cp->mdev);
>  			ccwchain_cda_free(chain, i);
>  		}
>  		ccwchain_free(chain);
> @@ -967,8 +916,7 @@ bool cp_iova_pinned(struct channel_program *cp, u64 iova)
>  
>  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>  		for (i = 0; i < chain->ch_len; i++)
> -			if (pfn_array_table_iova_pinned(chain->ch_pat + i,
> -							iova))
> +			if (pfn_array_iova_pinned(chain->ch_pa + i, iova))
>  				return true;
>  	}
>  
> 
