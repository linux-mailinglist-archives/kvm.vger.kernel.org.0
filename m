Return-Path: <kvm+bounces-72067-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CN8PBG6XoGnhkwQAu9opvQ
	(envelope-from <kvm+bounces-72067-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:56:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 286901AE11C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CB6F0315E495
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0043F23CA;
	Thu, 26 Feb 2026 18:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kvj7Jna6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81E63E95AD
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130305; cv=pass; b=AoeDcF2Jt0lYHn+QVBrASqzYuhVl9BZ2CVqqIftsIDoi08PvcgviS2+UsfJiws+9HjXBIS3bQiyT+wNHurveqQM+nyxkpAvLvirIEzXu9de0eiNYWSMk4/KwE0qyuw6XhC+bqTZ/DIRDKel2VBjr44lGzFawDHuNH+YZaC0nH34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130305; c=relaxed/simple;
	bh=RkOElQg3CI5L6VuXrmSVXhu5vFUi5hGqRopNPO/xOxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTmloQYDyGbMHTMiDVaoTjmDXAFKPWhKWsOKJcM2W6iNteZlB2X8/ma5g+FjGLmXjQ3tK59vhZeD3z35HgnVJ97x+5Dl4QKuCjocBAkHkUMt60TXoWX3v3//vdHfqEVoq52P3VDGVqx3IWMWjqM2t7rx+KkEkseCwLXedCEA1ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kvj7Jna6; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5033b64256dso41971cf.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 10:25:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772130302; cv=none;
        d=google.com; s=arc-20240605;
        b=BfDMqtZ2QHaev6174jzUH6Yj4dnSdi+R3Rq1gC6005scEqh/IM9Xozo5eu0MQrxCXV
         PjhcrzA2r+ww5G+8IF2wgf0JL0gj0Nz84N7pJmx4D/c8rvBoE8ULwDnB3nZTRpC2C96A
         3izulpeIW99BLVNtB0fJlFdUR2M60jeJX5u83Pe019PzYDFOnaDHp2BUaTy0TW818r5Q
         iPnSonTQf1iF8gg3VVmn5l3gIUczi5fgq+PJUF+4QXBYiTF2Sqr9s78JoeZgnMF0QuQg
         NYDzh0PdWizemPn10IKzxDkBaNTS/rm+S/NWefLgdjlwr5KuCneheAVAnKPYkqz1Itl7
         kNPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
        fh=Vcjo2DP4t0fwetI8pGgykXF7of0zN8zpBU3BBsMqVFU=;
        b=EID9pT4U2MUKLNIqyD8H4dfCTFWJGD53OvUa71UunCULFoc6JjlaKe/qs3gRMo3ydy
         fTfEMUIsrv0mK8biEPrDfKZMLnrdObyEwrvyJTHSlqBRr5MRCHZ3b+2TUM3rTptDElNa
         NYrUVIRBxY9wOxklyAt5wlZuvTDMXqSBNwWIk7WghUCnsoW1X809kOdQYYpiVXcWdbM9
         Et2zTO8DNVDh+GaY+vkqMvw5XhjrQl9JUC2wWjpfznL7l8pB6RM3NbsEeV7JVEsN2UCE
         UwoLO1LJROzYNIBnwTxvV/xM/PsRKWNf6787WPwIskEx2k0jJHo1c9MldLXzEWZQ1Xwi
         0g0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772130302; x=1772735102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
        b=Kvj7Jna69aw7UQMRua9neEIg29fi2Oqr0iDdDGSHqoaFy3g4HTOM6a7KiEfMSTG1aY
         EjA/I69NvMvGaSe5aFTBy0uoliGhUFWzd+RfkdZIAG2JIYdoYhA2au5xKQJXDgSRo6/b
         uWLaYIvByeKAD0cyKDMh2T0sY52aYS76s9lE5NJ2mWkAe4uwvCJwiArP6VsqAVB2ToUH
         MwBBgSHMhoEn4xgp3I8MWr88Boau1UM3uJO1b72s1bCA1MZAIC3P/DP5175QJhWoVusa
         zThND0ZooIm+Uqb7WJBqi3KWF8D5Y5oLRn49A4v0oYItV+oRydZZVuGroDuR2xQ5+mfG
         9gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772130302; x=1772735102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
        b=tHD1Q6wEBwM3RgsYi0SWjLnnTdLFtKSHD+dU4VKUvJRCookPUwUEL9jWt/8822cC0E
         5FNpbmo4Lz07w6SgInzbWS+NQHesSqn6gmXT77VP7cHOrOZGFO8XaOH6y9BGsKN8ybWc
         tmLvM2jrleMDSVDl2kYSEpzHulg6CypqhDxJ+H5QOAROoM8bXQ9f9JiQaeqJfeO4gNu+
         H8hb1+ghtIXG7O09vzSkLrUWKCSIT2970cnnuz9lfOrCePOooWdxJWrrH+bXhZTAap5T
         vgYwoVSyw6zqU7vJf1JAgp4V4t7OKj0i47MlOz7MPP3I9nlTrqbWZ5GXzSBe+2jiROub
         Xr+w==
X-Forwarded-Encrypted: i=1; AJvYcCWRSXYpyvqleBkxy7eTsb9+3IYRM5znIVClwuExzqY/l/UW09Lisn4aI93vGIdyEvokR7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwStUFgHN55qK1JZG531peujCNRvesaCk5AhR2ZTZTnYxYNrVYn
	0wwKor9u7pJmqhTReSgV4qU/SEValkqYra0pe1jPhjnu3odgHUZzZ0aarnEkWvlB4PB8cUEtfkL
	4aJUVZAHqIH9z/2iebxVEzd2/cgjALjIv86UqZt9q
X-Gm-Gg: ATEYQzwoGdp3K2VZ+KUsjsjq4Z0sAR2L4Qi8rvByClyD8h3uvrCJCQE+Kl4++Sdn/UD
	ginTq9VGLdDsp32pwF4MuHk6WVm9LbNxGzLrpflo2hIw/ld3Nw77fx8EBNr/3PPRSlWSg8mnKnC
	1N7s0eX1LkJoUm/PYxHrtVpBv0RrjFRhdWgnRgRPYUjN9TKT8KD4E8kD3uZk4BdfkFgYcEx4Rrh
	LjKdgYgnpgQMrePdNOoRqn0WfNtTrZjBBimL24RIsfu03ts92MSNpbM34j7SrhpgSWPe6vr1hQL
	enO1Am0t2GyjQeimaYHCl7t66nhrZaoIszKiVVvQSxjQbvzq
X-Received: by 2002:a05:622a:15d1:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-507454fc6c1mr12936811cf.5.1772130300634; Thu, 26 Feb 2026
 10:25:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-4-surenb@google.com>
 <20260226191007.409a7a21@p-imbrenda>
In-Reply-To: <20260226191007.409a7a21@p-imbrenda>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Feb 2026 10:24:49 -0800
X-Gm-Features: AaiRm52wFdTJC6YvOb26vvaOOFR294VpLCUuG2iciIW7CwkMabryiSXuJJdbEug
Message-ID: <CAJuCfpEk_VPqwpqtAiCJSR5bkvHuzvC8ooXrB4jKTYnQB2D4YA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72067-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.995];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 286901AE11C
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 10:10=E2=80=AFAM Claudio Imbrenda
<imbrenda@linux.ibm.com> wrote:
>
> On Wed, 25 Feb 2026 23:06:09 -0800
> Suren Baghdasaryan <surenb@google.com> wrote:
>
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it. Ensure users handle EINTR correctly and do not ignore
> > it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c |  2 +-
> >  fs/proc/task_mmu.c       |  5 ++++-
> >  mm/mempolicy.c           | 14 +++++++++++---
> >  mm/pagewalk.c            | 20 ++++++++++++++------
> >  mm/vma.c                 | 22 ++++++++++++++--------
> >  mm/vma.h                 |  6 ++++++
> >  6 files changed, 50 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 7a175d86cef0..337e4f7db63a 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned=
 int ioctl, unsigned long arg)
> >               }
> >               /* must be called without kvm->lock */
> >               r =3D kvm_s390_handle_pv(kvm, &args);
> > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof(arg=
s))) {
> >                       r =3D -EFAULT;
> >                       break;
> >               }
>
> can you very briefly explain how we can end up with -EINTR here?
>
> do I understand correctly that -EINTR is possible here only if the
> process is being killed?

Correct, it would happen if the process has a pending fatal signal
(like SIGKILL) in its signal queue.

>
> [...]

