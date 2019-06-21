Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8021C4EF47
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 21:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfFUTNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 15:13:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726321AbfFUTNb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jun 2019 15:13:31 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5LJBX1O095181
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 15:13:30 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t93tdb79n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2019 15:13:30 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 21 Jun 2019 20:13:29 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e33.co.us.ibm.com (192.168.1.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 21 Jun 2019 20:13:26 +0100
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5LJDMql55312824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:13:22 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50AAF136068;
        Fri, 21 Jun 2019 19:13:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C7B013605E;
        Fri, 21 Jun 2019 19:13:21 +0000 (GMT)
Received: from [9.80.222.142] (unknown [9.80.222.142])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jun 2019 19:13:21 +0000 (GMT)
Subject: Re: [PULL 13/14] vfio-ccw: Factor out the ccw0-to-ccw1 transition
To:     Cornelia Huck <cohuck@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190621143355.29175-1-cohuck@redhat.com>
 <20190621143355.29175-14-cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Fri, 21 Jun 2019 15:13:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621143355.29175-14-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062119-0036-0000-0000-00000ACE8A4A
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011304; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01221307; UDB=6.00642538; IPR=6.01002446;
 MB=3.00027411; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-21 19:13:28
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062119-0037-0000-0000-00004C4EC44A
Message-Id: <2129b739-6722-123f-ec7d-f751557de7a0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-21_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=977 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906210144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Conny,

I'm bad at things, because I thought for sure I had checked for and
fixed this before I sent the patches.  This one gets a sparse warning,
fixed below.

Eric

On 6/21/19 10:33 AM, Cornelia Huck wrote:
> From: Eric Farman <farman@linux.ibm.com>
> 
> This is a really useful function, but it's buried in the
> copy_ccw_from_iova() routine so that ccwchain_calc_length()
> can just work with Format-1 CCWs while doing its counting.
> But it means we're translating a full 2K of "CCWs" to Format-1,
> when in reality there's probably far fewer in that space.
> 
> Let's factor it out, so maybe we can do something with it later.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Message-Id: <20190618202352.39702-5-farman@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 48 ++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index a55f8d110920..9a8bf06281e0 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -161,6 +161,27 @@ static inline void pfn_array_idal_create_words(
>  	idaws[0] += pa->pa_iova & (PAGE_SIZE - 1);
>  }
>  
> +void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)

static void convert_...

> +{
> +	struct ccw0 ccw0;
> +	struct ccw1 *pccw1 = source;
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		ccw0 = *(struct ccw0 *)pccw1;
> +		if ((pccw1->cmd_code & 0x0f) == CCW_CMD_TIC) {
> +			pccw1->cmd_code = CCW_CMD_TIC;
> +			pccw1->flags = 0;
> +			pccw1->count = 0;
> +		} else {
> +			pccw1->cmd_code = ccw0.cmd_code;
> +			pccw1->flags = ccw0.flags;
> +			pccw1->count = ccw0.count;
> +		}
> +		pccw1->cda = ccw0.cda;
> +		pccw1++;
> +	}
> +}
>  
>  /*
>   * Within the domain (@mdev), copy @n bytes from a guest physical
> @@ -211,32 +232,9 @@ static long copy_ccw_from_iova(struct channel_program *cp,
>  			       struct ccw1 *to, u64 iova,
>  			       unsigned long len)
>  {
> -	struct ccw0 ccw0;
> -	struct ccw1 *pccw1;
>  	int ret;
> -	int i;
>  
>  	ret = copy_from_iova(cp->mdev, to, iova, len * sizeof(struct ccw1));
> -	if (ret)
> -		return ret;
> -
> -	if (!cp->orb.cmd.fmt) {
> -		pccw1 = to;
> -		for (i = 0; i < len; i++) {
> -			ccw0 = *(struct ccw0 *)pccw1;
> -			if ((pccw1->cmd_code & 0x0f) == CCW_CMD_TIC) {
> -				pccw1->cmd_code = CCW_CMD_TIC;
> -				pccw1->flags = 0;
> -				pccw1->count = 0;
> -			} else {
> -				pccw1->cmd_code = ccw0.cmd_code;
> -				pccw1->flags = ccw0.flags;
> -				pccw1->count = ccw0.count;
> -			}
> -			pccw1->cda = ccw0.cda;
> -			pccw1++;
> -		}
> -	}
>  
>  	return ret;
>  }
> @@ -441,6 +439,10 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>  	if (len)
>  		return len;
>  
> +	/* Convert any Format-0 CCWs to Format-1 */
> +	if (!cp->orb.cmd.fmt)
> +		convert_ccw0_to_ccw1(cp->guest_cp, len);
> +
>  	/* Count the CCWs in the current chain */
>  	len = ccwchain_calc_length(cda, cp);
>  	if (len < 0)
> 

