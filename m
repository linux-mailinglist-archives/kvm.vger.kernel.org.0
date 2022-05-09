Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82852050D
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiEITQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 15:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240455AbiEITQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 15:16:47 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9DE4B435;
        Mon,  9 May 2022 12:12:52 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249J8p3a023191;
        Mon, 9 May 2022 19:12:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DZzbJiIk8wIAoTuwwMQq7KRXqh2P/xm57Dp1M/M0xs0=;
 b=IvUL5tKMINtn2cb43bg1gLUvbBDBqoKQN8efrjBBHiUdwKrv4+fR82Z0nlqAVABrmffa
 bltkm7qFfVQ0r0I1zsohL1SzUU+BErZaixjdPyhMbk/ecIDifwdWoBI7Em5FcX7CZwu0
 t/iiW6BpGnR0RMAMf7GBUFRzGrBAaqGSNAOry54hK6zZsGsGXvyTvfHnPxx6Yfocyq/L
 FPQLWUn6MtG/dqLPOF5K3Ffmzo7boaK4S+OQw6aYQYlLkssD7OzX3HxQ2UWhjp4/rucm
 KjdmErh58canyJ4g1GBXvMq7BxUlNLwT07wD/DK7WTLiKHXxTNjKNuQZVnC/HqT7yjqx ZA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fy7s4s7gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 19:12:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 249Iv8Yq028759;
        Mon, 9 May 2022 19:12:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3fwg1j2xs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 19:12:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 249IxEjl48366030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 May 2022 18:59:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A74DAE04D;
        Mon,  9 May 2022 19:12:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A0FAE045;
        Mon,  9 May 2022 19:12:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 May 2022 19:12:45 +0000 (GMT)
Date:   Mon, 9 May 2022 21:11:40 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH 7/9] kvm: s390: Add CPU dump functionality
Message-ID: <20220509211140.38f49000@p-imbrenda>
In-Reply-To: <20220428130102.230790-8-frankja@linux.ibm.com>
References: <20220428130102.230790-1-frankja@linux.ibm.com>
        <20220428130102.230790-8-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ru6ROCiHgraWSlFUVpWgEdF43EuZAd7D
X-Proofpoint-GUID: Ru6ROCiHgraWSlFUVpWgEdF43EuZAd7D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205090100
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Apr 2022 13:01:00 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The previous patch introduced the per-VM dump functions now let's
> focus on dumping the VCPU state via the newly introduced
> KVM_S390_PV_CPU_COMMAND ioctl which mirrors the VM UV ioctl and can be
> extended with new commands later.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 73 ++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h |  1 +
>  arch/s390/kvm/pv.c       | 16 +++++++++
>  include/uapi/linux/kvm.h |  5 +++
>  4 files changed, 95 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8984e8db33b4..d15ce38bef14 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5149,6 +5149,52 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
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
> +	data = vzalloc(uv_info.guest_cpu_stor_len);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = kvm_s390_pv_dump_cpu(vcpu, data, &cmd->rc, &cmd->rrc);
> +
> +	VCPU_EVENT(vcpu, 3, "PROTVIRT DUMP CPU %d rc %x rrc %x",
> +		   vcpu->vcpu_id, cmd->rc, cmd->rrc);
> +
> +	if (ret) {
> +		vfree(data);
> +		return -EINVAL;
> +	}
> +
> +	/* On success copy over the dump data */
> +	if (copy_to_user((__u8 __user *)dmp.buff_addr, data, uv_info.guest_cpu_stor_len)) {
> +		vfree(data);
> +		return -EFAULT;
> +	}
> +
> +	vfree(data);
> +	return 0;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
> @@ -5313,6 +5359,33 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
> index 2868dd0bba25..a39815184350 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -250,6 +250,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
>  int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>  		       unsigned long tweak, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
> +int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc);
>  int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
>  				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
>  
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index d1635ed50078..9ab8192b9b23 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -299,6 +299,22 @@ int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
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

it's a small amount of data, but you use the _sched variant?

and, why aren't you using the _sched variant in the previous patch (for
DUMP_COMPLETE)?

to be clear: I think the right thing is to always use the _sched
variant unless there is a good reason not to (so please fix the previous
patch)

> +	*rc = uvcb.header.rc;
> +	*rrc = uvcb.header.rrc;
> +	return cc;
> +}
> +
>  /* Size of the cache for the storage state dump data. 1MB for now */
>  #define DUMP_BUFF_LEN HPAGE_SIZE
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b34850907291..108bc7b7a71b 100644
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
> @@ -1649,6 +1650,7 @@ enum pv_cmd_dmp_id {
>  	KVM_PV_DUMP_INIT,
>  	KVM_PV_DUMP_CONFIG_STOR_STATE,
>  	KVM_PV_DUMP_COMPLETE,
> +	KVM_PV_DUMP_CPU,
>  };
>  
>  struct kvm_s390_pv_dmp {
> @@ -2110,4 +2112,7 @@ struct kvm_stats_desc {
>  /* Available with KVM_CAP_XSAVE2 */
>  #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
>  
> +/* Available with KVM_CAP_S390_PROTECTED_DUMP */
> +#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
> +
>  #endif /* __LINUX_KVM_H */

