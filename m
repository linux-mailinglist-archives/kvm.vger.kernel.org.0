Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE874105467
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKUO2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:28:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45331 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfKUO23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:28:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574346508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qunIedvZoqaKok1Es37xOr2zxDWhnBKGE2xiOqEdTbQ=;
        b=ZaY/vcrpdFSri8TPZFce4v21JjgLIPFNyxbieQkDl0gbeWEjctjvP3y/7lQDbbo16TFHXh
        LlO0mgg2FmFEdRqhmZ3YyADwy5IKtGvGLV+Ngobwrzp9trvc9RjZEBdGD9SmYiWxB+yrcR
        GB308X99WwZDr0EdApFx9e6fykLjmAI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-1KcCEtDkOlmlWMWSmrtcaQ-1; Thu, 21 Nov 2019 09:28:26 -0500
Received: by mail-wr1-f69.google.com with SMTP id e3so2143792wrs.17
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 06:28:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JDhlodKbBGR2xq2l8pd8Qh2cvnVa+E6rf/WWc4SNwIY=;
        b=puakNFp3s9EKBfhQ8extkfQLKzFduPV9/IqSCU+UPmFePUJuvovrpy7wAVCBSRiSYk
         igZ4ns79v/vGECRXiiUa9Xam/JXcHBDFDYxy+/Hv0zGUIF/ABqliJxHT6rjLZHt62gDH
         MHp5emrZ+Sj8uPoW0WM3zvxxQ39XKJgCPz/nZrj70pNHXxP7izmLCN2G981DoZ33w9OC
         s+T3EtNjQXgFV3EKQQmHMVuFDgqJlpIi/pYm7y+CioffbQsKt8k1gLQc/94hi6PCORIF
         MCrQ9z8xsYYVKRSOLTlrr/MmkG8Gm7NxOlc38V88IBvIo+Usv4Y+dYa9rbLE6aDPVu5O
         EQXQ==
X-Gm-Message-State: APjAAAUvsgqFSIQsHIcwK73+zGzTfq2RxlNiuZTaUeEpXO6VjAGRhtgE
        amxtuCw6h31pKosOXxsx7thjCqOvUM+rGjb3+VZc4DfSDomlCT7mNEznQdlK1eucJINK1ehU/zz
        aptcTgeyLoxan
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr10512012wmc.69.1574346505606;
        Thu, 21 Nov 2019 06:28:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUVQZfjhyuJakG9KLQtcyAWuccYrKFRy9I3c7KAp6hgXeIJo3EZCpQIagT3pe6x+eRjFMZrw==
X-Received: by 2002:a05:600c:a:: with SMTP id g10mr10511889wmc.69.1574346504369;
        Thu, 21 Nov 2019 06:28:24 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id a8sm2973417wme.11.2019.11.21.06.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 06:28:23 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: expose "load IA32_PERF_GLOBAL_CTRL" controls
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1574343138-32015-1-git-send-email-pbonzini@redhat.com>
Message-ID: <d7c8232e-30b5-ca50-d5c4-34aed3210d31@redhat.com>
Date:   Thu, 21 Nov 2019 15:28:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1574343138-32015-1-git-send-email-pbonzini@redhat.com>
Content-Language: en-US
X-MC-Unique: 1KcCEtDkOlmlWMWSmrtcaQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 14:32, Paolo Bonzini wrote:
> These controls have always been supported (or at least have been
> supported for longer than nested_vmx_setup_ctls_msrs has existed),
> so we should advertise them to userspace.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Nevermind, they're actually very new (lesson learnt: cut-and-paste of
commit messages is bad, especially if it leads to incorrect Cc to
stable).  Sending v2 at once...

Paolo

> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..4b4ce6a804ff 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5982,6 +5982,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_m=
srs *msrs, u32 ept_caps,
>  #ifdef CONFIG_X86_64
>  =09=09VM_EXIT_HOST_ADDR_SPACE_SIZE |
>  #endif
> +=09=09VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>  =09=09VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
>  =09msrs->exit_ctls_high |=3D
>  =09=09VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> @@ -6001,6 +6002,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_m=
srs *msrs, u32 ept_caps,
>  #ifdef CONFIG_X86_64
>  =09=09VM_ENTRY_IA32E_MODE |
>  #endif
> +=09=09VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
>  =09=09VM_ENTRY_LOAD_IA32_PAT;
>  =09msrs->entry_ctls_high |=3D
>  =09=09(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
>=20

