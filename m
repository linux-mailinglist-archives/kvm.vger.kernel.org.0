Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2968852A8AE
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351276AbiEQQzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351259AbiEQQy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:54:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF66F4F9CA;
        Tue, 17 May 2022 09:54:56 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGhJAR004325;
        Tue, 17 May 2022 16:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Al2I3ZW+FcGqnhsMYBFvzbQKpppCa6yKkdmhNfB3S9E=;
 b=SkZaJeUI0S0IVgc5fLdapPLwjeapUtEww23xUeJ7ijDy12QUN/upPhGKcb5vED+VJsct
 Z6PLfOyF+/a0Xsgf6aWdHBH7zK2reJEHL3DoyCo+aKTHVusXTQGwPmllH4Iq0nZAhmku
 JVlzvNR0TxT5BLwf021Ee9PogtVgYZtR7ZkynMumlunTGytU+iwkjrlEZbke9hB/WD8F
 wed9dEus7Fw193jfz84k5N82oL6zgSp2/kSlGrYlqeXy4x7Ab5X/5BSo6ullc45fHahw
 m9mRVkZRj0nuHC/hDBOjaL3o2GviCGWmNGD9bQag5JJ8Ls1XiquWS1hZtNhnlsuEc+TR nQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ffjr86h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:54:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGnAlw017393;
        Tue, 17 May 2022 16:54:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429chsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:54:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGsosq52101438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:54:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93E28AE051;
        Tue, 17 May 2022 16:54:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6487FAE045;
        Tue, 17 May 2022 16:54:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:54:50 +0000 (GMT)
Date:   Tue, 17 May 2022 18:48:12 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v6 08/11] kvm: s390: Add KVM_CAP_S390_PROTECTED_DUMP
Message-ID: <20220517184812.48df017c@p-imbrenda>
In-Reply-To: <20220517163629.3443-9-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
        <20220517163629.3443-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FSdIDoB7mwk4B5QbtEId5ORqS0CUVwsX
X-Proofpoint-ORIG-GUID: FSdIDoB7mwk4B5QbtEId5ORqS0CUVwsX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=784 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 16:36:26 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The capability indicates dump support for protected VMs.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
>  include/uapi/linux/kvm.h |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1938756d4a32..99ce1aced86b 100644
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
> +		r = is_prot_virt_host();
> +
> +		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
> +			if (!test_bit_inv(pv_cmds_dump[i],
> +					  (unsigned long *)&uv_info.inst_calls_list)) {
> +				r = 0;
> +				break;
> +			}
> +		}
> +		break;
> +	}
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 204b06e3a50b..108bc7b7a71b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
> +#define KVM_CAP_S390_PROTECTED_DUMP 214
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

