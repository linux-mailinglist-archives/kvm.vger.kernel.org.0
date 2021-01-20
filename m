Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923CB2FD3FF
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 16:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbhATP2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 10:28:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390905AbhATPZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 10:25:45 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KF24mj003411;
        Wed, 20 Jan 2021 10:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=vFTmDdXq/JD+hlhwTE1nBPz1eBn8OTg3UYAZbWUGQ8Q=;
 b=J3Vdif1kXqk8PUPYc9Ld9hP1F7cBTMoqLRhH8bzENdMSEIveoVOOO+S26HhrDZJVgrCu
 XOAtry+nHIXZpTiKwln8+yPR/Xz/4alrr13xDvUi3i0jag8L2oDz3iabxPkyyNDQbKXL
 xyjfdZS8mQP5y6mEsA8LbD+kwBBxseJhT6Gp8sOM4kSVcwyXuE61DP0Fx/EGrfqtwYqB
 nxUjckYV9z8nDrJBRsljVovWR0Mzoz+/K9eyHYpSLT2Haj+YvJ+gFvk5E1yD2LH1sgS8
 K5pukjxHeQ35KPvNRLYkMKkqHGmzz+nOxFm1toxS+rxFIG00BcE1Y6f4SazieRWxqbpc 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366nc43v9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 10:24:54 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KF2CV4004446;
        Wed, 20 Jan 2021 10:24:54 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366nc43v8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 10:24:54 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KFLnTF018213;
        Wed, 20 Jan 2021 15:24:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3668parsax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 15:24:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KFOmhI22282674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 15:24:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C572A4068;
        Wed, 20 Jan 2021 15:24:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 051D3A4066;
        Wed, 20 Jan 2021 15:24:48 +0000 (GMT)
Received: from osiris (unknown [9.171.38.241])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 20 Jan 2021 15:24:47 +0000 (GMT)
Date:   Wed, 20 Jan 2021 16:24:46 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
Message-ID: <20210120152446.GD8202@osiris>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-3-frankja@linux.ibm.com>
 <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
 <20210120134208.GC8202@osiris>
 <221ce6ab-4630-473d-a49f-150ac8c573d6@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <221ce6ab-4630-473d-a49f-150ac8c573d6@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_06:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 mlxlogscore=953 impostorscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101200086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021 at 03:39:14PM +0100, Christian Borntraeger wrote:
> On 20.01.21 14:42, Heiko Carstens wrote:
> > On Tue, Jan 19, 2021 at 11:25:01AM +0100, Christian Borntraeger wrote:
> >>> +		if (user_mode(regs)) {
> >>> +			send_sig(SIGSEGV, current, 0);
> >>> +			return;
> >>> +		} else
> >>> +			panic("Unexpected PGM 0x3d with TEID bit 61=0");
> >>
> >> use BUG instead of panic? That would kill this process, but it allows
> >> people to maybe save unaffected data.
> > 
> > It would kill the process, and most likely lead to deadlock'ed
> > system. But with all the "good" debug information being lost, which
> > wouldn't be the case with panic().
> > I really don't think this is a good idea.
> > 
> 
> My understanding is that Linus hates panic for anything that might be able
> to continue to run. With BUG the admin can decide via panic_on_oops if
> debugging data or runtime data is more important. But mm is more on your
> side, so if you insist on panic we can keep it.

I prefer to have good debug data - and when we are reaching this
panic, then we _most_ likely have data corruption anywhere (wrong
pointer?). So it seems to be best to me to shutdown the machine
immediately in order to avoid any further corruption instead of hoping
that the system stays somehow alive.

Furthermore a panic is easily detectable by a watchdog, while a BUG
may put the system into a limbo state where the real workload doesn't
work anymore, but the keepalive process does. I don't think this is
desirable.
