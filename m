Return-Path: <kvm+bounces-71301-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIZBEf9NlmmbdgIAu9opvQ
	(envelope-from <kvm+bounces-71301-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:40:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B7015AF97
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A37C302D96A
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4813433B6E7;
	Wed, 18 Feb 2026 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVMXu7KH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7699B33ADA4
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771458038; cv=pass; b=Wuy3TcG3hdcFLxfSxihkmwi7Wxqnr8DJAG8+cIVkaWt80ifircMSeRvdTln9E77K2Lc+TbcbtCSbTQNU+lFPzJjeQFvhH6LlwGUvVMs0onSGAj3qL4tQ/5tj3WRL5076MNU4J0e/6o6EWGhrkRh5LR9DJ/DCDCVfr0fboIZJUIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771458038; c=relaxed/simple;
	bh=JCYIyYfQkXj6y+2FydgfZ0XMji9ZHAOjYEUYt5DGHJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ZM+8flvJZNTGO6Qa2tWE52a1ixxXNujHgJaigZ9QlXR16E7UEWIz2fG/eOIM0tfPSk2Vmm8oh7P596uBZmkQOpfyh0M6+Vn9V9Lu9Mj9UaYzg35Xvo1VjET8uIdiPB9OvKbC4k7fIQQ/dgSs77pCShthDzCOrvuoOGhO40CE+HA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVMXu7KH; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-505d3baf1a7so88031cf.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:40:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771458035; cv=none;
        d=google.com; s=arc-20240605;
        b=MGuYk/DpUdEbsKyLk0miijrGN99pqC06AZUUm+xMiGBCAg6yA5Nl6NneK5Unc7YMZG
         1VD91tCxSPph3lWH3M9UjnBP+UrKyjUyiRVtZUn7S7HtsN/lCXaRwzujdpfl+yhXRjsH
         ++BzyovCvg/E3gUgUbrikroCqe6mLvSa8w5UUyzOw2AvUB6YhrsodTx76cfNVzQoVru1
         C+GBYNMjXIIaUleI6ihdeUTWKpbPaRMxofIb92vid5YZRzSx4kGCdqq+oUOZQXl/eOtx
         1Zv6nlX2RyXYEaHvU/1lhUdBeJAWu6TEk2ssi1gWcHeI9Bsbq2B7FSVWJhaDEX2ps1+7
         snFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
        fh=Y/ITJD2B9sYaXrLbrUEmCq/nS1FRW1948xP2WNSX7Do=;
        b=VYdyvMZVt+3nN6JK33QGMbgjPraDb3ZDnJb/QKB4fiVTGbo25KXMb1CMaRmeegPEeH
         PNSjixiilmuAEIOUu9KWxPHUGnhWFlDkRWP+/XIjJOFn3zYAWWNxgSRZ++IDWU6iDsHk
         ojR0RnXXVIAicyxKQr/EZqkcYBH3pBKRQgdMtb0/7xujA8N7WBOVnjeoAIKuGKzw1mCa
         epXL3GHN1OwK3URhVaCARBIlNwpan26XjZLyhP1xYEUyjq0odCmT2TNjqNZ7rQYIml6M
         VXwgwvuFByzxAqtHDws0cY2mq3mZRml3qIXH1n/EqSu40p75QqEKD/WC0D+5pHn9O/4Z
         TlQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771458035; x=1772062835; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
        b=zVMXu7KHpfOUkepe4q8ggIvfeLArGHjvU4jVku5YBg1hWHhGVJaUl+2ifQAjdSoWYc
         igEaqjMl2E3Lgt58ji10Pgr2f7Vwv7OAjPhOqoEZp7qvs0PusD5GrOeG8Winv/3hLrER
         7cwwgf/kC1K0YZ+UwTLSgw9h/8BOzWQKHpux7XaJJD9b82Y4PEFXDR/Rr3jIVVgU3/a3
         z218YeIZ3q58w5hU2ICwHkaRuleUDM5w5mX1PegHPESs7GIGPlj9OmYSLvjFiG4vjy72
         t9ITOCANNOSH+mFVPtlVkOCzOWl7nj4U7oQv5aRkM/KUod4EG3F/8A9NgN2Pu32UKaQx
         2tTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771458035; x=1772062835;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xjxPiN30X7H58ROVHwhzf4/X04sTDdl8fl/0yuhsL/4=;
        b=gE3i4clypubU62xmXm2cmX3Nw/KRKmlK3vviaxQwFC39qSs0FZ8tgnSyHtCeWGbWI7
         D4puJAMlSmUgAMIM1M6QRV/M0zIoudo+T3xRFygq/teCcmG6icSLZNdeDBgROg/G+Ksd
         +nq1Hxt3lNya1hlrDZ2pbg3OncHdozRGShD5TQ9A3FncCw7Em4q27U+hW2Vz0Uhb2a0Q
         5Niac5IY/7pNzBFon5Yw0a5o9NAc5f4dFPBM8IZgJ1sHB8AFY39N2hwRkzQmgSUQG2nb
         ARDM+rlLwx0UZe/xXnRUqdTFktUkYwWZrLAr8sVxqGBZQKhOaEdqnvaLMNHQoxQ917RY
         n/sA==
X-Forwarded-Encrypted: i=1; AJvYcCXazpH19sMoMqBF/Uw+zitHA7WPLk2vHm5LEu0XwyVg+xRJbRH42lbZrTBBsaGt1vhBsmc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuRTa7XiXV/lbNLQLPOVI+bzdXCgTMOUujDJmgwASv5tiYDGA1
	EHkCbR9+xSto+2p4mwapBqTug+KC+Jh+rU/PkCb1yfhte8tfPV9g9Dm35Zk0Zrl+2Oj7UPhNlSH
	J4Q9ez2zJd/k+cbWAwynVw7dYp1cqsoUPihCXjtQu
X-Gm-Gg: AZuq6aIMRUTLGiI5tfruA/imu/BZ0MvcHXraqKWiOnSa7Oywi1z9Y9sleG3ID29q3Qf
	ijZNIVZhiMteXliajeNr5PlZNXNiI07WklgcBZeWgG7dU8vlt4iIfrgSPu+HinS50DviNteQDon
	9ei2uepyRgZ2wbsZevXrcaqRP6ex3fLGelccepERBpbFcf/YKz0dqER4ycFUFMb811w8BrtPlj4
	70eiX2W+59YpUPCDDLcosmVhaVRMORWu+10+To4oR3yDm5CdW4yvrToDLZbAj8Tx0tead3Aa72L
	yPrK4g==
X-Received: by 2002:a05:622a:1a8d:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-506f1dbd1b1mr2143471cf.6.1771458034886; Wed, 18 Feb 2026
 15:40:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-3-surenb@google.com>
 <dtdfrko7uqif6flc4mefnlar7wnmrbyswfu7bvb2ar24gkeejo@ypzhmyklbeh7>
 <CAJuCfpGViU4dDaLtPR8U0C+=FXO=1TuU-hT3fypNQO3LGOjbcA@mail.gmail.com> <lfnqadtmpkxjhsne3nto6bpourjv3nxw26y2a5kovump3beld7@c2pdvgxxj3ar>
In-Reply-To: <lfnqadtmpkxjhsne3nto6bpourjv3nxw26y2a5kovump3beld7@c2pdvgxxj3ar>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Feb 2026 15:40:23 -0800
X-Gm-Features: AaiRm53lCb3-A9mP4T-Ip4RZ_UT27OIlQVbKAc0RvblZzhy-3EiGT7cqg8sX1Wc
Message-ID: <CAJuCfpFr-MvDAo5wur0gGX-AMCd2kP=pBYOemwAP=G3UUVP4vQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71301-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[oracle.com,google.com,linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B2B7015AF97
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 8:46=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260217 16:03]:
> > On Tue, Feb 17, 2026 at 11:19=E2=80=AFAM Liam R. Howlett
> > <Liam.Howlett@oracle.com> wrote:
> > >
> > > * Suren Baghdasaryan <surenb@google.com> [260217 11:33]:
> > > > Now that we have vma_start_write_killable() we can replace most of =
the
> > > > vma_start_write() calls with it, improving reaction time to the kil=
l
> > > > signal.
> > > >
> > > > There are several places which are left untouched by this patch:
> > > >
> > > > 1. free_pgtables() because function should free page tables even if=
 a
> > > > fatal signal is pending.
> > > >
> > > > 2. process_vma_walk_lock(), which requires changes in its callers a=
nd
> > > > will be handled in the next patch.
> > > >
> > > > 3. userfaultd code, where some paths calling vma_start_write() can
> > > > handle EINTR and some can't without a deeper code refactoring.
> > > >
> > > > 4. vm_flags_{set|mod|clear} require refactoring that involves movin=
g
> > > > vma_start_write() out of these functions and replacing it with
> > > > vma_assert_write_locked(), then callers of these functions should
> > > > lock the vma themselves using vma_start_write_killable() whenever
> > > > possible.
> > > >
> > > > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
> > > > ---
> > > >  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
> > > >  include/linux/mempolicy.h          |  5 +-
> > > >  mm/khugepaged.c                    |  5 +-
> > > >  mm/madvise.c                       |  4 +-
> > > >  mm/memory.c                        |  2 +
> > > >  mm/mempolicy.c                     | 23 ++++++--
> > > >  mm/mlock.c                         | 20 +++++--
> > > >  mm/mprotect.c                      |  4 +-
> > > >  mm/mremap.c                        |  4 +-
> > > >  mm/vma.c                           | 93 +++++++++++++++++++++-----=
----
> > > >  mm/vma_exec.c                      |  6 +-
> > > >  11 files changed, 123 insertions(+), 48 deletions(-)
> > > >
>
> ...
>
> > >
> > >
> > > ...
> > >
> > > > @@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma=
, unsigned long address)
> > >
> > > Good luck testing this one.
> >
> > Yeah... Any suggestions for tests I should use?
>
> I think you have to either isolate it or boot parisc.
>
> To boot parisc, you can use the debian hppa image [1].  The file is a
> zip file which can be decompressed to a qcow2, initrd, and kernel.  You
> can boot with qemu-system-hppa (debian has this in qemu-system-misc
> package), there is a readme that has a boot line as well.
>
> Building can be done using the cross-compiler tools for hppa [2] and the
> make command with CROSS_COMPILE=3D<path>/bin/hppa64-linux-

Ah, I thought you were referring to the difficulty of finding specific
tests to verify this change but these instructions are helpful too.
Thanks!


>
> Cheers,
> Liam
>
> [1]. https://people.debian.org/~gio/dqib/
> [2]. https://cdn.kernel.org/pub/tools/crosstool/files/bin/x86_64/15.2.0/
>
>

