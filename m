Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8BB446214
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 11:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhKEKUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 06:20:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233034AbhKEKUa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 06:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636107471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s64YJyWRQD4QRcpO1AO69rPoeF4+3h+YhFg9hdrJPPY=;
        b=P31jLOWv1rorGHz6/vN2JYY/L/cBRkX0NQfpHpk00oZNvcvJ7/qmk7A8a2aMwQY4LLfD9W
        lqkfKGiw2DKFRXsPnwSKcWBkut6nvQUjBSJ+R3ZviENwDkByT+HfgEb9cagr9PoEM8T2CY
        /anVrtrnj1cp1VsYpOH2+h67z7jQaXs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-crQC42bDNc6iSaCmyrqT1w-1; Fri, 05 Nov 2021 06:17:50 -0400
X-MC-Unique: crQC42bDNc6iSaCmyrqT1w-1
Received: by mail-wm1-f72.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso5497345wms.4
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 03:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=s64YJyWRQD4QRcpO1AO69rPoeF4+3h+YhFg9hdrJPPY=;
        b=afQC02P/3EMnyUKCbdqxcszs1Z+hoFvU1/fRWTTjP0J0riEOzGqCck18WIVbW4cqNd
         +ezQKEEFO3h4xEZ7e6SsX44a2rTnsCyQPBMCFoi54HSvXOF60mpzj+jctq2NXmdB0McV
         eYyEXkPxh+eLVLw/+/4w8xIhwVJWxlYOpydLEauz2TQ8/Gr2stk9fKiGdoS1mSk0tJUo
         jCUVBp386P+eCA3v2w0Z1LstRcYKdTgnIv4ELnTeOXpaEHEEdcVhBiCTxPuWe1ySuCOi
         Y4tv7SzpFWbPL1gH0jT0El4u3l9tnigKPC13CW4AuIlxJDZ6ytArm7LNXNV0xwcQf3N4
         uP4w==
X-Gm-Message-State: AOAM533QAtTW+CeKspwd0R7yrarmQhbisVgdK2YIh9ezkHWa/AKh562H
        70rGxY9OvLtUvdxE+9SNKAaZwCVYb5KQARdePGXTyhGpHiRAH6NWCIy4FNs5YhZxp3fosJR47q0
        AddfLxB2lF+Jw
X-Received: by 2002:a7b:c005:: with SMTP id c5mr29234156wmb.150.1636107468788;
        Fri, 05 Nov 2021 03:17:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMUh8OeRnIWIsY0lA01uJy4wH55Rklvl3ciseMmHgfehTFnLdO+COw4j1f1czWLBqX7+oMKQ==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr29234143wmb.150.1636107468617;
        Fri, 05 Nov 2021 03:17:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r17sm7672649wmq.11.2021.11.05.03.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 03:17:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH] KVM: x86: disable pv eoi if
 guest gives a wrong
 address
In-Reply-To: <652f048a85d548d7b965680d9300e26b@baidu.com>
References: <1636078404-48617-1-git-send-email-lirongqing@baidu.com>
 <87v917km0y.fsf@vitty.brq.redhat.com>
 <652f048a85d548d7b965680d9300e26b@baidu.com>
Date:   Fri, 05 Nov 2021 11:17:47 +0100
Message-ID: <87k0hmlxdg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Li,Rongqing" <lirongqing@baidu.com> writes:

>> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
>> =E5=8F=91=E4=BB=B6=E4=BA=BA: Vitaly Kuznetsov <vkuznets@redhat.com>
>> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2021=E5=B9=B411=E6=9C=885=E6=97=A5=
 17:08
>> =E6=94=B6=E4=BB=B6=E4=BA=BA: Li,Rongqing <lirongqing@baidu.com>
>> =E6=8A=84=E9=80=81: kvm@vger.kernel.org; pbonzini@redhat.com; seanjc@goo=
gle.com;
>> Li,Rongqing <lirongqing@baidu.com>
>> =E4=B8=BB=E9=A2=98: Re: [PATCH] KVM: x86: disable pv eoi if guest gives =
a wrong address
>>=20
>> Li RongQing <lirongqing@baidu.com> writes:
>>=20
>> > disable pv eoi if guest gives a wrong address, this can reduces the
>> > attacked possibility for a malicious guest, and can avoid unnecessary
>> > write/read pv eoi memory
>> >
>> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> > ---
>> >  arch/x86/kvm/lapic.c |    9 ++++++++-
>> >  1 files changed, 8 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
>> > b1de23e..0f37a8d 100644
>> > --- a/arch/x86/kvm/lapic.c
>> > +++ b/arch/x86/kvm/lapic.c
>> > @@ -2853,6 +2853,7 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu
>> *vcpu, u64 data, unsigned long len)
>> >  	u64 addr =3D data & ~KVM_MSR_ENABLED;
>> >  	struct gfn_to_hva_cache *ghc =3D &vcpu->arch.pv_eoi.data;
>> >  	unsigned long new_len;
>> > +	int ret;
>> >
>> >  	if (!IS_ALIGNED(addr, 4))
>> >  		return 1;
>> > @@ -2866,7 +2867,13 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu
>> *vcpu, u64 data, unsigned long len)
>> >  	else
>> >  		new_len =3D len;
>> >
>> > -	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
>> > +	ret =3D kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
>> > +
>> > +	if (ret && (vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED)) {
>> > +		vcpu->arch.pv_eoi.msr_val &=3D ~KVM_MSR_ENABLED;
>> > +		pr_warn_once("Disabled PV EOI during wrong address\n");
>>=20
>> Personally, I see little value in this message: it's not easy to say whi=
ch particular
>> guest triggered it so it's unclear what system administrator is supposed=
 to do
>> upon seeing this message.
>>=20
>> Also, while on it, I think kvm_lapic_enable_pv_eoi() is misnamed: it is =
also used
>> for *disabling* PV EOI.
>>=20
>> Instead of dropping KVM_MSR_ENABLED bit, I'd suggest we only set
>> vcpu->arch.pv_eoi.msr_val in case of success. In case
>> kvm_gfn_to_hva_cache_init() fails, we inject #GP so it's reasonable to e=
xpect
>> that MSR's value didn't change.
>>=20
>
>
> Hi Vitaly:
>
> Could you submit your patch?=20
>

Sure, I will.

--=20
Vitaly

