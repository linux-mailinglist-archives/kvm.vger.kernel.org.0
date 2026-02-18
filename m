Return-Path: <kvm+bounces-71211-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uBRCFBRmlWmOQQIAu9opvQ
	(envelope-from <kvm+bounces-71211-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 08:11:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD6615393D
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 08:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D2CD3027DA0
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 07:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565FA30DD2C;
	Wed, 18 Feb 2026 07:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tSqb9du/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774C72EDD7E;
	Wed, 18 Feb 2026 07:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771398663; cv=none; b=FxNplFiyKxZlmn7L4ocbYkqhkL44oQ9mvune/RUFKQurCPxnsog43lrAsDDkhAQn4Zg8aTMu8RPxAaGzUdVzvEr5fpyTdxWNwu3zteY3DLAsVhpUtLSdjll5XFrApmeg2G0pTgKEUG7oiiRc0Ek2JVhPQwunqh9/PchoFMMp+Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771398663; c=relaxed/simple;
	bh=Ox2dOVXmbRBgdEYNhXg+PDFwMPH7Y7MKBtXaUVHfz2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWaxBHRpRxFUlr+sg4j3jlkt+m1oYOKkNMRtwakUOKoAVEjC+pAI0GzOLbKosM3tdUCweh8PJbsYJ9ymZVJmCAQMAEXcGOb+ZW/JWCygRpPqycGikEutIfnM7OYKwJWII+kgT39Xdun/0BP6CFK4J/i+NMiosQ05sdpvkcNMhxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tSqb9du/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HHJtU63183117;
	Wed, 18 Feb 2026 07:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wukgO5
	j/8aNavjZq33Drvjb9PS5A9guZ5fwgIH2CROE=; b=tSqb9du/lZex2lVtiYWD4f
	4+NKT9c72HZeLfQEX58ryWHQ3hvgyuWLaSUMpdHZtt2JntnhH2u+IZ/QC/icgL+A
	Tg5dA6p3JDM5tB3B29LFqlyYWbWWoO5OCxWTnmWovrTDnZG77upkcWMHISKqegoL
	vxjPiSH4wle69PTZzRLhc5XhZObUv7+hv1JJi9u9Bw5lqOjBxArce1guC7Wq2+Ge
	SyMBmoO0/8UabAQS290vPdEpNVy+KD32N+npTFPYEhfN8HvdwzA/BK06bVBOLfAn
	ccNndGaf2xlrUDjvj7wHsT9fnZR4Ma6Ec3ONIukB68qW8WRZIjxzXmf0/EQQRCyw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6ur280-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 07:10:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61I34Ffg011961;
	Wed, 18 Feb 2026 07:10:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb26xvbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 07:10:20 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61I7AGkO10879402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 07:10:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C72FC2004D;
	Wed, 18 Feb 2026 07:10:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19AE12004E;
	Wed, 18 Feb 2026 07:10:15 +0000 (GMT)
Received: from osiris (unknown [9.111.88.61])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Feb 2026 07:10:15 +0000 (GMT)
Date: Wed, 18 Feb 2026 08:10:13 +0100
From: Heiko Carstens <hca@linux.ibm.com>
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
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <20260218071013.12861A0b-hca@linux.ibm.com>
References: <20260217163250.2326001-1-surenb@google.com>
 <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com>
 <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=699565de cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=gGe32zGur58IqnNnNnwA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDA2MSBTYWx0ZWRfX1GbVKY+hQw/0
 xMtVyPtOGHwPd3EvY3nh6LAsZThMFJsu5ApLK0jWevZKbg8TbjdxYIQecUxKtVhACccLtW3/zOX
 oXfxEgPkBvBgxXpdYd4IiGZO6F6kxXCTlXhpq8QxhGoMU/i+eNxWKBdnJrgxUW13IMkTmMUU8Jy
 PE2PznWt7Z0CFRkIA9b4M1T2JSLNkyHoRD36p5g21pqtvSoDnC3ZF4OV3qSIUEkMDjr5OU6QQU8
 kbq35WpgDeMM3zXcuij2KgAt/FMKzfQkWjGWjXhhHaH45znBtDSdRxTPUnj4IoF9PL4C0U7v9vn
 qoBxoxHMJrgrOptI0h/YGNJTGe/dEAWaHLCAURLaZvUSSY/hXZgobo9hhruCwnnI+2L3b4+mOSV
 yyhCj4oZT+xipsWn8sM1Ji+oTx+mUeiXxi/G6CAeTdIuoBs0LXQgfIUFLqHLFZgKFP9rmV4Z5dA
 QQp6GdcAZOyxDFd0iAA==
X-Proofpoint-ORIG-GUID: PrNeiywUXSPNpfowIMohoR-adwD3XkAW
X-Proofpoint-GUID: 7NyzMkwUS6QnxMs17XYqyWDlVFmp7jpO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602180061
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71211-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hca@linux.ibm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: BFD6615393D
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 12:31:32PM -0800, Suren Baghdasaryan wrote:
> On Tue, Feb 17, 2026 at 11:15 AM Heiko Carstens <hca@linux.ibm.com> wrote:
> >
> > On Tue, Feb 17, 2026 at 08:32:50AM -0800, Suren Baghdasaryan wrote:
> > > Replace vma_start_write() with vma_start_write_killable() when
> > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > Adjust its direct and indirect users to check for a possible error
> > > and handle it.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  arch/s390/kvm/kvm-s390.c |  5 +++--
> > >  arch/s390/mm/gmap.c      | 13 ++++++++++---
> > >  fs/proc/task_mmu.c       |  7 ++++++-
> > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > >  4 files changed, 33 insertions(+), 12 deletions(-)
> >
> > The s390 code modified with this patch does not exist upstream
> > anymore. It has been replaced with Claudio's huge gmap rewrite.
> 
> Hmm. My patchset is based on mm-new. I guess the code was modified in
> some other tree. Could you please provide a link to that patchset so I
> can track it? I'll probably remove this patch from my set until that
> one is merged.

This is the corresponding merge commit in Linus' tree:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b1195183ed42f1522fae3fe44ebee3af437aa000

