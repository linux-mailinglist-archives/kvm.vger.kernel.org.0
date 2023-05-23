Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6170E501
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 20:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbjEWS6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 14:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjEWS6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 14:58:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB4091;
        Tue, 23 May 2023 11:58:38 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NHuHfO011599;
        Tue, 23 May 2023 18:58:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=5aC+OJOtsi5c4oLl9XNjE+QV12mOzwsZDutiUzFGjXY=;
 b=mCxP5xMlCrJzGd7lfuwopfp8nSdPrsYPLxbVCWfT1JH6ZTlEW0rEdGmGjcsqPsHG3sxC
 iO320IvLGYvZao5uSpRmFJOLzZiokCB5vTYF/b8NypKomxs5roIGuDnMUGGHM3HPnp4c
 f2jPosuGLG13ceIp2HjDjW+YGIEKWqaZFiLGsnlfLEm5oBgvRRreIB/QrqS+dItszYW/
 YMJ0pAwQQNQ31ERGASAZWQYGft9x+jtXH/bRUtVOYJ6jowGFCPFLKKiZImcGC4GNpprl
 8UO70g94gKBX+ciGEFgMpwAWuFGGKpMJw1kKms1ivHYEwReLLO9eiR0mH0mHBsiWhOHy dA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qs2aqhv9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 18:58:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34NHVleh017921;
        Tue, 23 May 2023 18:58:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qppcs9bqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 18:58:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NIwUfS24117848
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 18:58:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19B5320043;
        Tue, 23 May 2023 18:58:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFC7420040;
        Tue, 23 May 2023 18:58:28 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.19.15])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 23 May 2023 18:58:28 +0000 (GMT)
Date:   Tue, 23 May 2023 20:58:26 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Message-ID: <ZG0M0kzWHXcBQa0N@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <cover.1684805398.git.gustavoars@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1684805398.git.gustavoars@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Pp1HkwHa6AYGcy6FLtk71E6kwDCTo8PM
X-Proofpoint-GUID: Pp1HkwHa6AYGcy6FLtk71E6kwDCTo8PM
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_12,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 mlxlogscore=753
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230150
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 07:34:41PM -0600, Gustavo A. R. Silva wrote:
> This small series aims to replace a one-element array with a
> flexible-array member in struct vfio_ccw_parent.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/160
> Link: https://github.com/KSPP/linux/issues/297
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> 
> Gustavo A. R. Silva (2):
>   vfio/ccw: Replace one-element array with flexible-array member
>   vfio/ccw: Use struct_size() helper
> 
>  drivers/s390/cio/vfio_ccw_drv.c     | 2 +-
>  drivers/s390/cio/vfio_ccw_private.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Fixed duplicate "the the" in patch #1 commit message and applied.

Thanks!
