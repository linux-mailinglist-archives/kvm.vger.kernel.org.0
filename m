Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B712100E9A
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 23:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfKRWJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 17:09:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726272AbfKRWJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 17:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574114952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=l+1PGj+H4rKQuFV+YphzHIiRLQRDixGf9l5dALjfLIw=;
        b=DSb2qxuk0tUTrmhFOFf0NtJ21UFvOI1YgeBCmm7GnrhmAr3lXpwuvcnzKuYAguV9sC3l8P
        uYkg0srkWyrEfg73GRf8fLM/4m0nf4Kv6JU8aiYH0oQjluLBuxDmgK9u+tS606FGQmVFDj
        qAyvK2MFjfgWkTl7mLsuVkDWdRdWcS8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-KSBxqVvGM--k8SgGDuZt-w-1; Mon, 18 Nov 2019 17:09:09 -0500
Received: by mail-wr1-f71.google.com with SMTP id w4so16833217wro.10
        for <kvm@vger.kernel.org>; Mon, 18 Nov 2019 14:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DeR7oGmeiXKQ7yA5ehhnmdSVxed2wOzO6TKfrdCxJIU=;
        b=CNYUdpNrFz9+ZBUEf9xnpCrKgjXf5JzWunISAcKEHifqhrBSDmRgKt1DgG1N+tJibY
         5N5sxNiACZ7LG6u4twUDt9E0Hy0+nfsu7R7u7Ig36BkB1ZTn9qZ6xV6gKFlu+DJL7GSB
         uj3GFbR8B8D7aLZVFPI4c6yzhsxid2iwiuvkor0KVfmPPi9+w7z/wgngOXugDSppC+xd
         HUVOG3CudDiyOoiktLKcal640oCNIPkdnstsS/4KwYxIdukRLccySAkiPhTAeyHSdLwU
         KfEYFcQWagqJqwvo7O+4uBJGXnoWBVkZsQkXy3UWJPErm+lwFYe2eTx/nY6c1a1gt66c
         0Vvw==
X-Gm-Message-State: APjAAAWOHJu+hb5ZpHFMIY69Yk8tYIROEKST5x3lA8OJZQV3osMy2ws1
        fptV4rO+t8gjaVmyKIjLWCQV6GIdnlPkCC8WYn4pxULsxbSDS8IZQyiF4w7YVBbLmC37J5W3vcC
        u6bwwnULIfZq6
X-Received: by 2002:a1c:9c54:: with SMTP id f81mr1742159wme.89.1574114948061;
        Mon, 18 Nov 2019 14:09:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjngXelaqGBSrfPaz5aV5ersb7VpL5X/OEb2Kf5523fDbdhDJrVYMUhkF8ACasf71Smk+Lfg==
X-Received: by 2002:a1c:9c54:: with SMTP id f81mr1742130wme.89.1574114947778;
        Mon, 18 Nov 2019 14:09:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id v9sm24085812wrs.95.2019.11.18.14.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 14:09:07 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Use semi-colon instead of comma for
 exit-handlers initialization
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Mark Kanda <mark.kanda@oracle.com>
References: <20191118191121.43440-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <83268078-036f-5cc7-9033-b3ad1f05123c@redhat.com>
Date:   Mon, 18 Nov 2019 23:09:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118191121.43440-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: KSBxqVvGM--k8SgGDuZt-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/19 20:11, Liran Alon wrote:
> Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc11fcbbe12b..229ca7164318 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6051,23 +6051,23 @@ __init int nested_vmx_hardware_setup(int (*exit_h=
andlers[])(struct kvm_vcpu *))
>  =09=09init_vmcs_shadow_fields();
>  =09}
> =20
> -=09exit_handlers[EXIT_REASON_VMCLEAR]=09=3D handle_vmclear,
> -=09exit_handlers[EXIT_REASON_VMLAUNCH]=09=3D handle_vmlaunch,
> -=09exit_handlers[EXIT_REASON_VMPTRLD]=09=3D handle_vmptrld,
> -=09exit_handlers[EXIT_REASON_VMPTRST]=09=3D handle_vmptrst,
> -=09exit_handlers[EXIT_REASON_VMREAD]=09=3D handle_vmread,
> -=09exit_handlers[EXIT_REASON_VMRESUME]=09=3D handle_vmresume,
> -=09exit_handlers[EXIT_REASON_VMWRITE]=09=3D handle_vmwrite,
> -=09exit_handlers[EXIT_REASON_VMOFF]=09=3D handle_vmoff,
> -=09exit_handlers[EXIT_REASON_VMON]=09=09=3D handle_vmon,
> -=09exit_handlers[EXIT_REASON_INVEPT]=09=3D handle_invept,
> -=09exit_handlers[EXIT_REASON_INVVPID]=09=3D handle_invvpid,
> -=09exit_handlers[EXIT_REASON_VMFUNC]=09=3D handle_vmfunc,
> +=09exit_handlers[EXIT_REASON_VMCLEAR]=09=3D handle_vmclear;
> +=09exit_handlers[EXIT_REASON_VMLAUNCH]=09=3D handle_vmlaunch;
> +=09exit_handlers[EXIT_REASON_VMPTRLD]=09=3D handle_vmptrld;
> +=09exit_handlers[EXIT_REASON_VMPTRST]=09=3D handle_vmptrst;
> +=09exit_handlers[EXIT_REASON_VMREAD]=09=3D handle_vmread;
> +=09exit_handlers[EXIT_REASON_VMRESUME]=09=3D handle_vmresume;
> +=09exit_handlers[EXIT_REASON_VMWRITE]=09=3D handle_vmwrite;
> +=09exit_handlers[EXIT_REASON_VMOFF]=09=3D handle_vmoff;
> +=09exit_handlers[EXIT_REASON_VMON]=09=09=3D handle_vmon;
> +=09exit_handlers[EXIT_REASON_INVEPT]=09=3D handle_invept;
> +=09exit_handlers[EXIT_REASON_INVVPID]=09=3D handle_invvpid;
> +=09exit_handlers[EXIT_REASON_VMFUNC]=09=3D handle_vmfunc;
> =20
>  =09kvm_x86_ops->check_nested_events =3D vmx_check_nested_events;
>  =09kvm_x86_ops->get_nested_state =3D vmx_get_nested_state;
>  =09kvm_x86_ops->set_nested_state =3D vmx_set_nested_state;
> -=09kvm_x86_ops->get_vmcs12_pages =3D nested_get_vmcs12_pages,
> +=09kvm_x86_ops->get_vmcs12_pages =3D nested_get_vmcs12_pages;
>  =09kvm_x86_ops->nested_enable_evmcs =3D nested_enable_evmcs;
>  =09kvm_x86_ops->nested_get_evmcs_version =3D nested_get_evmcs_version;
> =20
>=20

Queued, thanks.

Paolo

