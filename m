Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE78F3C5BEA
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 14:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhGLMQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 08:16:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230074AbhGLMQN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 08:16:13 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CC3q8o063869;
        Mon, 12 Jul 2021 08:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BdjMHSTliAkxVobXwCyCSfvkC2Mr4rDmoFKGccLL69k=;
 b=hwK1PHG7ymOQaRFLOMv5IeeGeITaBlvhdzvYGmjTpz4MvCOaJaOC4KtYX2DZo/gtyZKz
 nUIKmy/GP5iE4wZh1hUvSOmWXPfBcfTjx2/ftb4fNEaQukBkY9oGMzzhz+CecEanUX4M
 J8QXOfpg87RNH+hMrsZH+8BkESxU0GooIbrOAMEbiJzdnn7Hv61yDApb7e2XXHZi57Fs
 oJky7lVtUx2zPzwa//Tsst8Twv5VIacqvHcmypoR03TzUakvXSQbbtciQhLi26j+sDxy
 OUSUCR+Trfz445o0/6QK9HglbJisaOqd3/iTlNfSHaD7n2oBL7LIhcHSNdWfumejsyHC 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrhyrahr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:13:19 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16CC3xS9064620;
        Mon, 12 Jul 2021 08:13:19 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39qrhyragn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 08:13:19 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16CC6u75008136;
        Mon, 12 Jul 2021 12:13:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 39q3688d9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Jul 2021 12:13:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16CCDDEI32768284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 12:13:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C41704C058;
        Mon, 12 Jul 2021 12:13:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43BE04C064;
        Mon, 12 Jul 2021 12:13:12 +0000 (GMT)
Received: from osiris (unknown [9.145.68.238])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Jul 2021 12:13:12 +0000 (GMT)
Date:   Mon, 12 Jul 2021 14:13:10 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kernel@pengutronix.de, Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] s390/cio: Make struct css_driver::remove return
 void
Message-ID: <YOwx1lZxLPIRQIJn@osiris>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
 <87zguzfn8e.fsf@redhat.com>
 <20210706160543.3qfekhzalwsrtahv@pengutronix.de>
 <ccc9c098-504d-4fd4-43a9-ccb3fa2a2232@linux.ibm.com>
 <20210707143431.g2wigjypoah4nrlz@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210707143431.g2wigjypoah4nrlz@pengutronix.de>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tl-b3u-hZoomtKhwFgAacLK_0kNqyNMe
X-Proofpoint-GUID: gMmn3Jl9HDzU6VQr65Ahy6MSpn6eaBPT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-12_05:2021-07-12,2021-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxscore=0 clxscore=1011 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 04:34:31PM +0200, Uwe Kleine-König wrote:
> Hello Vineeth,
> 
> On Wed, Jul 07, 2021 at 01:28:11PM +0200, Vineeth Vijayan wrote:
> > Thank you. I will use the modified description. This will be picked up by
> > Vasily/Heiko to the s390-tree.
> > 
> > Also Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>
> > 
> > One question, is this patchset supposed to have 4 patches ? Are we missing
> > one ?
> 
> Yes, the fourth patch[1] has the following shortstat:
> 
> 	80 files changed, 83 insertions(+), 219 deletions(-)
> 
> and the affected files are distributed over the whole source tree.
> 
> Given that this fourth patch is the actual motivation for the first
> three, and I'd like to get this in during the next merge window, I would
> prefer if these patches were taken together. (Well unless the first
> three make it into 5.14-rc1 of course.)
> 
> Best regards
> Uwe
> 
> [1] https://lore.kernel.org/lkml/20210706154803.1631813-5-u.kleine-koenig@pengutronix.de/

In this case I think Greg should pick up all four patches.

FWIW: it's usually also not very helpful to cc people only on parts of
a patch series and let them figure out the bigger picture.
