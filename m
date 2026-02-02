Return-Path: <kvm+bounces-69878-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJAuMDPTgGmFBwMAu9opvQ
	(envelope-from <kvm+bounces-69878-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:39:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17217CF11B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 17:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FE1730804C7
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 16:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0BB37E316;
	Mon,  2 Feb 2026 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H0aD1Tdx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="diZy6dQD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AC237998C
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770049894; cv=none; b=IS/yggYj1J33UwoyoIln6SH8s3DwjBn6Gr1ss3XZW9jwsI2TlF7kckw3Wqxe4B9SnQMpHqAxMxYYNqy8M+AzHE1H+Qx9ggovaHJ24d7N79e5Phyw4jDmT2hs0ucNQX6sbL2N3OuQNaRyGF8ZpcBrBsLygS9ZgGFDRkHjrmaZzrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770049894; c=relaxed/simple;
	bh=jACKelaig74D+y+Ulqe+158R86o6QVuVVW0cAl4t8/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFvDWh7orubC5rUo8g236cKBczzlewGCctv2eS4z0zDgdlL11xopjddOUuqdBWet65ND4pjr3RLBN11XilWxDoFS8WkK83Ro7JPaqZtPZvN7PiQ/cThJa6AbJsdyJRd2c3DP2eG89rrsnIKFftHbxSGVIobkiGEFrEJ7i1Xbz0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H0aD1Tdx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=diZy6dQD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612CJSST2884358
	for <kvm@vger.kernel.org>; Mon, 2 Feb 2026 16:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=eTpxpJLfJ8cj2Yer+m230biy
	2Ugzgu3eLhQ6MAn7/Yg=; b=H0aD1TdxU3ROBS+Dk3n49fvNaVNdzl1HXpx32sgB
	17Iu02FVFeS4Y2dAWxrBxUAHl+txY6kJBe5J34T6Nv9MDG1vQgq81sN+VfbtK7Xl
	1LMhRrniXNA1FLoK4apBSVgk6vI8t6q2pnMpXKInbjnnFgDx/l1ycEXVUkGWosYc
	S/8IKdhJpeCPe/ih3kVoCdpXYh6vrk3rKCCmURY+o6hDqaQoVVGmT7zcXV++yxSt
	eg/L6K+tzkdaeZljm0t/R/3MGIT8jiA2dCAJayuorPkWzuCEAKr34CcwFqm1/QCL
	WIaEpwtnQNgMulownNMgayZCMl6dKUsoBYkz8GCDNgAwIw==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2uu3grcy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 16:31:33 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-124a978ba9bso5321538c88.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 08:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770049892; x=1770654692; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpxpJLfJ8cj2Yer+m230biy2Ugzgu3eLhQ6MAn7/Yg=;
        b=diZy6dQDaxoCoVISM5R8/OfLbnDv/24pB6+mCMyzQK57R+Y0mdwyZbus2Orwsj6mMB
         FtxhX1woGCuj2jyUQ8X0N6fZUzf4QHkI85GBee4ENQ/F8tQyooDaC2Zvv+ZvbqcwP41W
         ceWqqXH8fj0wtxg+RBPAN2cyCyew0dknIryiUh34auow7Ly3W3aKg6AKoJcu2bOzEzMD
         cUW6N3JP4Oo0x5S2ZMfBBhRthB+26B0Lq9kKkW2AlPbsrljDHGaCZRJM5CQl0CGphayM
         kY0AJ/4wXzWVbdz97FaLsXPpdCU6ZL3VypJMIgpe/g/fcQ0sQGSTIF+DeR27ijAYrw+T
         1n6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770049892; x=1770654692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eTpxpJLfJ8cj2Yer+m230biy2Ugzgu3eLhQ6MAn7/Yg=;
        b=Vt8xuVaC+lXdCexMbCX/nqWVXbiR/IO8Khrbstq++E2JRXCHm5lR32WNgU26KYkCLw
         TmOXEnAKy1gzTW155j4/wMyRop/TJxgtIhvEq3hl1xvkozSQYDTlLd5U2nY/lf0EQveo
         MxoUSP00GMr2USE6pvHivk467SNXW2cnNBs2u2NI88gGwm5VXBdiX6RZoBUQm0FBlq6B
         BMMzULMu1ygg9E0L+w51NtpQv4FDeey8Io8cvNmp7UX6BTvO6fiCCnL6puiPPcgowvvH
         69i0RmspGlDYpE8QHH70iIqA7vPjEHpGJYVew1creXHeGmkH4XbctTQ2eLExOkdekor8
         zSIA==
X-Forwarded-Encrypted: i=1; AJvYcCUGqD3fSueX3yVE5p2VPHngY7VcNUa9SY8lwwJQjGmpr08FIElBc4tstgAzCnRDq4vRrNM=@vger.kernel.org
X-Gm-Message-State: AOJu0YypZtUrMxEKLPG3otsBlJfo7Hdd/ljQvYHjjcw5V3MOlD5S0xcm
	lkf/FpquCVBnwgqleYxk0yJfeR+hqv2Ztsj1Z/igv89IOXg/oGVFK4lO40Fr5FLzd1f8mE/Ab1X
	hrT5NQytW1v+9UshAfvrx601LNfJ6qAKxOR0FQolL2GtlrqO37fTKWCc=
X-Gm-Gg: AZuq6aKYDP5gSnDydbK3SZoSigb2ehcWQqckvy1BznncWV71hS+0YZbz+qAba08IlyI
	dY47UFBRnYb9qmB2jM+UsgWnjoLJ75RSN1w+7vX5VaUWYHsZWgWrg5A+MnY1O1PELjIUKVEj0Oo
	jM1/M/Mqees3zfou/yIotRV38lHd8nYdJenMw5+KvAaT+xUflTmSe2tXxKC0d85VDc6xGEtRWt5
	4I6hEYFb0I/516ekhgr1c+vbA8LsE/cZhSfm2jaTPd7Lqn9E2TJS5BGm4YEAy1SlkRvnrgQGyFu
	55ErPTcNiKILiYrGmJAMmFWEnDQu0n+dZVpd/re7auFK6MbkU3hBKooOC1PhKQHV1OVUchPNgB9
	nOmO1dCvJU5Sj6T8YnUg=
X-Received: by 2002:a05:7022:2481:b0:119:e56b:98a7 with SMTP id a92af1059eb24-125c0f95953mr6050913c88.14.1770049892258;
        Mon, 02 Feb 2026 08:31:32 -0800 (PST)
X-Received: by 2002:a05:7022:2481:b0:119:e56b:98a7 with SMTP id a92af1059eb24-125c0f95953mr6050882c88.14.1770049891645;
        Mon, 02 Feb 2026 08:31:31 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9d7f789sm17569743c88.6.2026.02.02.08.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 08:31:31 -0800 (PST)
Date: Mon, 2 Feb 2026 10:31:29 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Andrew Jones <ajones@ventanamicro.com>,
        Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>,
        Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: Re: [PATCH v5] RISC-V: KVM: Validate SBI STA shmem alignment in
 kvm_sbi_ext_sta_set_reg()
Message-ID: <h5ywmsqp2eysyslvh7zmuiw3mzthkiilgqv4gvjvpl6nejxs7m@ahjmnsz2c2x3>
References: <20260202003857.1694378-1-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202003857.1694378-1-xujiakai2025@iscas.ac.cn>
X-Proofpoint-ORIG-GUID: bJwE5I2OxmykWL8JivBIcsXiOG9g2RZU
X-Authority-Analysis: v=2.4 cv=OrRCCi/t c=1 sm=1 tr=0 ts=6980d165 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=sM2csZlYJ7vdm-W6c3UA:9 a=CjuIK1q_8ugA:10
 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-GUID: bJwE5I2OxmykWL8JivBIcsXiOG9g2RZU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDEzMCBTYWx0ZWRfX3FatYpFJ0F8d
 idOo8p2ffJQrrylDAtVnKlm9i/hg9mVMZqHxrbjouuvt7I/zdkzvoCiNhFqi0A4inGKZufT+Q6B
 QBQ5La7wp8qaKoBEjuxfAyKrbQ2WYmD+lVNcrplJwMrDaYxVEBa3eqvZIPiUp/QeRHi+UqWIera
 uD2V+m+qB+6eBUodGHnSSPd5WNBXt9OgN3baAKjJlyNg27gwLUuCygbcdqYfOapbPnugoUKM/Dh
 J1iQF6zPsQWYVMno775GEKv0M/npT6VDCsF48aM4mLdwGWSkRSUIVj4UyZAm3hZUDYa4ZQnkmR9
 mUOCanG97087laIEDLjMH7ytshz2UaPR+0oomQ9zQEKLL8h3tKPIZSH7uMX3NeQT0eknaAV7G0+
 JQviZ+2zgji/T5XAreoj9CilpmFWs/q782rpR0QYP8f4y+XXfLPdZToAclAjI5Fvhu+0HTkjx8H
 aOgsg1tfZejMfHPXpuA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 adultscore=0
 malwarescore=0 phishscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602020130
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69878-lists,kvm=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,ventanamicro.com,ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 17217CF11B
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 12:38:57AM +0000, Jiakai Xu wrote:
...
> V4 -> V5: Added parentheses to function name in subject.
> V3 -> V4: Declared new_shmem at the top of kvm_sbi_ext_sta_set_reg().
>           Initialized new_shmem to 0 instead of vcpu->arch.sta.shmem.
>           Added blank lines per review feedback.
> V2 -> V3: Added parentheses to function name in subject.
> V1 -> V2: Added Fixes tag.
>

A procedure comment is that you don't need to send a new revision for each
change as comments come in or as you think of them yourself. You should
leave a revision on the list long enough to collect comments from multiple
reviewers (including yourself) and then send a new revision with all the
changes at once. A couple of days between revisions is a minimum. For more
than a single patch (i.e. some longer series) a week would be a minimum.

Thanks,
drew

