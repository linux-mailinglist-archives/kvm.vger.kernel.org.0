Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7C97244A6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbjFFNjB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbjFFNi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:38:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629B410F1;
        Tue,  6 Jun 2023 06:38:44 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356DGwCG020986;
        Tue, 6 Jun 2023 13:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=46n7lg100dSUJohI1inMeAPhUrgIQOl7+5M4mbM/d/g=;
 b=JueLAffdXfIvkDRnDdfJUyScCxorl9D48NfAYJ3i8qMMPFQV7k/MXQMvxNpabbzIkAq1
 qjBl0xrPJneh+qpW/Fuj+SbDnwnP5QvhLjwmOdRqlK2KmCK88eOXX1OSFxylZOLuNFs8
 EyYFINXGh1U57nDKDjn868uIRCX5FMO+A4rHdwTjX1gwPCF9Hs08roSOFkF5eADiZ3ZA
 aDWMcB+k5tUSq9dEcMdST9Mkt2h87ovWilpdJwTZ/kh6i32zsV7ECKD67D8PP6R9UEwF
 gPCYPpl99fDiApDA/3ThpxLNDD3a/4Pl6HJp7LKm/9qJ5TXMao3cru46xIIOahc6Ov42 gw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r25hyrmr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 13:38:43 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3569VfT9001840;
        Tue, 6 Jun 2023 13:33:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qyxbu9j97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 13:33:36 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356DXWSj44761666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 13:33:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CA4520040;
        Tue,  6 Jun 2023 13:33:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FB2520043;
        Tue,  6 Jun 2023 13:33:32 +0000 (GMT)
Received: from [9.171.79.116] (unknown [9.171.79.116])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 13:33:32 +0000 (GMT)
Message-ID: <259a64f0-cdd4-ab96-f96e-baf00eb71e46@linux.ibm.com>
Date:   Tue, 6 Jun 2023 15:33:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 1/6] s390/uvdevice: Add info IOCTL
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230606113736.2934503-1-seiden@linux.ibm.com>
 <20230606113736.2934503-2-seiden@linux.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606113736.2934503-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gq6Y4KcQm2DnkbTbe6WzSiDM8Nhtk4Yx
X-Proofpoint-GUID: Gq6Y4KcQm2DnkbTbe6WzSiDM8Nhtk4Yx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_08,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060115
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
> Add an IOCTL that allows userspace to find out which IOCTLs the uvdevice
> supports without trial and error.
> 
> Explicitly expose the IOCTL nr for the request types.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arch/s390/include/uapi/asm/uvdevice.h | 42 ++++++++++++++-
>   drivers/s390/char/uvdevice.c          | 77 ++++++++++++++++++++++++---
>   2 files changed, 111 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
> index 10a5ac918e02..9d9b684836c2 100644
> --- a/arch/s390/include/uapi/asm/uvdevice.h
> +++ b/arch/s390/include/uapi/asm/uvdevice.h
> @@ -32,6 +32,33 @@ struct uvio_attest {
>   	__u16 reserved136;				/* 0x0136 */
>   };
>   
> +/**
> + * uvio_uvdev_info - Information of supported functions
> + * @supp_uvio_cmds - supported IOCTLs by this device
> + * @supp_uv_cmds - supported UVCs corresponding to the IOCTL
> + *
> + * UVIO request to get information about supported request types by this
> + * uvdevice and the Ultravisor.  Everything is output. Bits are in LSB0
> + * ordering.  If the bit is set in both, @supp_uvio_cmds and @supp_uv_cmds, the
> + * uvdevice and the Ultravisor support that call.
> + *
> + * Note that bit 0 (UVIO_IOCTL_UVDEV_INFO_NR) is always zero for `supp_uv_cmds`
> + * as there is no corresponding UV-call.
> + */
> +struct uvio_uvdev_info {
> +	/*
> +	 * If bit `n` is set, this device supports the IOCTL with nr `n`.
> +	 */
> +	__u64 supp_uvio_cmds;
> +	/*
> +	 * If bit `n` is set, the Ultravisor(UV) supports the UV-call
> +	 * corresponding to the IOCTL with nr `n` in the calling contextx (host
> +	 * or guest).  The value is only valid if the corresponding bit in
> +	 * @supp_uvio_cmds is set as well.
> +	 */
> +	__u64 supp_uv_cmds;
> +};
> +
>   /*
>    * The following max values define an upper length for the IOCTL in/out buffers.
>    * However, they do not represent the maximum the Ultravisor allows which is
> @@ -46,6 +73,19 @@ struct uvio_attest {
>   #define UVIO_DEVICE_NAME "uv"
>   #define UVIO_TYPE_UVC 'u'
>   
> -#define UVIO_IOCTL_ATT _IOWR(UVIO_TYPE_UVC, 0x01, struct uvio_ioctl_cb)
> +enum UVIO_IOCTL_NR {
> +	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
> +	UVIO_IOCTL_ATT_NR,
> +	/* must be the last entry */
> +	UVIO_IOCTL_NUM_IOCTLS
> +};
> +
> +#define UVIO_IOCTL(nr)		_IOWR(UVIO_TYPE_UVC, nr, struct uvio_ioctl_cb)
> +#define UVIO_IOCTL_UVDEV_INFO	UVIO_IOCTL(UVIO_IOCTL_UVDEV_INFO_NR)
> +#define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
> +
> +#define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
> +#define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
> +#define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
>   
>   #endif /* __S390_ASM_UVDEVICE_H */
> diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
> index 1d40457c7b10..4efeebcaf382 100644
> --- a/drivers/s390/char/uvdevice.c
> +++ b/drivers/s390/char/uvdevice.c
> @@ -32,6 +32,52 @@
>   #include <asm/uvdevice.h>
>   #include <asm/uv.h>
>   
> +#define BIT_UVIO_INTERNAL U32_MAX
> +/* Mapping from IOCTL-nr to UVC-bit */
> +static const u32 ioctl_nr_to_uvc_bit[] __initconst = {
> +	[UVIO_IOCTL_UVDEV_INFO_NR] = BIT_UVIO_INTERNAL,
> +	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
> +};
> +
> +static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
> +
> +static struct uvio_uvdev_info uvdev_info = {
> +	.supp_uvio_cmds = GENMASK_ULL(UVIO_IOCTL_NUM_IOCTLS - 1, 0),
> +};
> +
> +static void __init set_supp_uv_cmds(unsigned long *supp_uv_cmds)
> +{
> +	int i;
> +
> +	for (i = 0; i < UVIO_IOCTL_NUM_IOCTLS; i++) {
> +		if (ioctl_nr_to_uvc_bit[i] == BIT_UVIO_INTERNAL)
> +			continue;
> +		if (!test_bit_inv(ioctl_nr_to_uvc_bit[i], uv_info.inst_calls_list))
> +			continue;
> +		__set_bit(i, supp_uv_cmds);
> +	}
> +}
> +
> +/**
> + * uvio_uvdev_info() - get information about the uvdevice
> + *
> + * @uv_ioctl: ioctl control block
> + *
> + * Lists all IOCTLs that are supported by this uvdevice
> + */
> +static int uvio_uvdev_info(struct uvio_ioctl_cb *uv_ioctl)
> +{
> +	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
> +
> +	if (uv_ioctl->argument_len < sizeof(uvdev_info))
> +		return -EINVAL;
> +	if (copy_to_user(user_buf_arg, &uvdev_info, sizeof(uvdev_info)))
> +		return -EFAULT;
> +
> +	uv_ioctl->uv_rc = UVC_RC_EXECUTED;
> +	return  0;
> +}
> +
>   static int uvio_build_uvcb_attest(struct uv_cb_attest *uvcb_attest, u8 *arcb,
>   				  u8 *meas, u8 *add_data, struct uvio_attest *uvio_attest)
>   {
> @@ -185,8 +231,19 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
>   	return ret;
>   }
>   
> -static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp)
> +static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
> +				     unsigned long cmd)
>   {
> +	u8 nr = _IOC_NR(cmd);
> +
> +	if (_IOC_DIR(cmd) != (_IOC_READ | _IOC_WRITE))
> +		return -ENOIOCTLCMD;
> +	if (_IOC_TYPE(cmd) != UVIO_TYPE_UVC)
> +		return -ENOIOCTLCMD;
> +	if (nr >= UVIO_IOCTL_NUM_IOCTLS)
> +		return -ENOIOCTLCMD;
> +	if (_IOC_SIZE(cmd) != sizeof(*ioctl))
> +		return -ENOIOCTLCMD;
>   	if (copy_from_user(ioctl, argp, sizeof(*ioctl)))
>   		return -EFAULT;
>   	if (ioctl->flags != 0)
> @@ -194,7 +251,7 @@ static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *a
>   	if (memchr_inv(ioctl->reserved14, 0, sizeof(ioctl->reserved14)))
>   		return -EINVAL;
>   
> -	return 0;
> +	return nr;
>   }
>   
>   /*
> @@ -205,12 +262,17 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	void __user *argp = (void __user *)arg;
>   	struct uvio_ioctl_cb uv_ioctl = { };
>   	long ret;
> +	int nr;
> +
> +	nr = uvio_copy_and_check_ioctl(&uv_ioctl, argp, cmd);
> +	if (nr < 0)
> +		return nr;
>   
> -	switch (cmd) {
> -	case UVIO_IOCTL_ATT:
> -		ret = uvio_copy_and_check_ioctl(&uv_ioctl, argp);
> -		if (ret)
> -			return ret;
> +	switch (nr) {
> +	case UVIO_IOCTL_UVDEV_INFO_NR:
> +		ret = uvio_uvdev_info(&uv_ioctl);
> +		break;
> +	case UVIO_IOCTL_ATT_NR:
>   		ret = uvio_attestation(&uv_ioctl);
>   		break;
>   	default:
> @@ -245,6 +307,7 @@ static void __exit uvio_dev_exit(void)
>   
>   static int __init uvio_dev_init(void)
>   {
> +	set_supp_uv_cmds((unsigned long *)&uvdev_info.supp_uv_cmds);
>   	return misc_register(&uvio_dev_miscdev);
>   }
>   

