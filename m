Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B576E1F6A1
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfEOOgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 10:36:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60512 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbfEOOga (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 10:36:30 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FEa3KG098666
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 10:36:29 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sgmcms7nc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 10:36:29 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Wed, 15 May 2019 15:36:28 +0100
Received: from b03cxnp07029.gho.boulder.ibm.com (9.17.130.16)
        by e36.co.us.ibm.com (192.168.1.136) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 15:36:27 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FEaPSJ66781336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 14:36:25 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A23CEC605B;
        Wed, 15 May 2019 14:36:25 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AC46C605A;
        Wed, 15 May 2019 14:36:25 +0000 (GMT)
Received: from [9.56.58.102] (unknown [9.56.58.102])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 14:36:24 +0000 (GMT)
Subject: Re: [PATCH v2 2/7] s390/cio: Set vfio-ccw FSM state before ioeventfd
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190514234248.36203-1-farman@linux.ibm.com>
 <20190514234248.36203-3-farman@linux.ibm.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Wed, 15 May 2019 10:36:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190514234248.36203-3-farman@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051514-0020-0000-0000-00000EE92B92
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011102; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01203702; UDB=6.00631846; IPR=6.00984629;
 MB=3.00026905; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-15 14:36:28
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051514-0021-0000-0000-000065D599C6
Message-Id: <0b35722f-1f02-7369-cdd1-b7470144aea4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/14/2019 07:42 PM, Eric Farman wrote:
> Otherwise, the guest can believe it's okay to start another I/O
> and bump into the non-idle state.  This results in a cc=2 (with
> the asynchronous CSCH/HSCH code) returned to the guest, which is
> unfortunate since everything is otherwise working normally.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 0b3b9de45c60..ddd21b6149fd 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -86,11 +86,11 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>   	}
>   	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
>   
> -	if (private->io_trigger)
> -		eventfd_signal(private->io_trigger, 1);
> -
>   	if (private->mdev && is_final)
>   		private->state = VFIO_CCW_STATE_IDLE;
> +
> +	if (private->io_trigger)
> +		eventfd_signal(private->io_trigger, 1);
>   }
>   
>   /*
> 
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>

