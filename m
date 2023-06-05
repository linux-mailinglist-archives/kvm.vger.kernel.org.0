Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6722A72277D
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbjFENe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjFENe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:34:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE796D2;
        Mon,  5 Jun 2023 06:34:24 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355Cl4o4023036;
        Mon, 5 Jun 2023 13:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GdT6zfZTiSgNaK6kYoIX3NprH11FZeKSsejoddhPyak=;
 b=M7Luh6WfcGqCbQ/lNol2QhBCCNw5fNm4VZO6I74ytnCI/1vLJKkthfZNfCnP25X38qto
 qB0PXk8mLnD4HImd2g09UOgxboesR2HQb8g1Huw1OzhLZDVx9J+j7xM3shTuRRQYwdE4
 6czx35UHPyXaLSpR5Ad7a9Qs1cJge9jmKtNuqvgPqiIs1Sh4HAap+6yVlNS2rcWQbqrR
 V8+D143bHEUY+SmohygYh06OApVgO78Q+ZN1GwLj1bnUo3RUSO9MepfgnzeK0oIXMDAq
 hM2uqQ7NtCPm4Pbk4QmgSjbU88uXIfr2jped7czOngE4A9MjOPGHQZUJWVGw9z1TOzUu jg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1g0v1cbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:34:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 355AuLnW021629;
        Mon, 5 Jun 2023 13:34:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qyxdfh3fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:34:21 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355DYI8Z22544964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 13:34:18 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 705A920040;
        Mon,  5 Jun 2023 13:34:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E32F220043;
        Mon,  5 Jun 2023 13:34:17 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 13:34:17 +0000 (GMT)
Message-ID: <dc7e7448-eed0-591c-0c64-eba84b5a8e92@linux.ibm.com>
Date:   Mon, 5 Jun 2023 15:34:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 4/6] s390/uvdevice: Add 'Lock Secret Store' UVC
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230519093708.810957-1-seiden@linux.ibm.com>
 <20230519093708.810957-5-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230519093708.810957-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HYtSIl94UfsHtWJgp4cMRw_cjnYWkJ_A
X-Proofpoint-GUID: HYtSIl94UfsHtWJgp4cMRw_cjnYWkJ_A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_28,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050118
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/23 11:37, Steffen Eiden wrote:
> Userspace can call the Lock Secret Store Ultravisor Call
> using IOCTLs on the uvdevice.
> During the handling of the new IOCTL nr the uvdevice will do some sanity
> checks first. Then, perform the Ultravisor command, and copy the
> return codes to userspace.
> If the Lock Secrets UV facility is not present, UV will return
> invalid command rc. This won't be fenced in the driver and does not
> result in a negative return value. This is also true for any other
> possible error code the UV can return.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

While the add and list secret calls work on data structures that are 
opaque to the kernel I'd describe the effects of this call here. Namely 
that any further add secret calls will fail with return code 0x102 once 
the store has been locked.

> ---
>   arch/s390/include/asm/uv.h            |  2 ++
>   arch/s390/include/uapi/asm/uvdevice.h |  3 +++
>   drivers/s390/char/uvdevice.c          | 39 +++++++++++++++++++++++++++
>   3 files changed, 44 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 1e4f0f6d4923..6180ac8909d5 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -60,6 +60,7 @@
[...]
>   
> +/** uvio_lock_secrets() - perform a Lock Secret Store UVC
> + *
> + * @uv_ioctl: ioctl control block
> + *
> + * uvio_lock_secrets() performs the Lock Secret Store Ultravisor Call.
> + * It performs the UV-call and copies the return codes to the
> + * ioctl control block.
> + *
> + * The argument address and size must be 0.
> + *
> + * If the List Secrets UV facility is not present,
> + * UV will return invalid command rc. This won't be fenced in the driver
> + * and does not result in a negative return value.

This has weird indenting. The others often have it too but this one is 
especially strange. Did you do that yourself or is that from your editor?

> + *
> + * Context: might sleep
> + *
> + * Return: 0 on success or a negative error code on error.
> + */
> +static int uvio_lock_secrets(struct uvio_ioctl_cb *ioctl)
> +{
> +	struct uv_cb_nodata uvcb = {
> +		.header.len = sizeof(uvcb),
> +		.header.cmd = UVC_CMD_LOCK_SECRETS,
> +	};
> +
> +	if (ioctl->argument_addr || ioctl->argument_len)
> +		return -EINVAL;
> +
> +	uv_call(0, (u64)&uvcb);
> +	ioctl->uv_rc = uvcb.header.rc;
> +	ioctl->uv_rrc = uvcb.header.rrc;
> +
> +	return 0;
> +}
> +
>   static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
>   				     unsigned long cmd)
>   {
> @@ -388,6 +424,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	case UVIO_IOCTL_LIST_SECRETS_NR:
>   		ret = uvio_list_secrets(&uv_ioctl);
>   		break;
> +	case UVIO_IOCTL_LOCK_SECRETS_NR:
> +		ret = uvio_lock_secrets(&uv_ioctl);
> +		break;
>   	default:
>   		ret = -ENOIOCTLCMD;
>   		break;

