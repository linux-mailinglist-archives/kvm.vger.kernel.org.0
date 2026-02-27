Return-Path: <kvm+bounces-72133-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGL8MrRcoWmDsQQAu9opvQ
	(envelope-from <kvm+bounces-72133-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 09:58:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 755931B4CC6
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 09:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1BB383048D85
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 08:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F953ACA7D;
	Fri, 27 Feb 2026 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sZDfxp3p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B72332606;
	Fri, 27 Feb 2026 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772182701; cv=none; b=feU6anpgEYiYB1hu9sl9mmsWAqrcHJHI3j+K3MBXBR+h626UX/8goo7SFE1aerpiNxNhYAEPaFhFM6stgJujsUUlyn2OTkLm1du2eJ6RKKzKt0aPaiF2a5ilco5LMX2Uo9Kbzql4B9D49DAh6iHfp39lS8XushvtqooBhUriiDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772182701; c=relaxed/simple;
	bh=Wi6J+f5oQlDZKytCaDRy1GNr0FAigVOcgOKl0ZI+3Ik=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c9AIlmoZlM7PUqOaFlkIEpdwaJdULj0wA3tVjl3WDqFl8apNBDgFGe7j0rEBxGiZYYkaGvxL0se3zgB6sS06ZzFW9tBYYLQ1Trmo3+E8JM5UFt6lp/wwQHHNGYxOg3+cbLAhFZWEj+UTcZ0TvShupsp2BHfu0CuOHhjVlH30HEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sZDfxp3p; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QNfeDg3178876;
	Fri, 27 Feb 2026 08:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ohADth
	LDD9z3XUImOUnNifIKCKACdymEuIsWp6yNCC8=; b=sZDfxp3pYtANr1JiWIkADr
	lfCfeth2VR2Y2XN+68ftwKl05od9arHJ/ZN3j4BjHGVaXiJSqhqqiTjt3lRe3/Tb
	NspqofphmW0zV3wzay8doVQJVU5+11+mJNZq13UTw4NcF3FoH9gDBx/1VRqKqEk6
	TdjBn1hmyUWPKSAZRmFAIMLYQI33iq0PT4s+h1C3a69Q/ka6JaNfaNWDxoiDnK88
	BWtJ0hyTd5HehP0BaTBtyhpyZEWrTdIkrk1CGRtS9TXHd4A7UZ7shYy6EnhTyqJJ
	RTOLUPNYlt/XLrTk38tmOy9Z2lHHDeHD95ij6tpl7IM0aA+Uy0d4Ld/cgXzdRuYg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34cjtjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 08:57:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61R6ldH4014012;
	Fri, 27 Feb 2026 08:57:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdyhan3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 08:57:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61R8vJo814090732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 08:57:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D71652004B;
	Fri, 27 Feb 2026 08:57:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49CE620040;
	Fri, 27 Feb 2026 08:57:16 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.69.15])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 27 Feb 2026 08:57:16 +0000 (GMT)
Date: Fri, 27 Feb 2026 09:57:14 +0100
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
Message-ID: <20260227095714.5e69a0a8@p-imbrenda>
In-Reply-To: <CAJuCfpEk_VPqwpqtAiCJSR5bkvHuzvC8ooXrB4jKTYnQB2D4YA@mail.gmail.com>
References: <20260226070609.3072570-1-surenb@google.com>
	<20260226070609.3072570-4-surenb@google.com>
	<20260226191007.409a7a21@p-imbrenda>
	<CAJuCfpEk_VPqwpqtAiCJSR5bkvHuzvC8ooXrB4jKTYnQB2D4YA@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDA3MyBTYWx0ZWRfX9WncEKIsvtkE
 93BCkSDioR3viSI4k8M8ER0no2D2zADEGoLWX0KPQp0RA8BsPJbCrfq2KNwhRaeVWK9DAn3UOd6
 JAAx02zp+y9sAZSn4DLDrb3m80HWoUwQ3XZbkAc/WY4whBIPdkpq5++S1OS1U/BZL1YM5xtJRtL
 asZKx6fRd45Z4dwVYGheVX0JssABTlQnZcPMUUlLPHlLa2PGtc+gWSwVlWd/LbyzyJTu5/eCRQv
 ZD0ydFAWHEbM9dSGMVwbFmFBk6I11/cjfskqj1vi3sWYi9ExPCWFV8MocD36VLDGxyr7Hgvw95a
 oNSV4Q1Wk5+LBR+205t5wPH9duGWR6eo7a84XSUaM2JtRffZshKV0ovn8RzJA32bUOqSp/TehRx
 vmDqLHCgdsnyiO0l67/DgUsWIDjh+fag6Xuw/2WaA0DTHK1m/3W1tSm4sGSr6C6KPXPZdDprF1U
 j1k9+KMGXV8XsaOEoIg==
X-Proofpoint-ORIG-GUID: ajegLXIpD6Zt7S3-2yKIDNzKpDYqMOPu
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=69a15c75 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=VnNF1IyMAAAA:8 a=Ch0MJLqadWv443iAyyUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: co2lSwi4qVEs7Dzgf2PvZ6JwEnc7YSIK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602270073
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72133-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 755931B4CC6
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 10:24:49 -0800
Suren Baghdasaryan <surenb@google.com> wrote:

> On Thu, Feb 26, 2026 at 10:10=E2=80=AFAM Claudio Imbrenda
> <imbrenda@linux.ibm.com> wrote:
> >
> > On Wed, 25 Feb 2026 23:06:09 -0800
> > Suren Baghdasaryan <surenb@google.com> wrote:
> > =20
> > > Replace vma_start_write() with vma_start_write_killable() when
> > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > Adjust its direct and indirect users to check for a possible error
> > > and handle it. Ensure users handle EINTR correctly and do not ignore
> > > it.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  arch/s390/kvm/kvm-s390.c |  2 +-
> > >  fs/proc/task_mmu.c       |  5 ++++-
> > >  mm/mempolicy.c           | 14 +++++++++++---
> > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > >  mm/vma.c                 | 22 ++++++++++++++--------
> > >  mm/vma.h                 |  6 ++++++
> > >  6 files changed, 50 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > index 7a175d86cef0..337e4f7db63a 100644
> > > --- a/arch/s390/kvm/kvm-s390.c
> > > +++ b/arch/s390/kvm/kvm-s390.c
> > > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsign=
ed int ioctl, unsigned long arg)
> > >               }
> > >               /* must be called without kvm->lock */
> > >               r =3D kvm_s390_handle_pv(kvm, &args);
> > > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof(a=
rgs))) {
> > >                       r =3D -EFAULT;
> > >                       break;
> > >               } =20
> >
> > can you very briefly explain how we can end up with -EINTR here?
> >
> > do I understand correctly that -EINTR is possible here only if the
> > process is being killed? =20
>=20
> Correct, it would happen if the process has a pending fatal signal
> (like SIGKILL) in its signal queue.
>=20
> >
> > [...] =20

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


