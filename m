Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA0D34AC7C
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhCZQ1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 12:27:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230197AbhCZQ1K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 12:27:10 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12QG6CtG072755;
        Fri, 26 Mar 2021 12:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=reply-to : subject : to
 : cc : references : from : message-id : date : mime-version : in-reply-to
 : content-type : content-transfer-encoding; s=pp1;
 bh=4TeIP5QizuRmvPem7ZurUakno+r2/IajTbHd1lyb6tE=;
 b=WvMjMfCFtl+L8BsDNPxBrKWO2+Yy/DAXbldpynpveIP60Mv6wRy+M8/wqaG//v0xy8+0
 9tUH1L+ZWTrdp/99/HtlH9L3Q0qf+eFkLElGYKKR6ypbGnNqccX4IyHOvz3hWLkbgRn3
 09lMUMWGdL9GjOoOhKAdasTl7EhtxRfrjjuYXCbxbvPFCgSIFhiKdiUrJ0iV+96qz67u
 xHRzOWr3gFd1CRA1FPpHLSUKODdHEo5hdwPNe+OzH1XRzfDpUE0GwcynkbVsYa5oEUpg
 +fD1+CiNTqKDF1lTf8fLbl5u5NVyB/E9KWvbkhjlgoD46sCrQwHwt37KoahXS9/cJG/A /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37hh6mc2ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 12:27:09 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12QG6B4O072702;
        Fri, 26 Mar 2021 12:27:09 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37hh6mc2jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 12:27:09 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12QGNs0x021761;
        Fri, 26 Mar 2021 16:27:09 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 37h1586fjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 16:27:09 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12QGR50L23200246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 16:27:06 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2D4C6E05B;
        Fri, 26 Mar 2021 16:27:05 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8F736E058;
        Fri, 26 Mar 2021 16:27:04 +0000 (GMT)
Received: from [9.85.200.80] (unknown [9.85.200.80])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 16:27:04 +0000 (GMT)
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, farman@linux.ibm.com, pasic@linux.ibm.com,
        akrowiak@linux.ibm.com, pmorel@linux.ibm.com, cohuck@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, alex.williamson@redhat.com
References: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
Message-ID: <18aa0202-c086-9de1-fe04-7f185f89ea07@linux.ibm.com>
Date:   Fri, 26 Mar 2021 12:27:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DiP4O3ISs00xILbce3DFibjR1dNa8g4Q
X-Proofpoint-ORIG-GUID: p5OqrxCS7YbT_tHgnfeevDEBwfZAHfl5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_06:2021-03-26,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 priorityscore=1501
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/21 9:41 AM, Matthew Rosato wrote:
> Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
> and replace the backup for vfio-ap as Pierre is focusing on other
> areas.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
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

Acked-by: Jason J. Herne <jjherne@linux.ibm.com>


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
