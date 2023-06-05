Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151AB722766
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjFENaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjFENaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:30:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BFDCD;
        Mon,  5 Jun 2023 06:30:02 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355DKxjd015993;
        Mon, 5 Jun 2023 13:30:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h08ZUZge0V2LjuVc7Yhcn6I/LBABMkL/LoHYysfR98c=;
 b=QJoKRDXiDTIaTEUGHszjVWr32R779Pj61+gUD7gq2bx8wVgF/BF1Va1Suon0pS0Xqc/r
 kLs/fmtSWEd7kZ3lPvCdnWJ2qC3JCUaXtBN7JYex7/9F+7cgszyKHIWxLuNIZGXsYBMh
 DAqAzybPgJqHblLLXIwKIw1dstrbi07cDnIbY0egqP6YrtRL72Le2CM9426pr4YFmb/E
 621rehEu9vAZkoNN9fLth/2xBjWYgB9/um5a/PdYxKwbcpKEPQdpscY/223/DdtVWtFL
 ZY0ttfNvhcbUteUNq5SG6lZXCFnAmu2cksNIaPtO8rXBz+2l4Mnle+i46m7qUK5Lvxm4 NA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1ggx075h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:30:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 354GnjHr023638;
        Mon, 5 Jun 2023 13:29:58 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qyxg2hc8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 13:29:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355DTtCg51839330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 13:29:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 363D52004D;
        Mon,  5 Jun 2023 13:29:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A69DD20043;
        Mon,  5 Jun 2023 13:29:54 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 13:29:54 +0000 (GMT)
Message-ID: <c19ee46b-4f89-172e-95d4-093145cff34d@linux.ibm.com>
Date:   Mon, 5 Jun 2023 15:29:54 +0200
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
 <20230519093708.810957-4-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 3/6] s390/uvdevice: Add 'List Secrets' UVC
In-Reply-To: <20230519093708.810957-4-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pAs3NGx-YsPr4v4MsFEln9R8pzIRRVpG
X-Proofpoint-ORIG-GUID: pAs3NGx-YsPr4v4MsFEln9R8pzIRRVpG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 mlxlogscore=982
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050114
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
>[...]
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

int ret = 0;

> +
> +	if (uv_ioctl->argument_len != UVIO_LIST_SECRETS_LEN)
> +		return -EINVAL;

I'd be less uneasy if you 
s/uv_ioctl->argument_len/UVIO_LIST_SECRETS_LEN/ below. Yes, you check 
the length above but it still feels weird to use a variable when we have 
a perfectly fine constant just waiting to be used.

> +
> +	secrets = kvzalloc(uv_ioctl->argument_len, GFP_KERNEL);
> +	if (!secrets)
> +		return -ENOMEM;
> +
> +	uvcb.addr = (u64)secrets;
> +	uv_call_sched(0, (u64)&uvcb);
> +	uv_ioctl->uv_rc = uvcb.header.rc;
> +	uv_ioctl->uv_rrc = uvcb.header.rrc;
> +
> +	if (copy_to_user(user_buf_arg, secrets, uv_ioctl->argument_len))
> +		ret = -EFAULT;

and remove the else

> +	else
> +		ret = 0;
> +
> +	kvfree(secrets);
> +	return ret;
> +}
> +
>   static int uvio_copy_and_check_ioctl(struct uvio_ioctl_cb *ioctl, void __user *argp,
>   				     unsigned long cmd)
>   {
> @@ -333,6 +385,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	case UVIO_IOCTL_ADD_SECRET_NR:
>   		ret = uvio_add_secret(&uv_ioctl);
>   		break;
> +	case UVIO_IOCTL_LIST_SECRETS_NR:
> +		ret = uvio_list_secrets(&uv_ioctl);
> +		break;
>   	default:
>   		ret = -ENOIOCTLCMD;
>   		break;

