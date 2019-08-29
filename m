Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AE5A1D25
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 16:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfH2Oj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 10:39:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbfH2OjZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Aug 2019 10:39:25 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TEd1oQ106574
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 10:39:24 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2updvy78pu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 10:39:02 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <gor@linux.ibm.com>;
        Thu, 29 Aug 2019 15:38:45 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 15:38:42 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TEcfU68650832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 14:38:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14201A405B;
        Thu, 29 Aug 2019 14:38:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE2F4A405F;
        Thu, 29 Aug 2019 14:38:40 +0000 (GMT)
Received: from localhost (unknown [9.152.212.148])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 29 Aug 2019 14:38:40 +0000 (GMT)
Date:   Thu, 29 Aug 2019 16:38:39 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 0/1] vfio-ccw patch for next release
References: <20190828155716.22809-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828155716.22809-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 19082914-0012-0000-0000-000003444CEE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082914-0013-0000-0000-0000217E8E0B
Message-Id: <your-ad-here.call-01567089519-ext-5685@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=675 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290160
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 05:57:15PM +0200, Cornelia Huck wrote:
> The following changes since commit 416f79c23dbe47e0e223efc06d3487e1d90a92ee:
> 
>   s390/paes: Prepare paes functions for large key blobs (2019-08-21 12:58:54 +0200)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20190828
> 
> for you to fetch changes up to 60e05d1cf0875f0cf73472f7dff71d9933c5b697:
> 
>   vfio-ccw: add some logging (2019-08-23 12:53:32 +0200)
> 
> ----------------------------------------------------------------
> Add some logging into the s390dbf.
> 
> ----------------------------------------------------------------
> 
> Cornelia Huck (1):
>   vfio-ccw: add some logging
> 
>  drivers/s390/cio/vfio_ccw_drv.c     | 50 ++++++++++++++++++++++++++--
>  drivers/s390/cio/vfio_ccw_fsm.c     | 51 ++++++++++++++++++++++++++++-
>  drivers/s390/cio/vfio_ccw_ops.c     | 10 ++++++
>  drivers/s390/cio/vfio_ccw_private.h | 17 ++++++++++
>  4 files changed, 124 insertions(+), 4 deletions(-)
> 
> -- 
> 2.20.1
> 

Applied, thanks!
-- 
⣿⣿⣿⣿⢋⡀⣀⠹⣿⣿⣿⣿
⣿⣿⣿⣿⠠⣶⡦⠀⣿⣿⣿⣿
⣿⣿⣿⠏⣴⣮⣴⣧⠈⢿⣿⣿
⣿⣿⡏⢰⣿⠖⣠⣿⡆⠈⣿⣿
⣿⢛⣵⣄⠙⣶⣶⡟⣅⣠⠹⣿
⣿⣜⣛⠻⢎⣉⣉⣀⠿⣫⣵⣿

