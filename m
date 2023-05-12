Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9957B700882
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbjELMx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 08:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241057AbjELMxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 08:53:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D475414E51;
        Fri, 12 May 2023 05:53:26 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34CChBQX019856;
        Fri, 12 May 2023 12:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=4/L4M7NmQerqFjBvgJbiEMN4JttL1a2wd+8RqKU0MOE=;
 b=cKvIrjQ4IMtL5h5V62VsztICKrALfAsmzl1/xDBznZlgAvBEAKXh291hFRxJIQO6cSIU
 +IJdrMYrIxO0ICp477L+Btnb8vC8TV5RKR8BxsFGqJbiE3vBR1TtLQMV2mWV6BABeq3O
 GhJLpp3fe6IVDFyGaoJzhnNVPJFs08FUZXG/F17djGax5INTjhx6bQLpdkIkK2sh7GHU
 OWmfmytvFKNcPdnn50+CqBKYZ+L7Wgzkt3MFZgUUsZf2DajwDi1fpgZzN5SYWT2Jq7eW
 XO+xNu7acd62YaT8P2PZchLDQHWgAGKzrPHcomwazRvXHDSCwLQrNUyvC4thrEPoxxEF jA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qhk5h5yae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 12:53:25 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34C3JXxX011390;
        Fri, 12 May 2023 12:53:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qf7nh2bxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 May 2023 12:53:23 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34CCrJNY67043810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 May 2023 12:53:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD2D020040;
        Fri, 12 May 2023 12:53:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB3D20043;
        Fri, 12 May 2023 12:53:19 +0000 (GMT)
Received: from osiris (unknown [9.179.20.70])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 12 May 2023 12:53:18 +0000 (GMT)
Date:   Fri, 12 May 2023 14:53:17 +0200
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
Subject: Re: [PATCH 5/5] s390/uv: Update query for secret-UVCs
Message-ID: <ZF42vescJsAtK9pL@osiris>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
 <20230512093153.206378-6-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512093153.206378-6-seiden@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TStAkSQwbKPhJzdn-b0sM9kBRglX6DMF
X-Proofpoint-ORIG-GUID: TStAkSQwbKPhJzdn-b0sM9kBRglX6DMF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-12_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=925
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305120105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 11:31:53AM +0200, Steffen Eiden wrote:
> Update the query struct such that secret-UVC related
> information can be parsed.
> Add sysfs files for these new values.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/boot/uv.c        |  4 ++++
>  arch/s390/include/asm/uv.h | 11 ++++++++++-
>  arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 54 insertions(+), 1 deletion(-)
...
> +static ssize_t uv_query_supp_add_secret_req_ver(struct kobject *kobj,
> +						struct kobj_attribute *attr, char *page)
> +{
> +	return scnprintf(page, PAGE_SIZE, "%lx\n", uv_info.supp_add_secret_req_ver);
> +}

FWIW, another minor thing: all of these should be sysfs_emit() instead.
