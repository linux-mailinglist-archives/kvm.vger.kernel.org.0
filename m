Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE3334A361
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 09:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCZIt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 04:49:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229551AbhCZIs5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 04:48:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8YCpH048122;
        Fri, 26 Mar 2021 04:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Y07c2TPg93sZ+XXI/Ulc2KO+qCxUkQASzIXLkjpMeJA=;
 b=D6J04F6fiybZ6ZhCA/jbx2UZ2zNABQE9/J5DgXlkoMvkqzjkFrUuv8iag5CgQknl1JKz
 uIybiIRCc1WXVEDJnLh2WZi/tTmYoqiNKhohp8OMvrKEI/wdcOIG2S540LeT83Rlu13l
 x1wmwEjWhVUTTLzKWPmq9z651HnPxU/GFhdSEVreYnmX6n1Iuw6cNVHeDfWnhxBbk+ld
 GQJNH6RpKzFeItupCt7dL3y6bzXMFsvZVR2DYgdjXoU6ywj4P1IYdBYYu795CtdBYcp8
 +WLnnwRUszSExQvLkCi1JCVv8DtHr9TwpNPrNjRKaD+b8dDF/OPcA1oDpgbha1SJ0uNw cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37h76vf1q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 04:48:56 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12Q8YX68049868;
        Fri, 26 Mar 2021 04:48:56 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37h76vf1pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 04:48:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12Q8lTeR026922;
        Fri, 26 Mar 2021 08:48:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 37h14ugfgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Mar 2021 08:48:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12Q8mpru38928758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 08:48:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12DA5A405D;
        Fri, 26 Mar 2021 08:48:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B21B0A4055;
        Fri, 26 Mar 2021 08:48:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.87.8])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Mar 2021 08:48:49 +0000 (GMT)
Subject: Re: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     farman@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        akrowiak@linux.ibm.com, pmorel@linux.ibm.com, cohuck@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, alex.williamson@redhat.com
References: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <4a856f72-83ec-29b8-a251-b90c5f3c2049@de.ibm.com>
Date:   Fri, 26 Mar 2021 09:48:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ykDyQMq41E8h3CHqW7wamQMHKeJG482m
X-Proofpoint-ORIG-GUID: a_xBzTgzSVfEHqVeiboSZP3A0wMbK7nz
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-26_02:2021-03-25,2021-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.03.21 14:41, Matthew Rosato wrote:
> Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
> and replace the backup for vfio-ap as Pierre is focusing on other
> areas.
> 

Thanks for doing cross-backup. Queued for the s390 tree.

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
