Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AF66513A8
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiLSUPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLSUPD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:15:03 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E7F10A2;
        Mon, 19 Dec 2022 12:14:59 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJK9ebb009310;
        Mon, 19 Dec 2022 20:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=f4afIUwAbpIrjT4NZmI/HWdTn7aCXMNW4Ptj4tDkfQk=;
 b=PU5yI2sJLbD5Cf5mKMjaxU5/Bx5QJrufbMMAuTde4vlU93h5AT+AW+qB/UpGKfNvy3gg
 LgX4iV3xKpQI6UcTc4wdiiy8Epwa4UkHGPjVvkToTLeGJwbQrkn7fcv58GxQo3fk2KoO
 tXTxXkYF+KKXLd18Dm7dd71XREUnDlQNChLi01V2EEIOo1emMxyi+lyPYHLCmBHIPrD5
 yWZB++4agU+mU1aRAlIl5YRKKhHA3saQI+veAimK0abRjUd2ypFk4lbMTDmMf+N1WTJm
 hrS1ntgIq/vslEyf/1VcpkAt8hFF8x80JE07QvftDv2vJGVL7xuzNMoYVex4Sb9M/J52 +w== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mjxerrp19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:14:58 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJI84va017382;
        Mon, 19 Dec 2022 20:14:58 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxfk03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 20:14:58 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BJKEuAE41288044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 20:14:56 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE0F35805C;
        Mon, 19 Dec 2022 20:14:56 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D78358058;
        Mon, 19 Dec 2022 20:14:55 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Dec 2022 20:14:55 +0000 (GMT)
Message-ID: <b6542dba-5645-f1f2-12a0-203e1187dd31@linux.ibm.com>
Date:   Mon, 19 Dec 2022 15:14:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 13/16] vfio/ccw: allocate/populate the guest idal
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
 <20221121214056.1187700-14-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-14-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QeI2tVC7dCYwDDOjDl_aB3fnHyPpzK81
X-Proofpoint-ORIG-GUID: QeI2tVC7dCYwDDOjDl_aB3fnHyPpzK81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190178
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> Today, we allocate memory for a list of IDAWs, and if the CCW
> being processed contains an IDAL we read that data from the guest
> into that space. We then copy each IDAW into the pa_iova array,
> or fabricate that pa_iova array with a list of addresses based
> on a direct-addressed CCW.
> 
> Combine the reading of the guest IDAL with the creation of a
> pseudo-IDAL for direct-addressed CCWs, so that both CCW types
> have a "guest" IDAL that can be populated straight into the
> pa_iova array.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 72 +++++++++++++++++++++++-----------
>  1 file changed, 50 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 6839e7195182..90685cee85db 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -192,11 +192,12 @@ static inline void page_array_idal_create_words(struct page_array *pa,
>  	 * idaw.
>  	 */
>  
> -	for (i = 0; i < pa->pa_nr; i++)
> +	for (i = 0; i < pa->pa_nr; i++) {
>  		idaws[i] = page_to_phys(pa->pa_page[i]);
>  
> -	/* Adjust the first IDAW, since it may not start on a page boundary */
> -	idaws[0] += pa->pa_iova[0] & (PAGE_SIZE - 1);
> +		/* Incorporate any offset from each starting address */
> +		idaws[i] += pa->pa_iova[i] & (PAGE_SIZE - 1);
> +	}
>  }
>  
>  static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
> @@ -496,6 +497,44 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
>  	return -EFAULT;
>  }
>  
> +static unsigned long *get_guest_idal(struct ccw1 *ccw,
> +				     struct channel_program *cp,
> +				     int idaw_nr)
> +{
> +	struct vfio_device *vdev =
> +		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
> +	unsigned long *idaws;
> +	int idal_len = idaw_nr * sizeof(*idaws);
> +	int idaw_size = PAGE_SIZE;
> +	int idaw_mask = ~(idaw_size - 1);
> +	int i, ret;
> +
> +	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
> +	if (!idaws)
> +		return NULL;
> +
> +	if (ccw_is_idal(ccw)) {
> +		/* Copy IDAL from guest */
> +		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
> +		if (ret) {
> +			kfree(idaws);
> +			return NULL;

As discussed off-list, for debug purposes consider using something like ERR_PTR of the vfio_dma_rw error return here rather than NULL. 

> +		}
> +	} else {
> +		/* Fabricate an IDAL based off CCW data address */
> +		if (cp->orb.cmd.c64) {
> +			idaws[0] = ccw->cda;
> +			for (i = 1; i < idaw_nr; i++)
> +				idaws[i] = (idaws[i - 1] + idaw_size) & idaw_mask;
> +		} else {

If anyone else is reviewing and stumbles on this, I was initially wondering why we bail here with no obvious explanation - was going to ask for a comment here but it looks like this else gets replaced next patch with implementation for format-1.

> +			kfree(idaws);
> +			return NULL;
> +		}
> +	}
> +
> +	return idaws;
> +}
> +
>  /*
>   * ccw_count_idaws() - Calculate the number of IDAWs needed to transfer
>   * a specified amount of data
> @@ -555,7 +594,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
>  	unsigned long *idaws;
>  	int ret;
> -	int idaw_nr, idal_len;
> +	int idaw_nr;
>  	int i;
>  
>  	/* Calculate size of IDAL */
> @@ -563,10 +602,8 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	if (idaw_nr < 0)
>  		return idaw_nr;
>  
> -	idal_len = idaw_nr * sizeof(*idaws);
> -
>  	/* Allocate an IDAL from host storage */
> -	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
> +	idaws = get_guest_idal(ccw, cp, idaw_nr);
>  	if (!idaws) {
>  		ret = -ENOMEM;
>  		goto out_init;
> @@ -582,22 +619,13 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
>  	if (ret < 0)
>  		goto out_free_idaws;
>  
> -	if (ccw_is_idal(ccw)) {
> -		/* Copy guest IDAL into host IDAL */
> -		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
> -		if (ret)
> -			goto out_unpin;
> -
> -		/*
> -		 * Copy guest IDAWs into page_array, in case the memory they
> -		 * occupy is not contiguous.
> -		 */
> -		for (i = 0; i < idaw_nr; i++)
> +	/*
> +	 * Copy guest IDAWs into page_array, in case the memory they
> +	 * occupy is not contiguous.
> +	 */
> +	for (i = 0; i < idaw_nr; i++) {
> +		if (cp->orb.cmd.c64)
>  			pa->pa_iova[i] = idaws[i];
> -	} else {
> -		pa->pa_iova[0] = ccw->cda;
> -		for (i = 1; i < pa->pa_nr; i++)
> -			pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
>  	}
>  
>  	if (ccw_does_data_transfer(ccw)) {

