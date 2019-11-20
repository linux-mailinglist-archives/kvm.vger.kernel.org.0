Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C4910371B
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 10:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfKTJ5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 04:57:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53752 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728122AbfKTJ5w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 04:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574243872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=kP+7PUU9cuUz07wqefe5DEfcB8s8P3whTJQfTLtq3nM=;
        b=fNjKf/sNQNfG0Y62/z2TWlq8DeCXSJEJU+t32YyqESTgwnlkSuv7wLJgnvFfL113nGWfNu
        ylc01uwnqwVMUBQC0tAaSF7Tmn77ySc+E5SKzHnrP67LNh20KhwW3lryVs6epKZM+V6Ejl
        lZJNIWdIBPwHEpGz20SLmcNy3m860N8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-JbPPA0e3OFW0NGEnghgW_Q-1; Wed, 20 Nov 2019 04:57:44 -0500
Received: by mail-wm1-f70.google.com with SMTP id b10so4276034wmh.6
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 01:57:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VOeaSBbwy25VWhunQssl3vkukdnPUC7UX+JiFUj2CLQ=;
        b=Q5wTmB5BkAw7CZC3aczERZiorneG8OwkKdl11o2Afy8b9CjEQUyya70kKNwm765H7Z
         /t7EcPaa6xIOsySKgFzCpIIEyitF7aO4DNbkrKoK1tP7akifyFyb9Rt73Qg+hFs8OA9Q
         Ur6UCziE8yIXREn4OU7wZWDKN4hvlfRnZMyhiSR5Luez64XrrcAT8Ii5bjt5zkkupHoM
         ZPDiGww4gpEudtFvEDi8p8xg/zLfPnW/ENBiN8vYz+3u/WKBGowy98eTPp3UzyJSTvpa
         Mwr1TW8hRN0D/i4J2hwdmN4AXrI8CQ8mWTJeKQo+xkhZJMwmLSZWJRjWww2A7BffkymV
         z3fw==
X-Gm-Message-State: APjAAAWUCRA1AxBKJvmMkqbvz+rJcCHReqgD7Gx2J+4bhUby0/W71aQG
        If6t9MdISaUo/ufIRXIvBerQTNBMlMD0QlH4fgzy+JW41yD72/GvwcBKLWN1jauwJUmeWNSepOW
        qFEXddK61ODYx
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr2159471wrs.226.1574243863459;
        Wed, 20 Nov 2019 01:57:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzGpBVdMeT5BnfuDhHfXmTxFLa3nO42Evf//IV2cCqL4mYlWHfsc/ORQH6nrxAvABiG9488Cw==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr2159451wrs.226.1574243863207;
        Wed, 20 Nov 2019 01:57:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id a26sm6007124wmm.14.2019.11.20.01.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 01:57:42 -0800 (PST)
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Wanpeng Li <kernellwp@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Derek Yerger <derek@djy.llc>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm <kvm@vger.kernel.org>
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
 <20191016112857.293a197d@x1.home> <20191016174943.GG5866@linux.intel.com>
 <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
 <20191022202847.GO2343@linux.intel.com>
 <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
 <20191024173212.GC20633@linux.intel.com>
 <36be1503-f6f1-0ed0-b1fe-9c05d827f624@djy.llc>
 <20191119200133.GD25672@linux.intel.com>
 <CANRm+CzuYvZ-97EtYaCTT2GgCACKMvGGHbY_bWMZ90Z3-4TVrg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <18901fcb-6bd9-91b8-8e38-c8fcb6411f1a@redhat.com>
Date:   Wed, 20 Nov 2019 10:57:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CzuYvZ-97EtYaCTT2GgCACKMvGGHbY_bWMZ90Z3-4TVrg@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: JbPPA0e3OFW0NGEnghgW_Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 10:19, Wanpeng Li wrote:
> Since 5.3-rc2, we have three commits fix it.
>=20
> commitec269475cba7bc (Revert "kvm: x86: Use task structs fpu field for us=
er")
> commite751732486eb3 (KVM: X86: Fix fpu state crash in kvm guest)

These two should have been included in 5.2 though, see
https://bugzilla.kernel.org/show_bug.cgi?id=3D204209.

So this would be a separate bug in the FPU rewrite.

Paolo

> commitd9a710e5fc4941 (KVM: X86: Dynamically allocate user_fpu)


