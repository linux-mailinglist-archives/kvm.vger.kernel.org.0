Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6370ABDF6A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407043AbfIYNtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:49:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52851 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405963AbfIYNtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569419350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ess1SV7/89t0Gs5dcoLtffnrMG+DIOPMIxep3Wn+FdQ=;
        b=V581igE3wKCV62rCZM7zPM/dl570D3n0fcWqUm2BQcZDM93tVKlqPjG60RxryUu1BvsCwg
        wMLMrfEUqNkvDebiiSoXzkXIuLpoyKVfeP/OizajCAWN20XU4DjcF65Q5kQUMVKYTlB2EV
        iEW65tDF5qeFQEB8hTaRRA2bqy6nDpI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-nlHNZeToMAarnjPw5oa8Jw-1; Wed, 25 Sep 2019 09:49:08 -0400
Received: by mail-wm1-f71.google.com with SMTP id s25so2101336wmh.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7HwbMqRPla3XzEtPRNCpsd23jwZJdRUKQ8Q3k0M+3A0=;
        b=G8KmO98y8kxSDjFTR8vodjK64HdjiTjpAaXqrTU/pIvbykvxAUmuDqc+4CR90d/Y9N
         bfDMQkOrbIYq6Vr0mg8adFgi2O0QC5My2j5SFJNsvGtDw2UajRKv5yjSf0nAmeSTn7dx
         EMTXnwXggZ/LFITrlk672t8bEf0Cu5nKl8san+2u6/1ydzsbQonmAuAMqsQ2MUT0dx5m
         MSb8wFxg/nlvELznyleQkQ3z+MEHoAGwS5xks5iHKuNl8umRmyaqEAOY+sGzN38z5Qu9
         UOLxHQ1cZukmq/udAg88Oo4Pa1Rbi5lK8RT+R4n471R++D4b0iXiJOSSZCAelEXW5O/B
         SufA==
X-Gm-Message-State: APjAAAW8dvamBkyEWRLejVHRfYF23MrVzqdUYB30ey7Y3x/+XsQCH6QL
        oYLSnw6HRRBaSGlIDdnzB9fT4+tE2iPjgrmxmWUd4MaxXJtq/XZwMScmWrMIGupSihHufCvPmRt
        tF9PSmfGDmimc
X-Received: by 2002:a5d:684a:: with SMTP id o10mr9325078wrw.23.1569419346680;
        Wed, 25 Sep 2019 06:49:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxume3E+rEZ5rBdLU9MLkVXpYtDGtRy6pk4Du33BHTcqQDZNHjnuMo+SPZX7J3BHEpHjNeaLg==
X-Received: by 2002:a5d:684a:: with SMTP id o10mr9325059wrw.23.1569419346417;
        Wed, 25 Sep 2019 06:49:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id c18sm3626808wrv.10.2019.09.25.06.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 06:49:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: debug: use a constraint that doesn't
 allow a memory operand
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org
References: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <97179bda-2c90-7aba-e2f1-f65612125a23@redhat.com>
Date:   Wed, 25 Sep 2019 15:49:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGG=3QUHwHsVtrc3UYhhbkBX5WOp4Am=beFnn7yyxh6ykTe_Fw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: nlHNZeToMAarnjPw5oa8Jw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/19 23:00, Bill Wendling wrote:
> The "lea" instruction cannot load the effective address into a memory
> location. The "g" constraint allows a compiler to use a memory location.
> A compiler that uses a register destination does so only because one is
> available. Use a general register constraint to make sure it always uses
> a register.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  x86/debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/debug.c b/x86/debug.c
> index f66d1d0..2327dac 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -113,7 +113,7 @@ int main(int ac, char **av)
>   "and $~(1<<8),%%rax\n\t"
>   "push %%rax\n\t"
>   "popf\n\t"
> - : "=3Dg" (start) : : "rax");
> + : "=3Dr" (start) : : "rax");
>   report("single step",
>          n =3D=3D 3 &&
>          db_addr[0] =3D=3D start+1+6 && dr6[0] =3D=3D 0xffff4ff0 &&
>=20

There is another occurrence, also this has spaces and tabs messed up as
well.  Fixed up and queued.

Paolo

