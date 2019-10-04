Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94FB8CB4F2
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 09:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfJDHYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 03:24:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21594 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729310AbfJDHYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 03:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570173862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=pbx+rCyRuyCn21y+hMG3H967or+R7JkmlueXXHjswlI=;
        b=iAEP6pklB92aWgdHUKgKjVhNjTZvzyPrqAa13NwMArbO79C5K2c6iI3HEN3z6J32y5NNXt
        zoXtw/QSVeBUmIUsD3VZVMG/Ng4eZQEdDZsRDDGoELgi+DRpjxwx33AD+gBok8CZr8NvSH
        JZYvklIRM1oszBMH0khPqgjTueYZuWg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-rcAigjbjM5u1tZoq_Z1XkA-1; Fri, 04 Oct 2019 03:24:21 -0400
Received: by mail-wm1-f69.google.com with SMTP id k67so1250694wmf.3
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 00:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KI34XlCdh0iqJ/GDbHNFKp63Pe8m93EMqaoBoOW2RL4=;
        b=ZrIbAn0WnHCtQ0ZbH8r9jjeLL5/OZ5ZfHI9dO5i0nktUjHzAa8/4ZbhIu6lRkLCMfe
         cO9E6Iiz0XMHEOyqwOoADAFtP389swKP1X4hEHTPi1cI7nJNcCP1KOMbem9FqAiTcq/4
         N6EqZndZUROx0Be/k7S33IZVPFKdHsRopQjNFzE7Xmst7sMCGMMEfxT2z+Jl3qqcIgtv
         v6Ymoxg+UkuSdlTIbdEoRX9tS42A2oqgqqi3XA5xmDU3SYD8Lni8p3yUKCVzGIzNw4gn
         tCedo49yUCTUxfJ8fLuSA9thRwWe7xKAYLWI5fIDWw6mb/IMQckmGpACmT3Knay0Fprs
         /YVg==
X-Gm-Message-State: APjAAAW3S6uqLf7MHSjJqa322unO99EvMdPVYBAGtvapnCjk9eccvN7s
        vIvc35C1ZEZ0oWcvFp1rCv38oeXTUPwreE5lE149FncHY1CC4PGX/VMXpuQ15s/aCJNxw3GOZve
        LVUaGZH0Ny20Y
X-Received: by 2002:a1c:a8d8:: with SMTP id r207mr9383065wme.135.1570173859640;
        Fri, 04 Oct 2019 00:24:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxL/3Qg2/nFz5WGI22MgLAEnEVS+FvuTHhN/9hwnbJvJz9GG9hDmIIQ7hOMBhmCec7dUA13VA==
X-Received: by 2002:a1c:a8d8:: with SMTP id r207mr9383044wme.135.1570173859354;
        Fri, 04 Oct 2019 00:24:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id b16sm5729190wrh.5.2019.10.04.00.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:24:18 -0700 (PDT)
Subject: Re: [RFC PATCH 06/13] kvm: Add KVM_CAP_EXECONLY_MEM
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        luto@kernel.org, peterz@infradead.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-7-rick.p.edgecombe@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0f2307a5-314d-d3df-0bc9-4c1fbbf93f72@redhat.com>
Date:   Fri, 4 Oct 2019 09:24:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003212400.31130-7-rick.p.edgecombe@intel.com>
Content-Language: en-US
X-MC-Unique: rcAigjbjM5u1tZoq_Z1XkA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:23, Rick Edgecombe wrote:
> Add a KVM capability for the KVM_MEM_EXECONLY memslot type. This memslot
> type is supported if the HW supports execute-only TDP.
>=20
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm.c              | 6 ++++++
>  arch/x86/kvm/vmx/vmx.c          | 1 +
>  arch/x86/kvm/x86.c              | 3 +++
>  include/uapi/linux/kvm.h        | 1 +
>  5 files changed, 12 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 6d06c794d720..be3ff71e6227 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1132,6 +1132,7 @@ struct kvm_x86_ops {
>  =09bool (*xsaves_supported)(void);
>  =09bool (*umip_emulated)(void);
>  =09bool (*pt_supported)(void);
> +=09bool (*tdp_xo_supported)(void);
> =20
>  =09int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr)=
;
>  =09void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e0368076a1ef..f9f25f32e946 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6005,6 +6005,11 @@ static bool svm_pt_supported(void)
>  =09return false;
>  }
> =20
> +static bool svm_xo_supported(void)
> +{
> +=09return false;
> +}
> +
>  static bool svm_has_wbinvd_exit(void)
>  {
>  =09return true;
> @@ -7293,6 +7298,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_in=
it =3D {
>  =09.xsaves_supported =3D svm_xsaves_supported,
>  =09.umip_emulated =3D svm_umip_emulated,
>  =09.pt_supported =3D svm_pt_supported,
> +=09.tdp_xo_supported =3D svm_xo_supported,
> =20
>  =09.set_supported_cpuid =3D svm_set_supported_cpuid,
> =20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a30dbab8a2d4..7e7260c715f2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7767,6 +7767,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_in=
it =3D {
>  =09.xsaves_supported =3D vmx_xsaves_supported,
>  =09.umip_emulated =3D vmx_umip_emulated,
>  =09.pt_supported =3D vmx_pt_supported,
> +=09.tdp_xo_supported =3D cpu_has_vmx_ept_execute_only,
> =20
>  =09.request_immediate_exit =3D vmx_request_immediate_exit,
> =20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e321d788672..810cfdb1a315 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3183,6 +3183,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>  =09=09r =3D kvm_x86_ops->get_nested_state ?
>  =09=09=09kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
>  =09=09break;
> +=09case KVM_CAP_EXECONLY_MEM:
> +=09=09r =3D kvm_x86_ops->tdp_xo_supported();
> +=09=09break;
>  =09default:
>  =09=09break;
>  =09}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ede487b7b216..7778a1f03b78 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -997,6 +997,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
>  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
>  #define KVM_CAP_PMU_EVENT_FILTER 173
> +#define KVM_CAP_EXECONLY_MEM 174
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
>=20

This is not needed, execution only can be a CPUID bit in the hypervisor
range (see Documentation/virt/kvm/cpuid.txt).  Userspace can use
KVM_GET_SUPPORTED_CPUID to check whether the host supports it.

Paolo

