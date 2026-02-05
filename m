Return-Path: <kvm+bounces-70331-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QG33KLivhGk14QMAu9opvQ
	(envelope-from <kvm+bounces-70331-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:56:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 45237F450D
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:56:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EDE41300AC82
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 14:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1451441C30B;
	Thu,  5 Feb 2026 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H/rALWxp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PxBugaCd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2309A41C310
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770303398; cv=none; b=nW+8uOoVe2TqGK4HAlVMn6X6J9+87wxnmg0KcjSKwqrsy1wDaMOO/5aGjPzxPjPwcvcRdRSYXoOvpEIP8lRCBYyFCtbeE8lAetMWVCWCiEBCYf9fgOoylAqsHeBlO2itJfjLPGAM/oqMqstkt1RWmZoHOBYgUFzlQUjogxZbL7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770303398; c=relaxed/simple;
	bh=atub9o0Gb6IvRtnk8EumK9kYmYXe/E0BJsF031KmnIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FV7dkZETDq4FLJoV4IDzi4UGFPd0+44faa02iJzKE9g/wk3lexosnjU+7I96T2hUL6y2EZvF6RL0gGTcIr1FHOpWG7eymckBxJxJWx97iKxQSPhKHhvUP7eP/E5ly6vmB/HjBmLOL/nm2U78weZQrf7969CV+GURDEPtRjOOsDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H/rALWxp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PxBugaCd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615Clm984166730
	for <kvm@vger.kernel.org>; Thu, 5 Feb 2026 14:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=9g6+zH9yTy+gqiQg02/erDU6
	iT9X69ZdnysU8cGq/4k=; b=H/rALWxp2l6X54hT7X5f0Pe16GD/FTZddeL+7ndP
	GO5q0vqJu75qA6yRtJITBurImTgWxYB+/gvSu6b/9irQ8rkIsWByGEgYcvp2/wyc
	m+wuWYFG6gewptipkrCkvPZCIpWipejGYymc9JoFDaa67mKWFS7CIh1VoLGexZFM
	hDzdMogstPzZ3fUpyd9boZoux4r5NMUsgP6MIDNXDFIH8jBM5UFziM2Yc03RE8dz
	EQ/yHKTJKeNBoI8c4oDrQyUYhZbQimMZ2G/+aADOv+U7tPD57nn702DYknUI5WR+
	wAhAMTvyNdncZyusJpJJ4KX96WOTSySErcv/cY11Uvv2PA==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c4neg9m8j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 14:56:37 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-124627fc58dso2034589c88.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 06:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770303396; x=1770908196; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9g6+zH9yTy+gqiQg02/erDU6iT9X69ZdnysU8cGq/4k=;
        b=PxBugaCdkxqaG+ymtjD+Q/tSkPUMRBfD08d06sZhsS+wK+MnlJDkOOBneYTWLbxj3O
         SwDfqJu0Iavan6eWLAM2n9FlI/JeK/Rxlmh4ABZokI72TQ84R3/LWv5I9PjI7b6gR7h/
         Abz0GTySud8CNK/aW5wT18M38f80HKdIj95VgdR8Nl39iEEc6Q+bi2FAS1VkC30AyXP3
         xHj//Z+Zt8DSH8aW62pPZjSQzbN6HbPdiYsLK1PtsfmyVkPL4XyVcSSXR1UVxkZ6mEYm
         BIGQKA0XzkYyTX4bRDqhdNgXEA9dn6SGVks1KG6z2FAH5blbAY+5S9iCofIONqXHmN19
         mcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770303396; x=1770908196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9g6+zH9yTy+gqiQg02/erDU6iT9X69ZdnysU8cGq/4k=;
        b=d4ZG4vuWnNupzo+jD7QrX0HTV2PP52WfA+mUMXEn0sn2/79T1VpR8DvkcZCp8jB8iK
         7wulSE9dnepDs7GokchhiACEhG38TSOz9CH4Jjx8utLdLYZyRe+GMmhl7aAkakaSGwCv
         REXqgH7ShFB63wHL+VLqn9Un5d4g/O7ZkV5Ie4chu1/Qa1zoXSzivBHQKFkTxl949jIE
         A54nDhuXJkXR8AtaiIFPRxsDHtYq44/TUK8rI83WNvil9zEbhiU75bGyoPzBppqlAULm
         GGTkQSogD8k1PgDFRdQr8ihg/MU+awIAWHQk9bwcWF3nGj5yE1Cajkbm2xtlhu3EOgL+
         yf6w==
X-Forwarded-Encrypted: i=1; AJvYcCXs92r2XatBCzYr/vAs0oDpCv8vP6ZDMoMuHV7S1WQaCMzjCdziKu0qnl8UtGO5m1LJm0U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUcXGBeo6iD73rP7QXl+xls/p6lDP2ZnK+kCOve+KmQ26vvokv
	HtqyAMld5swqeQY9ilesqbO6cxzexVPJ+N075p2IHYahqg+k6fJVJLGPCRsunu5xWW9fMNYWWA5
	6ZlVy9jd1hq48TolhXcFp7z5THd4iQb8hOsV78EGvqWx84TGdRfjVuZk=
X-Gm-Gg: AZuq6aJzDnKnT7OToMMUQsc7qiJhS7azUovfItB7eJr8QwHbP3kMXS4HYu39Kkcv8ME
	T9X8mC4uw3r5vQpCAIVwrpwgtuytISopFmgj77Khvbg7cC3r0MTlM5MB2JQvjqUPAAMr7vKyC1c
	Qp+o42Twl0t1ixvrd9Lioe0AhX6P16/LMlZWOD/Bxqs5Mj9ilZ+8SDv9YZrEubV3YGV2NEr/GIV
	x5JLyKtc0MNKRAdRLQz6RfqpwqyKD576QQh9fb8enfNaSZzvWY8m7CdF3d0KaXM6dTZoEyYMRyK
	11ic+76qWFQSe98QE9NCwCgMyrjdYt4LbKi4Gkbu9I5skeDqdirSdVU7l6swDTVQsS4JC9Ds5om
	wHMxlJayMP4ZGEKiwkVM=
X-Received: by 2002:a05:7022:f90:b0:119:e56b:98a1 with SMTP id a92af1059eb24-126f4780c3bmr2575072c88.8.1770303396097;
        Thu, 05 Feb 2026 06:56:36 -0800 (PST)
X-Received: by 2002:a05:7022:f90:b0:119:e56b:98a1 with SMTP id a92af1059eb24-126f4780c3bmr2575043c88.8.1770303395516;
        Thu, 05 Feb 2026 06:56:35 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f503e5aasm4543164c88.14.2026.02.05.06.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 06:56:35 -0800 (PST)
Date: Thu, 5 Feb 2026 08:56:33 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: fangyu.yu@linux.alibaba.com
Cc: pbonzini@redhat.com, corbet@lwn.net, anup@brainfault.org,
        atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alex@ghiti.fr, guoren@kernel.org,
        radim.krcmar@oss.qualcomm.com, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Support runtime configuration for per-VM's HGATP
 mode
Message-ID: <vgqqpqfqin34stqyd2gdqxiopw6vornjpmomuyctx7ngbtjj5t@ly4avedudyrx>
References: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDExMyBTYWx0ZWRfX8iw5yuH7oU3R
 ZqZ2tA+mGCINQB2aNJAoMKcs7QgrLAarhaAQRH8T8ub+5uxC+A/fDewVu9olW2YiJpB/dEXWCXJ
 udoMsMNaWSUZOQdG/XLyehMLaJvSDwo5OLSiPNm2LiXG6te/7uwalLWeV/dVXWPUVJK5YADev6j
 wq1LIbfcD7wj1m6ccyow3MT2eKo3qUPv2prjrHfhrS8J5DBR656nDiQccG9eeuoWG5i3IoTQQ1I
 Grt2FTL+RY0g4S78sbT60qhNd927G74X+wA5YETf9frSNBKsRknwxqCZK1cv/T9CfMX6msClOOe
 SpDMdgyO73TyHMAGgQATp+2GnmiJtD9yn3xOZd/hvodYifePRKSYdJGZOQLLSP6oSODHGliYdzx
 0alldxk+U0P1wJhnB1l+aT6fQEf80r2o2Zju+Xfmjlgs+9OI4k34NL249qE/zyk7knJEJDiTKdk
 /iffwGsPK3CZsHd6aPQ==
X-Authority-Analysis: v=2.4 cv=ZITaWH7b c=1 sm=1 tr=0 ts=6984afa5 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=SRrdq9N9AAAA:8 a=EUspDBNiAAAA:8
 a=pZlcIiJjb0-w25zZ6xIA:9 a=CjuIK1q_8ugA:10 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-ORIG-GUID: PZE62ms7EjGIGExtQtrDdNiPs8yuVCl2
X-Proofpoint-GUID: PZE62ms7EjGIGExtQtrDdNiPs8yuVCl2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-05_03,2026-02-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602050113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70331-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.jones@oss.qualcomm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 45237F450D
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:45:04PM +0800, fangyu.yu@linux.alibaba.com wrote:
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> 
> Currently, RISC-V KVM hardcodes the G-stage page table format (HGATP mode)
> to the maximum mode detected at boot time (e.g., SV57x4 if supported). but
> often such a wide GPA is unnecessary, just as a host sometimes doesn't need
> sv57.
> 
> This patch introduces per-VM configurability of the G-stage mode via a new
> KVM capability: KVM_CAP_RISCV_SET_HGATP_MODE. User-space can now explicitly
> request a specific HGATP mode (SV39x4, SV48x4, SV57x4 or SV32x4) during
> VM creation.
> 

For the series,

Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>

