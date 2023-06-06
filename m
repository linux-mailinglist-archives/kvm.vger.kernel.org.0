Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF2724790
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbjFFPX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 11:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbjFFPX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 11:23:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC13E54;
        Tue,  6 Jun 2023 08:23:26 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356FHlBt028747;
        Tue, 6 Jun 2023 15:23:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pa3m1KrmUeV95wXnp/2hiFUe+laFDeJzwuUt+Le47b0=;
 b=WkMCU9bWkww7plhfRaDUDszhr49MyIYP71gEFvzIOzEuYEFpZ5wnH3z6B+DIwBQHC4Rg
 DipNJ/E2UJG1ANFc3LTJcTKjAp5SKUNcBG/f7c/fOxjcxt7yvoxHlD84xBtCbp2MNRys
 alkloN5sOA57Wh+NpsxCWFi25RBcAgiZE0fxwXrWt3KKTglDv4LycfBG6OEQ1sU485IC
 y1NfZQC9Z0ZRiEmQC8WZkWV2VoSkp6P1ckvpmeagwe8RbgsREc5f173zMYeWT0A+e7Wa
 9s7JyU3yHkMTEfnv6OWyQqecBDb55jOb3sTMgZfOXBKkqqka9y3EkUS11u+4VXBdlakr 9A== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r27ap04sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:23:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 356BsGXA021647;
        Tue, 6 Jun 2023 15:23:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qyxku21uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:23:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356FNJgd36569590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 15:23:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 279CF20043;
        Tue,  6 Jun 2023 15:23:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CAA620040;
        Tue,  6 Jun 2023 15:23:18 +0000 (GMT)
Received: from [9.171.79.116] (unknown [9.171.79.116])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 15:23:18 +0000 (GMT)
Message-ID: <3dcdd1de-50d9-1b75-dee6-8f7eee2dbe14@linux.ibm.com>
Date:   Tue, 6 Jun 2023 17:23:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 6/6] s390/uv: Update query for secret-UVCs
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606113736.2934503-1-seiden@linux.ibm.com>
 <20230606113736.2934503-7-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606113736.2934503-7-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b85OGtKE7nsylhmI-NFH4pQouDtk1-KQ
X-Proofpoint-ORIG-GUID: b85OGtKE7nsylhmI-NFH4pQouDtk1-KQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_10,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/23 13:37, Steffen Eiden wrote:
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
> index 0a077c0a2056..323b5cae3cf1 100644
> --- a/arch/s390/boot/uv.c
> +++ b/arch/s390/boot/uv.c
> @@ -47,6 +47,10 @@ void uv_query_info(void)
>   		uv_info.conf_dump_finalize_len = uvcb.conf_dump_finalize_len;
>   		uv_info.supp_att_req_hdr_ver = uvcb.supp_att_req_hdr_ver;
>   		uv_info.supp_att_pflags = uvcb.supp_att_pflags;
> +		uv_info.supp_add_secret_req_ver = uvcb.supp_add_secret_req_ver;
> +		uv_info.supp_add_secret_pcf = uvcb.supp_add_secret_pcf;
> +		uv_info.supp_secret_types = uvcb.supp_secret_types;
> +		uv_info.max_secrets = uvcb.max_num_secrets;
>   	}
>   
>   #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 3203ffbdde6b..d71eb9b887d3 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -123,7 +123,7 @@ struct uv_cb_qui {
>   	u32 reserved70[3];			/* 0x0070 */
>   	u32 max_num_sec_conf;			/* 0x007c */
>   	u64 max_guest_stor_addr;		/* 0x0080 */
> -	u8  reserved88[158 - 136];		/* 0x0088 */
> +	u8  reserved88[0x9e - 0x88];		/* 0x0088 */
>   	u16 max_guest_cpu_id;			/* 0x009e */
>   	u64 uv_feature_indications;		/* 0x00a0 */
>   	u64 reserveda8;				/* 0x00a8 */
> @@ -135,7 +135,12 @@ struct uv_cb_qui {
>   	u64 reservedd8;				/* 0x00d8 */
>   	u64 supp_att_req_hdr_ver;		/* 0x00e0 */
>   	u64 supp_att_pflags;			/* 0x00e8 */
> -	u8 reservedf0[256 - 240];		/* 0x00f0 */
> +	u64 reservedf0;				/* 0x00f0 */
> +	u64 supp_add_secret_req_ver;		/* 0x00f8 */
> +	u64 supp_add_secret_pcf;		/* 0x0100 */
> +	u64 supp_secret_types;			/* 0x0180 */
> +	u16 max_num_secrets;			/* 0x0110 */

Now I know where you got the "num" from
