Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEC781150EA
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 14:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfLFNRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 08:17:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbfLFNRP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 08:17:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575638234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3X892xnL6sAgLko+o1wSfufdRJLmijkF+hzQTMCrwo=;
        b=Rh7ydrfLjTRQgdzJJkVXkhVk4+JVYRPLObH7AIKHznbHqvZ1CS3iOQ7zoRW6iN0fOP0cay
        jvIIJJ0bUV7j8xFsxBzvPSA3O2fn/2LHQfGIEPxso97HaJdUmUghf1DW558YwXi+6HGCSe
        SwJjFcvsqjAOwvwqb/xDv9QTWiu+QrA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-5cB231UhOli5F2b9bqF2vw-1; Fri, 06 Dec 2019 08:17:12 -0500
Received: by mail-wr1-f69.google.com with SMTP id r2so3132722wrp.7
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 05:17:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CVOI61iWnax/6pPuPc1fNHm0iNuMh45UcjIi1A4RXZQ=;
        b=LUFfsQFs2Veu2/UuGkhI1P61b3ER2utEUpU2e+eCCZPZW+FcBH2HOQ0ajoYKELd0LT
         Rqd3Qx6Ldt9rYXNwUIj3ror3BMGLZa31Dz8p28lneNsfLahzMLFYHMBIAGUz24PQV8Km
         4in41dWHNqk3WmKFUrkDeIN1JK+3QFKvQuhgIGUL7MYlZCcVH9ySsX/mBxLcE8uVlhZF
         DsSTi4eo24TxfUHBrt6EqutP2btna2974cKbIm/EFh+cUzPgFEYHygu/yQ2yITTOFuAf
         kAtryd/psj+uGgSgLyyiL7RLMx2N1sueBmZOoseS65EmT5vDQ8XqQ/JvwYo025Kqwmrz
         cdoA==
X-Gm-Message-State: APjAAAXMuiIixohw2Ug/lS2ITTrRHMRJdR0nVBKCHMyBWaa+fjBpzdBs
        gk55frhq3ph/5nsXI8qkiMJBzlx2YCNrqJRahIaOv6ngz9gbBP/Z/TdL60oz0VulUHNjdm2O/MQ
        ubrWKF59xGTNi
X-Received: by 2002:a7b:cd8a:: with SMTP id y10mr10492741wmj.136.1575638231710;
        Fri, 06 Dec 2019 05:17:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqx57J0z/FDQaK2j7MvGLFOQuKHHCaI6GE5m58trPLZJ/RdPYocVLPPTKNMMiS6Ydj7kTunefg==
X-Received: by 2002:a7b:cd8a:: with SMTP id y10mr10492718wmj.136.1575638231480;
        Fri, 06 Dec 2019 05:17:11 -0800 (PST)
Received: from [10.201.49.168] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id z3sm15960814wrs.94.2019.12.06.05.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 05:17:10 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Radim is no longer available
 as kvm-unit-tests maintainer
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, radimkrcmar@gmail.com, drjones@redhat.com
References: <20191206131534.18509-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83947f2f-9058-91a4-afa7-4f9dbb14f6d9@redhat.com>
Date:   Fri, 6 Dec 2019 14:17:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191206131534.18509-1-thuth@redhat.com>
Content-Language: en-US
X-MC-Unique: 5cB231UhOli5F2b9bqF2vw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/19 14:15, Thomas Huth wrote:
> Radim's mail address @redhat.com is not valid anymore, so we should
> remove this line from the MAINTAINERS file.
>=20
> Thanks for all your work on kvm-unit-tests during the past years, Radim!
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d195826..48da1db 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -54,7 +54,6 @@ Descriptions of section entries:
>  Maintainers
>  -----------
>  M: Paolo Bonzini <pbonzini@redhat.com>
> -M: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>  L: kvm@vger.kernel.org
>  T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> =20
> @@ -88,7 +87,6 @@ F: lib/s390x/*
> =20
>  X86
>  M: Paolo Bonzini <pbonzini@redhat.com>
> -M: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
>  L: kvm@vger.kernel.org
>  F: x86/*
>  F: lib/x86/*
>=20

Queued, thanks.

Paolo

