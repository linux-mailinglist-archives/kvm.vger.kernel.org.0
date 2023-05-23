Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B4170E262
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 18:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbjEWQhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237105AbjEWQhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 12:37:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4262111A;
        Tue, 23 May 2023 09:37:03 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NGVhmq014628;
        Tue, 23 May 2023 16:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4QSbeGpvSiReYGcIr7QrxPewrKrb4N/ywhA3WbbktU8=;
 b=HduYbZH3tDTH4FQp2R04o6SBjNP2ws8AVUYhNQ+v1ldlWPDimXYpFmRs14P5CiXukEk7
 MoRlWXv8wB1akliyxDrp9hyHp99LSNMOayx8pgNeZGHm+QY+kWNQ3a3rT3NWhr0v7NHP
 U4Etb8AYXKDiiTaI24aIy5BZuJr5ywN7PxCpVp22bbQa2SLPtFHHbOYSDFvOGTtoIdMU
 mAooG8F1Ies+HAKaYeE4eSYf7tXY8RujVcKQwB9WH6RyU6WGilNP25yjpUofssrVsLEt
 Ril7sCRTfoczWj28hvSULQ2z0s7VslnlYIWRqCmBFgXh0AGeEN8qrl/jZIm3eTk+Jpgb 9A== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qryy41ub8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 16:36:57 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34NEKh8g031369;
        Tue, 23 May 2023 16:36:56 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3qppdpky27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 May 2023 16:36:56 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NGatHo66453942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 16:36:55 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3614858045;
        Tue, 23 May 2023 16:36:55 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B776158052;
        Tue, 23 May 2023 16:36:53 +0000 (GMT)
Received: from [9.61.92.8] (unknown [9.61.92.8])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 23 May 2023 16:36:53 +0000 (GMT)
Message-ID: <410d06c5-90f5-93dc-6e6d-37e5923fe0a7@linux.ibm.com>
Date:   Tue, 23 May 2023 12:36:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 0/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <cover.1684805398.git.gustavoars@kernel.org>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <cover.1684805398.git.gustavoars@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ympyjzcNDEsFLxKdxoCce_RGFjRUV_RH
X-Proofpoint-ORIG-GUID: ympyjzcNDEsFLxKdxoCce_RGFjRUV_RH
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_10,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=946 phishscore=0 suspectscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/22/23 9:34 PM, Gustavo A. R. Silva wrote:
> Hi!
> 
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
> 

Hi Gustavo,

Thanks! For the series:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
