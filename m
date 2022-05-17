Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FB252A8AB
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351257AbiEQQy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351243AbiEQQyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:54:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E93E4EF46;
        Tue, 17 May 2022 09:54:53 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGBvc6010452;
        Tue, 17 May 2022 16:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uPzMjnwHrIS+LQieaP09MWDS89MClWG64s+gzoAv+D4=;
 b=Zx4xs6toIUkLl++iCG1Iu46NcE9Oh9lLlBikXVytqLrkDHoHpmGy15ZUXsV1s2gvqvmM
 ZkGMJD9hEzjgw2xpTIlsKwLMSV7E6QleEjYFacAUG/qXm0DNH2Q8wiJFiwI6UBF2JZIK
 BkgVSVLct3E7kiVFw1n5wyM8iHmSRfoNeJwPwyk2+/ygscpO9+kjtW4kc7+BdwToj+ZJ
 iIknPzVih0A3ZWkzEYuZtWN7laiMg9N45/xr3gk/iXSzoC1I1iZ9SWjcGl6OLd9gVE66
 o8XsVAb7CnSc9DGQ7e5fflW/oa/E9VSjL3U8Cr56ck60oz25vFiqH6gGwPphSLBRu+fh PQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f0w0wth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:54:52 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGmN1J017260;
        Tue, 17 May 2022 16:54:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429chsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:54:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGslUE48300390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:54:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FDE5AE051;
        Tue, 17 May 2022 16:54:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20C8AAE045;
        Tue, 17 May 2022 16:54:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:54:47 +0000 (GMT)
Date:   Tue, 17 May 2022 18:48:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v6 07/11] kvm: s390: Add CPU dump functionality
Message-ID: <20220517184853.547df48c@p-imbrenda>
In-Reply-To: <20220517163629.3443-8-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
        <20220517163629.3443-8-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a6hSWSiS1Oi1tdKzijipv_5badTsQ7oa
X-Proofpoint-ORIG-GUID: a6hSWSiS1Oi1tdKzijipv_5badTsQ7oa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 16:36:25 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The previous patch introduced the per-VM dump functions now let's
> focus on dumping the VCPU state via the newly introduced
> KVM_S390_PV_CPU_COMMAND ioctl which mirrors the VM UV ioctl and can be
> extended with new commands later.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 69 ++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h |  1 +
>  arch/s390/kvm/pv.c       | 16 ++++++++++
>  include/uapi/linux/kvm.h |  4 +++
>  4 files changed, 90 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 24b8ac61efff..1938756d4a32 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5087,6 +5087,48 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>  	return -ENOIOCTLCMD;
>  }
>  
> +static int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu,
> +					struct kvm_pv_cmd *cmd)
> +{
> +	struct kvm_s390_pv_dmp dmp;
> +	void *data;
> +	int ret;
> +
> +	/* Dump initialization is a prerequisite */
> +	if (!vcpu->kvm->arch.pv.dumping)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&dmp, (__u8 __user *)cmd->data, sizeof(dmp)))
> +		return -EFAULT;
> +
> +	/* We only handle this subcmd right now */
> +	if (dmp.subcmd != KVM_PV_DUMP_CPU)
> +		return -EINVAL;
> +
> +	/* CPU dump length is the same as create cpu storage donation. */
> +	if (dmp.buff_len != uv_info.guest_cpu_stor_len)
> +		return -EINVAL;
> +
> +	data = kvzalloc(uv_info.guest_cpu_stor_len, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = kvm_s390_pv_dump_cpu(vcpu, data, &cmd->rc, &cmd->rrc);
> +
> +	VCPU_EVENT(vcpu, 3, "PROTVIRT DUMP CPU %d rc %x rrc %x",
> +		   vcpu->vcpu_id, cmd->rc, cmd->rrc);
> +
> +	if (ret)
> +		ret = -EINVAL;
> +
> +	/* On success copy over the dump data */
> +	if (!ret && copy_to_user((__u8 __user *)dmp.buff_addr, data, uv_info.guest_cpu_stor_len))
> +		ret = -EFAULT;
> +
> +	kvfree(data);
> +	return ret;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> @@ -5251,6 +5293,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  					   irq_state.len);
>  		break;
>  	}
> +	case KVM_S390_PV_CPU_COMMAND: {
> +		struct kvm_pv_cmd cmd;
> +
> +		r = -EINVAL;
> +		if (!is_prot_virt_host())
> +			break;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&cmd, argp, sizeof(cmd)))
> +			break;
> +
> +		r = -EINVAL;
> +		if (cmd.flags)
> +			break;
> +
> +		/* We only handle this cmd right now */
> +		if (cmd.cmd != KVM_PV_DUMP)
> +			break;
> +
> +		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
> +
> +		/* Always copy over UV rc / rrc data */
> +		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
> +				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
> +			r = -EFAULT;
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 2c11eb5ba3ef..dd01d989816f 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -250,6 +250,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>  int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>  		       unsigned long tweak, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
> +int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
>  				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_dump_complete(struct kvm *kvm, void __user *buff_user,
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 52a67e2aaadd..a200543cf6a1 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -305,6 +305,22 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
>  	return 0;
>  }
>  
> +int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc)
> +{
> +	struct uv_cb_dump_cpu uvcb = {
> +		.header.cmd = UVC_CMD_DUMP_CPU,
> +		.header.len = sizeof(uvcb),
> +		.cpu_handle = vcpu->arch.pv.handle,
> +		.dump_area_origin = (u64)buff,
> +	};
> +	int cc;
> +
> +	cc = uv_call_sched(0, (u64)&uvcb);
> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	return cc;
> +}
> +
>  /* Size of the cache for the storage state dump data. 1MB for now */
>  #define DUMP_BUFF_LEN HPAGE_SIZE
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b34850907291..204b06e3a50b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1649,6 +1649,7 @@ enum pv_cmd_dmp_id {
>  	KVM_PV_DUMP_INIT,
>  	KVM_PV_DUMP_CONFIG_STOR_STATE,
>  	KVM_PV_DUMP_COMPLETE,
> +	KVM_PV_DUMP_CPU,
>  };
>  
>  struct kvm_s390_pv_dmp {
> @@ -2110,4 +2111,7 @@ struct kvm_stats_desc {
>  /* Available with KVM_CAP_XSAVE2 */
>  #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
>  
> +/* Available with KVM_CAP_S390_PROTECTED_DUMP */
> +#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
> +
>  #endif /* __LINUX_KVM_H */

