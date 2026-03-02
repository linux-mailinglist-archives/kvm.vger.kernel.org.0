Return-Path: <kvm+bounces-72426-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAwlM7AOpmmFJgAAu9opvQ
	(envelope-from <kvm+bounces-72426-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:26:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F811E55F2
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B071230B604E
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B344C311957;
	Mon,  2 Mar 2026 22:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oD3V9X0G";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QF3auAEx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E59390995
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 22:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489302; cv=none; b=EIUqed/niewoVHd4dAtqMA5KjJwMJJpwS2VbWIhdb3aJ/BxAeKaSHy1Abas6DdIk9x+4FK13rGBZq2VfKMaXRCev+S2x5dfor6JKR/mXANswYUmwotbSC+2jzE96A0oBkk8V/6CGnGXeiXM4vlMtjtvQVERbLjnuud4tlDD8URg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489302; c=relaxed/simple;
	bh=clTABuQ5nWAgbKLYbTeDNgxmJ8oOt1MKo7+nBuDZHxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9d3QOaxcrXYDedmCaG8DZ4Nd1MlAuEbhpVKa19d69vyMgNhxlqXCv/Of25rUNd7YTW0bl4UdzOuU32qJfmSaPDj7HQo2mHOP23whPdeDLm2mdVsTPxT2/CmkHpCjCqSDiFiW6jBnBlIAsqVx2JfllZ+ItFlVpmBUbaPWA8dn2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oD3V9X0G; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QF3auAEx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622IVOQ73561527
	for <kvm@vger.kernel.org>; Mon, 2 Mar 2026 22:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=aFlTulkTiHRUNVyM0yuMIYm1
	zlj17kVnR05A3j3KKwk=; b=oD3V9X0GhEe5gFKThb2dbOb327G4eOVgVqX3P1wp
	dp/UZ86q8QykjGUFi6SsqRNxEb69gly/McwN7KNqkIBQBfxOqaBRAHCPChCxr8Wy
	HRrDp5APKjbi7PaJSkvCLgngOHHIdeGqPL/VBbSKoj8wEbn32+oAb22fGki2N9tE
	uckjZffASObUusEP+/pmBeHrC5mI21QPgWFLQ8EgF/IeIFacMIMCQ3G1dNHZMylT
	+22//KWD9fsMUpdOEP4RnqSzNjQjGeX8xse2Fe5dh4acv4rrWyYWG9DlE6KxOM0w
	jnXsQ/EJDFCQmuCDa59W4RFtrevm2tnR0JcjTrpUfCD6Dw==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn9bva4yw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 22:08:19 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-12721cd1a2aso57457972c88.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 14:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772489299; x=1773094099; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aFlTulkTiHRUNVyM0yuMIYm1zlj17kVnR05A3j3KKwk=;
        b=QF3auAExGeOd8kUoj7jnkabgQeQASG1athUim3hJ7EXLI7GX5JOWCd0sGRSn6YCJK6
         k2EDOkP7d7ylpAsZhzgUGJ7R0j2gu71Gm2wSceKZfgdCWKwMZKBHkl+trKAL1dc66i1N
         z2HW6UQvB728F9HrgN6B77pCpbNl4XP5eCo094V0g1BOHOv2Jahx5jH0ktMbs0z5HqRW
         lOjWUfI5smmpswtxUR1RVKPWzZmndTJGtWFXQE06ayQBRnX5xCrOqd0fVIoU+b8sqSzN
         HDy9/pdcpQHWPFkYhFzRxnjurJ7aec0q3oTfodSWrNnoqHiyAADud6EN08am02IBp9dj
         D8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772489299; x=1773094099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFlTulkTiHRUNVyM0yuMIYm1zlj17kVnR05A3j3KKwk=;
        b=TAQdIwBKg7uU/tClya4ZE2FPDZtiax61xf0853H8dUuFkQ6+mSWmFtp5ZuQ4CrlHFf
         YUfT294R0SFrmNdcR36RUd/SBYsTPlVdyL+FOVRIpakG7JxUX76324Bfxs+BQ5pF/Wum
         0+b/M3SYE3FyCjhwaJKnaD+PcK2ppGsT9v5Qf8v5hm0p+ZjwiEhJQ1NsW25Qo4LnMrOY
         /QDWbkUhIdfvlD+I42tGGJH+yzV/Vm/CGNAgAHp0wN8Wj8pHphszZrSzzcE9NJLGMVEm
         Any/VdTsXw4zvlLLlAtgFEYKrtGRy8JvyDVIc0h73FvkN+10J44FtVPTm7tazczWLr/l
         L0KA==
X-Forwarded-Encrypted: i=1; AJvYcCXWAQUZn5oO/5OBtlfMwbQuqPMLvEY0VHafs/sjrAM5zNiOlqfTLciw06KP0ChAy3AnprA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykk4XYNatLQlvvAJAMx4XFvZbtGz4k2wDNUd1GW7fyAyj81lhp
	Mt9RQ+AnSpYHFdCGKtUZqctsv2aXIKxzObQPWsyafdbZxBWxMIfA198CWpUfY9lyzOC3dEYo8+v
	n8RhB7c4W8dgarc1zCLK+jXnOtN0qU6zWkwbRh5fkqbi9vvHCZaJcvjg=
X-Gm-Gg: ATEYQzw0V3h75+6/TxaaT2SlRH3hw+ht+7QIv5enS20bHXRXqBIvaVR57Fh8zRAkrGC
	tvc0oV8DVn9qQQMFFGekjSg/GvZsXVUyuqOZLlfWE+cDzHkMvb0w3NMfUlKwKKNW01MTuPea4U7
	N1l+UWOs9guGIyFwBh6diHssgMNCI5vz/vaQgV8UrCix28OAeBbzXy1uIziSnuCKYCG+QQ9eN5M
	pp0ta4j1Ong2w8NOByVOYCCcDqJg77j+f48z9T1NOaewkFV6V0HxC6tJnDbTt40fjfhDmqWTefN
	vbTihSD9WdoMIEPLVb4wstKG0W4NgEQNtBrxk2d4n2psd6IheA3vJVWjH2Bh+XiMf0rss0rpbOA
	D5ihOhMrdSQCF/JbaAgEI9gosPb6Xjeo=
X-Received: by 2002:a05:7022:128f:b0:123:3461:99be with SMTP id a92af1059eb24-1278fcdfe04mr7472444c88.21.1772489298698;
        Mon, 02 Mar 2026 14:08:18 -0800 (PST)
X-Received: by 2002:a05:7022:128f:b0:123:3461:99be with SMTP id a92af1059eb24-1278fcdfe04mr7472413c88.21.1772489298167;
        Mon, 02 Mar 2026 14:08:18 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899dfc47sm18367820c88.6.2026.03.02.14.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 14:08:17 -0800 (PST)
Date: Mon, 2 Mar 2026 16:08:16 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
        Albert Ou <aou@eecs.berkeley.edu>, Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v9 3/3] RISC-V: KVM: selftests: Add RISC-V SBI STA shmem
 alignment tests
Message-ID: <xhcbisolsce6mbaoovxpzbsyqfdtptnny44uqbfcbte5udtg2g@wqgprootl7yt>
References: <20260228005355.823048-1-xujiakai2025@iscas.ac.cn>
 <20260228005355.823048-4-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228005355.823048-4-xujiakai2025@iscas.ac.cn>
X-Proofpoint-GUID: g6UsBrDTLnqqEvBKdHksaQyhdPsgyauW
X-Authority-Analysis: v=2.4 cv=S83UAYsP c=1 sm=1 tr=0 ts=69a60a53 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=9KHX6hOa5LuH6kksGFwA:9 a=CjuIK1q_8ugA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: g6UsBrDTLnqqEvBKdHksaQyhdPsgyauW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE2NCBTYWx0ZWRfX4RTybwL3Sq4c
 Pv3rORAR/B8sGg/6dUWjdN/ZleRU97knlRWNGUhi5xzZtoV8BdhFYtM16xYXkxjJCoA3eDKOlQh
 K0QA8m0ZhDx4It0Nnl5mk5Fe0n6Dy8nv13IiBt15bdE7G+kHx7OLFCUDbFUlaq6O5gRotbIHT6K
 Nsp0UHz2rEVR2r31wOSAre+9VgApRhImArhYRFKMhMzKRtko/W3dpN5HzG5kFCl5jMQm48Cr6S+
 hRnJf0BkUOmW+yr+hCSTod/MIsVEPWPcN7AKZ8NEQpiqsDYs0cqp+RGtNwgEO57XTmwp9r8cufl
 eL7kjbAyqTdJ3CUZz9/GICt4jdEwifg6eXn5Ok9O72NY/CHcnc6qpg+6WPZU4y10mxFEMDncqUa
 A5Zm4EZpiE8gVwaRjl7I9zFDM2QUuTMSrFLg1/b3KjQrw2skuZ7s8R/DiMXjEdZtPafIl4aOrli
 1JO/r/tt2TAiFm6OBvQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020164
X-Rspamd-Queue-Id: 51F811E55F2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72426-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,oss.qualcomm.com:dkim,reg.id:url];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

On Sat, Feb 28, 2026 at 12:53:55AM +0000, Jiakai Xu wrote:
> Add RISC-V KVM selftests to verify the SBI Steal-Time Accounting (STA)
> shared memory alignment requirements.
> 
> The SBI specification requires the STA shared memory GPA to be 64-byte
> aligned, or set to all-ones to explicitly disable steal-time accounting.
> This test verifies that KVM enforces the expected behavior when
> configuring the SBI STA shared memory via KVM_SET_ONE_REG.
> 
> Specifically, the test checks that:
> - misaligned GPAs are rejected with -EINVAL
> - 64-byte aligned GPAs are accepted
> - all-ones GPA is accepted
> 
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
> V8 -> V9: Dropped __riscv guard around INVALID_GPA, which is common to
>            all architectures.
> V7 -> V8: Moved INVALID_GPA definition to kvm_util_types.h.
>           Removed comments in RISC-V check_steal_time_uapi().
>           Corrected reg.id assignment for SBI STA.
> V6 -> V7: Removed RISCV_SBI_STA_REG() macro addition and used existing
>            KVM_REG_RISCV_SBI_STA_REG(shmem_lo) instead.
>           Refined assertion messages per review feedback.
>           Split into two patches per Andrew Jones' suggestion:
>            Refactored UAPI tests from steal_time_init() into dedicated
>             check_steal_time_uapi() function and added empty stub for
>             RISC-V.
>            Filled in RISC-V stub with STA alignment tests. (this patch)
> ---
>  .../selftests/kvm/include/kvm_util_types.h    |  2 ++
>  tools/testing/selftests/kvm/steal_time.c      | 31 +++++++++++++++++++
>  2 files changed, 33 insertions(+)
>

Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>

