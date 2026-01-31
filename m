Return-Path: <kvm+bounces-69758-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLfGGxxKfWlZRQIAu9opvQ
	(envelope-from <kvm+bounces-69758-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 01:17:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB9CBF964
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 01:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2524A305EFAE
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1B52F6900;
	Sat, 31 Jan 2026 00:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ffoSa8dd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D0285C98
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 00:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769818557; cv=pass; b=DYVhUaT7ArM7diZnyEKdFEPvd9c/eus9132/DGXhwQqtLKWyszDcTfdy9efKWmvW1N3iPjavspmv4ZKcm36iPg6bR1/ZH+SlaVEraE1KU/Z27QhX+lcIS6lSa6uKW6va3vcLBdggiDR68peVqYVWkFpE8wDOO67v0FPQ9GR62xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769818557; c=relaxed/simple;
	bh=XL4ym8S7YTp5+9WWsHosOBbyfPJoZokKlvMfADw3SJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S53iN6ZyZ+TUMttU6LQ8N9CW+wfx2fX0+9dSdxajgZxhSSkdafvrTsnyZjx6Vt+4SHufVt1V025iiN+hYRgPntd/TsnAURnSlB7EUzdoZ7F8qlzoCArGf5P5MaNiBXoDZsJHuLjwKMkcSazzJ0PAaQkN60WpZm1MXI35rWQ5Wmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ffoSa8dd; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7cfd65ea639so1693197a34.0
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 16:15:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769818555; cv=none;
        d=google.com; s=arc-20240605;
        b=Qp68fAgV267S8FeuhVkX9hOt2787Al3qTVX+Si1WlJI595dO00ic68Ixwmkv4KMlU9
         ecY0SiYPTiEZ/L77mX+nYPwLSdjmvOK4LUI2v8Jr1wKWQS9cE7mHENke6HKygNKOcQMu
         H+1gfLxE590TTwfkHopJlQ5DaZgOhOtoG1o85o0rTB+pUdbSigxy5VH20xNaa4lh2YD+
         tACCU2CABCX29W+TJgMwSdpQ7lDdPKquy6fQaBRicKCuzt1VFN9kyHqa9L0LYDXD/Lyy
         F62kmGlhhynlcqU2tcUpGv0UkjvHD2q+3sITtsIv+minq+DbROdoma7FR7sRF6cYZJuK
         p8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yRm5sfCTEKVx/sN5RzP4+dvvkIsVmkN2zIPCD6RD2hs=;
        fh=rtIgVhpugR/obvfe8W0zUBpufD+wy/zNf7G/ZTC4L6Y=;
        b=FjBdbS39astQiDwKBqZMNpkmPPKaFoWpowS+8vRmrh3NMrcp3piO2uknJ56Ql4aPL4
         FeK8XixID7v5xLmrwpaAdL7/ilybo82YAAVu9LC16vaang42sz/gCxZ4T+z8T2uKkZvY
         vAbjDnTyp39ttRgQZOcM7JcxdjV94iiFVpZ4cZSKFa8SkpnzotU2jSxCyV9Fa5iAsPkL
         nHH41HDQYnDc598DAk6WzJQIjOyYLrwlGoshhLaI/+3dkVhBp0dDyncn4dWqlRoNgtmF
         INol3oJ+VuvQDFJJLsQQzFivkk3swjjIPrNiHnWa9rXpM5AHSbcsiUFs8VTerCfnYSV9
         Xgwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769818555; x=1770423355; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRm5sfCTEKVx/sN5RzP4+dvvkIsVmkN2zIPCD6RD2hs=;
        b=ffoSa8ddAZb4tvOOrVmCOOWaPAq8JVG+SOu8iXv87yWjJry8ZvbPUMwvDQ0UgUrzvI
         30eN3LWOfseDxMCrsHjC5tj2pgf6NLt3XheEsIdqgbimdLUKd5kTA31jZuafQHf/tcZ9
         1YpDE2hXV9Ym6rTm3mUdcry/svKQwPixQO6yeyJ83KU5WAPqL71Dc1+U/diGwxlauxPf
         QLzICipXq2jjZOcjGJIXllHYvAcDs8+nua6oexgD5gHXiykiEhgnJPFY3rwHVshuVJxg
         QJfD236jO+HD0vlQnWktSZGvSklkgbnjpjAF/CsZ7Dksu9LRQDYUzyNU/xFTx+BQpRvr
         2ZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769818555; x=1770423355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yRm5sfCTEKVx/sN5RzP4+dvvkIsVmkN2zIPCD6RD2hs=;
        b=g3mLQs+i2KjxZkV+tOabNgQky7uVmGL/RXV5gQXVxCHkuqHKJqIy0LTCDP1GLOD4N3
         m/F90Jzzc+dWSX6JJPskbidPavslYGNITDBs61cAZVL36mdcFSEgUBqpe1pga4x5kInv
         wusXHO12Aw6YcZD76zDt/1xNd03TLdKWQAAsS1Q/G3wjX18EzVEuoIeCrjXBL28QMopw
         w1/axZ8RAxhcisLznqCo4Yu9A/ordtRtY4KlHjolotKEfL4RdW7i+AGfEcFQPDMs/+Pg
         rox+uLNFrMAxaV8kOKEh4wuDJmFzTKDJuXpaPShSWx4P2oWl7ZVayWlcGJnwOOmQfsnf
         /KTg==
X-Forwarded-Encrypted: i=1; AJvYcCW+zXaArarQxXdzme9nwMWUjq+XJpfGcVrk+kw+UG5z0cGaoVXgCt28Cw4S1lxqNlh4g0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh5Jo1dqiWaDXZyTZwJJ6TOWvg9sJ2Tams8bq+shM3bN7eRHuV
	3QXQWRNn8y57MJwhCGW/Q9wov5ML7jgpSVD8CxvKw3ezqYHdnAG8LMK+3KroHAv+H1UWbP8oDen
	fqnG/eoPvCKKbaG6mekHC1nBaIW2U7E0=
X-Gm-Gg: AZuq6aKGzagK9lZ1QYBi3H4I6furSLsarxv1+wH0xio4qDmNaJ7aINqqkWaAaS7nHtG
	0m8UvxCkLUT48bdOPq5LytqoehPm8tXYHUacNEHsyow4zZ1yb6KleM0QBBwNz9jsUqu7dYBBirf
	hJq8OTSkgA4mqGiaUP+6MVoZBTMvR/3uxfEoAB4eA4VKKD7iDyxBpJOwUiGkmLBUiOW4Xgp8Gz7
	rbUvlmryoZ7musSK9GpAxilkIvYlh6NyCHe/kq6Be+Etd6MsWXSitOI0fA8vKtI+R0efdJuPkuk
	aDCK09IP+hVFZ+vcwDGlrAZ7Ug==
X-Received: by 2002:a05:6820:4489:b0:659:9a49:8f33 with SMTP id
 006d021491bc7-6630f3a6d87mr1889512eaf.68.1769818554970; Fri, 30 Jan 2026
 16:15:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260124022042.2168136-1-xujiakai2025@iscas.ac.cn> <ydibz63oh6tj66utjlemeikxg7iateqoox3bwg7r4pdvbwijoj@5zxhlhesvv2t>
In-Reply-To: <ydibz63oh6tj66utjlemeikxg7iateqoox3bwg7r4pdvbwijoj@5zxhlhesvv2t>
From: eanut 6 <jiakaipeanut@gmail.com>
Date: Sat, 31 Jan 2026 08:15:44 +0800
X-Gm-Features: AZwV_QiUFp1qYkWALkWr6hfzyepY58cE_Y-BcKFDEwgeIpp64Dx1DEYCOS4-mFo
Message-ID: <CAFb8wJsPgfE2WRE2wcuYUwkqr27vGOPVv_VHJttQzWoA3dL_0Q@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Validate SBI STA shmem alignment in kvm_sbi_ext_sta_set_reg
To: Andrew Jones <andrew.jones@oss.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Atish Patra <atish.patra@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Jiakai Xu <xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69758-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1AB9CBF964
X-Rspamd-Action: no action

Thanks for the review.

I=E2=80=99ll send a v2 shortly with these changes.

Thanks,
Jiakai

On Sat, Jan 31, 2026 at 4:48=E2=80=AFAM Andrew Jones
<andrew.jones@oss.qualcomm.com> wrote:
>
> On Sat, Jan 24, 2026 at 02:20:42AM +0000, Jiakai Xu wrote:
> ...
> > diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_st=
a.c
> > index afa0545c3bcfc..7dfe671c42eaa 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
> > @@ -186,23 +186,25 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcp=
u *vcpu, unsigned long reg_num,
> >               return -EINVAL;
> >       value =3D *(const unsigned long *)reg_val;
> >
> > +     gpa_t new_shmem =3D vcpu->arch.sta.shmem;
>
> Please declare new_shmem at the top of the function and there's no
> need to initialize it to vcpu->arch.sta.shmem. Actually it appears you
> meant to initialize it to NULL, based on the 'if (new_shmem ...)' check
> below.
>
> > +
> >       switch (reg_num) {
> >       case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
> >               if (IS_ENABLED(CONFIG_32BIT)) {
> >                       gpa_t hi =3D upper_32_bits(vcpu->arch.sta.shmem);
> >
> > -                     vcpu->arch.sta.shmem =3D value;
> > -                     vcpu->arch.sta.shmem |=3D hi << 32;
> > +                     new_shmem =3D value;
> > +                     new_shmem |=3D hi << 32;
> >               } else {
> > -                     vcpu->arch.sta.shmem =3D value;
> > +                     new_shmem =3D value;
> >               }
> >               break;
> >       case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
> >               if (IS_ENABLED(CONFIG_32BIT)) {
> >                       gpa_t lo =3D lower_32_bits(vcpu->arch.sta.shmem);
> >
> > -                     vcpu->arch.sta.shmem =3D ((gpa_t)value << 32);
> > -                     vcpu->arch.sta.shmem |=3D lo;
> > +                     new_shmem =3D ((gpa_t)value << 32);
> > +                     new_shmem |=3D lo;
> >               } else if (value !=3D 0) {
> >                       return -EINVAL;
> >               }
> > @@ -210,7 +212,10 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu=
 *vcpu, unsigned long reg_num,
> >       default:
> >               return -ENOENT;
> >       }
>
> Please add a blank line here.
>
> > +     if (new_shmem && !IS_ALIGNED(new_shmem, 64))
> > +             return -EINVAL;
> >
> > +     vcpu->arch.sta.shmem =3D new_shmem;
>
> And another blank line here.
>
> >       return 0;
> >  }
> >
> > --
> > 2.34.1
> >
>
> Thanks,
> drew

