Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1AA706E0D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjEQQ0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 12:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjEQQ0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 12:26:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8D9FB;
        Wed, 17 May 2023 09:25:59 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HG7taU028415;
        Wed, 17 May 2023 16:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=dtAtxvqSEj1oMGBcMNSBCA1ooa+jT0qh9fn6NZ1A9Qg=;
 b=dzNqe5kMPz8R8c3CWoFQJ0ctlj5qposLwoJSnyU+nMa3nzNK9j9L0ssiviklrzkOF1dE
 RPOi4qAq6wbLCf/baMiLacJpKLLLOwOaNzLZq6hLeuD8HaZ4XdGHbfwL0crmnIq3vqUE
 8b09I7MJ9aQ6FQ5EDcg6yYlffQSNdslh3d19hzaAyhBj2cc9YQdhsL2Y3H/z2GdNWglg
 ML/3lylyKIe/NfLml7CFFqh8nQCGynYloTj/V0BlxlZ7x9/dcF6KsHC07JdvVSe8gHXk
 4W7GL5YFIKmQXwDNvy7DZd1qBl9dXDh7qBbB409zayTPuMEGrortkVqV6guDun6zdR9m fA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qn14yk3c0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 16:25:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34HCc5xN020462;
        Wed, 17 May 2023 16:03:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qj2651vts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 16:03:41 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HG3bjO7144138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 16:03:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93C320049;
        Wed, 17 May 2023 16:03:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 660E620040;
        Wed, 17 May 2023 16:03:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 16:03:37 +0000 (GMT)
Date:   Wed, 17 May 2023 18:03:35 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH 3/5] s390/uvdevice: Add 'List Secrets' UVC
Message-ID: <20230517180335.05599c6a@p-imbrenda>
In-Reply-To: <20230512093153.206378-4-seiden@linux.ibm.com>
References: <20230512093153.206378-1-seiden@linux.ibm.com>
        <20230512093153.206378-4-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tKt5boysgt5Tb_R2hj2gzCfJzTC0ec-k
X-Proofpoint-ORIG-GUID: tKt5boysgt5Tb_R2hj2gzCfJzTC0ec-k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305170130
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 May 2023 11:31:51 +0200
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Userspace can call the List Secrets Ultravisor Call
> using IOCTLs on the uvdevice.
> During the handling of the new IOCTL nr the uvdevice will do some sanity
> checks first. Then, perform the Ultravisor command, and copy the answer
> to userspace.
> If the List Secrets UV facility is not present, UV will return
> invalid command rc. This won't be fenced in the driver and does not
> result in a negative return value. This is also true for any other
> possible error code the UV can return.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---

[...]

> diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
> index ba3e60dc4ba8..5fcd719047ab 100644
> --- a/drivers/s390/char/uvdevice.c
> +++ b/drivers/s390/char/uvdevice.c
> @@ -38,6 +38,7 @@ static const u64 ioctl_nr_to_uvc_bit[] __initconst = {
>  	[UVIO_IOCTL_UVDEV_INFO_NR] = -1UL,
>  	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
>  	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
> +	[UVIO_IOCTL_LIST_SECRETS_NR] = BIT_UVC_CMD_LIST_SECRETS,
>  };
>  
>  static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
> @@ -286,6 +287,57 @@ static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
>  	return ret;
>  }
>  
> +/** uvio_list_secrets() - perform a List Secret UVC
> + *
> + * @uv_ioctl: ioctl control block
> + *
> + * uvio_list_secrets() performs the List Secret Ultravisor Call.
> + * It verifies that the given userspace argument address is valid and its size
> + * is sane. Every other check is made by the Ultravisor (UV) and won't result
> + * in a negative return value. It builds the request, performs the UV-call,
> + * and copies the result to userspace.
> + *
> + * The argument specifies the location for the result of the UV-Call.
> + *
> + * If the List Secrets UV facility is not present,
> + * UV will return invalid command rc. This won't be fenced in the driver
> + * and does not result in a negative return value.
> + *
> + * Context: might sleep
> + *
> + * Return: 0 on success or a negative error code on error.
> + */
> +static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
> +{
> +	void __user *user_buf_arg = (void __user *)uv_ioctl->argument_addr;
> +	struct uv_cb_guest_addr uvcb = {
> +		.header.len = sizeof(uvcb),
> +		.header.cmd = UVC_CMD_LIST_SECRETS,
> +	};
> +	void *secrets = NULL;
> +	int ret;
> +
> +	if (uv_ioctl->argument_len != UVIO_LIST_SECRETS_LEN)
> +		return -EINVAL;
> +
> +	secrets = kvzalloc(uv_ioctl->argument_len, GFP_KERNEL);
> +	if (!secrets)
> +		return -ENOMEM;
> +
> +	uvcb.addr = (u64)secrets;

I think you need virt_to_phys()

> +	uv_call_sched(0, (u64)&uvcb);
> +	uv_ioctl->uv_rc = uvcb.header.rc;
> +	uv_ioctl->uv_rrc = uvcb.header.rrc;
> +
> +	if (copy_to_user(user_buf_arg, secrets, uv_ioctl->argument_len))
> +		ret = -EFAULT;
> +	else
> +		ret = 0;
> +
> +	kvfree(secrets);
> +	return ret;
> +}
> +
>  static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
>  				     unsigned long cmd)
>  {
> @@ -333,6 +385,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case UVIO_IOCTL_ADD_SECRET_NR:
>  		ret = uvio_add_secret(&uv_ioctl);
>  		break;
> +	case UVIO_IOCTL_LIST_SECRETS_NR:
> +		ret = uvio_list_secrets(&uv_ioctl);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;

