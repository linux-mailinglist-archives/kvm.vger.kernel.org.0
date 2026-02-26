Return-Path: <kvm+bounces-72060-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEy+KO6LoGkCkwQAu9opvQ
	(envelope-from <kvm+bounces-72060-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:07:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC8A31AD41B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A0E313093554
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01113290D1;
	Thu, 26 Feb 2026 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fNjhrGYm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F217D3290CA
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126615; cv=pass; b=XLEfYD/xoL/ndoA/NlLRBenBatsJiAHN8mvwsnUUsvV7x1rtjvSfljSgDE3l8KZsw9NR/t8lOiIFxhdAPDsQXf3h7yx0ANl3/PyYgr1WnRTTgi/UAXsgfx+Rll/TvbHkLxhMD9mfQHDKfxMmCxxcdNWvoc77WhQ+scA7OQDpbrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126615; c=relaxed/simple;
	bh=zN1A0NVoCrNndk1h7brwP4PDvP8PmvZiG+Q9N3TyOjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=oRt9TPMYcPtiKqP00eGRQMzPOFn2ELnSjHIjul3V1wZVeG157f3WlNw6e94p073+HCLO+iu2akCk7UfZdd84USf/2NJ4jVrl3Anjsqg3iCJGpNoQcORjQkWPKIp5HCpa+stV5DK4HsC8MmFLfOo0+b1eA9ZcOsghqdejaKmpF6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fNjhrGYm; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-505d3baf1a7so639741cf.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 09:23:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772126613; cv=none;
        d=google.com; s=arc-20240605;
        b=jZXdUa35qBpuNsIPychsVU2EwTN8qFmagOWcXPVlyrZsitVfW2AYi4tEK0/haAVPR6
         aZGQSW528Uz39ACPwVkkdPK4C9+Rsg7b1jaWsfpiT2R00iE53v/9P5GplWXLqstJwFQ2
         i/1vgQiR77SE3GpMI/t7x56uwZrR0uHYIx5XTEhkrtNbUqA9AWdcOtx8ViuO7qDQw/bG
         m/PFDeglv1HA6wdjV+EPkp4QLVhMqC6IyHDbO18DWV51b0bogCFO4eQdlU37mZsndxBw
         J9EL6M0bt0SjBHqZ/iWIJelG85Ju1YX4G9QEfy8BDsSwXo2+O0g7VPUVbroHn0O49UuG
         3kfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
        fh=nsPVUg0/g25iJMkuqbBBgnnVjdWqBXXyPp8HMRC3+eg=;
        b=aJPQMcWP2xOErXkcNeCcc/sMr6o4BCY+y3ZtwtAlzeA/GdJfz5tYF+VHR5EwD4+JCx
         WA0ZqsOnSXT02Bab2CQS6jBEgM2LoCRxiW2sfAtRnFsh225OQxoDTD7Tg0FCnw1jU3Ju
         w9NW5vlHCvvykYRgYdWrrvSTyWL8/AlUysFZ2rdLFYOwL3Ir/hNqkjVpJzDjCMxVDmzy
         07+PJAV9QpNBFxgeHP8UPzzp7kRFU7WJ9bnAny8XyclAFRhHpUebwDqdWUcK3lix7o1e
         /klw7MTeSyOGcd9ZykkXG0rxcMUNODuqLKVUJbyqwXGZpOSf0eR0Xvsf1ILVITj5fe3A
         L5bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772126613; x=1772731413; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
        b=fNjhrGYmxWL/YvzTLQjN5I8tbQIsTwhB5AZcbt+xKgVJv7BpVOMppvdGMgoTSVX7Za
         Sv/8EL6RNO0WbR8pK9cfM8rRHzbM0poFvzkJ0Q78MWj3x/qRR652mwVmVoL4KAxrc1Z3
         iSMsurK8ZnETiVfLLcYbgMYtvitEoGN0GZzq6m1PRH0VOm0RwcTq67hhdgRsn1wE6ecF
         YXY+oijCE6Pp429gC8WJA5oppjEYYyDpEexm0b9zlNA2aytoiGR/ptaHTEMo8zfRbNfh
         KD+FV9EhJLV+ZaK4PUFFmZLyXEHzQpX1VdJ6JZid0uQjg0KWWp9QhqzY+qINiDENV3o7
         RjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772126613; x=1772731413;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FynKKhlWalFQKKrs3ZP5yNMAhsIr6fWHYQm9TKDGe4A=;
        b=MNbeI+6z0OXjgWLqWjjTMiEhWBOTtXlZgQ2O3HuGzkGza4/pD4gMbP2Sofh+nufBKl
         Plst++JzhVljHB9MjAoLHFJWitzO1zWcqyQBqUDRtL46zLgQmMUHJ40A9Qh1Svu4KrmN
         V6pC59f0eLUaK/c0WC2IR7LF91NCZEb4jf7GeydjZUb5cYh8n3Bz16Co8Jvg6gZijaXT
         zetD4+BkmpJ0qYdw48MOGZsm1M4gkDf0+vOJHVtIckcUE5vThPUulQG1RBo9IviHxCbF
         Xx3pFgvWfeTxYJFGr5KpcfhtcuRjdlsWvD79D2xFpee/5wvtcbtBviOHk7+Ie8dScfCd
         nV2w==
X-Forwarded-Encrypted: i=1; AJvYcCXwkBKDM+lO/RnRam/ATnXyGPwrA9rcU1bRCiKkdH7TJV6/q85L+wp0lAz0Z6I7x739Y00=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQzPB/XeOiW1q9h33JnsezW2nKsVrmU+hIZI2sc/383crFE9gB
	sNOlhTTLlk5z/LXKHuhMQWr37OOlqJ1CFGMhmbrTO2FzZYGy2MRKg57IAtcnc7QZuFg5NAWNii1
	aqo/ZUbw4CBWyK/T6S7+ku5A0daKWMgXga86YQRjb
X-Gm-Gg: ATEYQzwq2xqQA9BO3mZ/T49juSfd2FliOvoqncCkwijUMjB8DEI4ghjRW9oBQR5lSNO
	bbA0giXWVghldDYqGo0EoqozHagmjvcmGoJl5d7gHzbsq/NUONEawIIRv+VlFu72gSPbxF2AckI
	y6j/Ny98Yf/6FOMbXslOqZlBLySbRxPmg7IVpvuEHgvUe5cxGY4G5adR1X4mVPbqV5WfW9n1XG0
	2nIgXx42Cn9RSjesYLOTYWUQzbR0e3ob3MdbpbUSgmjAECyMxA4WWePQ1VdXi7oqMTxbxui74x2
	1UXU+iP/6Vnfm6BBJNK8KRIAwwekembEQYgt/NP6JLkakA5o
X-Received: by 2002:ac8:7fca:0:b0:4f1:a61a:1e8 with SMTP id
 d75a77b69052e-507441ca8aamr14889431cf.10.1772126612071; Thu, 26 Feb 2026
 09:23:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-2-surenb@google.com>
 <pifgesxxxcwcrarg3q7sgiybg6d6laaym2jcj2h44wqoaxopcv@idc7vavsmjsd>
In-Reply-To: <pifgesxxxcwcrarg3q7sgiybg6d6laaym2jcj2h44wqoaxopcv@idc7vavsmjsd>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Feb 2026 09:23:19 -0800
X-Gm-Features: AaiRm51NlioHOecXqmKgqusOoAstD_F3nrG3Ao8qrpHVfKsEfdkgNePW1BjyYWA
Message-ID: <CAJuCfpGTNuojCXUQU0o-WrCRAuXPUAtLtSG=c8BL00JvnvNBiw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/vma: cleanup error handling path in vma_expand()
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
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72060-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[oracle.com,google.com,linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: AC8A31AD41B
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 8:43=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260226 02:06]:
> > vma_expand() error handling is a bit confusing with "if (ret) return re=
t;"
> > mixed with "if (!ret && ...) ret =3D ...;". Simplify the code to check
> > for errors and return immediately after an operation that might fail.
> > This also makes later changes to this function more readable.
> >
> > No functional change intended.
> >
> > Suggested-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> This looks the same as v2, so I'll try again ;)

Sorry, missed adding it. So again, thank you very much!

>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> > ---
> >  mm/vma.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index be64f781a3aa..bb4d0326fecb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * Note that, by convention, callers ignore OOM for this case, so
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> > -     if (remove_next)
> > +     if (remove_next) {
> >               ret =3D dup_anon_vma(target, next, &anon_dup);
> > -     if (!ret && vmg->copied_from)
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +     if (vmg->copied_from) {
> >               ret =3D dup_anon_vma(target, vmg->copied_from, &anon_dup)=
;
> > -     if (ret)
> > -             return ret;
> > +             if (ret)
> > +                     return ret;
> > +     }
> >
> >       if (remove_next) {
> >               vma_start_write(next);
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
> >
>

