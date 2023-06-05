Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2BA722739
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjFENUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjFENT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:19:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155DDA6;
        Mon,  5 Jun 2023 06:19:58 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355CqTHH010626;
        Mon, 5 Jun 2023 13:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UX/seApaMwCV5AdOHDETDgg1s3TtWbsyNOhrnZ/AQk8=;
 b=BEf7mpcH8ma4SIbK+to96xRYjKpsnmHKesC3gGnntuCcq/otvrKimKVOtALvVgeekBbs
 wglO9c2A7yq242A+iLmpK/nQG4CFDG817EPIbTXp2nDXjcUTBhMVOx0cizWmUfBFDUTP
 LGA/Gl91oDI3DmYUZ1z18MPMm+YN88X0OlVSr2U+MXQ1kLDRMwPDwkclAi7audvxd1I7
 +8/dTCZ+SwYQqD1GbnZlBmeTg38i5qxBNYugbZ6Q/tvtKH0MtGlHbaV14hRKXTMIjWqV
 TDdho6xU9GXrnWnYy9ALieAQRpizEKAcH3JUuwZXwswx7KIz2a1vMKz7KJPBj+M/Gr/b cw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1g3jrnc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:19:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3554gbGB001935;
        Mon, 5 Jun 2023 13:19:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qyxg2hc3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:19:55 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355DJpZZ36438382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 13:19:51 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 737462004B;
        Mon,  5 Jun 2023 13:19:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E75B720040;
        Mon,  5 Jun 2023 13:19:50 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 13:19:50 +0000 (GMT)
Message-ID: <76f45ab9-deed-a24c-9949-c6786daa2c10@linux.ibm.com>
Date:   Mon, 5 Jun 2023 15:19:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
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
 <20230519093708.810957-3-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 2/6] s390/uvdevice: Add 'Add Secret' UVC
In-Reply-To: <20230519093708.810957-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Sdom5LAgZUtvmQFLJDZ2q8WnpvYBpeg7
X-Proofpoint-GUID: Sdom5LAgZUtvmQFLJDZ2q8WnpvYBpeg7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 phishscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306050114
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
> Userspace can call the Add Secret Ultravisor Call
> using IOCTLs on the uvdevice.
> During the handling of the new IOCTL nr the uvdevice will do some sanity
> checks first. Then, copy the request data to kernel space, perform the
> Ultravisor command, and copy the return codes to userspace.
> If the Add Secret UV facility is not present,
> UV will return invalid command rc. This won't be fenced in the driver
> and does not result in a negative return value. This is also true for
> any other possible error code the UV can return.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h            | 14 +++++++
>   arch/s390/include/uapi/asm/uvdevice.h |  4 ++
>   drivers/s390/char/uvdevice.c          | 58 +++++++++++++++++++++++++++
>   3 files changed, 76 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 28a9ad57b6f1..a7dff64e1e24 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -58,6 +58,7 @@
>   #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>   #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
>   #define UVC_CMD_RETR_ATTEST		0x1020
> +#define UVC_CMD_ADD_SECRET		0x1031
>   
>   /* Bits in installed uv calls */
>   enum uv_cmds_inst {
> @@ -88,6 +89,7 @@ enum uv_cmds_inst {
>   	BIT_UVC_CMD_DUMP_CPU = 26,
>   	BIT_UVC_CMD_DUMP_COMPLETE = 27,
>   	BIT_UVC_CMD_RETR_ATTEST = 28,
> +	BIT_UVC_CMD_ADD_SECRET = 29,
>   };
>   
>   enum uv_feat_ind {
> @@ -292,6 +294,18 @@ struct uv_cb_dump_complete {
>   	u64 reserved30[5];
>   } __packed __aligned(8);
>   
> +/*
> + * A common call for pv guests that contains a single address

control block struct

> + * Examples:
> + * Add Secret
> + */
> +struct uv_cb_guest_addr {
> +	struct uv_cb_header header;
> +	u64 reserved08[3];
> +	u64 addr;
> +	u64 reserved28[4];
> +} __packed __aligned(8);
> +
[...]

> +static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
> +{
> +	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
> +	struct uv_cb_guest_addr uvcb = {
> +		.header.len = sizeof(uvcb),
> +		.header.cmd = UVC_CMD_ADD_SECRET,
> +	};
> +	void *asrcb = NULL;
> +	int ret;
> +
> +	if (uv_ioctl->argument_len > UVIO_ADD_SECRET_MAX_LEN)
> +		return -EINVAL;
> +	if (uv_ioctl->argument_len == 0)
> +		return -EINVAL;
> +
> +	asrcb = kvzalloc(uv_ioctl->argument_len, GFP_KERNEL);
> +	if (!asrcb)
> +		return -EINVAL;

-ENOMEM

> +
> +	ret = -EFAULT;
> +	if (copy_from_user(asrcb, user_buf_arg, uv_ioctl->argument_len))
> +		goto out;
> +
> +	ret = 0;
> +	uvcb.addr = (u64)asrcb;
> +	uv_call_sched(0, (u64)&uvcb);
> +	uv_ioctl->uv_rc = uvcb.header.rc;
> +	uv_ioctl->uv_rrc = uvcb.header.rrc;
> +
> +out:
> +	kvfree(asrcb);
> +	return ret;
> +}
> +
>   static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
>   				     unsigned long cmd)
>   {
> @@ -275,6 +330,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	case UVIO_IOCTL_ATT_NR:
>   		ret = uvio_attestation(&uv_ioctl);
>   		break;
> +	case UVIO_IOCTL_ADD_SECRET_NR:
> +		ret = uvio_add_secret(&uv_ioctl);
> +		break;
>   	default:
>   		ret = -ENOIOCTLCMD;
>   		break;

