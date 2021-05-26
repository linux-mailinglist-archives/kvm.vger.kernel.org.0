Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8766C3922C2
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 00:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhEZWep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 18:34:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234278AbhEZWeo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 18:34:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QM4c1M183926;
        Wed, 26 May 2021 18:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1rk5W1wtQNJAVtPklROCpsFvjC8BNyqTL7Z/xWrWsOE=;
 b=XyS6dMcjXFHrcXlq7fMcA3sTsYqvGlpNvzh7gyaotpTf79HpT+tRE1rZisqm0CdhIldx
 pKH/soNlS+/ufWllmpeJfLejL6b7MakPQSWipjPgWzbD7yQFYLFXMhRovCdQyY3XBllx
 InVUrJWDGMmJ4c0ZBV9fsptxAb8n3SeHq0uPlAC7XeJtftkhxRh4FvlAAhzGkOtFIYeS
 WyAqU5fFBMJmsfYkcOZk4zckGMfXvFN6eddLVzTSuIenb2WD2R73vtnUc6HySTGNM074
 kV60WcuDGuhZllA2D7Fdf3Xz4FB9DT0LIDFOt49LVgC/5LGJ9TnAi6A7Vc/Hp6Um6/jV LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sumhnxdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 18:33:12 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QM4fGx184309;
        Wed, 26 May 2021 18:33:12 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38sumhnxd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 18:33:12 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QMKD4r032752;
        Wed, 26 May 2021 22:33:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2rm8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 22:33:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QMX6lY32113050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 22:33:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80D9DAE06C;
        Wed, 26 May 2021 22:33:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33379AE068;
        Wed, 26 May 2021 22:33:06 +0000 (GMT)
Received: from localhost (unknown [9.171.24.75])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 26 May 2021 22:33:06 +0000 (GMT)
Date:   Thu, 27 May 2021 00:33:00 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PULL 0/3] vfio-ccw: some fixes
Message-ID: <your-ad-here.call-01622068380-ext-9894@work.hours>
References: <20210520113450.267893-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210520113450.267893-1-cohuck@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kpdLUgBQXplun-zmDtKmvfkCTO99fl5S
X-Proofpoint-ORIG-GUID: T2nOFJsA81hZFhO8LANdpVxxVIabFZtU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_12:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1011 impostorscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 01:34:47PM +0200, Cornelia Huck wrote:
> The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:
> 
>   Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw.git tags/vfio-ccw-20210520
> 
> for you to fetch changes up to 2af7a834a435460d546f0cf0a8b8e4d259f1d910:
> 
>   vfio-ccw: Serialize FSM IDLE state with I/O completion (2021-05-12 12:59:50 +0200)
> 
> ----------------------------------------------------------------
> Avoid some races in vfio-ccw request handling.
> 
> ----------------------------------------------------------------
> 
> Eric Farman (3):
>   vfio-ccw: Check initialized flag in cp_init()
>   vfio-ccw: Reset FSM state to IDLE inside FSM
>   vfio-ccw: Serialize FSM IDLE state with I/O completion

Pulled into fixes, thanks.

BTW, linux-s390@vger.kernel.org is now archived on lore and we started
using b4 (https://git.kernel.org/pub/scm/utils/b4/b4.git) to pick up
changes. Besides all other features, it can convert Message-Id: to Link:

Hm, and b4 also now complains:
✗ BADSIG: DKIM/ibm.com
have to look into that...
