Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB97F75FA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKKOH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:07:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20235 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbfKKOH1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 09:07:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573481246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ZGs0M6vNOlR72l+3qKrXi768QPAALJbpnXDDJqiP0K0=;
        b=ANwsGQxPB9LPAIWYyd7f04BMg0ZKth9TSyE47uZ6u6M40/haBQGTH5TsfLRXPA1R8CFib2
        C4zh85iiayjpoPwfVULgD5VTZOW6j9OTWsgTPK4en4oy93qh+cNozU6bT1P0YPV5huseZd
        Gek2gtBsW33c3kNKkD0c6G5Rf2rifZo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-0by6CQwYMBawjAdK-tT_qQ-1; Mon, 11 Nov 2019 09:07:25 -0500
Received: by mail-wr1-f72.google.com with SMTP id m17so9939582wrb.20
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:07:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHT8z9ApKJ84GVmGisp2JZyy+3t2iYfQwx7HQlS2FAw=;
        b=sOOLg7yxA1wiAyaZCXZbIDNxEcZENLWQ9JjC35klbVDGTSBa3M1fZpUW4aqy9AJJUU
         kmfX5TPPstXbLX8ZsAlxlCX0fRcK/xGHPhbzqBLKIrU7WPk2FweIeiq+qwjdsUM9ZMCb
         iuIB/OnqTZMMPGFmj3iohQjlIwqFRw5Bu8G3YmACAWZjD8QMRxPXRJHdhyrqII43WI63
         SdRRBVmyvF5tbEiTaoWPuMeOGhXjgwSCNAsW13opINldwoSJo0b4YNMO51fiSrlR8Ghu
         zL5vzpM8Kaudwq6lxitrJuaHdNotmRJ6II/42GRzwPM9sfPLU1fekjLVR04N9yqEz/J8
         hKAg==
X-Gm-Message-State: APjAAAUGQxllyIay/Gm4IzZWPQSSbD65qHb4SUC4U/gvxsHb/p5q/73l
        i1EK6LGtqwRY/FS+0bD2QvK3XjgGzTlrxZhmlGGHiXERSznhriZ0ZdUxBFnnYlseRKToywCrNe1
        3aYvV9cOWKlh2
X-Received: by 2002:adf:f60a:: with SMTP id t10mr17727030wrp.29.1573481243880;
        Mon, 11 Nov 2019 06:07:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqymX6a+Us/pFWg+HkVt+RJVFYpS4w6sHQvgwVRhK7Od4V2R+giqMbAZhKM06rQzj9qXOOvIcw==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr17727007wrp.29.1573481243620;
        Mon, 11 Nov 2019 06:07:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id f14sm14645823wrv.17.2019.11.11.06.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:07:23 -0800 (PST)
Subject: Re: [PATCH] KVM: MMIO: get rid of odd out_err label in
 kvm_coalesced_mmio_init
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1573286900-19041-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e6780f84-e5e5-09ec-3cef-535a2d33ef92@redhat.com>
Date:   Mon, 11 Nov 2019 15:07:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1573286900-19041-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-MC-Unique: 0by6CQwYMBawjAdK-tT_qQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/11/19 09:08, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>=20
> The out_err label and var ret is unnecessary, clean them up.
>=20
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/coalesced_mmio.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 8ffd07e2a160..00c747dbc82e 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -110,14 +110,11 @@ static const struct kvm_io_device_ops coalesced_mmi=
o_ops =3D {
>  int kvm_coalesced_mmio_init(struct kvm *kvm)
>  {
>  =09struct page *page;
> -=09int ret;
> =20
> -=09ret =3D -ENOMEM;
>  =09page =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
>  =09if (!page)
> -=09=09goto out_err;
> +=09=09return -ENOMEM;
> =20
> -=09ret =3D 0;
>  =09kvm->coalesced_mmio_ring =3D page_address(page);
> =20
>  =09/*
> @@ -128,8 +125,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
>  =09spin_lock_init(&kvm->ring_lock);
>  =09INIT_LIST_HEAD(&kvm->coalesced_zones);
> =20
> -out_err:
> -=09return ret;
> +=09return 0;
>  }
> =20
>  void kvm_coalesced_mmio_free(struct kvm *kvm)
>=20

Queued, thanks.

Paolo

