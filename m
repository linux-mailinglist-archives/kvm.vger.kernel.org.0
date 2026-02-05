Return-Path: <kvm+bounces-70330-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEx2D22vhGk14QMAu9opvQ
	(envelope-from <kvm+bounces-70330-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:55:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7AC8F44D0
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 51D86300646F
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 14:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A262421885;
	Thu,  5 Feb 2026 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WdK8KA6b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y+kwkcF9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D940FDA4
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770303333; cv=none; b=jDoR+decagmoI5gOQ22IjQrV/ExA4lfQo79icG42OsdvembPsFX38tf/rKXKPTEUzC6oN+RgZQ1C1RfUugiCSYxH9rjNLx6D6QgTJtqDHL81mGmLB+zZERLhYrte+ubK/Sjnvkzo68Bm7F+gSJ+nDHwzFAGwz9cyW6xaIsHrpD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770303333; c=relaxed/simple;
	bh=l0yRuRF97EIOXhnfoKAAWF006czZECBbbCfStBD8MwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CI/a0bH8DsEiDxd8MXFXYCY389147D3St3hcoGTsO6I8C9x69iGcCLyRJB2dReHC5gVDGf7qR6t1h1o8dmrbIXWq9w7EDxhqOqFaTV1GxmfZPB2dg+aqw3PmlU307IpXZQR9AVpXMMrsz52aaVNVzzXioI1AaGNam97rGG51Z04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WdK8KA6b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y+kwkcF9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615B4LR33077728
	for <kvm@vger.kernel.org>; Thu, 5 Feb 2026 14:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=sQsqX44DUNzihTZKDnTdc2J2
	cKiScOMC8GyFnzDeQdU=; b=WdK8KA6baec4m76KEECT2zVxe8SZ7JvZaJ9yFrOn
	fmV2o8AhuMaDKJwSADpXWAMWTO106dSvfkOc7ylxlQubQECRAQZGkOClpfhjJ5Qa
	5iFSLMpiTYdGiXDdXAC4hEz599HV/KYvluRTUApNmJRMUs+Txf3DoV3khYtphzUJ
	rz3PHkl8IzsCXguF4Rcnpl9Re98FEicdKMSFArN1gDOUsXUJ6kItIM7v9UGAcprv
	AmqkTVbq1nKFohXIql0YD4qWU3rTw65Ll/dL+GU6cN9h8xFn6uuCpPOAFEWUp06x
	7HBS9yOSxwDJISL5oM9ipVK+Z90XL1AxvLBOTVyD5lPvEg==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c4t0t0nax-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 14:55:32 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-45f1665f706so3865593b6e.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 06:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770303332; x=1770908132; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sQsqX44DUNzihTZKDnTdc2J2cKiScOMC8GyFnzDeQdU=;
        b=Y+kwkcF9abfWCaRo7KviJm5/cTAbgWz/Eh3v6fOTqHAdJ1HYivRa2ZOfoSz30Pc73r
         MOw8X6P+zDjbuSdVOoqUHfILhezTLEgowxYIVTieILyQIkOlO69m+EWyCo3zFgr36r8V
         1cRid1BY84K3ufo3ldkWyQJ88A07Ext/EFA1Ii/Yh2Sy0t26W+n1orqDdWNWu9OPFIhZ
         GAg93UAYSrZSNoQP9nrfSFM1dze13jQAvD7P2iOgGD0eHNiVPVzAcpk9arEqcaAdAv1u
         4j9VczeBh5hx+Gx53gtASDzHNIspHsWrECS8XP0kh63R0soxW8cdX+fkdwUV1I89OSRu
         THtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770303332; x=1770908132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQsqX44DUNzihTZKDnTdc2J2cKiScOMC8GyFnzDeQdU=;
        b=E3+5ivdRB8VQRk3PAqD4Lf32OgpiUOdPJw34bxw5YreMBehdSPozUVqMdQ/mMFxFbM
         mFJV9o5MA5zct98c4CPrhHlmgvWBrK3VWN57hyIeXcMTGQuVYTMQ8hooMw8HVNthiE60
         lEwE1aDOgeFQQb851T+hGcjFThGYOnd7pSK+577gOlh5jy2yhxkEj7BAIt4sRHRGcvn0
         LDF0Lm26pqDOsP7oew6Vk66EMk7wX2acILufnkoEW/6/b6BmHIXs2SjIWQHHPAfe1L5Q
         6Mb4lOWXl+Zqh2//Oe/LLXqMcm/mdpbaRi1sz9F0xruIRScfLYwkJBjcoYquIZiT8RTc
         8RiA==
X-Forwarded-Encrypted: i=1; AJvYcCU9S/n4vLd0U1oPgzJHyfFUzX46YPWMkBrSb9N57TdcTuGrxI+HO6kxOBY8L3WXQ3ED7bI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHUv+WAO72ZAynknT5/9Puhzr74QNjA8fYtKiwRSXMEtyiLMZY
	ayvVVcpqXt7/S1DW7RmbcGe4ztRMqtFJD6Yl6xNrfbHRESnem33hSEvu5mTgnpMZlHprprQp+/r
	PnedZ3h8xRMECfFwXWw2qCOgkxKJ3y2EczuCnl4CE2zYBBNvDoRAp5yQ=
X-Gm-Gg: AZuq6aJ8e39hj2bhCYX+5JUODJTE4vRGER4bNlGUdL70Pr4Q/rYGv/7s+uL8cSGkvCa
	BOpGB48h2XNPSzjNI14wi1iqFypVOXH8SqK6XDxfUukbfM0qKsQvni9qUl1GAccmPox4hQVxBij
	wgWyVg4n1p/PEL1js3ODpUAAsM7IUH9ZRpfgwuc+kEGTQ/MVVOwVZubq2BbGjG6nEjZu8EIv6R3
	E9QAWzsgPanYuIoi2uwRG2MYcZUwNAd+/tyy3t9s/w0hrIpOkfBvAmW0g39xoGInY/m0TU7LPqM
	gVFi7VUO9DO3jj1SQdqJ/n1R6tcaMN/gEOr2j0a4e/gBC/aL5TnwugfbyEoTAWQYfIfIsxWIhhC
	vMyHQFMoUuGqPugHCT7E=
X-Received: by 2002:a05:6808:4f64:b0:450:ca65:ef60 with SMTP id 5614622812f47-462d5a2ea64mr3150894b6e.39.1770303331620;
        Thu, 05 Feb 2026 06:55:31 -0800 (PST)
X-Received: by 2002:a05:6808:4f64:b0:450:ca65:ef60 with SMTP id 5614622812f47-462d5a2ea64mr3150874b6e.39.1770303331218;
        Thu, 05 Feb 2026 06:55:31 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462d67cf83esm3226817b6e.16.2026.02.05.06.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 06:55:30 -0800 (PST)
Date: Thu, 5 Feb 2026 08:55:29 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: alex@ghiti.fr, anup@brainfault.org, aou@eecs.berkeley.edu,
        atish.patra@linux.dev, corbet@lwn.net, guoren@kernel.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        pbonzini@redhat.com, pjw@kernel.org, radim.krcmar@oss.qualcomm.com
Subject: Re: [PATCH v5 3/3] RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE
Message-ID: <uqklo2bxvs6v7kg2yotmzbba7x4r3evmqlj3gubwiptrimy2es@dtl3rtmclwso>
References: <ocfqo4zpsg6yyaz6kd65jrvudtb35uerdsueazqdk6w7c5lvdf@wvwzhc57gxez>
 <20260205012808.98973-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205012808.98973-1-fangyu.yu@linux.alibaba.com>
X-Authority-Analysis: v=2.4 cv=WZMBqkhX c=1 sm=1 tr=0 ts=6984af64 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=YnUHmWYE1xSIxKmkA7UA:9
 a=CjuIK1q_8ugA:10 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-GUID: _SUIq4ZsBSCjN88h9jv8nMoNDukhauWL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDExMiBTYWx0ZWRfXwEv5wVy6oMUW
 08f3HjrTifIXl0O97s9Jkx5cYZF4P2/bi9xpSj6AOV81fzWh++lPqhoQtiB9ggIYjYqzKBBDDmK
 TnTssVAvdobYCv+02dvXPQBdMsDmXeBuDFJhBTz+oMjXCTPYxIkTlsmiIoHArE5/kgv2y97D+c0
 MZJ5Imi2oae2H5Wxe5tR7YOWaP0+ihHBU0Gqdve/hBoo4ZxzeK8jvH9U1YwME6MPXfOdNr+eIAx
 MBROSaKvZe2MfsK9Eo6WlR1bCCGSLapB2UJHHbS5VMJezH80PC/RUL7Zl7jT/e5BxEuhdmZgbUD
 p0KH3CP6TFGM0LErEXW24cb2h/Al/WOGDI8uJxVtyKUusGLQcorih8VkcMQy8dSNZSfq+c4Lujy
 DpFGB9hWnBZnP7up6VtroyTywAirIKv8JliLBv5085lIjoGHCp6hzG2AaQojVl2OkECw0VNiVzt
 uhE9sGMooYu8en2E4fQ==
X-Proofpoint-ORIG-GUID: _SUIq4ZsBSCjN88h9jv8nMoNDukhauWL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_03,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 bulkscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602050112
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70330-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D7AC8F44D0
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 09:28:08AM +0800, fangyu.yu@linux.alibaba.com wrote:
> >> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >> 
> >> Add a VM capability that allows userspace to select the G-stage page table
> >> format by setting HGATP.MODE on a per-VM basis.
> >> 
> >> Userspace enables the capability via KVM_ENABLE_CAP, passing the requested
> >> HGATP.MODE in args[0]. The request is rejected with -EINVAL if the mode is
> >> not supported by the host, and with -EBUSY if the VM has already been
> >> committed (e.g. vCPUs have been created or any memslot is populated).
> >> 
> >> KVM_CHECK_EXTENSION(KVM_CAP_RISCV_SET_HGATP_MODE) returns a bitmask of the
> >> HGATP.MODE formats supported by the host.
> >> 
> >> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >> ---
> >>  Documentation/virt/kvm/api.rst | 27 +++++++++++++++++++++++++++
> >>  arch/riscv/kvm/vm.c            | 19 +++++++++++++++++--
> >>  include/uapi/linux/kvm.h       |  1 +
> >>  3 files changed, 45 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> >> index 01a3abef8abb..62dc120857c1 100644
> >> --- a/Documentation/virt/kvm/api.rst
> >> +++ b/Documentation/virt/kvm/api.rst
> >> @@ -8765,6 +8765,33 @@ helpful if user space wants to emulate instructions which are not
> >>  This capability can be enabled dynamically even if VCPUs were already
> >>  created and are running.
> >>  
> >> +7.47 KVM_CAP_RISCV_SET_HGATP_MODE
> >> +---------------------------------
> >> +
> >> +:Architectures: riscv
> >> +:Type: VM
> >> +:Parameters: args[0] contains the requested HGATP mode
> >> +:Returns:
> >> +  - 0 on success.
> >> +  - -EINVAL if args[0] is outside the range of HGATP modes supported by the
> >> +    hardware.
> >> +  - -EBUSY if vCPUs have already been created for the VM, if the VM has any
> >> +    non-empty memslots.
> >> +
> >
> >Currently the documentation for KVM_SET_ONE_REG has this for EBUSY
> >
> >  EBUSY    (riscv) changing register value not allowed after the vcpu
> >           has run at least once
> >
> >I suggest we update the KVM_SET_ONE_REG EBUSY description to say
> >
> >(riscv) changing register value not allowed. This may occur after the vcpu
> >has run at least once or when other setup has completed which depends on
> >the value of the register.
> 
> Thanks for the suggestion.
> 
> In this series the HGATP mode is configured via KVM_ENABLE_CAP at the VM level
> (kvm_vm_ioctl_enable_cap), not via KVM_SET_ONE_REG. Updating the KVM_SET_ONE_REG
> -EBUSY description might be misleading since it is vCPU one-reg specific and not
> directly related to this series.

Oh, right. I'm so used to adding registers I forgot we're only adding a
cap...

Thanks,
drew

