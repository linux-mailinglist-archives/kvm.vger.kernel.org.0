Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1419D7A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfEJM4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 08:56:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfEJM4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 08:56:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ACrvnQ058105;
        Fri, 10 May 2019 12:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2CcUco/IGTuXl0z7L7QKePfHWuioroKL4VZPWaueI2E=;
 b=s+y9OFGVDJdToV/VY+kfBPShNbNax1Oqle8ufkTS9lG/r/NCPHOyV08ooNT50FrUGS1a
 sJvDyvS5iSWs+0jf6YFnkKTqW4eYPBQHwqiSqUAK3WTOb+edCq6g1Gu+QYxGdNdIz8HM
 xAFoEG47L/udtxXlyHZbqD7qLagBavoUGqzszBiVfHd2pnP5iWmUGK8Xl9CGkBay2V1H
 Q2Y75onaQk0qKR5I+LVfmDlgVGjJVave4TneoDcPKCUOKhx0iznChF1ohc7/BVhWsq94
 b5gTPlFxvzO/1lMBcu0CgrlC+M6OVWqvIxlDCXpHG5h8fDKhRaGj9dj7Rp9ZDfeTcMeN ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2s94b18ua6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 12:55:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ACs3Lb035101;
        Fri, 10 May 2019 12:55:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2sagyvtp9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 12:55:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4ACteXM015202;
        Fri, 10 May 2019 12:55:40 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 05:55:40 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 5F01F6A00CB; Fri, 10 May 2019 08:55:46 -0400 (EDT)
Date:   Fri, 10 May 2019 08:55:46 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/4] Zero allocated pages
Message-ID: <20190510125546.GD12248@char.us.oracle.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509200558.12347-1-nadav.amit@gmail.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100091
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 01:05:54PM -0700, Nadav Amit wrote:
> For reproducibility, it is best to zero pages before they are used.
> There are hidden assumptions on memory being zeroed (by BIOS/KVM), which
> might be broken at any given moment. The full argument appears in the
> first patch commit log.
> 
> Following the first patch that zeros the memory, the rest of the
> patch-set removes redundant zeroing do to the additional zeroing.
> 
> This patch-set is only tested on x86.

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

for all of them please.
> 
> v2->v3:
> * Typos [Alexandru]
> 
> v1->v2:
> * Change alloc_pages() as well
> * Remove redundant page zeroing [Andrew]
> 
> Nadav Amit (4):
>   lib/alloc_page: Zero allocated pages
>   x86: Remove redundant page zeroing
>   lib: Remove redundant page zeroing
>   arm: Remove redundant page zeroing
> 
>  lib/alloc_page.c         |  4 ++++
>  lib/arm/asm/pgtable.h    |  2 --
>  lib/arm/mmu.c            |  1 -
>  lib/arm64/asm/pgtable.h  |  1 -
>  lib/virtio-mmio.c        |  1 -
>  lib/x86/intel-iommu.c    |  5 -----
>  x86/eventinj.c           |  1 -
>  x86/hyperv_connections.c |  4 ----
>  x86/vmx.c                | 10 ----------
>  x86/vmx_tests.c          | 11 -----------
>  10 files changed, 4 insertions(+), 36 deletions(-)
> 
> -- 
> 2.17.1
> 
