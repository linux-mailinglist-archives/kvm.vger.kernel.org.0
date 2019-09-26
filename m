Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC035BEFA1
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 12:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfIZKbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 06:31:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725208AbfIZKbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 06:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569493869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=xCM2gmrRR22cE4S9oN112VCuGwqE6kkbJ9is9al5/Hc=;
        b=LOX3RinaNWKrvgHRQPWpgGrp22KH9sS073aNVfIExLycveNg5LersJaX1KBBpcjluvQJ4M
        lbo185D114bTA5mg798OqOBFEF35M7ReDW5ekidtU5aFPlcc8iJnj476zaL4w8ijwpgPAv
        wo+I9mpF5Bir/mT/PBKXKQm/e5oyjqU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-6sQxyffKNQ2ADByEvfhpFg-1; Thu, 26 Sep 2019 06:31:08 -0400
Received: by mail-wm1-f72.google.com with SMTP id f63so842443wma.7
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dN2dNZ9PUSilO2/uPSojApb2GOkA+z7Wzm+fd/NDSCM=;
        b=ZWz7JxYj2r22qL6UkE7R/yG8XxIxVPV/8HRbbssxTjE3JXdF7xwelCSfTO7CQ2E/Y9
         dArp3uRDidWYod0AQkPZChOPayrqpj756WtgDJgTlrE/OZ88ISJ1CpR5tu2r9zoQqwM4
         soieYfsXG5iO1l0nFL2HuvlLU8QhQc7cjdFx3eneG+LpVaLJnaPGKDIw4CZAZ8SytKAZ
         gkL/PC4PEG4sWDf1lqhZxG/SqkZTQAhozXejOe+WiGpbxG1dknMvm9ixdjtPqsSzdmb3
         oFLtDLMYMyDrvop9hrV7m9UUGNvHPFTl3i/NNoFxRCyALkkqjBQOZtc9klgTXmgpwxh7
         SESw==
X-Gm-Message-State: APjAAAVeI5QZev0i/y4YaTArfwnZu4n26ISoGLJF/nxdaYrzOJ+LDY35
        ypn2N5UC6epmZU4lhiuITjfQ+8b5fqw40Xgp8vzpdizFI0oMBgTgM5O9Mbe+q4IvlxJy+wGYDrj
        pWT8btpRPgO9f
X-Received: by 2002:adf:f0c7:: with SMTP id x7mr2484763wro.2.1569493866751;
        Thu, 26 Sep 2019 03:31:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxBvPo16QpIFnZEqAn1jL1Z6+eR77EJr8DDLEUtMfwMbC/U2nbiQRObc/rrpVNY+cHSt72gDQ==
X-Received: by 2002:adf:f0c7:: with SMTP id x7mr2484724wro.2.1569493866164;
        Thu, 26 Sep 2019 03:31:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id p7sm2432548wma.34.2019.09.26.03.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:31:05 -0700 (PDT)
Subject: Re: [PATCH 2/2] kvm: x86: Use AMD CPUID semantics for AMD vCPUs
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>, Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190926000418.115956-1-jmattson@google.com>
 <20190926000418.115956-2-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f678b935-bd80-6935-f686-9dc94d9b111d@redhat.com>
Date:   Thu, 26 Sep 2019 12:31:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190926000418.115956-2-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: 6sQxyffKNQ2ADByEvfhpFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/19 02:04, Jim Mattson wrote:
> When the guest CPUID information represents an AMD vCPU, return all
> zeroes for queries of undefined CPUID leaves, whether or not they are
> in range.
>=20
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Fixes: bd22f5cfcfe8f6 ("KVM: move and fix substitue search for missing CP=
UID entries")
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 35e2f930a4b79..0377d2820a7aa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -988,9 +988,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 =
*ebx,
>  =09/*
>  =09 * Intel CPUID semantics treats any query for an out-of-range
>  =09 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
> -=09 * requested.
> +=09 * requested. AMD CPUID semantics returns all zeroes for any
> +=09 * undefined leaf, whether or not the leaf is in range.
>  =09 */
> -=09if (!entry && check_limit && !cpuid_function_in_range(vcpu, function)=
) {
> +=09if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
> +=09    !cpuid_function_in_range(vcpu, function)) {
>  =09=09max =3D kvm_find_cpuid_entry(vcpu, 0, 0);
>  =09=09if (max) {
>  =09=09=09function =3D max->eax;
>=20

Queued both, thanks.

Paolo

