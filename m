Return-Path: <kvm+bounces-72063-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Ju7BBGPoGlZkwQAu9opvQ
	(envelope-from <kvm+bounces-72063-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:21:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E621AD806
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B8FCD306110B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7E7364958;
	Thu, 26 Feb 2026 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A9XozN7y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90FF355F46;
	Thu, 26 Feb 2026 18:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772129466; cv=none; b=TXLHQ8ETLtJSoMvLWEO1N9Vbs1mMmcSmWBmNSVY/efNo6cVyE2l3oJL1sCY+PC7N+6gQMgbFJ74t7dFtY+z5Xn9im+4oDDLXmgZ4wx+Min4+pHZTY8KzdR7CTtfmXe9y3kbs4Y8uN2pGgL8UjTcjIV5GVFXqHDfGbR+5JUj8FyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772129466; c=relaxed/simple;
	bh=ZVz9v8EprtYEbGjKzlng+vjKY69YdjRC5wngokZyTZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lc8yT+58slAIF+q7OEQrmyCcSL1FCSUiStKuL1p8+awpgIT1W/xv8CBYyV/4krNTXcs32FuE6d5CaNYeUaLm/M0n+BLKfry5ozo3ap0AzMFKSnO1vdZTFBJwJIQRGOewAkTBGPjBr6fxp24c13bywX/SjPn3gaUFMj2KohYXwQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A9XozN7y; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QD6Faq2725309;
	Thu, 26 Feb 2026 18:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EiFUwG
	lKvPHJc9AsU/Wqf2qX4SDWzVFk7B399xUfI9M=; b=A9XozN7yADv+w734KoqjJu
	cmY5URUgJGXV1lciduLFTJDjuvpGVRXqNodjYvdRm6srQYfX+JKkyTzLJ6oO3lid
	lt1246JIMpLXN60GlHCw78QYjEclm7RCJaIOga82zWCfa4xr6Hw2ZXeO4gOdxI2k
	6cGeTcMHVR8xSwxLTb7kJhPH4UdNUh4NAQwmwLEeArGnHOukzh7fA7eMLi41cgrf
	zls2ufrfHcFIcmaY9B7hUC5cvbachdn+mq5Qjb9CRIeULa45GKXoDkd7b6ZzEVRj
	LMwmN48tEzzMzCMerpEr7STe88AIe245K5+3VGYVEOWTNTkEXCfDNPyeMNBSCygA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4bs7aa8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 18:10:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QI2mNq001607;
	Thu, 26 Feb 2026 18:10:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfr1nd82t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 18:10:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QIAAwk42991898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 18:10:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C5B620043;
	Thu, 26 Feb 2026 18:10:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A613320040;
	Thu, 26 Feb 2026 18:10:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.52.223.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 26 Feb 2026 18:10:09 +0000 (GMT)
Date: Thu, 26 Feb 2026 19:10:07 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org,
        ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
        rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
        ying.huang@linux.alibaba.com, apopple@nvidia.com,
        lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
        pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
        npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <20260226191007.409a7a21@p-imbrenda>
In-Reply-To: <20260226070609.3072570-4-surenb@google.com>
References: <20260226070609.3072570-1-surenb@google.com>
	<20260226070609.3072570-4-surenb@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: CtrnfnLFeGbNILvMxH4zz7_6vXcy1bo2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE2NSBTYWx0ZWRfX92/iJsyzGWX+
 U7gNleqecboFJWTHpna/+exChG3YePLWbT7HIINpkqg0RRcbAghOgu83/JdENcOYjyMxHXyYS2J
 vxq09Edt50L8rapeL1iGqQfXep6UdFtEScs6PLrjliHJTfK4HkCtLV1f5gYqnr4+oR+P/TmrBrJ
 WHUPRr898gbzAFY0BpdSk4/GWwqKBJ07z/9d2A3JTukzTerEs7+5ySYw7XMrM/MTFa6foacNTwu
 ZzwE1fe97JUOUH3DNbY21+30YHBz0ECn7fkHHJ4mRtDcI9n0YT/WOppk/oEf16FvL4+a4QS/5xY
 UAk4/2ujObMmGbT5ewiKuYjsEYSWdCs29SxYLJCCj4/1z0zdDKNhZ7ATf/bTOCeEEIGocCE7sZy
 PwQ4UxojBvq7LC4FCsLrkANEzgg4tXzL50hIzKkCGgm65w87ImnGgtlyXd+XZXRjtxPBhS5EBYQ
 NQ7T/7hz36hqMdZ4aaw==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=69a08c87 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=8MrrMA2wyEC7cuUn5CwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 5vfp8VXyeBQAaEvJC7GasClW74sWeMkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260165
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72063-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[42];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E6E621AD806
X-Rspamd-Action: no action

On Wed, 25 Feb 2026 23:06:09 -0800
Suren Baghdasaryan <surenb@google.com> wrote:

> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it. Ensure users handle EINTR correctly and do not ignore
> it.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/s390/kvm/kvm-s390.c |  2 +-
>  fs/proc/task_mmu.c       |  5 ++++-
>  mm/mempolicy.c           | 14 +++++++++++---
>  mm/pagewalk.c            | 20 ++++++++++++++------
>  mm/vma.c                 | 22 ++++++++++++++--------
>  mm/vma.h                 |  6 ++++++
>  6 files changed, 50 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7a175d86cef0..337e4f7db63a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		}
>  		/* must be called without kvm->lock */
>  		r = kvm_s390_handle_pv(kvm, &args);
> -		if (copy_to_user(argp, &args, sizeof(args))) {
> +		if (r != -EINTR && copy_to_user(argp, &args, sizeof(args))) {
>  			r = -EFAULT;
>  			break;
>  		}

can you very briefly explain how we can end up with -EINTR here?

do I understand correctly that -EINTR is possible here only if the
process is being killed?

[...]

