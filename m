Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D2327F3C
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 14:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhCANPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 08:15:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235326AbhCANOI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 08:14:08 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121D3F1T085080;
        Mon, 1 Mar 2021 08:13:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=DcWQGXA/VC+hCL9kCP9BkC9iOey7+37NofIcKI9YjqY=;
 b=XDdc/EYmCzxLdj4vYSVjaPKcj/hZ7EtS27VKR6sAvpNWcTksZffnMCS2ixSVhmPcO+kx
 MCNmByPoKKupEYzh70wq8U7alk2Ydv8bCQ4vRonSnl11u1ARLROo5ent67kU+P2Q3rJG
 5rQAwRgboFibjVjV/wZyj7vywkODcQiGEtPvKs4od7hzIv/UQ2KytBQbsjgt3eJL+wsI
 foENz3R1OCgNE45Ij0ntd+1BzEA2GdJkN3z2BrQ+uz1jmx9Pd7UvNK16Q0yakm6orXIF
 cY9Rd+GIh4tXwM8CwTyiRmEc8bILiRMxthKuBOXSkiNOUg48CsIFcx/AHWPmvAXfOyyN NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37106d1s9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 08:13:26 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121D455L092418;
        Mon, 1 Mar 2021 08:13:26 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37106d1s8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 08:13:26 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121DDOmt009245;
        Mon, 1 Mar 2021 13:13:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 36yj530w34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 13:13:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121DDLfM41288066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 13:13:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0957AA4051;
        Mon,  1 Mar 2021 13:13:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82829A4040;
        Mon,  1 Mar 2021 13:13:20 +0000 (GMT)
Received: from osiris (unknown [9.171.28.2])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Mar 2021 13:13:20 +0000 (GMT)
Date:   Mon, 1 Mar 2021 14:13:19 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: cio: Return -EFAULT if copy_to_user() fails
Message-ID: <YDzob/k70ix1g0s+@osiris>
References: <1614600093-13992-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614600093-13992-1-git-send-email-wangqing@vivo.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_06:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=920 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 bulkscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 08:01:33PM +0800, Wang Qing wrote:
> The copy_to_user() function returns the number of bytes remaining to be
> copied, but we want to return -EFAULT if the copy doesn't complete.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks!
