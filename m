Return-Path: <kvm+bounces-72075-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCh8OBCloGk9lQQAu9opvQ
	(envelope-from <kvm+bounces-72075-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:54:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEFD1AEBE2
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:54:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 83570301A400
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C67466B5D;
	Thu, 26 Feb 2026 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bQHQBnuY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DBPYuro1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02B4657EE
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772135667; cv=none; b=rqGKUMBIpEoDGIcQL6ryyFTdWlAnxpN/7hQkxrB0d5aq2NOdTtcpZgyuvzoLBXNTqg6QFp9pWxgJGTarIwQe8ZDAJ2uFJ62s5/bCU87ZNomTPNpqB6FJ/JNmXRbmxpvJJJF/710SvZ7YYTbOrRxm7Xz8tr5Ardl6W+T34KhsK34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772135667; c=relaxed/simple;
	bh=gGUscGY27edMw11lPJHTNPeh7Uf9+oR8ca8jIhQKtHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FoKxzpP8ZsFABQNsmXGmZClXmXJBGqZPMclRL8LQfij+en+fpwjaZ/QnWu9AHFyitGkkhf2upCwOgzRyuqfFrRrtpuqaUmwkjX2CZ6b47i/6JFPqY4umzBciNgAPt8haQv6UVRFDjnEWOGIg6zwPlgHhwbN8fNt5URCQs6m24Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bQHQBnuY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DBPYuro1; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QIrUlR2807411
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=gkS2kEkiD1AazRxh9MEv+lrE
	cNwpZ9ngwbS4rZ3aYQY=; b=bQHQBnuY976RywjkkxRFoJe1aPFJ/Rc7+AJMIJmA
	y+xV9ItFDwrV5VVJB0WoORNHY3ApR6lEBMjFWILzqRaKb08DNmPQgvI09pZ6uSBj
	lfckXXnFndIkMCVi13Y4cS/FOC+SNPBuWAo2rpYzFC3/1TmZd9c0pLlrAIXBBAqG
	LNgSp49rX3g7BoCy0C+iLcmAK6OkH9QEtrs8O3axSSprqElupwd1tuLXwbK4p1mi
	KepYovkFCiN7wpy9Gs1QXWlb+I9U4W09ja3g6VbmI4PsB0+guOMfqWXkWtygp+wN
	GXD+RBobmG5w/pfGQD46E3ztudBgi5Kq5Touq62EVny7LA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjuur06ay-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:54:23 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2bddd304622so530858eec.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 11:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772135663; x=1772740463; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gkS2kEkiD1AazRxh9MEv+lrEcNwpZ9ngwbS4rZ3aYQY=;
        b=DBPYuro1+RdFqxXqb9mY46vfpCE0ikk45UAeDJ3eoaatlf6AXlCkUa7oW8KwGHhRlA
         mIHXPrSuMp/ozA4toLKH6xTvCI15l7uBn051fBH2/5XyjvDe+3Adw4sdE3lLwVKCZUWy
         07FjtwZzAjs+ZPDVQRpqg9MY6h9Ucmpb66eo85PtzOEY2prfX+ZpddIJAIcKL4voVpEX
         bGNz5D0e848xLl8i2FCTCYn81OnKC3FfyxBJIqk8uztsmVTfRUaM5lu5pdZJ/gMRM1Vr
         deE5RTycabVZWQSNs7vfsFdxy28PCd8ZxYhOkeV5To/8bcytZP8zBIkuCba4LflnOY7y
         sTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772135663; x=1772740463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkS2kEkiD1AazRxh9MEv+lrEcNwpZ9ngwbS4rZ3aYQY=;
        b=uuKdb+P5ZsRTrM/dYYxsMkrATLajc32cVhZqjFplxEFlZmP2GgiYBP7P4wRtLvNXya
         oVg4lu/WdRm7XnXeAIwQllds3IA/41LQVPoTACCa9VW+xWaxLS313eEXbtT00bYRjqcg
         nhgDxnhCNEvm1W/vibaFM7jH3GttIhLB941jOcXsbn7iHy9ERL043PkHNdHiX5uMDOJJ
         XapWLdslSG3gU87jJaiXC0E4Akfxvmusa3tXry9ZOJklF/0YoK5bB5U6JhdYWMUR4srw
         M5FtQSJI4mVSEDMSQKqyLejMAYTZUegxtjKaaICJ0T/RiC0hhtTHj5AneHr/0aqPYeym
         j7jA==
X-Forwarded-Encrypted: i=1; AJvYcCVZDJ5vq185leonUNQP5LAur2urdP8qBDhHh2JlF8bS4AaEZtJucqIC9nSTaxr761pVgVs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtr77k5oST9S+KZTcGgeRVkg3DBmxUW+WPx/qAS8VVlJ79v8O5
	xdmemvpNz/xVIUZiKGvT4lM5YlE4HTZZz74DtKNytM22UvSm+lkfUGXuaKug6l+dN8QxDv5gIXU
	SJKjTpXKz8KAo/MGbuMLG4Q3e/tJwgP6oWO9vKEbw+YcB01lkK7dtN34=
X-Gm-Gg: ATEYQzxOTvTDtO26lieBWtMLoM801+TLYM7sb3xoz4QT16qs0cRnLnrVKMLxn1/JTV2
	viijAKZtTar0kJlIw40vQJIgZy5HQIMN0IlGbzrh8l212o6jK+bhsLnUkzjN+9RSKarDZ0V4Khg
	1o+bCWKV9phswhuAI+AbBtPT6zJAa5r1v0c1X4HEtIMFt+ymOuvIt472Rh5jpM2hbkY6Dh4GWP1
	HUy8+0p97E1IS9dckVfaFxqTVxin1IuGk8268VUA78G1ShqXv3JCgp/1k52t7fA46RApONDpE2k
	dbe8QS2znmI3En3hsYfAFAg+/eB4jw8Ki2mX3ODCSnKTBPxYOwDKwE1z59uLthhq3+aAGBlBhlJ
	ImeKlLERsVJFqQ95QdAcOieCkxBieFCI=
X-Received: by 2002:a05:7301:5795:b0:2b8:26b8:3426 with SMTP id 5a478bee46e88-2bde1bb19d9mr133485eec.13.1772135662430;
        Thu, 26 Feb 2026 11:54:22 -0800 (PST)
X-Received: by 2002:a05:7301:5795:b0:2b8:26b8:3426 with SMTP id 5a478bee46e88-2bde1bb19d9mr133461eec.13.1772135661846;
        Thu, 26 Feb 2026 11:54:21 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f7ee87sm2493752eec.31.2026.02.26.11.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:54:21 -0800 (PST)
Date: Thu, 26 Feb 2026 13:54:19 -0600
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
Subject: Re: [PATCH v8 2/3] KVM: selftests: Refactor UAPI tests into
 dedicated function
Message-ID: <kycoxbbf7krrqaqivzin6twb4vnbl7g3xfnx2qwotwxkjklxad@37c66df75wv5>
References: <20260226083234.634716-1-xujiakai2025@iscas.ac.cn>
 <20260226083234.634716-3-xujiakai2025@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226083234.634716-3-xujiakai2025@iscas.ac.cn>
X-Proofpoint-GUID: 2wnDoEjBcU4fcBXVB3wJRTV-be__Tt8I
X-Authority-Analysis: v=2.4 cv=PN8COPqC c=1 sm=1 tr=0 ts=69a0a4ef cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=a8_vTcVqeGFb8pxCYGAA:9 a=CjuIK1q_8ugA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4MiBTYWx0ZWRfX8b+AC/hNhOUX
 AGAX77qKUi/4gZ9gB/g1+K6Jb9ZbLBzzRYSPgIlDdfb880uwUCc9rMpy+XpMjymK3JMUkkFdji8
 UAM0By7gXd6j8kdymhKbyidc5ldqfPPmrlmXpqJhaXBNIei6ubFetXizhU8Wt4ffLVJZNTDaawQ
 ZUK+RWnn655t1U/Js0soPcHRDJwThYUFGAUnJGTYp5/Ox5iZH/lPAZCF8E1juffvC8fZBHAL9JJ
 0Q86YmIM/EHk77y65XnTJgqrDrYZ/xIVXozWuy1rglq59q5ul2LUsUr3q8aRdnWZra7HzhP+opE
 ghur7uq4ipSsiEhuCBl6cYA2uniFJhxLiXqZOgE2RHMcON5Hp1fzLrgeWSbeAv/9OMJCakYNxxQ
 Z2TD4irgfDXQrvp1dmdGABrDFQ5NqI6Y/Y6Qc1U8GX7B3BChmibUa3jw9qpbDtgIK05NNaXzxMs
 jxzgikD7RprHJ3of3Fw==
X-Proofpoint-ORIG-GUID: 2wnDoEjBcU4fcBXVB3wJRTV-be__Tt8I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602260182
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_FROM(0.00)[bounces-72075-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,ghiti.fr,redhat.com,kernel.org,dabbelt.com,ventanamicro.com,brainfault.org,linux.dev,eecs.berkeley.edu,gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,qualcomm.com:dkim];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 5FEFD1AEBE2
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 08:32:33AM +0000, Jiakai Xu wrote:
...
> +static void check_steal_time_uapi(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vm *vm = vcpu->vm;
> +	struct kvm_vcpu *tmp_vcpu = vm_vcpu_add(vm, NR_VCPUS, guest_code);

We probably get away with adding NR_VCPUS+1 vcpus to a vm which was
created with NR_VCPUS because we don't run it and rlimits happen to
work out, but that's pretty fragile and not a correct use of the APIs.
So, we should also create a throw-away vm,

 vm_create_with_one_vcpu()
 ...
 kvm_vm_free()


And, even if some archs don't require the temporary vm/vcpu we can use
that same pattern for all of them. So, check_steal_time_uapi() doesn't
need to take any parameters.

Thanks,
drew

