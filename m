Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE67C32900F
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 21:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbhCAUCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 15:02:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237822AbhCAT5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 14:57:47 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121JYAmf104584;
        Mon, 1 Mar 2021 14:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=KdYnacJ38nNqtx282dJOQCrwe0ckmvWKWzfDXRFu2TQ=;
 b=enitdJ/GuXcmjB0FwI3nSeNvbJ29tjIEqFIAf8FlLCibPRAjiGAMXEzkHclaIhsbt38F
 n+y6G8DjT0h/yaUsBFUJYXbEPkqPIoLcztwcBMXUVFP8AqwamsCTQzUO4ZVx3r5NOOu4
 yFB+oLdhXUZzSS64mkj9ZECLicbwfqw/efDdQpTnVliGS8+0rQa/rqhK8tKdr7Guiubf
 mwLh57AdYBfRVFw3dOtGjwhNGqPbj2a0gfOgU/IgIu23eTZ5aeIHGjb8goglaVa4PXu7
 ABViDl1FQkL0xJUOKN66W71cvGr9xPXwzlLbkgL5C+I5htjwkWJCD5PseUUbE2qWeEo+ fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 370td139ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 14:56:35 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121JZ8Gx108318;
        Mon, 1 Mar 2021 14:56:35 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 370td139xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 14:56:35 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121JratB005724;
        Mon, 1 Mar 2021 19:56:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 37150cr1ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 19:56:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121JuUxP31523300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 19:56:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 021FF4203F;
        Mon,  1 Mar 2021 19:56:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E37F42042;
        Mon,  1 Mar 2021 19:56:29 +0000 (GMT)
Received: from osiris (unknown [9.171.39.26])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Mar 2021 19:56:29 +0000 (GMT)
Date:   Mon, 1 Mar 2021 20:56:28 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Wang Qing <wangqing@vivo.com>, Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: cio: Return -EFAULT if copy_to_user() fails
Message-ID: <YD1G7HLUcp04kr+j@osiris>
References: <1614600093-13992-1-git-send-email-wangqing@vivo.com>
 <YDzob/k70ix1g0s+@osiris>
 <e7edc20c-49d7-9297-7d0e-01f8a55c9c37@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7edc20c-49d7-9297-7d0e-01f8a55c9c37@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_13:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 mlxlogscore=971 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103010156
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021 at 01:07:26PM -0500, Eric Farman wrote:
> 
> 
> On 3/1/21 8:13 AM, Heiko Carstens wrote:
> > On Mon, Mar 01, 2021 at 08:01:33PM +0800, Wang Qing wrote:
> > > The copy_to_user() function returns the number of bytes remaining to be
> > > copied, but we want to return -EFAULT if the copy doesn't complete.
> > > 
> > > Signed-off-by: Wang Qing <wangqing@vivo.com>
> > > ---
> > >   drivers/s390/cio/vfio_ccw_ops.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Applied, thanks!
> 
> There's a third copy_to_user() call in this same routine, that deserves the
> same treatment. I'll get that fixup applied.

Thanks a lot - I actually realized that there was a third one, but
blindly assumed that the other patch addressed that (for which the
original broken commit e06670c5fe3b ("s390: vfio-ap: implement
VFIO_DEVICE_GET_INFO ioctl") got an amazing number of eight tags ;))

I'll keep your patch as a seperate one, since it fixes a different
upstream patch.
