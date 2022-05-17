Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BD352A08D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiEQLha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345325AbiEQLh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:37:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9F941FA1;
        Tue, 17 May 2022 04:37:26 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HALwCL028013;
        Tue, 17 May 2022 11:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=N79pR0bBhXrGGqfQhZl8CgBdbVYH4QmChH6XdmlaioQ=;
 b=OACuUMiJ+KJB7yw5u3QnCita4BIqlsVxilhMUKUFi/zrK2itvJ6F3VVFHS24M86zCIkL
 3OXvFZlAWTI5MOvKEQqGX37cV9b2VQhy5U95yi/9GK5boTbYObAQduAMv4KgSxojmJIY
 qm0Bf1ZYgcMDOYStG9L9glrSqmDHuxwssfvaBEY/y73MU3yH2KYxM5pu9ujzctPStpsL
 fvVXinJTFzVApz4wU6JgWVX1vu/vQ3cP3Q6wPVo/xTSe0Ks9SUOKnyq//TxVQItRNtyI
 Uek4QVsvv1YGPgpXJ/NU32Q+OE8ht8AO+XBQTxjJVliFmMJ+QYPL335gr4XCD+8U9os1 /g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g49w11qbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBIlIc020277;
        Tue, 17 May 2022 11:37:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjc4ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBbLdP46858630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:37:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2679AA405B;
        Tue, 17 May 2022 11:37:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB9CDA4054;
        Tue, 17 May 2022 11:37:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:37:20 +0000 (GMT)
Date:   Tue, 17 May 2022 13:37:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v5 08/10] kvm: s390: Add KVM_CAP_S390_PROTECTED_DUMP
Message-ID: <20220517133707.1b17e7ab@p-imbrenda>
In-Reply-To: <20220516090817.1110090-9-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
        <20220516090817.1110090-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xjRX9bEKlDcrQuFxA_rTFlVVo21HKSeN
X-Proofpoint-ORIG-GUID: xjRX9bEKlDcrQuFxA_rTFlVVo21HKSeN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 impostorscore=0 mlxlogscore=780 lowpriorityscore=0 spamscore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 09:08:15 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The capability indicates dump support for protected VMs.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
>  include/uapi/linux/kvm.h |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index c0c848c84552..1d65235ed3d3 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -606,6 +606,26 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_PROTECTED:
>  		r = is_prot_virt_host();
>  		break;
> +	case KVM_CAP_S390_PROTECTED_DUMP: {
> +		u64 pv_cmds_dump[] = {
> +			BIT_UVC_CMD_DUMP_INIT,
> +			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
> +			BIT_UVC_CMD_DUMP_CPU,
> +			BIT_UVC_CMD_DUMP_COMPLETE,
> +		};
> +		int i;
> +
> +		if (!is_prot_virt_host())
> +			return 0;

we don't return usually in this function, can you use break instad? or
maybe even something simpler like this:

r = is_prot_virt_host();

for (i = 0; r && i < ARRAY_SIZE(...); i++)
	r = r && test_bit_inv(...);
> +
> +		r = 1;
> +		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
> +			if (!test_bit_inv(pv_cmds_dump[i],
> +					  (unsigned long *)&uv_info.inst_calls_list))
> +				return 0;
> +		}
> +		break;
> +	}
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0a8b57654ea7..ba8f2985a8c0 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DISABLE_QUIRKS2 213
>  /* #define KVM_CAP_VM_TSC_CONTROL 214 */
>  #define KVM_CAP_SYSTEM_EVENT_DATA 215
> +#define KVM_CAP_S390_PROTECTED_DUMP 216
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

