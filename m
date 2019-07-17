Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC5C6BF7B
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 18:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfGQQLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 12:11:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726620AbfGQQLP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jul 2019 12:11:15 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6HG7pO3090453
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 12:11:14 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tt5y9jtbq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 12:11:13 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Wed, 17 Jul 2019 17:11:11 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 17 Jul 2019 17:11:08 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6HGAr8R32244190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 16:10:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E67DFA4055;
        Wed, 17 Jul 2019 16:11:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A70F0A404D;
        Wed, 17 Jul 2019 16:11:06 +0000 (GMT)
Received: from osiris (unknown [9.152.212.134])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 17 Jul 2019 16:11:06 +0000 (GMT)
Date:   Wed, 17 Jul 2019 18:11:05 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL v2 0/6] vfio-ccw fixes for 5.3
References: <20190717094350.13620-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717094350.13620-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19071716-4275-0000-0000-0000034E2D02
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071716-4276-0000-0000-0000385E4392
Message-Id: <20190717161105.GC5427@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=938 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170187
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 17, 2019 at 11:43:44AM +0200, Cornelia Huck wrote:
> are available in the Git repository at:
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190717-2
> Cornelia Huck (1):
>   Documentation: fix vfio-ccw doc
> 
> Farhan Ali (5):
>   vfio-ccw: Fix misleading comment when setting orb.cmd.c64
>   vfio-ccw: Fix memory leak and don't call cp_free in cp_init
>   vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn
>   vfio-ccw: Don't call cp_free if we are processing a channel program
>   vfio-ccw: Update documentation for csch/hsch
> 
>  Documentation/s390/vfio-ccw.rst | 31 ++++++++++++++++++++++++++++---
>  drivers/s390/cio/vfio_ccw_cp.c  | 28 +++++++++++++++++-----------
>  drivers/s390/cio/vfio_ccw_drv.c |  2 +-
>  3 files changed, 46 insertions(+), 15 deletions(-)

I added these to our internal repository for the time being for
testing. Will pull into our external fixes branch as soon as rc1 is
available. So please don't delete the tag ;)

