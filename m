Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04256724795
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbjFFPZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 11:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbjFFPY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 11:24:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DAC1BD;
        Tue,  6 Jun 2023 08:24:56 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356FJUAP014186;
        Tue, 6 Jun 2023 15:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DU6vu7BGB9Pd7PgUM7O8HCjTO02oYXZf9At20IhpIQs=;
 b=R1229+ClY8Wi7DZALJtOvd9cmf0R9+An+WECGHflg3uuSv31DF9KHZcYpVvEzsfibZ7P
 8wWBY7bvnnbfLo1nhvZY1sMPUkdMlRJEaKCmigPteU4q+JRWbC8SzH1VJ11SLX/5fMWN
 0fjJFFgyMJgwmg+FnexNpuhYT/siGzHVpu6GxMBYNfa/ODt+yghPDTEaHjJLIqDbtLXy
 HwDI+KBoHzG2H6tURl/IK8YfRfLR1LUWgdfnrlkmKApABfkN8WLjqXW5uSaGkJ52QQZx
 c/1NpyLXCmWr/2XT15DPEoYfFiBf566fj6OoFbG4KIigPuMhxWxxZ5OX8NNmR/eSauKC Qg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r27bfr3g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:24:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3562k5VL001223;
        Tue, 6 Jun 2023 15:24:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qyxmyj1ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 15:24:53 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356FOnm919399240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 15:24:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 936ED20043;
        Tue,  6 Jun 2023 15:24:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3CC320040;
        Tue,  6 Jun 2023 15:24:48 +0000 (GMT)
Received: from [9.171.79.116] (unknown [9.171.79.116])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 15:24:48 +0000 (GMT)
Message-ID: <2e0a8215-ba68-f80c-1610-fb1e5489f6fd@linux.ibm.com>
Date:   Tue, 6 Jun 2023 17:24:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 4/6] s390/uvdevice: Add 'Lock Secret Store' UVC
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
 <20230606113736.2934503-5-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20230606113736.2934503-5-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 77z7Siz4mRM9fw16CiqKCoRRRDhuJiMi
X-Proofpoint-GUID: 77z7Siz4mRM9fw16CiqKCoRRRDhuJiMi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_10,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

[...]

> +/** uvio_lock_secrets() - perform a Lock Secret Store UVC
> + * @uv_ioctl: ioctl control block
> + *
> + * uvio_lock_secrets() performs the Lock Secret Store Ultravisor Call. It
> + * performs the UV-call and copies the return codes to the ioctl control block.
> + * After this call was dispatched successfully every following Add Secret UVC
> + * and Lock Secrets UVC will fail with return code 0x102.
> + *
> + * The argument address and size must be 0.
> + *
> + * If the List Secrets UV facility is not present, UV will return invalid
> + * command rc. This won't be fenced in the driver and does not result in a
> + * negative return value.

This is not "list secrets" though.

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
> @@ -384,6 +420,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	case UVIO_IOCTL_LIST_SECRETS_NR:
>   		ret = uvio_list_secrets(&uv_ioctl);
>   		break;
> +	case UVIO_IOCTL_LOCK_SECRETS_NR:
> +		ret = uvio_lock_secrets(&uv_ioctl);
> +		break;
>   	default:
>   		ret = -ENOIOCTLCMD;
>   		break;

