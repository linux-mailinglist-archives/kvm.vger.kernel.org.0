Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CD7157652
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 13:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBJMv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 07:51:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730468AbgBJMnj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 07:43:39 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ACeN3Z089457
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 07:43:37 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y1ufkaue2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2020 07:43:37 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <gor@linux.ibm.com>;
        Mon, 10 Feb 2020 12:43:35 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 12:43:34 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01AChWhm49086526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 12:43:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5E1BA4054;
        Mon, 10 Feb 2020 12:43:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 307A9A405F;
        Mon, 10 Feb 2020 12:43:32 +0000 (GMT)
Received: from localhost (unknown [9.145.76.6])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 10 Feb 2020 12:43:32 +0000 (GMT)
Date:   Mon, 10 Feb 2020 13:43:30 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PULL 0/1] one vfio-ccw patch for 5.6
References: <20200206170331.1032-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206170331.1032-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
x-cbid: 20021012-0020-0000-0000-000003A8CB6C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021012-0021-0000-0000-00002200A5C7
Message-Id: <your-ad-here.call-01581338610-ext-6781@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_02:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1011
 mlxlogscore=884 bulkscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 06:03:30PM +0100, Cornelia Huck wrote:
> The following changes since commit d1eef1c619749b2a57e514a3fa67d9a516ffa919:
> 
>   Linux 5.5-rc2 (2019-12-15 15:16:08 -0800)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20200206
> 
> for you to fetch changes up to dbaf10027ae92a66f0dfad33e1e3453daa16373f:
> 
>   vfio-ccw: Use the correct style for SPDX License Identifier (2020-01-07 10:37:34 +0100)
> 
> ----------------------------------------------------------------
> fix style of SPDX License Identifier
> 
> ----------------------------------------------------------------
> 
> Nishad Kamdar (1):
>   vfio-ccw: Use the correct style for SPDX License Identifier
> 
>  drivers/s390/cio/vfio_ccw_trace.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> 2.21.1
> 
Pulled into fixes, thanks!

