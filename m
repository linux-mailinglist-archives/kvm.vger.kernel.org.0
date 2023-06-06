Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1921372459A
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbjFFOS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjFFOS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:18:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C777E73;
        Tue,  6 Jun 2023 07:18:52 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356E750l000990;
        Tue, 6 Jun 2023 14:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=geJM4BwS1/PyAeZ1Tb704iMYC7J9WV0RRZ9YhaMmb5A=;
 b=dm5uHHicR0jrQCskKZXEqADGoVAo7gjpDerklaSDrPB8aRFVybR8Rnb/6nDvfqDVr5rX
 29gUPGQimIcLVncjjqsdDUR66rheHx9npfbb1GHCzil7BGryj0viq+GpWY1V5xGo3Em/
 FZOPNpW0dN1LznwZPg7cl+/uYuF9Bhnem3H0Q9FkH4U+rXfPcIK2pG/wPoGpwgCwClcm
 ce9LT043vJAcwcEaZOPXbNS2ti1Ecc2jwkQ6MEWUJ4v1rCQje8hjIPvKj1/7bl8VdU4E
 l4tyRsLDB2905DRVpsxttLVWulFj6HFjVlXeWa2PRVJ+XVDVkUJkDR4oVkJxpBjr4I6u Hw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r263kgkv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 14:18:50 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3561JBC0030188;
        Tue, 6 Jun 2023 14:18:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qyx8xhjd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jun 2023 14:18:47 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 356EIirX60031302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jun 2023 14:18:44 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAAF52004B;
        Tue,  6 Jun 2023 14:18:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6305720049;
        Tue,  6 Jun 2023 14:18:43 +0000 (GMT)
Received: from [9.171.79.116] (unknown [9.171.79.116])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jun 2023 14:18:43 +0000 (GMT)
Message-ID: <981c660f-27cb-5cbd-f965-3ecc1b36aa7a@linux.ibm.com>
Date:   Tue, 6 Jun 2023 16:18:43 +0200
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
References: <20230606113736.2934503-1-seiden@linux.ibm.com>
 <20230606113736.2934503-3-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v3 2/6] s390/uvdevice: Add 'Add Secret' UVC
In-Reply-To: <20230606113736.2934503-3-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0YQIUoiD2PxoV2u136_AnXP3mBwrx6Df
X-Proofpoint-GUID: 0YQIUoiD2PxoV2u136_AnXP3mBwrx6Df
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_10,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060119
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
> Userspace can call the Add Secret Ultravisor Call
> using IOCTLs on the uvdevice.
> During the handling of the new IOCTL nr the uvdevice will do some sanity
> checks first. Then, copy the request data to kernel space, perform the
> Ultravisor command, and copy the return codes to userspace.
> If the Add Secret UV facility is not present,
> UV will return invalid command rc. This won't be fenced in the driver
> and does not result in a negative return value. This is also true for
> any other possible error code the UV can return.

The Add Secret UV call sends an encrypted and cryptographically verified 
request to the Ultravisor. The request inserts a protected guest's 
secret into the Ultravisor for later use.

The uvdevice is merely transporting the request from userspace to the 
Ultravisor. It's neither checking nor manipulating the request data.

> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   arch/s390/include/asm/uv.h            | 14 +++++++
>   arch/s390/include/uapi/asm/uvdevice.h |  4 ++
>   drivers/s390/char/uvdevice.c          | 57 +++++++++++++++++++++++++++
>   3 files changed, 75 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 28a9ad57b6f1..1babc70ea5d4 100644
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
> + * A common UV call struct for pv guests that contains a single address
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
>   static inline int __uv_call(unsigned long r1, unsigned long r2)
>   {
>   	int cc;
> diff --git a/arch/s390/include/uapi/asm/uvdevice.h b/arch/s390/include/uapi/asm/uvdevice.h
> index 9d9b684836c2..e77410226598 100644
> --- a/arch/s390/include/uapi/asm/uvdevice.h
> +++ b/arch/s390/include/uapi/asm/uvdevice.h
> @@ -69,6 +69,7 @@ struct uvio_uvdev_info {
>   #define UVIO_ATT_ARCB_MAX_LEN		0x100000
>   #define UVIO_ATT_MEASUREMENT_MAX_LEN	0x8000
>   #define UVIO_ATT_ADDITIONAL_MAX_LEN	0x8000
> +#define UVIO_ADD_SECRET_MAX_LEN		0x100000
>   
>   #define UVIO_DEVICE_NAME "uv"
>   #define UVIO_TYPE_UVC 'u'
> @@ -76,6 +77,7 @@ struct uvio_uvdev_info {
>   enum UVIO_IOCTL_NR {
>   	UVIO_IOCTL_UVDEV_INFO_NR = 0x00,
>   	UVIO_IOCTL_ATT_NR,
> +	UVIO_IOCTL_ADD_SECRET_NR,
>   	/* must be the last entry */
>   	UVIO_IOCTL_NUM_IOCTLS
>   };
> @@ -83,9 +85,11 @@ enum UVIO_IOCTL_NR {
>   #define UVIO_IOCTL(nr)		_IOWR(UVIO_TYPE_UVC, nr, struct uvio_ioctl_cb)
>   #define UVIO_IOCTL_UVDEV_INFO	UVIO_IOCTL(UVIO_IOCTL_UVDEV_INFO_NR)
>   #define UVIO_IOCTL_ATT		UVIO_IOCTL(UVIO_IOCTL_ATT_NR)
> +#define UVIO_IOCTL_ADD_SECRET	UVIO_IOCTL(UVIO_IOCTL_ADD_SECRET_NR)
>   
>   #define UVIO_SUPP_CALL(nr)	(1ULL << (nr))
>   #define UVIO_SUPP_UDEV_INFO	UVIO_SUPP_CALL(UVIO_IOCTL_UDEV_INFO_NR)
>   #define UVIO_SUPP_ATT		UVIO_SUPP_CALL(UVIO_IOCTL_ATT_NR)
> +#define UVIO_SUPP_ADD_SECRET	UVIO_SUPP_CALL(UVIO_IOCTL_ADD_SECRET_NR)
>   
>   #endif /* __S390_ASM_UVDEVICE_H */
> diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
> index 4efeebcaf382..c10554bc1fee 100644
> --- a/drivers/s390/char/uvdevice.c
> +++ b/drivers/s390/char/uvdevice.c
> @@ -37,6 +37,7 @@
>   static const u32 ioctl_nr_to_uvc_bit[] __initconst = {
>   	[UVIO_IOCTL_UVDEV_INFO_NR] = BIT_UVIO_INTERNAL,
>   	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
> +	[UVIO_IOCTL_ADD_SECRET_NR] = BIT_UVC_CMD_ADD_SECRET,
>   };
>   
>   static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
> @@ -231,6 +232,59 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
>   	return ret;
>   }
>   
> +/** uvio_add_secret() - perform an Add Secret UVC
> + *
> + * @uv_ioctl: ioctl control block
> + *
> + * uvio_add_secret() performs the Add Secret Ultravisor Call. It verifies that
> + * the given userspace argument address is valid and its size is sane. Every
> + * other check is made by the Ultravisor (UV) and won't result in a negative
> + * return value. It copies the request to kernelspace, performs the UV-call, and
> + * copies the return codes to the ioctl control block. The argument has to point
> + * to an Add Secret Request Control Block. It is an encrypted and
> + * cryptographically verified request generated by userspace to insert the
> + * actual secret into the UV. If the Add Secret UV facility is not present, UV
> + * will return invalid command rc. This won't be fenced in the driver and does
> + * not result in a negative return value.
> + *
> + * Context: might sleep
> + *
> + * Return: 0 on success or a negative error code on error.
> + */

Maybe:

/** uvio_add_secret() - perform an Add Secret UVC 
 
 
 

  * 
 
 
 

  * @uv_ioctl: ioctl control block 
 
 
 

  * 
 
 
 

  * uvio_add_secret() performs the Add Secret Ultravisor Call. 
 
 
 

  * 
 
 
 

  * The given userspace argument address and size are verified to be 
 
 
 

  * valid but every other check is made by the Ultravisor 
 
 
 

  * (UV). Therefore UV errors won't result in a negative return 
 
 
 

  * value. The request is then copied to kernelspace, the UV-call is 
 
 
 

  * performed and the results are copied back to userspace. 
 
 
 

  * 
 
 
 

  * The argument has to point to an Add Secret Request Control Block 
 
 
 

  * which is an encrypted and cryptographically verified request that 
 
 
 

  * inserts a protected guest's secrets into the Ultravisor for later 
 
 
 

  * use. 
 
 
 

  * 
 
 
 

  * If the Add Secret UV facility is not present, UV will return 
 
 
 

  * invalid command rc. This won't be fenced in the driver and does not 
 
 
 

  * result in a negative return value. 
 
 
 

  * 
 
 
 

  * Context: might sleep 
 
 
 

  * 
 
 
 

  * Return: 0 on success or a negative error code on error. 
 
 
 

  */


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
> +		return -ENOMEM;
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
> @@ -275,6 +329,9 @@ static long uvio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   	case UVIO_IOCTL_ATT_NR:
>   		ret = uvio_attestation(&uv_ioctl);
>   		break;
> +	case UVIO_IOCTL_ADD_SECRET_NR:
> +		ret = uvio_add_secret(&uv_ioctl);
> +		break;
>   	default:
>   		ret = -ENOIOCTLCMD;
>   		break;

