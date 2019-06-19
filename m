Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDD94C2D2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 23:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbfFSVO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 17:14:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726175AbfFSVO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 17:14:26 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JLEMB9103380
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 17:14:25 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t7v621bud-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2019 17:14:21 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Wed, 19 Jun 2019 22:13:42 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Jun 2019 22:13:40 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JLDeNj31457560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 21:13:40 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED290AE05F;
        Wed, 19 Jun 2019 21:13:39 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB7C8AE066;
        Wed, 19 Jun 2019 21:13:39 +0000 (GMT)
Received: from [9.80.202.78] (unknown [9.80.202.78])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 21:13:39 +0000 (GMT)
Subject: Re: [RFC PATCH v1 5/5] vfio-ccw: Remove copy_ccw_from_iova()
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190618202352.39702-1-farman@linux.ibm.com>
 <20190618202352.39702-6-farman@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Wed, 19 Jun 2019 17:13:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190618202352.39702-6-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061921-0060-0000-0000-000003525021
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011293; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01220388; UDB=6.00641986; IPR=6.01001529;
 MB=3.00027382; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-19 21:13:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061921-0061-0000-0000-000049D4EBC3
Message-Id: <98b91731-e503-03af-a7d6-5dcc9bcbf4ae@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/18/2019 04:23 PM, Eric Farman wrote:
> Just to keep things tidy.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_cp.c | 14 ++------------
>   1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 9a8bf06281e0..9cddc1288059 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -228,17 +228,6 @@ static long copy_from_iova(struct device *mdev,
>   	return l;
>   }
>   
> -static long copy_ccw_from_iova(struct channel_program *cp,
> -			       struct ccw1 *to, u64 iova,
> -			       unsigned long len)
> -{
> -	int ret;
> -
> -	ret = copy_from_iova(cp->mdev, to, iova, len * sizeof(struct ccw1));
> -
> -	return ret;
> -}
> -
>   /*
>    * Helpers to operate ccwchain.
>    */
> @@ -435,7 +424,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>   	int len;
>   
>   	/* Copy 2K (the most we support today) of possible CCWs */
> -	len = copy_ccw_from_iova(cp, cp->guest_cp, cda, CCWCHAIN_LEN_MAX);
> +	len = copy_from_iova(cp->mdev, cp->guest_cp, cda,
> +			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
>   	if (len)
>   		return len;
>   
> 

This patch probably could be squashed with patch 4. Not a big deal though.

