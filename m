Return-Path: <kvm+bounces-9041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 026AF859DD9
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 342861C21583
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF5C20DF5;
	Mon, 19 Feb 2024 08:11:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A788220DC3
	for <kvm@vger.kernel.org>; Mon, 19 Feb 2024 08:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708330271; cv=none; b=hsPHWE/nV0a1aOzY65XWBL5Jt3q5sFrazvA0ewPqheL5XMX6WuegHECNenjRHPs/g6c3d/D/Y31NC/Ep2g681zL1wkCJTR929araROIs18qxb6Qpd0OQldyO2+4cQnOr/FXHIPqC0L88vbShaHCOHu6KoVHFoKTbDUyAmzZ/eSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708330271; c=relaxed/simple;
	bh=iSJIAGsEjAITh2lF0JtX2nN0PEMwcbXZB+17HgnU6Jk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=X8Ja6d4cRRlQS9SzUnYW1oahlfJrGwvy+fE3Qx7GsTRXnFBjxZtezF6z43uMQCeruanR4gqugnxManZq3cakX4c3UH9SFTLLNNyWzJycGx6idD2wmg69PrTsQnvOev/X1ssLiob9n67DUg25X/O0XNFUBS15xl6B2vIBgR1eDUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1708329263-086e230f2743bb0001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id AUhwfZp6qktPqla3 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 19 Feb 2024 15:54:23 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 19 Feb
 2024 15:54:23 +0800
Received: from [10.28.66.62] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 19 Feb
 2024 15:54:22 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Message-ID: <b09804a5-b93d-4370-918d-acd18bcc64bb@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.28.66.62
Date: Mon, 19 Feb 2024 02:54:21 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: PING: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
Content-Language: en-US
X-ASG-Orig-Subj: PING: [PATCH v2] target/i386/kvm: Refine VMX controls setting for
 backward compatibility
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
To: <pbonzini@redhat.com>, <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
	<zhao1.liu@intel.com>
CC: <qemu-devel@nongnu.org>, <cobechen@zhaoxin.com>, <ewanhai@zhaoxin.com>
References: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
In-Reply-To: <20231127034326.257596-1-ewanhai-oc@zhaoxin.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1708329263
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3531
X-Barracuda-BRTS-Status: 0
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.121040
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Dear QEMU Community,

Two months have passed since my last submission of the patch aimed at
addressing an issue encountered with kernels prior to Linux kernel 5.3.
When using the latest version of QEMU with '-cpu host', if the host
supports the rdseed instruction but not rdseed exiting, it results in
a QEMU error: "error: failed to set MSR 0x48b to 0x*****".

I understand everyone is busy, and reviewing patches can be quite
resource-intensive. Nevertheless, I am eager to hear if there are any
further comments, suggestions, or advice on what steps I should take next
regarding this patch.

Sincerely,Ewan

On 11/26/23 22:43, EwanHai wrote:
> Commit 4a910e1 ("target/i386: do not set unsupported VMX secondary
> execution controls") implemented a workaround for hosts that have
> specific CPUID features but do not support the corresponding VMX
> controls, e.g., hosts support RDSEED but do not support RDSEED-Exiting.
>
> In detail, commit 4a910e1 introduced a flag `has_msr_vmx_procbased_clts2`.
> If KVM has `MSR_IA32_VMX_PROCBASED_CTLS2` in its msr list, QEMU would
> use KVM's settings, avoiding any modifications to this MSR.
>
> However, this commit (4a910e1) didn't account for cases in older Linux
> kernels(<5.3) where `MSR_IA32_VMX_PROCBASED_CTLS2` is in
> `kvm_feature_msrs`-obtained by ioctl(KVM_GET_MSR_FEATURE_INDEX_LIST),
> but not in `kvm_msr_list`-obtained by ioctl(KVM_GET_MSR_INDEX_LIST).
> As a result,it did not set the `has_msr_vmx_procbased_clts2` flag based
> on `kvm_msr_list` alone, even though KVM maintains the value of this MSR.
>
> This patch supplements the above logic, ensuring that
> `has_msr_vmx_procbased_clts2` is correctly set by checking both MSR
> lists, thus maintaining compatibility with older kernels.
>
> Signed-off-by: EwanHai <ewanhai-oc@zhaoxin.com>
> ---
> In response to the suggestions from ZhaoLiu(zhao1.liu@intel.com),
> the following changes have been implemented in v2:
> - Adjusted some punctuation in the commit message as per the
>    suggestions.
> - Added comments to the newly added code to indicate that it is a
>    compatibility fix.
>
> v1 link:
> https://lore.kernel.org/all/20230925071453.14908-1-ewanhai-oc@zhaoxin.com/
> ---
>   target/i386/kvm/kvm.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..c8f6c0b531 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2296,6 +2296,7 @@ void kvm_arch_do_init_vcpu(X86CPU *cpu)
>   static int kvm_get_supported_feature_msrs(KVMState *s)
>   {
>       int ret = 0;
> +    int i;
>   
>       if (kvm_feature_msrs != NULL) {
>           return 0;
> @@ -2330,6 +2331,19 @@ static int kvm_get_supported_feature_msrs(KVMState *s)
>           return ret;
>       }
>   
> +    /*
> +     * Compatibility fix:
> +     * Older Linux kernels(<5.3) include the MSR_IA32_VMX_PROCBASED_CTLS2
> +     * only in feature msr list, but not in regular msr list. This lead to
> +     * an issue in older kernel versions where QEMU, through the regular
> +     * MSR list check, assumes the kernel doesn't maintain this msr,
> +     * resulting in incorrect settings by QEMU for this msr.
> +     */
> +    for (i = 0; i < kvm_feature_msrs->nmsrs; i++) {
> +        if (kvm_feature_msrs->indices[i] == MSR_IA32_VMX_PROCBASED_CTLS2) {
> +            has_msr_vmx_procbased_ctls2 = true;
> +        }
> +    }
>       return 0;
>   }
>   


