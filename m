Return-Path: <kvm+bounces-71675-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDQbDhYinmnWTgQAu9opvQ
	(envelope-from <kvm+bounces-71675-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:11:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E19518D0BA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 027FB303744C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF5133D50A;
	Tue, 24 Feb 2026 22:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RNBG68nO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="H+1EJFKg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8433BBD9
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771971079; cv=none; b=PFcZSWAPYd6Y5tnot+ZzfFRiUBblOs+9Hw2QJ+8hvzLlhIjJo/ZjrY0BzUe4/orn0pmCKaTdpQZDd0rKFv4r5CVNHh8LinTWX/ypKvIzGQ6PHU5Oy6aRhgGOjw8g80OFHCRhdfx4yMJaDn/WfKdBtLBgfC/C4IDVufA7e7fwRhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771971079; c=relaxed/simple;
	bh=G26Hr1tAV2jes/iTZMbRbrI1WvP5GQJo5U2I+/W9Cgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdS6ju78C8xOE208QiTLy7feNQbA/sVDs/azrIIP+KJIGvxYO0DFQxy90CkscXpe0f9EWZ32Tz1KwY7w9vpvm2RtJY/iWLnr9o5e3Y0QLEgsb8oiIY061SsrlGMPkjUS25Z5955a9uMsL8nTWIOODDzPr+/LGS34BozmVXkt6ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RNBG68nO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=H+1EJFKg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OHquaB057785
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=MpuMHOd/Hug9XUMO7ooIdgJu
	G+bQRgf3rD7wfYuWTIk=; b=RNBG68nOWtnkct3pLRXTzFwfqNxyv6vii0G7syYk
	Gc23n86pTdRvIWxNUEXvkzXkaElzJNwoVgMVMtZxbx/E/NeGYlgOznoziDx4Sa5w
	zUpAVvy1V9/L9vWn9jzWTQt1Z5pFvztLL6/hc/IIFpqjXXBbKgy8WkfMO0Ng077J
	5vX35Q9PL64/QejwiMXAGeocTONi4cpet6wS+cGKiaZtO5IxeMhaipCXReiEFTJx
	P4VwUh1HghI7bHRP9SxSPgez2JoRwR9VjBi1gvTlNQN9ahpCvRx52lOTgIGwDqky
	fvdWqraP3OWQbGkde2q56uMrrp4NJNllkbJvo2LiZzeNnQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ch9saacjh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 22:11:15 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2bdc1b30ac8so1965081eec.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 14:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771971075; x=1772575875; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MpuMHOd/Hug9XUMO7ooIdgJuG+bQRgf3rD7wfYuWTIk=;
        b=H+1EJFKgumdYgVfsYN/YU506Gnz/dh3rgfvC0NgIdikvviPkS8vYM9hmbm19g9Gheg
         TcbHicxnzzAEW+YY1z61XCntiRWE1hRuUherqvY/JLG5PYoY33g/Cr9E2ATrQd8tYT7Z
         YxtL9rlycCNZ4qz0POFQZSXE3fQfx25gevbJhtwqIQ+Sf5VD6HlI/n44l2fvb0SoLnIH
         mBJdsRfceoIDs0NcYVvEKsU/IWx0aMOGfI41pl9q5WGYEURXmKIpTKzr9v4jEUUZR8tp
         PRRli/Rx58DAFskz0Q3q0HBZAzjnmD74ZgifjM5BRBqcrdbszJuXFK3Tey7FX8Pxarh9
         yrFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771971075; x=1772575875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpuMHOd/Hug9XUMO7ooIdgJuG+bQRgf3rD7wfYuWTIk=;
        b=QKV3W/tv4DwLeVGzbM8Q3YWaHcjq+dLp00XkQ2MfHBs2X2wW0R/ZTRNcUG4FLNq5zW
         f3JI8uWUJ5ZX31kCF+x5k1qb9vCge9W8M+oOTuvyg/d/C5ijRioS21a0TGInccwhaHOc
         vWU1IB/Uy4sB68H6W/t7crcmILTZ9X1QOZBgKX5IY5Vmi+1qGlpjJntl+oDIdNg2DPpT
         t06oVQjhL5ZwTgpBVlmQ9FDYGG8+xN4T4bEaRm611kRje2XYnwqadYMOMwPam3ahneKN
         HBxS1fcF1l49EgoNvTop//BuEZnFhHcntBiELngS+GW16WXPgTMWeyB/0zCpqt7IeRed
         JxOA==
X-Forwarded-Encrypted: i=1; AJvYcCWQlWZK+YbQoAk3orJbFUHV/fW2bzmdXqOSIAx3lintXWUHEWvifH1iuQyKf77iNqMF488=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/YIMlm7V5gMuXYiT5qV+rLN2MMZjQ9QisFRODtJpFfDZPjMpP
	PzXm3xWM6yRA8DoaKvhiGFEg7jInmFJC8Yu+eMJTclGGp7HsMmD63d/KVbSqZAI10soc1G7L7AB
	7cspTe9KueoUK98gMDPCyb4WSiaT5zd6kH2mL5CljN0ENjl6qPYpjJNY=
X-Gm-Gg: ATEYQzzCuZ0TA6UKmQCRiZLoS7g64JQvaHccm8I2P4lrOMMpjOC7u/PzFvpr9H3lyfR
	lTtvQOA1Dh05XvJfAJQ1YmU79RfZN8wwycwn3fOqD6pgSaaa5h2QiUqZ6auvIVADMdC4Ty99wTc
	Sfx7UlvWLeQdT802uSldLp5Evw30+ZwL5fPZMt2dPujH1ksfu9gon7F/IwtjQ0MmTWTrpcGeNdR
	mHs8xIgVcH10MWc5d8/WKADysMReANPnETNBEW4EU7VdeloFmGFXRkV/lI2Ue+KdKTn7ALMno6l
	b+3QvcQGGaaybM2ozf5oxrvVzgEkGxgSECbTeE/gZ+c7cM/Vf7bjDDRQoFhCn1VVs05b7itQUar
	L8s4MmuUNriU2uQKvoslNrnUv0HKbJr4=
X-Received: by 2002:a05:7301:9bc5:b0:2ba:a0c6:ef5d with SMTP id 5a478bee46e88-2bd7bd2a538mr5920106eec.21.1771971075057;
        Tue, 24 Feb 2026 14:11:15 -0800 (PST)
X-Received: by 2002:a05:7301:9bc5:b0:2ba:a0c6:ef5d with SMTP id 5a478bee46e88-2bd7bd2a538mr5920085eec.21.1771971074444;
        Tue, 24 Feb 2026 14:11:14 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bd7da47778sm7770942eec.6.2026.02.24.14.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 14:11:13 -0800 (PST)
Date: Tue, 24 Feb 2026 16:11:11 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kselftest@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v7 2/3] KVM: selftests: Refactor UAPI tests into
 dedicated function
Message-ID: <bo356uh554twpg2jateqth7rqi7g6uoc26kao3yekcukitg6wc@eeyd2qdjpgff>
References: <20260213103557.3207335-1-xujiakai2025@iscas.ac.cn>
 <20260213103557.3207335-3-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213103557.3207335-3-xujiakai2025@iscas.ac.cn>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE5NCBTYWx0ZWRfXygS8HgZo07RQ
 vUwMTXg8lXcSWB4IzaG7z6cPuiZy+EHAhZ5DIwRL0AMlVmxjNoSI89fi6B5Mk5q46PDnB0LI4nt
 fAdFwnyHenqCFG79Ukbzbdyy4ZE8pxhaRHfP/mA5OvmjlL5L1qZngiofD/d2dELaYOaK3NCYB1+
 Po+yz7bnaSxLCxe/0jM6fB9sSxDxV7F2DScVgB5wTaRYYtMWv5ob2Z8QgN45NEy5IObG9gVyfK1
 XUTifEzpN/tEXG21X+l4H2Hw/KcwKGKYMx64R50ghAfO5pt6NPfRAmJGKpP4SYKY1Pci49ka9Al
 wh50bXaxnccLY7DNJLzasQm7qkG7QOGQtVBBU5H3hs9S/0wuzUsS0XHjw5dUZvS1birUPzT+No1
 tUr7XMKzSxel0qfW9D1p7WuTCxcijSzHoO9rxmCPWGxYMEWkT36zpzNOIZshmOYT+BI4tZuW+66
 RF+jBBu7Uf1yg2xhUYg==
X-Proofpoint-ORIG-GUID: nNltBCUFoCcRFFADNwj0AI2rSCQCROwO
X-Authority-Analysis: v=2.4 cv=e7ELiKp/ c=1 sm=1 tr=0 ts=699e2203 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=HySIa_1SWE6k9wrxFvsA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: nNltBCUFoCcRFFADNwj0AI2rSCQCROwO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602240194
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71675-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,brainfault.org,linux.dev,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,ventanamicro.com,redhat.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oss.qualcomm.com:dkim,iscas.ac.cn:email,qualcomm.com:email,qualcomm.com:dkim];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 8E19518D0BA
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 10:35:56AM +0000, Jiakai Xu wrote:
> Move steal time UAPI tests from steal_time_init() into a separate
> check_steal_time_uapi() function for better code organization and
> maintainability.
> 
> Previously, x86 and ARM64 architectures performed UAPI validation
> tests within steal_time_init(), mixing initialization logic with
> uapi tests.
> 
> Changes by architecture:
> x86_64:
>   - Extract MSR reserved bits test from steal_time_init()
>   - Move to check_steal_time_uapi() which tests that setting
>     MSR_KVM_STEAL_TIME with KVM_STEAL_RESERVED_MASK fails
> ARM64:
>   - Extract three UAPI tests from steal_time_init():
>     	Device attribute support check
>     	Misaligned IPA rejection (EINVAL)
>     	Duplicate IPA setting rejection (EEXIST)
>   - Move all tests to check_steal_time_uapi()
> RISC-V:
>   - Add empty check_steal_time_uapi() stub for future use
>   - No changes to steal_time_init() (had no tests to extract)
> 
> The new check_steal_time_uapi() function:
>   - Is called once before the per-VCPU test loop
> 
> No functional change intended.
> 

Suggested-by: Andrew Jones <andrew.jones@oss.qualcomm.com>

> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 63 ++++++++++++++++++------
>  1 file changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index 8edc1fca345ba..a814f6f3f8b41 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -69,16 +69,10 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
>  
>  static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
>  {
> -	int ret;
> -
>  	/* ST_GPA_BASE is identity mapped */
>  	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
>  	sync_global_to_guest(vcpu->vm, st_gva[i]);
>  
> -	ret = _vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
> -			    (ulong)st_gva[i] | KVM_STEAL_RESERVED_MASK);
> -	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
> -
>  	vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENABLED);
>  }
>  
> @@ -99,6 +93,18 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  			st->pad[8], st->pad[9], st->pad[10]);
>  }
>  
> +static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
> +{
> +	int ret;
> +
> +	st_gva[0] = (void *)(ST_GPA_BASE);
> +	sync_global_to_guest(vcpu->vm, st_gva[0]);

No need to use st_gva[] and sync_global_to_guest(). For this test we can
just use ST_GPA_BASE directly.

> +
> +	ret = _vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
> +			    (ulong)st_gva[0] | KVM_STEAL_RESERVED_MASK);
> +	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
> +}
> +
>  #elif defined(__aarch64__)
>  
>  /* PV_TIME_ST must have 64-byte alignment */
> @@ -170,7 +176,6 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
>  {
>  	struct kvm_vm *vm = vcpu->vm;
>  	uint64_t st_ipa;
> -	int ret;
>  
>  	struct kvm_device_attr dev = {
>  		.group = KVM_ARM_VCPU_PVTIME_CTRL,
> @@ -178,21 +183,12 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
>  		.addr = (uint64_t)&st_ipa,
>  	};
>  
> -	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
> -
>  	/* ST_GPA_BASE is identity mapped */
>  	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
>  	sync_global_to_guest(vm, st_gva[i]);
>  
> -	st_ipa = (ulong)st_gva[i] | 1;
> -	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> -	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
> -
>  	st_ipa = (ulong)st_gva[i];
>  	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> -
> -	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> -	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
>  }
>  
>  static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
> @@ -205,6 +201,34 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  	ksft_print_msg("    st_time: %ld\n", st->st_time);
>  }
>  
> +static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vm *vm = vcpu->vm;
> +	uint64_t st_ipa;
> +	int ret;
> +
> +	struct kvm_device_attr dev = {
> +		.group = KVM_ARM_VCPU_PVTIME_CTRL,
> +		.attr = KVM_ARM_VCPU_PVTIME_IPA,
> +		.addr = (uint64_t)&st_ipa,
> +	};
> +
> +	vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &dev);
> +
> +	st_gva[0] = (void *)(ST_GPA_BASE);
> +	sync_global_to_guest(vm, st_gva[0]);

Same comment as above.

> +
> +	st_ipa = (ulong)st_gva[0] | 1;
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> +	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
> +
> +	st_ipa = (ulong)st_gva[0];
> +	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> +
> +	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
> +	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
> +}

Hmm... don't we now fail with EEXIST in arm64's steal_time_init() for i=0 ?
I think the only way to avoid it is to create a temporary vcpu for the uapi
tests which gets thrown away before creating the vcpus for the steal time
tests.

> +
>  #elif defined(__riscv)
>  
>  /* SBI STA shmem must have 64-byte alignment */
> @@ -301,6 +325,11 @@ static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
>  	pr_info("\n");
>  }
>  
> +static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
> +{
> +	/* RISC-V UAPI tests will be added in a subsequent patch */

nit: no need for this comment.

> +}
> +
>  #endif
>  
>  static void *do_steal_time(void *arg)
> @@ -369,6 +398,8 @@ int main(int ac, char **av)
>  	TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
>  	ksft_set_plan(NR_VCPUS);
>  
> +	check_steal_time_uapi(vcpus[0]);
> +
>  	/* Run test on each VCPU */
>  	for (i = 0; i < NR_VCPUS; ++i) {
>  		steal_time_init(vcpus[i], i);
> -- 
> 2.34.1
>

Thanks,
drew

