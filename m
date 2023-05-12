Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05A870087B
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 14:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbjELMv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 08:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240881AbjELMvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 08:51:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0F99D;
        Fri, 12 May 2023 05:51:44 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CCHMX2013993;
        Fri, 12 May 2023 12:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=l3f2SlxGQyOsuhHFYAbNgTNKTMQ+kP4uGpcgbSok8TA=;
 b=pgLOBu4hnivmJCT+eWdvfL1CcARlFfjEVmF1Am7XYTqq7U6uYxOiLi4UXa3k1NTYF3cf
 +mPExHyi/cRIfB+6uOEtlCgIslBd3eMc3g3ad4xPfF//+StEuQkJb8Yfv4ghM8/AhJAx
 uwxh735NAtwB80aOCPWR10CJCBhM8sUMkxP6rUA85fPSxjOonTxTlDJGSUwyx+ELj8La
 NF4Xh1xKMQu9N2kbDuzINeP3LuV08dxEfZeUHgUSAM6xI9eXVM80GUshkTdy70B81Fmt
 SA0ub4x50Nt5bbYM+/9bwszAwZhoRthR1tm73i/6DFu96Se1+6tUwD2ohuma/FEeXRS2 uA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhn0wssqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 12:51:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C28egb010798;
        Fri, 12 May 2023 12:51:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qf84eabx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 12:51:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34CCpbjf51904876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 12:51:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B309820043;
        Fri, 12 May 2023 12:51:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13EB720040;
        Fri, 12 May 2023 12:51:37 +0000 (GMT)
Received: from osiris (unknown [9.179.20.70])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 12 May 2023 12:51:36 +0000 (GMT)
Date:   Fri, 12 May 2023 14:51:35 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH 1/5] s390/uvdevice: Add info IOCTL
Message-ID: <ZF42V9fJFtRLR1Ua@osiris>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
 <20230512093153.206378-2-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512093153.206378-2-seiden@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cQz2cHMoBJNi1xHvkk3RJhv2emJYez1o
X-Proofpoint-ORIG-GUID: cQz2cHMoBJNi1xHvkk3RJhv2emJYez1o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=814 impostorscore=0 adultscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305120105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 11:31:49AM +0200, Steffen Eiden wrote:
> Add an IOCTL that allows userspace to find out which IOCTLs the uvdevice
> supports without trial and error.
> 
> Explicitly expose the IOCTL nr for the request types.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/include/uapi/asm/uvdevice.h | 45 +++++++++++++++-
>  drivers/s390/char/uvdevice.c          | 77 ++++++++++++++++++++++++---
>  2 files changed, 114 insertions(+), 8 deletions(-)
...
> +static void __init set_supp_uv_cmds(struct uvio_uvdev_info *info)
> +{
> +	int i;
> +
> +	for (i = 0; i < UVIO_IOCTL_NUM_IOCTLS; i++) {
> +		if (ioctl_nr_to_uvc_bit[i] == -1UL)
> +			continue;
> +		if (!test_bit_inv(ioctl_nr_to_uvc_bit[i], uv_info.inst_calls_list))
> +			continue;
> +		set_bit(i, (unsigned long *)&info->supp_uv_cmds);

Just a minor thing: please use

		__set_bit(i, (unsigned long *)&info->supp_uv_cmds);

set_bit() is the atomic variant which may even generate a compare and swap
loop (dependent on config options) to set bits, which is not what is needed
here. Didn't see that in previous version.
So if atomicity is not needed, please use __set_bit() instead.
