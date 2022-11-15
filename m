Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960A66293B0
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 09:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiKOI5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 03:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237459AbiKOI5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 03:57:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9A420F65;
        Tue, 15 Nov 2022 00:56:59 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF8rm3e015433;
        Tue, 15 Nov 2022 08:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9K16PVaszELkFcfxK/QfEDUWv8H3W4NPdl++z4H22ug=;
 b=DRBJe0AgT1lyhfGuca0J6u7btMBKDONWCg567wzbQuZ3IzknMG7ltE4z66OMgWp9FkZM
 X7kWc4zSvkdgTwPVw2MlMOKbyp7p5MBun5Mglk9bb4qmMz6TsZsh/0hnjGO+3t5ji40p
 5SUS0pM/jiZdIB/zhAVDWlFt99wLyqWgAAgEruzd+bW/kEJImtuOW4qxhivuPMjmLjTa
 31yVMzJIyhtL8mSjXIb7eYwbtOo38jtyJ6iDTCUOYrNzfvdO3fIO4HxoacQcE3iZQS+o
 uaqnjAiD/pZ6Q2FWK0lHmphjSijeemuAJKOLZ85n1G2YKLpXYzBPyzohPT8h69hs5Nrn Ag== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kv6xdh8h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 08:56:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AF8pdva000508;
        Tue, 15 Nov 2022 08:56:56 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3kt348v0p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 08:56:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AF8uqqu13500736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 08:56:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D43EAA405C;
        Tue, 15 Nov 2022 08:56:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C9BA4054;
        Tue, 15 Nov 2022 08:56:52 +0000 (GMT)
Received: from [9.171.74.64] (unknown [9.171.74.64])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Nov 2022 08:56:52 +0000 (GMT)
Message-ID: <659501fc-0ddc-2db6-cdcb-4990d5c46817@linux.ibm.com>
Date:   Tue, 15 Nov 2022 09:56:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, pasic@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@linux.ibm.com, imbrenda@linux.ibm.com
References: <20221108152610.735205-1-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v1] s390/vfio-ap: GISA: sort out physical vs virtual
 pointers usage
In-Reply-To: <20221108152610.735205-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bfYHNrVXE0g0wu2VdCILSw4Tg8nyAbYq
X-Proofpoint-ORIG-GUID: bfYHNrVXE0g0wu2VdCILSw4Tg8nyAbYq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211150061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/8/22 16:26, Nico Boehr wrote:
> Fix virtual vs physical address confusion (which currently are the same)
> for the GISA when enabling the IRQ.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 0b4cc8c597ae..20859cabbced 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -429,7 +429,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>   
>   	aqic_gisa.isc = nisc;
>   	aqic_gisa.ir = 1;
> -	aqic_gisa.gisa = (uint64_t)gisa >> 4;
> +	aqic_gisa.gisa = (uint64_t)virt_to_phys(gisa) >> 4;

I'd suggest doing s/uint64_t/u64/ or s/uint64_t/unsigned long/ but I'm 
wondering if (u32)(u64) would be more appropriate anyway.

@halil @christian ?

>   
>   	status = ap_aqic(q->apqn, aqic_gisa, h_nib);
>   	switch (status.response_code) {

