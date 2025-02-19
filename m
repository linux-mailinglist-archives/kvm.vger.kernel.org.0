Return-Path: <kvm+bounces-38523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD44FA3AE50
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC8D8188B275
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DF3195B37;
	Wed, 19 Feb 2025 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="N5d6Wgvv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F71C28E
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926525; cv=none; b=NONwnLmJVgZPuD9m8nnMevdK63gyuWy7kfKn3oClCyW43Sv+1ZhZDqLFN8zYuoPa/LqPsE3G/66EdCxHBG9rB7L38n/xcWz6DP4enJiKD/R5qfFQKlO2/AapIzHxjbU5e1sjgNW4QlmUj0OFBM0dyif7oCj8bLuRpbP9j5cYhvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926525; c=relaxed/simple;
	bh=0HD9f6Q0+um9Uu9vpR4Q8s30w3Xw/Vd5V2C8wzjWp/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bY2Ht/Z45kautEiLPmpEjNeEJn3i3/vmyrx5PMDWaKB9r9UFu/oFnJC0rp1qqpWivJDhaBqUg+PtiUTdmxqLGA6eF3VY0sF6NYp1eNYzmLw/bpLmMQAFBboiyYmmCyYE8sWsuYyuXd7mPlCDhrYR3/FZkUol9EF0e6QWIWetc40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=N5d6Wgvv; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CB4F43F2BC
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 00:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1739926519;
	bh=NLWmLVqr39FXw4/AXsNpGlD7g8VdYK2vZxqlgBh3Mq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=N5d6WgvvtZDo8ZeXzDv5Do4QRSIEVotZC7qpGDZV05/56tQZItDPLKBmQW4R7tjaZ
	 CSq550HClqf3+EzXixM9RbtQ415uu1N72768GKXBDihk7uEjrOR8Zn7/r1o8vzx0ny
	 vmd+XcucueC33PJ9FHNqye1oFttYE2JtII62UGh8OprpCsAJBxlJtteRuhAa7CsBXA
	 gBhwOyD2fOiqD4j1smOxA/qdUhNlsB49RvdMmC5Yo9edWsfsjugeruKTRwy5LV6JZS
	 1UyRXieaVtEDWfIp+TKqgO9rbECAC3meNkGqNfvjv2wkDpGeaSMg7UBvIhlkQ8OXQ7
	 CG8cyz8ujnUOw==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5ded802b571so4986810a12.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:55:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739926518; x=1740531318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NLWmLVqr39FXw4/AXsNpGlD7g8VdYK2vZxqlgBh3Mq8=;
        b=LJGvDoC77aU8PSMu8bSpe+B06vfjV0xYca92a8SPe8BRR3U3DW0uaGOll5YoPtiFL7
         rKyYiSBFgTMU4nVbH04LHT1hRToeUOLcFa4hCuQhZNW2mc8Rx8WxFQ9S9ouOdxs9q5x7
         jQh6nW+tftsbkqyHmv7iV7opdMTSLErnBlsFuvrmIp1m9CaLcP76O7EETPIEInrJrFNE
         ufZFI0b29vIwDX7lwJ4BDppJn9DFOLwmjmKVqdJWjoJgMwuaW5h7txby9GupnzkWhEzz
         UAeDGgVwpRo9ga1twXvWDDxluMNZtk75WMIRf8XQcQ7rW3dqljmk5PjAHzWOJqLdHQ8i
         aMJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHToLZPlzR7/iOhjCdcfsmHyw8xEM/eQFA7gK7uqTbckxu0Srks+3xDpEVW4gNpbW9FAc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+8P32jcMzD54vUrmRhtXR9RQ69dYML69fl5n+vX/1RTNQxN9m
	YsQ2Ks39KAGOKpGc6ngURDC0sCW9wKobOvs3K0E8R7qsQ75AvFNmo9b3jD1TEAghmAD8UfAl03b
	h68u+oK75vlG1rkj0AvDz2+JOp4guchja3oq0x26jfxa+1k0p7t4oEL1PqR3TyWEa5+uQ9fff5d
	PocFolMJom3+xZQ12zlIQVdl78cVqMMKP0pX3RCIjhAwvmLiJbgO0=
X-Gm-Gg: ASbGnct4s0WCaWcsXxizWA/HR+3wcBBz76d8dgeU4I8tK6K37X+rOW7kw2WAn1Q43GR
	OaaU9Qag/oXq4Nmn9h4hU4Ai/bX+7Yl9Wd37LjHJUK4bjNH2JBtg8sbVyI5Wq
X-Received: by 2002:a05:6402:5246:b0:5de:39fd:b2ff with SMTP id 4fb4d7f45d1cf-5e035f49943mr17649877a12.0.1739926518679;
        Tue, 18 Feb 2025 16:55:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGT2uJA8DApXDK/hkpgpT6514+F1RAcaCyRGE946iObnvNukFLaBB3sPmzN2RQj66iTo73OWKv3q72y5RXj+GA=
X-Received: by 2002:a05:6402:5246:b0:5de:39fd:b2ff with SMTP id
 4fb4d7f45d1cf-5e035f49943mr17649870a12.0.1739926518350; Tue, 18 Feb 2025
 16:55:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-5-alex.williamson@redhat.com> <Z7UNsiRfdOWfZWuq@x1.local>
In-Reply-To: <Z7UNsiRfdOWfZWuq@x1.local>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Tue, 18 Feb 2025 18:55:06 -0600
X-Gm-Features: AWEUYZlI5D_is7dzf1BazOzKeFxBNWJyWcCvq6K9QTXLgIopUjBtOh6ETRN7vx0
Message-ID: <CAHTA-ubd8eTAt41n41jTR-O6PH+aVMvufghtYCja5xv3DwC+nA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] vfio/type1: Use consistent types for page counts
To: Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, clg@redhat.com, jgg@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

No change in behavior observed from v1 on my config (DGX H100). Thanks!

Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>

On Tue, Feb 18, 2025 at 4:46=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Feb 18, 2025 at 03:22:04PM -0700, Alex Williamson wrote:
> > Page count should more consistently be an unsigned long when passed as
> > an argument while functions returning a number of pages should use a
> > signed long to allow for -errno.
> >
> > vaddr_get_pfns() can therefore be upgraded to return long, though in
> > practice it's currently limited by the batch capacity.  In fact, the
> > batch indexes are noted to never hold negative values, so while it
> > doesn't make sense to bloat the structure with unsigned longs in this
> > case, it does make sense to specify these as unsigned.
> >
> > No change in behavior expected.
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> --
> Peter Xu
>


--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

