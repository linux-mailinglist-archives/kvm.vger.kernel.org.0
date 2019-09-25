Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F901BDF33
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406589AbfIYNnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:43:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58220 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406387AbfIYNnR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Sep 2019 09:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569418996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xv5hq9uxBL32ttquYBgJQAlJVDafnHX9eAEE/XpL+2M=;
        b=NbXNf7w+FaTFne1vei0Dlz5l78K+pKSe33NGglbe+dfrlSn94SQgFrnF3dcrArhJdGUA4A
        sKtzCjiKl5TXNWApXqLu9G4KgeRvUOoJC3GDJdhG08RbB09U3mnaoKIpcfo+e8BHPKwkiA
        uFQY5Ww6OsnHDbqCDlJZW3ia9ozqygU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-RmOnchMHNA-KFR0cclJzUw-1; Wed, 25 Sep 2019 09:43:14 -0400
Received: by mail-wr1-f70.google.com with SMTP id z17so2410567wru.13
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iRarKmGPVWqc7yYSzBBJY8icg44iyz00B7a6gDKz8eA=;
        b=VPE3FyF4S8BJSdNOHnpnhRxlpsRLkYcR+wNdiuIUVx6xXWjd6SolYs2QQ5GhRIYxxA
         BGsS9ykiCHoCr0bSUivTfLquRlo6S4mDKJpjEcTFLsthnl21TFnbQymjWQgLoI0M4nCc
         IbcL1IU2p1u1TRAVD/k3KQ4b0NbE5rEwcSxSbTeKy4Bz56r7WxMxhbBNfAJVs+6Sus/E
         JdqLNaAw0vNMoHkpRrGzbSdg3LtwXxWHU2DTB8vqmiuhi1c2k34hT4gtgzp7WWtxjjAQ
         D4aEuV8k9roIdnUHsPJG5ceWc/6AEqvHtK6T7uG6rfQ5UsEb5nE5gEkOoDb9psps5R5M
         A2/Q==
X-Gm-Message-State: APjAAAWNFSE1SQd7FPp4EIM9YJxDzH8DZBdJiSW+TkIUioUDsLZ8QKhB
        oeb+AnS03UQsQ+XOC5R4sR8h5pA/ia13hpLSD53Qcer8693VqZWDOql+KQRrZ3+LSVeHWHbxRRi
        6D0hq6cP478X1
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr8003825wmk.49.1569418993694;
        Wed, 25 Sep 2019 06:43:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwuyjEoA5HNCNsNQGUnAlvYgsGWPaPsqhteaAKK+7vqH8t8mlJQ35B0ku2DMfvripcVT/gqlw==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr8003815wmk.49.1569418993454;
        Wed, 25 Sep 2019 06:43:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id q66sm6679794wme.39.2019.09.25.06.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 06:43:13 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>
References: <20190919230225.37796-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d11ba83-aa57-e124-6666-7a0fc1fae727@redhat.com>
Date:   Wed, 25 Sep 2019 15:43:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919230225.37796-1-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: RmOnchMHNA-KFR0cclJzUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 01:02, Jim Mattson wrote:
> +int main(int ac, char **av)
> +{
> +=09setup_idt();
> +
> +=09report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
> +=09report("RDPRU raises #UD", rdpru_checking() =3D=3D UD_VECTOR);
> +
> +=09return report_summary();
> +}
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d..9764e18 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -221,6 +221,11 @@ file =3D pcid.flat
>  extra_params =3D -cpu qemu64,+pcid
>  arch =3D x86_64
> =20
> +[rdpru]
> +file =3D rdpru.flat
> +extra_params =3D -cpu host
> +arch =3D x86_64
> +
>  [umip]
>  file =3D umip.flat
>  extra_params =3D -cpu qemu64,+umip
>=20

Queued, thanks.

Paolo

