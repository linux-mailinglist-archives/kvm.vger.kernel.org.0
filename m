Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF51164E297
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLOUzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiLOUzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:55:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DE053ED2;
        Thu, 15 Dec 2022 12:55:13 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFJqeH9025947;
        Thu, 15 Dec 2022 20:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=stKfaeuvHuhy7ZH3AVq7bpS1ZWXRhXQsdOY6tGCfi3g=;
 b=NnvgwD3NZXHmPYlnrAYuWtFPlHqbRpJPVN/5mAMviI4vdRmzvR/nmljo5BUV5eIBVApB
 Hc7BMQOLTlLkVMpG6rEII/ynbRnrmZV+5DkRgpcBu0OazGlsqIygQU8EUjFXFUSV4MDj
 Nmf6Dcg+WAO86zeF1BtbkhgTN72fTpRm3KJC42rphROz1Buie/4/3JGcrb7bEpfG1frn
 OC8MKvyUfH1yC8C2hDPjxvAr2VgdrNFWl1Ic1Pwur/raCPo5W64hfJoSb0r/Ovz644C1
 rozJwdgEUIRNzBd/9ctz9mKj7Nitti4+/an8C9D6XG32YzC/JcYgkWfxrgdkGzVKPlYH Vw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mga4hhava-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 20:55:12 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFJQ3sj017711;
        Thu, 15 Dec 2022 20:55:11 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3meyqknn6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 20:55:11 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFKtApA42074810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 20:55:10 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C8755805C;
        Thu, 15 Dec 2022 20:55:10 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D3D58064;
        Thu, 15 Dec 2022 20:55:08 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 20:55:08 +0000 (GMT)
Message-ID: <89b3caec-4520-9ae9-b398-99ea0db6d279@linux.ibm.com>
Date:   Thu, 15 Dec 2022 15:55:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 04/16] vfio/ccw: move where IDA flag is set in ORB
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
 <20221121214056.1187700-5-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-5-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZkSnhZ4W9RJVXAA8bviaKjU-vQftSATI
X-Proofpoint-ORIG-GUID: ZkSnhZ4W9RJVXAA8bviaKjU-vQftSATI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150172
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> The output of vfio_ccw is always a Format-2 IDAL, but the code that
> explicitly sets this is buried in cp_init().
> 
> In fact the input is often already a Format-2 IDAL, and would be
> rejected (via the check in ccwchain_calc_length()) if it weren't,
> so explicitly setting it doesn't do much. Setting it way down here
> only makes it impossible to make decisions in support of other
> IDAL formats.
> 
> Let's move that to where the rest of the ORB is set up, so that the
> CCW processing in cp_prefetch() is performed according to the
> contents of the unmodified guest ORB.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 268a90252521..3a11132b1685 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -707,15 +707,9 @@ int cp_init(struct channel_program *cp, union orb *orb)
>  	/* Build a ccwchain for the first CCW segment */
>  	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>  
> -	if (!ret) {
> +	if (!ret)
>  		cp->initialized = true;
>  
> -		/* It is safe to force: if it was not set but idals used
> -		 * ccwchain_calc_length would have returned an error.
> -		 */
> -		cp->orb.cmd.c64 = 1;
> -	}
> -
>  	return ret;
>  }
>  
> @@ -837,6 +831,11 @@ union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
>  	orb->cmd.intparm = (u32)virt_to_phys(sch);
>  	orb->cmd.fmt = 1;
>  
> +	/*
> +	 * Everything built by vfio-ccw is a Format-2 IDAL.
> +	 */
> +	orb->cmd.c64 = 1;
> +
>  	if (orb->cmd.lpm == 0)
>  		orb->cmd.lpm = sch->lpm;
>  

