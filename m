Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C94D67F4
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350882AbiCKRqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350871AbiCKRqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:46:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1497134DC8;
        Fri, 11 Mar 2022 09:45:31 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BHff44029748;
        Fri, 11 Mar 2022 17:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hf7SnOuqN2meVGbfQgtUckloLdzEFLJ5qZvzOfhhc8k=;
 b=r9O0LomPvGjtPDflOHD+Glm0svnaC1DSaEwroKsndKazu7gU5dmbZPjWS/cWni4z5AyS
 29lbdIY2lrnSgUliWRtwuM20Oql0g76IlFTm3fyukIrmi8G4gL0H8bmLh8V8PaLE4oYW
 1KdHUePyw3PmaJiCM1bqhj0lW6ne0rV0+KbdSIm/ncld3ZXxvJjVi+mBok7oA2rRjiNk
 T7iELaycCr1W68qdDVVOK84sbo7pgBbsmXFIvSphn/63Que6c172VC6pi5k8i3Ik/VqT
 bzxgvpqVTAKnrsPadGRFRoA+lKsR/BiLrU2q9K14RtxeYDbAathQSMhyc4mZvqhDzn4j Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eqm1bafgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:30 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BHhZ3O004585;
        Fri, 11 Mar 2022 17:45:30 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eqm1bafgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHhpPv002516;
        Fri, 11 Mar 2022 17:45:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3eqqf0a5sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:45:28 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHjPOV19071332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:45:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F7C111C04A;
        Fri, 11 Mar 2022 17:45:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CE7E11C04C;
        Fri, 11 Mar 2022 17:45:25 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Mar 2022 17:45:25 +0000 (GMT)
Date:   Fri, 11 Mar 2022 18:42:28 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v2 4/9] KVM: s390: pv: Add dump support definitions
Message-ID: <20220311184228.47b3d85b@p-imbrenda>
In-Reply-To: <20220310103112.2156-5-frankja@linux.ibm.com>
References: <20220310103112.2156-1-frankja@linux.ibm.com>
        <20220310103112.2156-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IlyG6XCYd31Byr_MEvT9aDYP5DIqcJCv
X-Proofpoint-GUID: CPAMQchpdAnRU6S3JP7-M5KIH7Cxu_Xg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 priorityscore=1501
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Mar 2022 10:31:07 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Lets add the constants and structure definitions needed for the dump
> support.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/uv.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index a774267e9a12..a69f672daa1f 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -50,6 +50,10 @@
>  #define UVC_CMD_SET_UNSHARE_ALL		0x0340
>  #define UVC_CMD_PIN_PAGE_SHARED		0x0341
>  #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
> +#define UVC_CMD_DUMP_INIT		0x0400
> +#define UVC_CMD_DUMP_CONF_STOR_STATE	0x0401
> +#define UVC_CMD_DUMP_CPU		0x0402
> +#define UVC_CMD_DUMP_COMPLETE		0x0403
>  #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>  #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
>  
> @@ -76,6 +80,10 @@ enum uv_cmds_inst {
>  	BIT_UVC_CMD_UNSHARE_ALL = 20,
>  	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>  	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> +	BIT_UVC_CMD_DUMP_INIT = 24,
> +	BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE = 25,
> +	BIT_UVC_CMD_DUMP_CPU = 26,
> +	BIT_UVC_CMD_DUMP_COMPLETE = 27,
>  };
>  
>  enum uv_feat_ind {
> @@ -225,6 +233,31 @@ struct uv_cb_share {
>  	u64 reserved28;
>  } __packed __aligned(8);
>  
> +struct uv_cb_dump_cpu {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 cpu_handle;
> +	u64 dump_area_origin;
> +	u64 reserved28[5];
> +} __packed __aligned(8);
> +
> +struct uv_cb_dump_stor_state {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 config_handle;
> +	u64 dump_area_origin;
> +	u64 gaddr;
> +	u64 reserved28[4];
> +} __packed __aligned(8);
> +
> +struct uv_cb_dump_complete {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 config_handle;
> +	u64 dump_area_origin;
> +	u64 reserved30[5];
> +} __packed __aligned(8);
> +
>  static inline int __uv_call(unsigned long r1, unsigned long r2)
>  {
>  	int cc;

