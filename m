Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38873B989A
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 22:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbfITUok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 16:44:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46280 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfITUoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 16:44:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KKhb2X130354;
        Fri, 20 Sep 2019 20:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=B1OArm4axadQMjlOGNaK1utZZ8JS8CSjC5aaST7ysag=;
 b=hLSEk8leZZ0UHBGpdiWaq/bftdFO4R+zyS+ah0GTAwgFw2cBR3eXdGwe4lcMKsDvhuNw
 wVYBSool5mo33c4leJ7XP8DRR3HOIwKICfran3KZt2JpXBBXXp/dwkRVHHhkPhULcMAV
 tSwjcwbIdhvonNJg0iMoxSuwuuTelTpeFFxjQVjpv7u2bWnUAe9T0jTOuqwHtKTOhdVj
 xykHjMLmpmdys+YRtJqZwbDwezigIJI6vlLNGXBozsJWkJjKk5tXdUUM2npYHgduqTcr
 l5JHQNuUxr3AAHBgxgJkYu9CEakz6z7UV1uf36ZlkChXk7YPioeGs8GihSqJ2m9k+eaR 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2v3vb4vmjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 20:44:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KKSvCR085414;
        Fri, 20 Sep 2019 20:44:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v4vpmyt5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 20:44:35 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8KKiYcK028410;
        Fri, 20 Sep 2019 20:44:34 GMT
Received: from localhost.localdomain (/10.159.151.167)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 13:44:34 -0700
Subject: Re: [PATCH] kvm: svm: Intercept RDPRU
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Drew Schmitt <dasch@google.com>, Jacob Xu <jacobhxu@google.com>,
        Peter Shier <pshier@google.com>
References: <20190919225917.36641-1-jmattson@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <f70da185-880c-f5af-b28a-f95b40448ca1@oracle.com>
Date:   Fri, 20 Sep 2019 13:44:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190919225917.36641-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/19/19 3:59 PM, Jim Mattson wrote:
> The RDPRU instruction gives the guest read access to the IA32_APERF
> MSR and the IA32_MPERF MSR. According to volume 3 of the APM, "When
> virtualization is enabled, this instruction can be intercepted by the
> Hypervisor. The intercept bit is at VMCB byte offset 10h, bit 14."
> Since we don't enumerate the instruction in KVM_SUPPORTED_CPUID,
> intercept it and synthesize #UD.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Drew Schmitt <dasch@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>   arch/x86/include/asm/svm.h      | 1 +
>   arch/x86/include/uapi/asm/svm.h | 1 +
>   arch/x86/kvm/svm.c              | 8 ++++++++
>   3 files changed, 10 insertions(+)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index dec9c1e84c78..6ece8561ba66 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -52,6 +52,7 @@ enum {
>   	INTERCEPT_MWAIT,
>   	INTERCEPT_MWAIT_COND,
>   	INTERCEPT_XSETBV,
> +	INTERCEPT_RDPRU,
>   };
>   
>   
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index a9731f8a480f..2e8a30f06c74 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -75,6 +75,7 @@
>   #define SVM_EXIT_MWAIT         0x08b
>   #define SVM_EXIT_MWAIT_COND    0x08c
>   #define SVM_EXIT_XSETBV        0x08d
> +#define SVM_EXIT_RDPRU         0x08e
>   #define SVM_EXIT_NPF           0x400
>   #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
>   #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 04fe21849b6e..cef00e959679 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1539,6 +1539,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>   	set_intercept(svm, INTERCEPT_SKINIT);
>   	set_intercept(svm, INTERCEPT_WBINVD);
>   	set_intercept(svm, INTERCEPT_XSETBV);
> +	set_intercept(svm, INTERCEPT_RDPRU);
>   	set_intercept(svm, INTERCEPT_RSM);
>   
>   	if (!kvm_mwait_in_guest(svm->vcpu.kvm)) {
> @@ -3830,6 +3831,12 @@ static int xsetbv_interception(struct vcpu_svm *svm)
>   	return 1;
>   }
>   
> +static int rdpru_interception(struct vcpu_svm *svm)
> +{
> +	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
> +	return 1;
> +}
> +
>   static int task_switch_interception(struct vcpu_svm *svm)
>   {
>   	u16 tss_selector;
> @@ -4791,6 +4798,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>   	[SVM_EXIT_MONITOR]			= monitor_interception,
>   	[SVM_EXIT_MWAIT]			= mwait_interception,
>   	[SVM_EXIT_XSETBV]			= xsetbv_interception,
> +	[SVM_EXIT_RDPRU]			= rdpru_interception,
>   	[SVM_EXIT_NPF]				= npf_interception,
>   	[SVM_EXIT_RSM]                          = rsm_interception,
>   	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

