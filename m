Return-Path: <kvm+bounces-71674-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KC95KlkdnmlyTgQAu9opvQ
	(envelope-from <kvm+bounces-71674-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:51:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E46A18CF41
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C8FC306774C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 21:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E3A33F375;
	Tue, 24 Feb 2026 21:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cQmV6/+h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="USLvuxEX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84933B6CF
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771969861; cv=none; b=klqXSm54WqdbcazLJqC/3s1uJ2wJunLo11LaL/PJUlpUe2s/iZWr42aGa7rhymTvvd/0EfIXcWjV6v5MtIZYG0+tWui6Tbc5kSF+mW03BxKumRL/3ZbWJ7QySjvANZ+hKKU9M+91nZwQW7IUOltroHrmQIMks+3Oe1Yu3I/94K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771969861; c=relaxed/simple;
	bh=4SG8RP7kHBaHzKBQxDKU8h04lXbe3ryF7/XGLu2hzQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGHR37WsRqgwQGDt0dSxvPWw60eEg76Gyl+JK9hHF/4l7i9ltDlfeo6e9tQfTCEn7tmbfrjTCDlju9NIraxRogh1ni0wL12BKqHD2L9hJjIEMTVwLB+ukcBrpGJLaZbSCFm+Gwr1hshg7qPaXGiEFekQdm5mlM31bOnQ2syr8jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cQmV6/+h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=USLvuxEX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OLVUaQ2432576
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=PYdOYbhb4RINNVZP0bdh4mEu
	h5KJPe7w0rQzb0Et4Lk=; b=cQmV6/+hvUaKLA8pJgSUofxUW98ZZ1zAEaUqekSu
	i1o6YtvHC47F99Tm+i2Jh9cBnJ1kbwGXZChybh8lNAeuejdEk3RZ0DvHFYLpckX0
	aYHNYRRB3qiYDB2pwmh9fJR/dsCe4VyACviHfnhLhy1Pt0n2cS4kMPOpKmYkm45N
	QmdlLl3Rgdtz8bGhtGbboY01vAbbpHdwP94XUyx3Rs4muDUKmoM2Fi0dXinpzt80
	7PT5LWLwow62dTZD8bFIwxcv88PLetthKN1b99UsArMxKiy5lb7fH//jumzIvkAV
	9wiBy9nOYdr8Ej2vCQoCqleKJQtMZiSRD+3OWQDwZsShJw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chekj9cd8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:50:57 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2ba8013a9e3so6770643eec.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 13:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771969857; x=1772574657; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PYdOYbhb4RINNVZP0bdh4mEuh5KJPe7w0rQzb0Et4Lk=;
        b=USLvuxEXo2krBE28xlvmx8osvOStZB+60lxmRohQn18igOxMLkLsN3N2Yk3wwDh6ox
         UxqTrQhQr8LCg2bifcCBH6O4pzwaK66YnXP6MnJtjMnpWfZvoUbcjZjunuKSE4qEjAqh
         2t03GxmcSjFHZ/UJ2foMQBVO/GAytBsuaRaeON+AktDXl+T2z9BQujUSyKYnGrXDClfu
         vzm1HIhhvz67NECSYsU0pWqfX82n/4Zke4lZfsQZf6mBkFq8J7cLg/kFABh7Y8IEnIuH
         YBTBE21oUKf/hmodf6Imip+v8DYki2tgQgSUq74+Sq5WZq2mkvyewhGtilniBZeyMCup
         c1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771969857; x=1772574657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYdOYbhb4RINNVZP0bdh4mEuh5KJPe7w0rQzb0Et4Lk=;
        b=EmulWoFkxDJG3hr2zYxK3/euaap1Y8NFi5pGLZbRJ01CtJP9dSnYYCw188YGcrw48D
         3xeD2iPr3IapDXS7AZZYbooANVnjzZshico4sgvWmNjj2Qeh54QIupmmaIWIMJEUGYj1
         hrCI+a94Dy/i35Nt8KuiqTHQRd/qNleU8qq+BucvsCaWZ4qfkSxWqq1FQZBVJgmasf1X
         hJXzqEzWxdnP09FhjU73UYjyTBp/41vDGK0tGCDoEd8AUUZ+QzpppjQDu5YFvMD6IcwC
         v/47fSXTq0SoiOvEZx3rIhj/A2Xk60PX0m3yI9wGM6LuxW4XD17Hl3AWTNsuNz9bz/I2
         yPiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVOL0ke6WfjyCupXzk8x5JyWp4fgBvppzIgVJ6ehDkq3VF0cq8hlQNOiEuzAxFRjtyykQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz63j7Gpxo49sPFxn5undfwYaG3WF5NNTvTyZO8F3WkiRBdYoS9
	28MoFdSHILgkXG3MnOFL+ma+dl9UcM6pA7ZVp2bQEaUG6UitsehoAWioN0zipQ8wJPYc6mvi8E2
	HCirA6md/o+MXYHt5TBKleFowRIHdoB3Z245LkdNe8gsM/+EXXxpuhUM=
X-Gm-Gg: ATEYQzwztVDRmRyFTa1f8fEXGgvv7iLLWsB3aWS0FKxK4x/8kYYEumai3Wkyw6s5DPz
	T6ekKBI5BlPlR+8YcknW9R4RZBMPd9RYN7K+q7/Y956gB7lSfnhVRjxsO6NnKTu5tObAn5HroWH
	SvxLzte459BDeU1RWGxsi0f4wYJ4YVdRcMCwzMm/DcHiloc6/NdBvALrDBDrAFElQpSr9a+y72G
	0npt7IZ1e0rfPxgH9D6IWQYMnBTr3RnEuxSdMcfgm73TG7lYKK7hp3+lQtu66O7wkmQwcwPmjBO
	B07wl1D4JpeeZ8bcFNR8W86+9kHjCL2qaNA4Nb2TE9mAOdxKkwEKxCao4u+0f9OBGMGkwkRI3E0
	lsyy9MSmzB9znouQ55u3zhq1hj7Z7ALA=
X-Received: by 2002:a05:693c:2b0d:b0:2b8:4a34:6c39 with SMTP id 5a478bee46e88-2bd7bae9c9dmr5164278eec.16.1771969856488;
        Tue, 24 Feb 2026 13:50:56 -0800 (PST)
X-Received: by 2002:a05:693c:2b0d:b0:2b8:4a34:6c39 with SMTP id 5a478bee46e88-2bd7bae9c9dmr5164253eec.16.1771969855873;
        Tue, 24 Feb 2026 13:50:55 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bd7dc164e3sm7529614eec.25.2026.02.24.13.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 13:50:55 -0800 (PST)
Date: Tue, 24 Feb 2026 15:50:54 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: anup@brainfault.org, atish.patra@linux.dev, ajones@ventanamicro.com,
        conor.dooley@microchip.com, yongxuan.wang@sifive.com,
        nutty.liu@hotmail.com, paul.walmsley@sifive.com, pjw@kernel.org,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: riscv: Skip CSR restore if VCPU is reloaded on
 the same core
Message-ID: <fr5tir6ypoxkgqwfg5u2ke5n23bucdkk6zaxckfha2wibsebbo@qqusmvhky24e>
References: <20260222045741.260325-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222045741.260325-1-tjytimi@163.com>
X-Authority-Analysis: v=2.4 cv=RNe+3oi+ c=1 sm=1 tr=0 ts=699e1d41 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=Byx-y9mGAAAA:8 a=J8dAU397a_ys_4ZrTBUA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: wMLDDaT7zuq9sW1C1J6nBVOiwK7HUO1U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE5MCBTYWx0ZWRfX9jT2niM0Q4ib
 rttp1GAmPym7rAHFRdROpHofPjIvnSX6oFFvU9SjQP43ApMH+crLVKBNjy23GEDStc2k9zKK7uL
 VJzwHLO+0VBBlknG85W6pf7iKD+9t+HV0rjgpI2Z/guQsUji0tpeXMhovijtnGhAl1nC3upr6DI
 HwninR/uWvBnIr70luAVoSgcta8gcUp9kHf2Bm/dlAHsLFor4nroiPeHXFuyS/Zo4RZFEZqKjj0
 16gT8ICy5YE7nvy+AYHUz9NYLK0Obd+ENA2Nee9fainQhrY+hjyhJcTK+LUBXl3Zy5/s+2LzETy
 vYjgi17VlESipBFRQY8tXJCnhKjbEAk2h29d3ZBdanQqR6nvRWM7M6zO7BCvDzHAmxD8d1mJv0a
 QJnPogyGtW1hWu14nPWYiOXOv/Fsy6semDq8dvhMP8SRSUylrqWywmzVMUvxNJ0Kai63MMf7VNg
 xUirmyG3nke8bFM/GYA==
X-Proofpoint-GUID: wMLDDaT7zuq9sW1C1J6nBVOiwK7HUO1U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602240190
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71674-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[163.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,ventanamicro.com,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,vger.kernel.org,lists.infradead.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oss.qualcomm.com:dkim,qualcomm.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 2E46A18CF41
X-Rspamd-Action: no action

On Sun, Feb 22, 2026 at 12:57:41PM +0800, Jinyu Tang wrote:
> Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs and
> HGATP. However, when a preempted VCPU is scheduled back on the same
> physical CPU, and no other KVM VCPU has run on this CPU in the meantime,
> the hardware CSRs are still valid.
> 
> This patch optimizes the vcpu_load path by skipping the expensive CSR
> writes if all the following conditions are met:
> 1. The VCPU was previously preempted (vcpu->scheduled_out == 1).
> 2. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu == cpu).
> 3. No other VCPU used this CPU (vcpu == __this_cpu_read(kvm_former_vcpu)).
> 4. The CSRs are not dirty (!vcpu->arch.csr_dirty).
> 
> To ensure this fast-path doesn't break corner cases:
> - Live migration and VCPU reset are naturally safe. KVM initializes
>   last_exit_cpu to -1, which guarantees the fast-path won't trigger.
> - A new 'csr_dirty' flag is introduced to track runtime userspace
>   interventions. If userspace modifies guest configurations (e.g.,
>   hedeleg via KVM_SET_GUEST_DEBUG, or CSRs via KVM_SET_ONE_REG) while
>   the VCPU is preempted, the flag is set to skip fast path.

I'm a bit concerned that the need for csr_dirty makes this fragile. Maybe
some reorganizing/factoring of kvm_arch_vcpu_load() could be done in a way
to make it obvious to anybody that's adding another csr to be loaded that
they also need to ensure csr_dirty is set when appropriate? At least a big
comment would help.

That said, can we now apply csr_dirty everywhere CSRs are dirtied allowing
us to remove the vcpu->scheduled_out check? Unless I'm missing something
we should only need to ensure last-cpu and last-vcpu are as expected and
that no csrs are dirty in order to skip the writes - it shouldn't matter
that we're reloading after a sched out or otherwise.

A couple nits below.

> 
> Note that kvm_riscv_vcpu_aia_load() is kept outside the skip logic
> to ensure IMSIC/AIA interrupt states are always properly
> synchronized.
> 
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>  v3 -> v4:
>  - Addressed Anup Patel's review regarding hardware state inconsistency.
>  - Introduced 'csr_dirty' flag to track dynamic userspace CSR/CONFIG
>    modifications (KVM_SET_ONE_REG, KVM_SET_GUEST_DEBUG), forcing a full
>    restore when debugging or modifying states at userspace.
>  - Kept kvm_riscv_vcpu_aia_load() out of the skip block to resolve IMSIC
>    VS-file instability.
> 
>  v2 -> v3:
>  v2 was missing a critical check because I generated the patch from my
>  wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.
> 
>  v1 -> v2:
>  Apply the logic to aia csr load. Thanks for Andrew Jones's advice.
> ---
>  arch/riscv/include/asm/kvm_host.h |  3 +++
>  arch/riscv/kvm/vcpu.c             | 13 +++++++++++++
>  arch/riscv/kvm/vcpu_onereg.c      |  3 +++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 24585304c..7ee47b83c 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -273,6 +273,9 @@ struct kvm_vcpu_arch {
>  	/* 'static' configurations which are set only once */
>  	struct kvm_vcpu_config cfg;
>  
> +	/* Indicates modified guest CSRs */
> +	bool csr_dirty;
> +
>  	/* SBI steal-time accounting */
>  	struct {
>  		gpa_t shmem;
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index a55a95da5..f7f58f02c 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -24,6 +24,8 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>  
> +static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_former_vcpu);
> +
>  const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	KVM_GENERIC_VCPU_STATS(),
>  	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
> @@ -537,6 +539,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  		vcpu->arch.cfg.hedeleg |= BIT(EXC_BREAKPOINT);
>  	}
>  
> +	/* Mark CSRs dirty on hedeleg update */

Unnecessary comment.

> +	vcpu->arch.csr_dirty = true;
> +
>  	return 0;
>  }
>  
> @@ -581,6 +586,11 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
>  
> +	if (vcpu->scheduled_out && vcpu == __this_cpu_read(kvm_former_vcpu) &&
> +		vcpu->arch.last_exit_cpu == cpu && !vcpu->arch.csr_dirty)

Align the second line condition under the first

	if (vcpu->scheduled_out && vcpu == __this_cpu_read(kvm_former_vcpu) &&
	    vcpu->arch.last_exit_cpu == cpu && !vcpu->arch.csr_dirty)

> +		goto csr_restore_done;
> +
> +	vcpu->arch.csr_dirty = false;
>  	if (kvm_riscv_nacl_sync_csr_available()) {
>  		nsh = nacl_shmem();
>  		nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> @@ -624,6 +634,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  
>  	kvm_riscv_mmu_update_hgatp(vcpu);
>  
> +csr_restore_done:
>  	kvm_riscv_vcpu_timer_restore(vcpu);
>  
>  	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
> @@ -645,6 +656,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	void *nsh;
>  	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
>  
> +	__this_cpu_write(kvm_former_vcpu, vcpu);
> +
>  	vcpu->cpu = -1;
>  
>  	kvm_riscv_vcpu_aia_put(vcpu);
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index e7ab6cb00..88cfcb018 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -652,6 +652,9 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
>  	if (rc)
>  		return rc;
>  
> +	/* Mark CSRs dirty after userspace update csr */

Unnecessary comment.

> +	vcpu->arch.csr_dirty = true;
> +
>  	return 0;
>  }
>  
> -- 
> 2.43.0
>

Thanks,
drew

