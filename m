Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D589E553ADE
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 21:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354157AbiFUT4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 15:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354182AbiFUT4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 15:56:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0216C2E095;
        Tue, 21 Jun 2022 12:56:16 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LJmudX004833;
        Tue, 21 Jun 2022 19:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 reply-to : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=pp1;
 bh=PNhLoyePJieVJUPQtnkVNsib2PrRHGt1oyeaf1N0hAg=;
 b=qLQYq7ZZBqW/OHta0CaSKr8AKu+Boy5d7JkmTzxnWCIsJOxZA4fYYgUiA8Fgheam/1GV
 9ERbVT3RUD/8d8zibeLcWN3X4uCr5NkRb9sbWR6jGBo7sSgMaWULlyEOOSlteEvafKi4
 qLRxapmuJtSFOHdozjpLsFEf4rDf4R3JYyPUu0P9aYh5VIcyXQpkhaEmytA2gVZ2bDj6
 oXzFKpqjirx9oE852Zf0g5rdl8TxT8+zxU53IyDPkYTe2PzXoZSeX6rg/HGclpId5JB7
 xrK6BmvwvqdoeXN1PjEy0qJElrm2b6OcnbGL0nOZmPkQIieU4MvIjnJQmrcqDuDIKmxc yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gumfr0440-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 19:56:13 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LJnFtF010268;
        Tue, 21 Jun 2022 19:56:13 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gumfr043d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 19:56:13 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LJphnC016660;
        Tue, 21 Jun 2022 19:56:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3gs6b9e2mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 19:56:12 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LJuAHS31326712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 19:56:11 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE9D17805C;
        Tue, 21 Jun 2022 19:56:10 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEAA578064;
        Tue, 21 Jun 2022 19:56:09 +0000 (GMT)
Received: from [9.65.195.48] (unknown [9.65.195.48])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 19:56:09 +0000 (GMT)
Message-ID: <f18b53b1-b7d4-08b2-1030-7f91c3b22f3d@linux.ibm.com>
Date:   Tue, 21 Jun 2022 15:56:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v20 20/20] MAINTAINERS: pick up all vfio_ap docs for VFIO
 AP maintainers
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
 <20220621155134.1932383-21-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220621155134.1932383-21-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: M5FTh8smiFQWU1d_0LDJgsumkqQAl-Iu
X-Proofpoint-GUID: B1pCbIFWB57jkTUFodQhxKyLN9s7oS0l
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_09,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 malwarescore=0 priorityscore=1501 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206210077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 11:51, Tony Krowiak wrote:
> A new document, Documentation/s390/vfio-ap-locking.rst was added. Make sure
> the new document is picked up for the VFIO AP maintainers by using a
> wildcard: Documentation/s390/vfio-ap*.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3cf9842d9233..fbe417746e22 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17453,7 +17453,7 @@ M:	Jason Herne <jjherne@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   S:	Supported
>   W:	http://www.ibm.com/developerworks/linux/linux390/
> -F:	Documentation/s390/vfio-ap.rst
> +F:	Documentation/s390/vfio-ap*
>   F:	drivers/s390/crypto/vfio_ap*
>   
>   S390 VFIO-CCW DRIVER

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
