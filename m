Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E47D1A34
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 22:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbfJIU6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 16:58:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37093 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731763AbfJIU6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 16:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570654721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SXdPrh5SQBY2g5E44Kbwxu0eoL2g32/Mh7xHjPoo0bo=;
        b=b+MkdQxgCXYhaf2rMUnZAHqJRzXZvIRdOzD3b3+scqFmOtDYAJLkuQJc8LNG5jR8P7mj/T
        xbphmPiVKibSfZZkEgMnESKqIHNgmH9KRse0b3T529Y/ajhGhFXh1VcZAiYm9YDgzYYwd4
        3TmuD4vCyVaXxAJddXEqM8E9YzFDN/k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-MrfLmIxDPHembUjNlzufPA-1; Wed, 09 Oct 2019 16:58:40 -0400
Received: by mail-wr1-f71.google.com with SMTP id z1so1633660wrw.21
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 13:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZCiTiFbtDiMRheTU38K9dij6O6J26jyHcq0IPo3YkI=;
        b=bRLwY4kxAQdOhMugsu0Np+wwno1yLX69jXSTpvF43hA8rSaRYRziRWZ/ZfP2hC7kDS
         Rsr2xOmSuURLHLfAA1G1Fh0k2ADp/m4LXQAm6Tm+7qPbBHx+jkSiQeOkyXwqU8NrTXJq
         qsw47sed6b/Q6BKphUuFItauu6zzJ1oiAV1HldrCUj6yPrffvOVN3OLFjmyxaUWd44eG
         tXRd7Zdb5Thk3gETx28R7qH9iISMzEE5PdRK3gxuXrmjU32vmIw0ecoJjGv/zQu4ENTj
         ZFkh7CpI4Rrjy/Loe4IfHbJ/MZihMdSlZIl7IDPdUzv7iWFN7isGsr5eN8c31EnlT22y
         TUWw==
X-Gm-Message-State: APjAAAUaNRoWaRswzDh554yRSCcsamQ9xjiHcwk6y419KZ9LCz6msPuR
        WDbEjp8stNv6egNPGW+2K/YfpBduFj7RilGTKk+hsCOrJu/eDVnAuXV4F/XKQk+1yI29b3krZr7
        gXYAfvl/RztD2
X-Received: by 2002:a5d:544a:: with SMTP id w10mr2258709wrv.271.1570654717999;
        Wed, 09 Oct 2019 13:58:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxX7JfRvkV9uOOZ0iYaYnAdc1Oax5CH0j4BaeLo2KW73O0Nr1ynOw/1ZdsltoZnfUbPMApWTw==
X-Received: by 2002:a5d:544a:: with SMTP id w10mr2258693wrv.271.1570654717701;
        Wed, 09 Oct 2019 13:58:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1032:7ea1:7f8f:1e5? ([2001:b07:6468:f312:1032:7ea1:7f8f:1e5])
        by smtp.gmail.com with ESMTPSA id o9sm5463455wrh.46.2019.10.09.13.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 13:58:37 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.19 08/26] kvm: x86: Improve emulation of CPUID
 leaves 0BH and 1FH
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Marc Orr <marcorr@google.com>,
        Peter Shier <pshier@google.com>,
        Jacob Xu <jacobhxu@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
References: <20191009170558.32517-1-sashal@kernel.org>
 <20191009170558.32517-8-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5fcb0e38-3542-dd39-6a1c-449b4f9f435e@redhat.com>
Date:   Wed, 9 Oct 2019 22:58:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009170558.32517-8-sashal@kernel.org>
Content-Language: en-US
X-MC-Unique: MrfLmIxDPHembUjNlzufPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 19:05, Sasha Levin wrote:
> From: Jim Mattson <jmattson@google.com>
>=20
> [ Upstream commit 43561123ab3759eb6ff47693aec1a307af0aef83 ]
>=20
> For these CPUID leaves, the EDX output is not dependent on the ECX
> input (i.e. the SIGNIFCANT_INDEX flag doesn't apply to
> EDX). Furthermore, the low byte of the ECX output is always identical
> to the low byte of the ECX input. KVM does not produce the correct ECX
> and EDX outputs for any undefined subleaves beyond the first.
>=20
> Special-case these CPUID leaves in kvm_cpuid, so that the ECX and EDX
> outputs are properly generated for all undefined subleaves.
>=20
> Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation supp=
ort")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/kvm/cpuid.c | 83 +++++++++++++++++++++++++-------------------
>  1 file changed, 47 insertions(+), 36 deletions(-)

This is absolutely not stable material.  Is it possible for KVM to opt
out of this AUTOSEL nonsense?

Paolo

