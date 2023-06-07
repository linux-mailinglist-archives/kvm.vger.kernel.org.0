Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF08725F87
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 14:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbjFGMdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 08:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240747AbjFGMc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 08:32:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DDA173B;
        Wed,  7 Jun 2023 05:32:57 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357CI3sH018559;
        Wed, 7 Jun 2023 12:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hDT+EsnEZTT85GETLFxOhsl5jbVJly+mb2YHySAH0Ak=;
 b=j61it+uoliI9s0Uh02AuX9v5A4ILaHb8eZ1MFiTOQ8IWCKl8zO1hN00i8Ry5rFqisfQb
 /pW0vqLb6t3dkU+ObUbD9h1T6veMI0gfPmT1ZyiEuXZQr79IvFxjWmTRXZ3uDMqwpldI
 F3PiH7YK8zysOKoTCBN6rozByJtL2osWVKiI2rdrj19l70ap7zIv5NSbqC/l10RsZO0s
 ejleTTNF/tc5KkXsswsg+cjxT0x82r+qG2uXI5pwwfdpuvfeHZPUHSsAibvfGLRsUJeN
 qzGyEKbtkE4y9fC4YN0XaaI0m4gHED5f9dQD88ZJdobFtEC4uF5jgOK3f0/BQNBGcRx1 fA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2ssd8ccs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:32:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3573065u014126;
        Wed, 7 Jun 2023 12:32:54 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3r2a768f37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 12:32:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357CWpNG60162372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 12:32:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 232F72004D;
        Wed,  7 Jun 2023 12:32:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E4BA2004B;
        Wed,  7 Jun 2023 12:32:50 +0000 (GMT)
Received: from [9.179.8.138] (unknown [9.179.8.138])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jun 2023 12:32:50 +0000 (GMT)
Message-ID: <e2b8d63e-06ff-bbd7-b76d-e358a9a8533e@linux.ibm.com>
Date:   Wed, 7 Jun 2023 14:32:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 6/6] s390/uv: Update query for secret-UVCs
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606180817.3019077-1-seiden@linux.ibm.com>
 <20230606180817.3019077-7-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606180817.3019077-7-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0m5l70EYFKB8OCRm5pC6C5bXzQmjp_Ki
X-Proofpoint-GUID: 0m5l70EYFKB8OCRm5pC6C5bXzQmjp_Ki
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/23 20:08, Steffen Eiden wrote:
> Update the query struct such that secret-UVC related
> information can be parsed.
> Add sysfs files for these new values.
> 
> 'supp_add_secret_req_ver' notes the supported versions for the
> Add Secret UVC. Bit 0 indicates that version 0x100 is supported,
> bit 1 indicates 0x200, and so on.
> 
> 'supp_add_secret_pcf' notes the supported plaintext flags for
> the Add Secret UVC.
> 
> 'supp_secret_types' notes the supported types of secrets.
> Bit 0 indicates secret type 1, bit 1 indicates type 2, and so on.
> 
> 'max_secrets' notes the maximum amount of secrets the secret store can
> store per pv guest.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   arch/s390/boot/uv.c        |  4 ++++
>   arch/s390/include/asm/uv.h | 13 +++++++++++--
>   arch/s390/kernel/uv.c      | 40 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
> index 0a077c0a2056..cdffc395f1cd 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -47,6 +47,10 @@ void uv_query_info(void)
>   		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
>   		uv_info.supp_att_req_hdr_ver = uvcb.supp_att_req_hdr_ver;
>   		uv_info.supp_att_pflags = uvcb.supp_att_pflags;
> +		uv_info.supp_add_secret_req_ver = uvcb.supp_add_secret_req_ver;
> +		uv_info.supp_add_secret_pcf = uvcb.supp_add_secret_pcf;
> +		uv_info.supp_secret_types = uvcb.supp_secret_types;
> +		uv_info.max_secrets = uvcb.max_secrets

Apart from this:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

But we can add the ";" when picking.
