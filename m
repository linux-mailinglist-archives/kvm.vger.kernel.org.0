Return-Path: <kvm+bounces-72604-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SM2/KkdOp2nKggAAu9opvQ
	(envelope-from <kvm+bounces-72604-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:10:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D891F7372
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1613130B409C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2FA3A6EF2;
	Tue,  3 Mar 2026 21:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="htilFfbV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDA9384253
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772572108; cv=pass; b=smebmEBMjm2Tqfin3Y+I/hW2FZFvVjFB3bdS4bf5xQgQIKc8oS+69Azym9Qln8xbTFJnCW2tv8x5Fwp6vgKtUpRq92dzfSSt483+hVDnGqbGt03y111RC0B91He5wcysbYinIGWlIY+hPp1D5sA4yCQVsYRQGmxBpFs9rJUEvyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772572108; c=relaxed/simple;
	bh=KEkVamCoeFISLCmjti3x3hvAOikseimZp+4dyxL4Jmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofIsOZ2hi9wYXq5u3/LQCTSbgDfM6T5v5ivVbu4OnmoDRcCoTYf9dwvHE2E0U11xDxlY2ZByIDBsE4NSA31kDeaKxr45CU88+sjnRMBypEUXUlcOh+PYW5RtWuXznO1Bv0ddgam5FvJtLlS9YIEwWMmbq2vb+fWO68rElGcbKdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=htilFfbV; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-505d3baf1a7so652221cf.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:08:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772572106; cv=none;
        d=google.com; s=arc-20240605;
        b=N7IQFZ3zhuC+X2cBYcWui8+S2m1CdFaZ19A5xkX44eBY+51fFml4xn6C50lhVHl0PX
         ArvcGpEOk488Nt/PfCVZQ7HCD5ZaPOYqlepWHrrPVDRqqNMNmYmPa0GWkvcMJwv39X1N
         Veob4XtQutdybIGqPIyKLDr6rLr/i7tLdglKaRB3fQXUwcwVqH7VtQoNi6OGUbMBpKcR
         QxA/c5jjrwrTcZppxZN2Y0IA68tU/WEKiQ409JIIYuMd61HOuYGa4U0mlctBtNje33Gl
         1u3E7JPU84wk360CRB2/7mh3A6nqJkKhrvLD9mFjwCMVXinVcQsUmGFlPK2eOjk1fWY9
         KlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
        fh=JoWDSSqZJ5LlevCIC6zhAx/gPKbV7ptZEu6KPUyYkYI=;
        b=GfJlCyBY4+nPnKhwWiWP9JV17v1xqPCKtIvSQ9+tRM0wIQebNOKy0AVrB7rZmjlQCZ
         8yqRxN9yGMSXRWD3sxHboSmpYUc1//+y/VXoBaj12Kz/JYKwrgNKwriDkMdkKfHjKMp2
         n6kiNHL1GyabVkODmHJ52ZMiyz7+U3Xsm0QePdaRUm8oufvndRXHlXi4Uc5t44DE5MLw
         vzKMo1u24AYj2MZKqW3V0xM43hUOoeBrOTesYqeGPokSFtZK2lSF2eqCRBWUkB+GDiZU
         2sQM4tBqza/rcv0BW+ASuhLefkEQ8ptLbwoh/P0gQkTaPvu9aSJo1NPrpjVqB93XdEDh
         lMoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772572106; x=1773176906; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
        b=htilFfbVzNItWcnwEt9SMUFi7ba3iCxdaaMIXtleC4O/fng9tkBtBBxrGcS1cEtzRg
         UB/qqqthVL5LjoPs8wSwOkCiTw9HdjJaU5czx73019QUPTa03dKluY5RSFxhn6avyywK
         19zhDQ54ZT4QT1ciCa0/Pw7xFwvZn84/eO59ft3LJoJWD0hjrSujUtXIG+QJlDVqXVO4
         eGj8D6hoT7TqTkEccs0LNxS+DFmwTzMBf0O2L4BaDr2ZHoJTgQb4ptPODmqLj2ejXe3E
         zvSQgrmeSbdX6hXK4W/5Hd+RhZtpYxJe3CUJDZGPe03EQOdpbNo69KsofrqeQxT6lmkj
         brgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772572106; x=1773176906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
        b=sC8OYz98J+Lq02Lo7r2SntberimFvygMd3d91trRYfJu4UxgjktWnBuTAfYxqno8eG
         8QfatHtk7GP9q6MH94gZ9XBQlSwv0c27pFg55+TPQrdDGCyfpwvIc7gs6ijEmrsHhNTp
         apQ2FudnIhmHT5uyveQcyqSRUyFYhrvPrdTreVVPSWaEbBTVvmiokStxFFZOJvlrxxWY
         WDO4bMJlj8WbgX5KZD3xin9xxQMEVQeP+VU1cmYraPvAar/CBZXxpv1IhumDBsG7a/eF
         JR7RIK/pjWwRJnI68mQcZJ4C0P2R2dQkQ/3mncL5yS/yN0LxUKv8WsKwot9TnpMP8vab
         UvNw==
X-Forwarded-Encrypted: i=1; AJvYcCVQo/ogmbHRndwlp/V4uaPOqTmUDDDWxRxEp+6t1mQ/8KXb9raieZq9XXa3t9o5rWil3RM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN/nmSRpeWlGiSU4fcW2MZg/VVpVTirI7rHNI6saeIFrDN4dKH
	6MC1i1bY6qGr/7qg0l6bh3RjVXXHhHMf/X+W6+eYt44ewoMo5zRsheD/yTd0EzG5IDSAWQ7vvAl
	NthROFHuT4OeLfjDjSJDNHvwztOFy1AiWPBEKs0XU
X-Gm-Gg: ATEYQzxbapwNEyZUHIvy/k/pcgZhJZcVXCG3Bm97LB07vpPJxE7V8udkmPBWPsihlHR
	7E1QFmrW+YyZE0gNwWz4+ii2Z0Jb0luZWQkAeSornUYq80iI4W6GE/r+ZWussG/p/wdAFrDc6Yu
	H88eSRoh7HKEC34fjWQmALXlYmWxt6I2AWNdLgUU6sPHL4kvjKe+5dDQLRU+397EacfBQsQhSBn
	5a9rFDv1AMyFQ3NqqVNHk7V2xDdY6652Up9WxhjBytUbkGpd08tFaLc/vFC9x41QHTl/nJYiG4p
	iT1Uoiiyzsi2IS7g7NWOMF2aW8G3+aeNMvZM
X-Received: by 2002:a05:622a:1999:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-5075fcedcc2mr43645141cf.6.1772572105403; Tue, 03 Mar 2026
 13:08:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-2-surenb@google.com>
 <877a55ac-b12d-4997-8c0f-fc0405220a63@lucifer.local>
In-Reply-To: <877a55ac-b12d-4997-8c0f-fc0405220a63@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 13:08:13 -0800
X-Gm-Features: AaiRm50S7J7MsSFOK2DH7gtLJxKekAGMKhFqAJWn8DaN9ladXIEjtSX1nx_7JMk
Message-ID: <CAJuCfpHD8wKJTpaRjZtUR3d+e4hSPH4GyL9DCKwbVWDVxWXRug@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/vma: cleanup error handling path in vma_expand()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 49D891F7372
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72604-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,oracle.com:email,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 5:57=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Feb 25, 2026 at 11:06:07PM -0800, Suren Baghdasaryan wrote:
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
> LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

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
>
> > +     if (vmg->copied_from) {
> >               ret =3D dup_anon_vma(target, vmg->copied_from, &anon_dup)=
;
> > -     if (ret)
> > -             return ret;
> > +             if (ret)
> > +                     return ret;
> > +     }
>
> Thanks that is an improvement!
>
> I was going to suggest declaring 'ret' in each block but that kinda adds =
noise
> so this is fine.
>
> Maybe rename 'ret' to 'err' but not a big deal, this function could do wi=
th a
> little more cleanup too I think!

Sure, since I'll be posting a new version I'll do the rename too.
Cheers!

>
> >
> >       if (remove_next) {
> >               vma_start_write(next);
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
>

