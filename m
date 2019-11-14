Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FCCFC62D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfKNMQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:16:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38221 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbfKNMQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 07:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573733793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6g3FuiSmJL+Kk/iwiMI9WeS/k56NyXnRD61zjnDeFo8=;
        b=CWMhGPaUV0aKGd4SQk5OlLb7qD4pwJ81W2piEt/dB2oRo6m+w6YeoO2CMqXwDx0U3J6zBB
        r3ob9WqqJCTyY1ZlIxYwYBsQbwuBSYON2zXLRrGo7Ee6jTAHzg1X1+OquUFGCOY2BCXcmV
        O2Wg3FiM8eCEX05YMGNmyPBPDAxvABY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-wH-5KiBPNCm-6e7kyCfNqQ-1; Thu, 14 Nov 2019 07:16:32 -0500
Received: by mail-wr1-f71.google.com with SMTP id h7so4331828wrb.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 04:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wbG6hQQW5/T3L1JRr4XcKwwPNPz10SDjCnOLcci1gTs=;
        b=rmYutrqHz05Kmj34ldpPS3IJAsTECZYMjse/mAbY/7YOh0+mo7Rol667DcjDfM4WdI
         0xQ+AEH+a8QVZ2SiDpk7sRo+d6tC6LPjE14gVpwESFueZteFNa9y+Jlqbdvb7XsiUbgS
         oyycadotQTU5cd2muyUxdD+s+eecBkzcSPeNpndwsl5f+aYrIjuhchdmbjZ1maRERRvU
         21hSgEjNflNBbWbOgqikBC9ws206kHbAg+xunT5q0LxNrAGgJzWLHw5ytCYsxfeLrKka
         6hZ0ia8+YqdkdQ0cP38k7nJyv17VzTrw29r2YfcajjsEtuGGTPTV2JluwzWP+m1ky2fE
         F07w==
X-Gm-Message-State: APjAAAUo7tJSIyXOJaMOkrTrSbyptPk7rpPmYBDXzNFAABPVt5XRNs3E
        qGlT119lFqNFdIexk6wqjMgPqg2IeBZNJO6Vmbt8XXiXwZmpBrAsHKKeL5XxhNs7e4XjaCjC0a/
        sanFzXmFHgK8x
X-Received: by 2002:a1c:7f94:: with SMTP id a142mr7299107wmd.33.1573733791357;
        Thu, 14 Nov 2019 04:16:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqwm8L07aob9pGVI1BqTnXUFu0oi7C7NBJZTfOSxIoMVifSd1LDxfNMr/utRbXLIyyw76nANLw==
X-Received: by 2002:a1c:7f94:: with SMTP id a142mr7299081wmd.33.1573733791064;
        Thu, 14 Nov 2019 04:16:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id w13sm6588216wrm.8.2019.11.14.04.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 04:16:30 -0800 (PST)
Subject: Re: [PATCH] selftests: kvm: Simplify loop in kvm_create_max_vcpus
 test
To:     Wainer dos Santos Moschetta <wainersm@redhat.com>,
        rkrcmar@redhat.com
Cc:     shuah@kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191112142111.13528-1-wainersm@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <70986b1a-5a04-cbd6-fe1a-fda4d97d5a72@redhat.com>
Date:   Thu, 14 Nov 2019 13:16:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191112142111.13528-1-wainersm@redhat.com>
Content-Language: en-US
X-MC-Unique: wH-5KiBPNCm-6e7kyCfNqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/19 15:21, Wainer dos Santos Moschetta wrote:
> On kvm_create_max_vcpus test remove unneeded local
> variable in the loop that add vcpus to the VM.
>=20
> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> ---
>  tools/testing/selftests/kvm/kvm_create_max_vcpus.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/t=
esting/selftests/kvm/kvm_create_max_vcpus.c
> index 231d79e57774..6f38c3dc0d56 100644
> --- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> +++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> @@ -29,12 +29,9 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcp=
us)
> =20
>  =09vm =3D vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> =20
> -=09for (i =3D 0; i < num_vcpus; i++) {
> -=09=09int vcpu_id =3D first_vcpu_id + i;
> -
> +=09for (i =3D first_vcpu_id; i < first_vcpu_id + num_vcpus; i++)
>  =09=09/* This asserts that the vCPU was created. */
> -=09=09vm_vcpu_add(vm, vcpu_id);
> -=09}
> +=09=09vm_vcpu_add(vm, i);
> =20
>  =09kvm_vm_free(vm);
>  }
>=20

Queued, thanks.

Paolo

