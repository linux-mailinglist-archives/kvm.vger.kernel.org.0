Return-Path: <kvm+bounces-72823-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yK3iC+GUqWmKAQEAu9opvQ
	(envelope-from <kvm+bounces-72823-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 15:36:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E3C213937
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 15:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 795AA308A6D8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 14:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CB53A7F6F;
	Thu,  5 Mar 2026 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FIBHUpYb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B46621E091;
	Thu,  5 Mar 2026 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772720885; cv=none; b=RDqqHRj29eHy2LFCl6phqCsK6odJlbZ/V4O5IEnqQKnSW8vxx5oNnWEQBrMc+29Mqr/4CmsC2H+YHlrrtKitVuesNmtEhKkFJjYhUl2HgDWK6XJRY7mxExLyNx6OGGmIdpDSP5PC/byUr6WTCS8hgqml8ZYW+L6WygDMKMzaXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772720885; c=relaxed/simple;
	bh=mycKdiYx+bRYsf+UE51so3y8Rt3sk7Q3lHga/5oIgPg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iuEHA/gv7TV7cQGhTbakpcu9A+I33xpqRchTrlpC+XyEujrYiKhqOzo7Wq3Xsy2KID1RGBpMFeOSfX4aeK0M9S8kcjrWuJYRSsuICv0ZlwWKitWWDKSQZTVthtT8Tt0uTLWQ00RVi6/5NzHOwRTbw0fI8hY4X3buyFkTvzuw27Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FIBHUpYb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6251Ogj42198741;
	Thu, 5 Mar 2026 14:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BuX4BR
	/veybC48JOr+5BRfnMnKSjVNJ/DhDjO0c2o7E=; b=FIBHUpYbPH5xOxuaw8D1RL
	sGurciTokTDEBwQeRUh1aXbJUySFyxVYlIiiRpNNYIX3Kf/R3Cw7QY+di/e9wATP
	RuMepddDw1l6o2aq+dMtdf/2jdTGYRZrwPYZpVaLNLF611dVPaN0JMFh/pMlKUxN
	LqdXKF0dXklWX0XaG+wt5y3aelDVKYkulMwlPEVqJiJq+1NQtmveSQWwLiryxCqG
	W6reh3xZUjCWb6p8/GVmRFwaLWcNUF5qQW4vVL14VNefMwiF1WbZdXmoR4iAgLRf
	ib0XhHcCZy4JmFbI3wK7kEB7hLb2Dkz3xelUs7hIhuH3q6F88DCkMMEbx79LTCew
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksjdm24f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 14:28:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 625Aq94M008791;
	Thu, 5 Mar 2026 14:28:02 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd1kb65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 14:28:02 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 625ES0Rr37356066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 14:28:00 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49DF058059;
	Thu,  5 Mar 2026 14:28:00 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 922CD5805C;
	Thu,  5 Mar 2026 14:27:59 +0000 (GMT)
Received: from [9.61.30.112] (unknown [9.61.30.112])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 14:27:59 +0000 (GMT)
Message-ID: <283f936a-0a87-4125-a4ea-023fb54d222f@linux.ibm.com>
Date: Thu, 5 Mar 2026 09:27:59 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: s390: selftests: Add IRQ routing address
 offset tests
From: Matthew Rosato <mjrosato@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, freimuth@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
References: <20260303135250.3665-1-frankja@linux.ibm.com>
 <20260303135250.3665-3-frankja@linux.ibm.com>
 <cef95ca6-f55a-43b4-b65c-ee7372530eee@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <cef95ca6-f55a-43b4-b65c-ee7372530eee@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=M9BA6iws c=1 sm=1 tr=0 ts=69a992f3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=iSo8agnm6a5hXGK0_gEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 3ofHqq9Ul9-gTy-2pidCYSWdoWzcLx15
X-Proofpoint-GUID: 3ofHqq9Ul9-gTy-2pidCYSWdoWzcLx15
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDExMyBTYWx0ZWRfX3F8Kdiu8nV+b
 YLbVcWESzqBPnizO3zk9IPAry6jFIIbUJ7+3csrEIANUz17wZHkCJg/yWHZlOp8yeqe2j43HDks
 7mxh2t05771rYhm0ny6p92XNjvuiyjp/lkzPDxiqEjK7pN/m+rvUbXd/pj7vsrhRKsX9/TDKF7A
 nfXvCcEZ1VfCbvCAsjmxv8tgsnMqFgLV1YliV5Zhj6QH5IONmibDqw3l2x17EwbpeGaKMjA1Ub5
 JBOzsav5gQRmTyr7er0ovP2pZkxYsHf7Ua7fPkOgvl/znCob7N2rf7aR1oeLqlC79Tv2yZjhpL8
 PsHiDY0nFpB1RDPwH8DoavJkd5DfvSZNjXs5FKEI3pgT9KZrA+shrtm7UjFMNycTKg5pZhMJXQR
 4VCG2Yvy6liOqUOhH0ynf85uQL59Jg7R4z6ZWLKDhOurVytyVo7YWQ6HNZFjABvijVN0R6VdBZB
 AleMJsXm7FOqXJ6n9jg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050113
X-Rspamd-Queue-Id: C9E3C213937
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mjrosato@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72823-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

On 3/4/26 3:19 PM, Matthew Rosato wrote:
> On 3/3/26 8:46 AM, Janosch Frank wrote:
>> This test tries to setup routes which have address + offset
>> combinations which cross a page.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
> 
> LGTM, verified half of these tests fail without the first patch from this series; all pass once it is applied.
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> 

As mentioned above I ran tests with a few different kernel builds against this patch, so if you'd like you can also have:

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>

