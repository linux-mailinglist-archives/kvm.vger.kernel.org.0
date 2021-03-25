Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69A334937C
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 14:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCYN7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 09:59:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5484 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229731AbhCYN7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 09:59:17 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PDXGUC146632;
        Thu, 25 Mar 2021 09:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Y8OTtjdqRl/MoSWUJkF7gfhzrEMqtT7yvFRK11sZTE4=;
 b=lsv/1+yKf81lxtSCK06KJIQreTBiTaBqskf8KCuo0IcwiEubep6gX2DH6eD/cOcihGDB
 uQQBWxAVJEA8t4i2Itf7yyx0OHLo8+h3HWN9lzdvD2oeYTmE1L6ldPgDhplusxgExUoX
 NpRad7R9iSXNp1TWEiDoDWYs+HBy0e1G4prqp1IkFIP997wG3ai2sFBhN3DPW54OPx7n
 7ay1+RiMEknXWifrBU5fb5ITqcTM0QSLe6IkhQm+IoOJYxvPiNAAMmWnt+U82W+VmKOX
 tX9EBHF4VCgNWp8Mm5stgVwha4OKXFLO9vSUFAs8cJUr3Y2Wx9cXQH8edhHuZZvoEnxS 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37grn15tfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:59:16 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PDXV6G147408;
        Thu, 25 Mar 2021 09:59:16 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37grn15tf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:59:16 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PDvPxk025749;
        Thu, 25 Mar 2021 13:59:16 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 37d9dae3bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 13:59:16 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PDxEnU35848472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 13:59:14 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C682112061;
        Thu, 25 Mar 2021 13:59:14 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E1E5112062;
        Thu, 25 Mar 2021 13:59:13 +0000 (GMT)
Received: from [9.160.1.180] (unknown [9.160.1.180])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 13:59:13 +0000 (GMT)
Subject: Re: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        akrowiak@linux.ibm.com, pmorel@linux.ibm.com, cohuck@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, alex.williamson@redhat.com
References: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <3b1893e7-16c2-9bc7-672e-8b7abe202f10@linux.ibm.com>
Date:   Thu, 25 Mar 2021 09:59:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_03:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/25/21 9:41 AM, Matthew Rosato wrote:
> Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
> and replace the backup for vfio-ap as Pierre is focusing on other
> areas.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Acked-by: Eric Farman <farman@linux.ibm.com>

> ---
>   MAINTAINERS | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9e87692..68a5623 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15634,8 +15634,8 @@ F:	Documentation/s390/pci.rst
>   
>   S390 VFIO AP DRIVER
>   M:	Tony Krowiak <akrowiak@linux.ibm.com>
> -M:	Pierre Morel <pmorel@linux.ibm.com>
>   M:	Halil Pasic <pasic@linux.ibm.com>
> +M:	Jason Herne <jjherne@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   S:	Supported
>   W:	http://www.ibm.com/developerworks/linux/linux390/
> @@ -15647,6 +15647,7 @@ F:	drivers/s390/crypto/vfio_ap_private.h
>   S390 VFIO-CCW DRIVER
>   M:	Cornelia Huck <cohuck@redhat.com>
>   M:	Eric Farman <farman@linux.ibm.com>
> +M:	Matthew Rosato <mjrosato@linux.ibm.com>
>   R:	Halil Pasic <pasic@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
> @@ -15657,6 +15658,7 @@ F:	include/uapi/linux/vfio_ccw.h
>   
>   S390 VFIO-PCI DRIVER
>   M:	Matthew Rosato <mjrosato@linux.ibm.com>
> +M:	Eric Farman <farman@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
>   S:	Supported
> 
