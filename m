Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A3C104393
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfKTSne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 13:43:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24885 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726001AbfKTSne (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 13:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574275413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YTl0JpKh0KAXB8g1lalkpeA1rdf0JhlRgGsLX6yzuuA=;
        b=I+M+h9YnvOxGNUpLbe4+u1GMPqU9Ir26cANaUtVmTPCD2XS/EXMH1SGSgJQIPDb7Q5Ndnv
        i6YRViXbYIXa7rTNuuHJV7iEtjK2WJ51X28GfGBceJ9iNmXfJ1UJti8zeKTIoUcaFD8CNH
        dGfofM/rBueGPdLmYnjEO4CjpRDFCGc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-WE2PZsO4NT-w3pdt3WMcOw-1; Wed, 20 Nov 2019 13:43:29 -0500
Received: by mail-wm1-f71.google.com with SMTP id 2so256543wmd.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 10:43:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/+UyJXUNfD0T0ntg5QHUOTOCvBFHCWEoQaG9jm8Dbs=;
        b=oO6+uV7ILik2ItcuBfqkgDlhVXqGWGHuoU2+RG76bNJ+UGb2ahrUHvj92+Rd3ORpw3
         E5FwApiAza9ghfOxqVcrYW/vww6dymdw81TovNNkF/mvmj0SlFMB9kLR+eqQjEXVDIx9
         uB4JB/44n5KyJySl1TWupdU4fLJr8GZOsqUvlOXvKazyaUyTRrG2N41Pthi8oCWiH2cU
         XJ48YG2IKBF/nZUw1YR/n8Qb0nrAm3bUTnBuImaj3DdMMFB4r3o3c/K89538EJqIDHOL
         pz9kBlXQiqDJHAONfY0z/rc2KspnGD/RIngRmhe6JlSA9SdhbYjP6JU2XNVKjnqNa6t+
         Tpow==
X-Gm-Message-State: APjAAAWeWtE+VtPULVZa6uy89NIyUl4fkRDovfB5DrbjfWe6l70C439f
        33CNcugRVU4Sv+9egsrzX31eZHcauTPe1bvKWwTMMU2MQHuqWhdWe6ptfOwWdLd4ipm27u/KJgF
        ajWa3Ma+vOtgO
X-Received: by 2002:a1c:740a:: with SMTP id p10mr4880848wmc.49.1574275408642;
        Wed, 20 Nov 2019 10:43:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdE/4SAa/OCZ1DLgysz/nkS80mQMO4lkImRbGMJHtMlN5VGEMW6dYQMAx4tmgYYEQoVi/1wQ==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr4880824wmc.49.1574275408341;
        Wed, 20 Nov 2019 10:43:28 -0800 (PST)
Received: from [192.168.178.40] ([151.48.115.61])
        by smtp.gmail.com with ESMTPSA id a6sm175023wrh.69.2019.11.20.10.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 10:43:27 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] x86: add tests for MSR_IA32_TSX_CTRL
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eQERkb76LvGDRQbJafK75fo=7X6xyBb+PfwfzGaY5_qeA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <710cd64e-b74e-0651-2045-156ba47ce04b@redhat.com>
Date:   Wed, 20 Nov 2019 19:43:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQERkb76LvGDRQbJafK75fo=7X6xyBb+PfwfzGaY5_qeA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: WE2PZsO4NT-w3pdt3WMcOw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 19:13, Jim Mattson wrote:
> On Mon, Nov 18, 2019 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote=
:
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>=20
> I had to add tsx-ctrl to x86/unittests.cfg:
>=20
> +[tsx-ctrl]
> +file =3D tsx-ctrl.flat
> +extra_params =3D -cpu host
> +groups =3D tsx-ctrl
> +
>=20
> With qemu 4.1, I get:
>=20
> timeout -k 1s --foreground 90s /root/kvm-unit-tests/deps/qemu.sh
> -nodefaults -device pc-testdev -device
> isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc none -serial stdio -device
> pci-testdev -machine accel=3Dkvm -kernel x86/tsx-ctrl.flat -smp 1 -cpu
> host # -initrd /tmp/tmp.7wOLppNO4W
> enabling apic
> SKIP: TSX_CTRL not available
>=20
> Maybe qemu is masking off ARCH_CAP_TSX_CTRL_MSR? I haven't investigated.

Yes, you need "-cpu host,migratable=3Doff" if you don't have the
corresponding QEMU patches (which I've only sent today, but just
allowing unmigratable features in extra_params will be okay for you to
test).

Paolo

