Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A6B64E295
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLOUzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLOUzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:55:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EC850D65;
        Thu, 15 Dec 2022 12:55:05 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFKDe5b020391;
        Thu, 15 Dec 2022 20:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1r/aOm9/5uyOuLRLkgVpzu43C+5VnVD3kixD47+A/VY=;
 b=HuVClZeh2rvQUgEa/UrhqKqLNkw7A61ri0zoHEVfKFdFM/PJzgMGYxkEToGH/Cy4QUKI
 yAc5aApdp7q5aTJ1iu94uxBSuVXRG/Fnu6Xdww8FNNif7LezC+rI4PQXehXXGF0JJfLa
 3BXCGrqhq+IhLpB4tXJsdZYZFX9c1qAcfgDHoFCV1vHIEfb1pCx+uCT99h/+eq18Mc/c
 paNaaPPqJjNQMbKr9xgy0vHJjPuVnthmRcPQRt+aGnVGBYzZPwUPmJ5eHb8E8K3O9sNj
 EEH5xVa+HFryL57f+VEn0TAqALuP0o4z4qo79zKT2fV+Y41Fdb0376PBwkCmXRIoIJtt JQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mgae4gv0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 20:55:04 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFKBdSG006767;
        Thu, 15 Dec 2022 20:55:04 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3mf08ewe48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 20:55:04 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFKt2CA49611136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 20:55:03 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1F4B58062;
        Thu, 15 Dec 2022 20:55:02 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6320858058;
        Thu, 15 Dec 2022 20:55:01 +0000 (GMT)
Received: from [9.160.114.181] (unknown [9.160.114.181])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 20:55:01 +0000 (GMT)
Message-ID: <6d29131a-bf0d-060a-2247-b3d15583320e@linux.ibm.com>
Date:   Thu, 15 Dec 2022 15:55:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 03/16] vfio/ccw: allow non-zero storage keys
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
 <20221121214056.1187700-4-farman@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20221121214056.1187700-4-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IEroFwxGRhUpDerLiJvrJYN4-kkTwICh
X-Proofpoint-GUID: IEroFwxGRhUpDerLiJvrJYN4-kkTwICh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150172
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 4:40 PM, Eric Farman wrote:
> Currently, vfio-ccw copies the ORB from the io_region to the
> channel_program struct being built. It then adjusts various
> pieces of that ORB to the values needed to be used by the
> SSCH issued by vfio-ccw in the host.
> 
> This includes setting the subchannel key to the default,
> presumably because Linux doesn't do anything with non-zero
> storage keys itself. But it seems wrong to convert every I/O
> to the default key if the guest itself requested a non-zero
> subchannel (access) key.
> 
> Any channel program that sets a non-zero key would expect the
> same key returned in the SCSW of the IRB, not zero, so best to
> allow that to occur unimpeded.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index a0060ef1119e..268a90252521 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -836,7 +836,6 @@ union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
>  
>  	orb->cmd.intparm = (u32)virt_to_phys(sch);
>  	orb->cmd.fmt = 1;
> -	orb->cmd.key = PAGE_DEFAULT_KEY >> 4;
>  
>  	if (orb->cmd.lpm == 0)
>  		orb->cmd.lpm = sch->lpm;

