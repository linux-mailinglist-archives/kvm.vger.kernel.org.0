Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCB73DE885
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 10:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhHCIeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 04:34:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234526AbhHCIeg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Aug 2021 04:34:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1738Xm0K001498;
        Tue, 3 Aug 2021 04:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=gztNBNWGYIeoA7EMxLtqr7x1FH5dKTBCDjZWF4fFaw8=;
 b=Fk07zDHzpbnB6AB1BGSjqTdkQmNkJ1LtlKeXuj0i+02sGZEoXCCFGRMAszf2VawT1JjE
 j6gHcORNvcruOj6fCH51jq0U5D2GztIFKsdlmd80Bs5BLHeZeumrpeLN6KQWbVqX/MU2
 0ZHP9UesG7OlgZhwecDcQ/rYa0HIH3ESrLruH41xTizc7iivZbiNk5Jr0lihYYr1rQzM
 a2N6Gd1e70SnMOPa+1n5GBVL4/hnVf42Vdiq1wCRaO0iOlr1XO4xAW22umUeZnVPZ2Ib
 tduAY9j/oVuiBrtH1Psq3uAUATugiCtBEy6srCXp4cuT4TYa2lFTU7iNRn3wunTCnMkE QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a6keaqmhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:34:23 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1738Xukv002517;
        Tue, 3 Aug 2021 04:34:22 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a6keaqmgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 04:34:22 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1738WGl2026340;
        Tue, 3 Aug 2021 08:34:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a4x58xp0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 08:34:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1738VLOb56951082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Aug 2021 08:31:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A07A52057;
        Tue,  3 Aug 2021 08:34:17 +0000 (GMT)
Received: from osiris (unknown [9.145.48.2])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id AD4AC5204F;
        Tue,  3 Aug 2021 08:34:16 +0000 (GMT)
Date:   Tue, 3 Aug 2021 10:34:15 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, cohuck@redhat.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        chaitanya.kulkarni@wdc.com, axboe@kernel.dk,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] s390: Make use of PAGE_ALIGN/PAGE_MASK/PFN_UP helper
 macro
Message-ID: <YQj/h5oi9y4Zs8FR@osiris>
References: <20210803034904.1579-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803034904.1579-1-caihuoqing@baidu.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: G1Hi1ySNKAMlvfjTJ72Esf_C_dhyaM4I
X-Proofpoint-GUID: JvqMmm9psheAG2tkwsbY_aME3d7kkWIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_02:2021-08-03,2021-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=946 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021 at 11:49:00AM +0800, Cai Huoqing wrote:
> it's a refactor to make use of PAGE_ALIGN/PAGE_MASK/PFN_UP helper macro
> 
> Cai Huoqing (4):
>   s390/scm_blk: Make use of PAGE_ALIGN helper macro
>   s390/vmcp: Make use of PFN_UP helper macro
>   vfio-ccw: Make use of PAGE_MASK/PFN_UP helper macro
>   s390/cio: Make use of PAGE_ALIGN helper macro
> 
>  drivers/s390/block/scm_blk.c   |  2 +-
>  drivers/s390/char/vmcp.c       | 10 ++++------
>  drivers/s390/cio/itcw.c        |  2 +-
>  drivers/s390/cio/vfio_ccw_cp.c |  8 ++++----
>  4 files changed, 10 insertions(+), 12 deletions(-)

I'm not willing to review or apply these patches. There is no added
value and I doubt that anything of this has been tested, so you are
putting the burden on other people.
