Return-Path: <kvm+bounces-72427-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KgeH0sXpmkCKQAAu9opvQ
	(envelope-from <kvm+bounces-72427-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:03:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E621E63AE
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:03:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3EF131314CA
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8333731C567;
	Mon,  2 Mar 2026 22:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O2l9ikoS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LLSG5hvV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84987390982
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489933; cv=none; b=SA6k9s5kMXkixv4Lo4k9Rtp+NqZbLu1JbIA+TT5gMRZDzM8Gn4BUILuG504EdGXo6Oir6PpJOrri4ep0QXiQCU/ZIjQFnUeb+evzxGHMdui8SxaooMXMtNmHkyYzS1/7eZYEcpyHAKqc2yGIRXfCv/SNaRudeeVusfMieSWCI7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489933; c=relaxed/simple;
	bh=EZsJ49Ewww8UnP2671jWLKEusF2TLYFcEBSnlhxV/P8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEeQIINOZQ/V/ZKzJw3nPMxFXNHCh1P4CKRn/WSEYHkO/vaVKQuZZ85Z63yBEOu/zGHsu5OTQAg1gThEM70KajCe57KVSnAGAcWfplQRQwv08u+yt/ldlPfqxUnRQnSRMaGV/5DwrhVgi/wss428qlwuSiG4NIx0khIN3ham8sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O2l9ikoS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LLSG5hvV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622G86aF3741985
	for <kvm@vger.kernel.org>; Mon, 2 Mar 2026 22:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5jzi6xUspl1H57VMYdStLRVZGkZtz1A2ALKD/Cg0yxQ=; b=O2l9ikoSTWGNyUIC
	/RkMVl/Ty+P1I4fF5G0pQePsr6Cj0YMA/Hr8hfBW5Tu91owY7AYzembkG9zO7kQu
	ueiBYCTHS4EEjQ83hxmKG8fVLsE8pg+NGW1jzZL6Q5SyfyEyGe+m8J05AdTml5Ji
	vla6qPm1eZTWKJ7FcbqrRZLzkHVNZWI4i0UvTEdj6vkCfJ9pzLd5bqABqrxkVwBf
	cpXvqlwHdeS4GoptiRS1jFR34/NWGbp28JY20w2NJFSlLotkQdAXudR8Zf6KMFtV
	lRS58rwBelV1Mp8zq+zvolVB3vg6KEn7V949N+Hp0GrghZBLYIDinBSlER57fthl
	HKh6+w==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7trjh8j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 22:18:51 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2bdf75bc88fso2001996eec.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 14:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772489931; x=1773094731; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5jzi6xUspl1H57VMYdStLRVZGkZtz1A2ALKD/Cg0yxQ=;
        b=LLSG5hvVnnEcq2+Te+9HTi/3/o3475DcINszFdDp+GMHwp9KBozE2BPKfhbAhyu9do
         vcSPxaCZ2HGJ4TfyAbzAJIpe9AujcdYzYTO1rPyyYZGITSNTswDZ63+3kQOKCHACfAaF
         YyBHMvh1qRCx7wBk1FW8PH19C654HozI2FVH0tMJx292iVKRAT+45TE76IBs3vuozh59
         rfolTubdIbvLP4YEdagz6A+yUUydqKvfXix9asutDcKt23twiniSV7kEfW7y5x5f6ye8
         KZMGIZUM2Ig/+yOIb+vuq64E7aa08V2S/b8IxDE5nvk+I9bD6anlBCNtTNlxJaOm9XKH
         xMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772489931; x=1773094731;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jzi6xUspl1H57VMYdStLRVZGkZtz1A2ALKD/Cg0yxQ=;
        b=aH7lshdyoHxAZii5Z76uwTz1Fy9AGywnbaETjvUdAJHHW5OpherBVZyjvKxqscj/1A
         qCddrtqY9vg1L3NhSfMP3SgTHzh/CCryKL2wrrNUnPNEoJeRceejEkJeAMhEKjU8hjDF
         NDsv5taggg+nOjdy8HJRLoJTo+0BqYdMBm3AQjCNNtKtaDMN4P3PgaSskKb5KhVLu8mz
         yfBtOU1NkeDPZFDvhicZeIwZ+qBbe9mf0jAglqaIEI/3e+XyBRHoBnTU4KVFFJlc9ID1
         pjKnr9G2frC9NhPcOoY9WsGW10STPoHeXoZd+zuodTLi7SJYIIVSBLfglPnV+W7wQMto
         fFOw==
X-Forwarded-Encrypted: i=1; AJvYcCXPleD1f1joL1MnHOOmxF7Ppoi2M6d9n7IiOm4+mv1fFSA/QDrXfnsbHsO4lkgH2XdzCQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRsgs/U0yZb+9t05fYfoNTL0HY+09RrQEDizOqXFBTyb5O1DIM
	XCF6kDSzO/4u56KL6704ldKfLabqlkBlDWjcgV3rILqh/kAdJA4HcM3I6sG9c/Q08HWw2ISX6CN
	yFFWnSC2u18Dhvu20G9WYgVC73NNVc4+5bwa1tBXxHi9RJ2HtK552H7hqktZOzLo=
X-Gm-Gg: ATEYQzzTcxyzvgQJT5F+meu3WA2oi6aqgEIzUxsCG0PNMgvQF3tfoPWQCKV4Nrdp1Ac
	Z3J54RTXHEXWdxfKWZqRS0wRFUAWwI1bSAckwfBMtqM4m7WQpeBbCqcxxAsfF7ukN/JjmRpni4S
	EhELQwQdAv/78Hj2Oo/Xg0j2GIlOn21jL9l4XR+88Ny6G74xvjijhYgH00U+eSVweDAmcyxlj74
	FsCGCWSRdkONJ47ME5nYN+WWl0w3gqqeKIDJztCTsS/tgv0T7S9HF56WQd/IQnNj8VJAiUDzZ7H
	tSlT9/ExwMdf+8gaIxv6Hx45deo08+giKboFXcEcBbMwkvXbchPLc6hEO1CEIzLgIPgAl/G4Cr2
	b0sCGZnKxS/dKsyvdssAueGYgWk3nkGM=
X-Received: by 2002:a05:7300:7309:b0:2ba:8496:498 with SMTP id 5a478bee46e88-2bde1ba0474mr4470658eec.7.1772489930702;
        Mon, 02 Mar 2026 14:18:50 -0800 (PST)
X-Received: by 2002:a05:7300:7309:b0:2ba:8496:498 with SMTP id 5a478bee46e88-2bde1ba0474mr4470647eec.7.1772489930109;
        Mon, 02 Mar 2026 14:18:50 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdf662eb6dsm7239828eec.2.2026.03.02.14.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 14:18:49 -0800 (PST)
Date: Mon, 2 Mar 2026 16:18:48 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jinyu Tang <tjytimi@163.com>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <radim.krcmar@oss.qualcomm.com>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
        Conor Dooley <conor.dooley@microchip.com>,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        Nutty Liu <nutty.liu@hotmail.com>, Paul Walmsley <pjw@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] KVM: riscv: Skip CSR restore if VCPU is reloaded on
 the same core
Message-ID: <24ev3x4ppteznxfdunzzcl5ra3n64oikjxbnuj2dqhwlvuu52k@aiujsgdy2nsk>
References: <20260227121008.442241-1-tjytimi@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260227121008.442241-1-tjytimi@163.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE2NSBTYWx0ZWRfX2K8WOXlVzami
 Gy5xsTYisPQdEsNRrcL40O0+X35GRWZUw8LgwIcGaLOMleV94TVIarzcOmEwi/leRfxlc5xHw4m
 Wx2CVD/OHLLzeABE2ix+gRd3kYSOe2+5C50AcR91PeoCrrTSVqPetmye4szpb8ACgrRA4JIQKoU
 5d2C5w3bmMSSv7OUgHogtv+EUpOrLsrUo35oAYw3GMs7UCaHYOUo64znhKvktuo1t3S1O3BSNrZ
 vM9f5rMdSVctZfvI5jAv6ozRxXrHsir90TB3P0FTxAXAnENAZ+iEsaTlY1MYS8r1NqOdwaMWpJz
 yZQ1el/HmyCKyBDVz9Si2WIobIApp5SBtd5lWhMvru6XavsKkHZTLLHA336gREDRWtWVSnyydH8
 rxM+qsdCIOyGn0x6J+chrHu7tTUHkcDvtkABQ7kjy3LwQBhaKn3Iz5mAcfVK/OCkU89ekNewjh6
 wMV/obGpfG9ZOZ76f9Q==
X-Authority-Analysis: v=2.4 cv=TNhIilla c=1 sm=1 tr=0 ts=69a60ccb cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=KQEVWjvnPtaqH-4Khw8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: ISTKolhmcxvbAQC7mrmu0WRY5-ivMjs3
X-Proofpoint-GUID: ISTKolhmcxvbAQC7mrmu0WRY5-ivMjs3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020165
X-Rspamd-Queue-Id: 22E621E63AE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72427-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[163.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FREEMAIL_CC(0.00)[oss.qualcomm.com,brainfault.org,linux.dev,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr,vger.kernel.org,lists.infradead.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,oss.qualcomm.com:dkim,qualcomm.com:dkim,qualcomm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.992];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 08:10:08PM +0800, Jinyu Tang wrote:
> Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs,
> HGATP, and AIA state. However, when a VCPU is loaded back on the same
> physical CPU, and no other KVM VCPU has run on this CPU since it was
> last put, the hardware CSRs and AIA registers are still valid.
> 
> This patch optimizes the vcpu_load path by skipping the expensive CSR
> and AIA writes if all the following conditions are met:
> 1. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu == cpu).
> 2. The CSRs are not dirty (!vcpu->arch.csr_dirty).
> 3. No other VCPU used this CPU (vcpu == __this_cpu_read(kvm_former_vcpu)).
> 
> To ensure this fast-path doesn't break corner cases:
> - Live migration and VCPU reset are naturally safe. KVM initializes
>   last_exit_cpu to -1, which guarantees the fast-path won't trigger.
> - The 'csr_dirty' flag tracks runtime userspace interventions. If
>   userspace modifies guest configurations (e.g., hedeleg via
>   KVM_SET_GUEST_DEBUG, or CSRs including AIA via KVM_SET_ONE_REG),
>   the flag is set to skip the fast path.
> 
> With the 'csr_dirty' safeguard proven effective, it is safe to
> include kvm_riscv_vcpu_aia_load() inside the skip logic now.
> 
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>  v6 -> v7:
>  - Moved kvm_riscv_vcpu_aia_load() into the fast-path skip logic, as
>    suggested by Radim Krčmář.
>  - Verified the fix for the IMSIC instability issue reported in v3.
>    Testing was conducted on QEMU 10.0.2 with explicitly enabled AIA
>    (`-machine virt,aia=aplic-imsic`). The guest boots successfully 
>    using virtio-mmio devices like virtio-blk and virtio-net.
> 
>  v5 -> v6:
>  As suggested by Andrew Jones, checking 'last_exit_cpu' first (most
>  likely to fail on busy hosts) and placing the expensive
>  __this_cpu_read() last, skipping __this_cpu_write() in kvm_arch_vcpu_put()
>  if kvm_former_vcpu is already set to the current VCPU.
> 
>  v4 -> v5:
>  - Dropped the 'vcpu->scheduled_out' check as Andrew Jones pointed out,
>    relying on 'last_exit_cpu', 'former_vcpu', and '!csr_dirty'
>    is sufficient and safe. This expands the optimization to cover many
>    userspace exits (e.g., MMIO) as well.
>  - Added a block comment in kvm_arch_vcpu_load() to warn future
>    developers about maintaining the 'csr_dirty' dependency, as Andrew's
>    suggestion to reduce fragility.
>  - Removed unnecessary single-line comments and fixed indentation nits.
> 
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
>  arch/riscv/kvm/vcpu.c             | 24 ++++++++++++++++++++++--
>  arch/riscv/kvm/vcpu_onereg.c      |  2 ++
>  3 files changed, 27 insertions(+), 2 deletions(-)
>

Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>

