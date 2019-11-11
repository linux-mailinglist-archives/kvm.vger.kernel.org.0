Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D61F7842
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKKQBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:01:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726912AbfKKQBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:01:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573488063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YHZkeB5T/8kDp81NuYsaDME5Rlh+op3JEGkQG2On5GU=;
        b=HC+GXS9ULsmbwKoM6KPOBi0N3cBxMeR0dILVE7hb52Z26QRWJEoC+F5TpSoEIoAbfx53ds
        jNsGJsqu0/AWVTDeSj6iYj0Siieb6pRiHEVFJ3bwrOIEzerR7ce1kfoFjo8zybGVNo+8HT
        1s9mb1f+V3PfX18eSZgc3veMxpcLxbY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-kh1TCQPPNQyH5u81Bwcirw-1; Mon, 11 Nov 2019 11:01:01 -0500
Received: by mail-wm1-f69.google.com with SMTP id y133so6440481wmd.8
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 08:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0V9mpph4X3XpCrA5eTjfn8Ml9lCsnBVTkl/QXfLfdeg=;
        b=trRXqs4UzZ58R6FVEg+NqKtQ0CmU4bgrvoCr/Qmyj604XB4f20DzNjGKoLUpnaKKKT
         BFNvD5ng+oIHz+tvx7eP7viOWNV992wMvN4s2ypxgWbBe1EfsHSnCLk1x+2lveI3aVF6
         Pj/p1RNjV0eSIoi3hYsrlIZy9Au4MlLYOvUBHBXNPKEN/oBxqrgCwatZWKBmb6gqeHkI
         uN99c3nQSZU/CrI3QC337C/o2JwirkhnA/D9bwZvApVD4E2M+v5OdJ6BfHXz2/xT4JC1
         aScvtAcCp1/jPY5pqs5q1Gga7Okq/AzPXmou27xNvalMkvIxOUgQQbpXx7xzSO3P0HFA
         wxZg==
X-Gm-Message-State: APjAAAVxiP/cJu3NknlftFZpfhqKVnbGslZoeybMndfP0zbHbMufmC5d
        aVyHZmvmkAT4BMB6mEtrUIaiiHygEChCtJce1lHKbbnNdNki5JQf6AhrKR+sQwlnD4V4iEHu+/6
        nl+n1x3u8O1jU
X-Received: by 2002:a5d:694d:: with SMTP id r13mr20400883wrw.395.1573488060225;
        Mon, 11 Nov 2019 08:01:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqzsAgKvCKlpgw1A0fBubjc54AF9wL4RjdvYVjTmuhGdTXItTVea5xCCZfmDgEcwSXvRYdlDzw==
X-Received: by 2002:a5d:694d:: with SMTP id r13mr20400862wrw.395.1573488059944;
        Mon, 11 Nov 2019 08:00:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id b15sm8133605wrx.77.2019.11.11.08.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 08:00:59 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: VMX: Refactor update_cr8_intercept()
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-2-liran.alon@oracle.com>
 <de93a7b8-d0b6-33b2-2039-ad836fcfab1e@redhat.com>
 <30BFAF3B-EB5A-4121-B53D-9FD594CFF92E@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0b04e879-f19c-da08-2feb-8dc17b08460c@redhat.com>
Date:   Mon, 11 Nov 2019 17:01:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <30BFAF3B-EB5A-4121-B53D-9FD594CFF92E@oracle.com>
Content-Language: en-US
X-MC-Unique: kh1TCQPPNQyH5u81Bwcirw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 16:00, Liran Alon wrote:
>=20
>=20
>> On 11 Nov 2019, at 16:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 11/11/19 13:30, Liran Alon wrote:
>>> No functional changes.
>>>
>>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>>> ---
>>> arch/x86/kvm/vmx/vmx.c | 9 +++------
>>> 1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index f53b0c74f7c8..d5742378d031 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -6013,17 +6013,14 @@ static void vmx_l1d_flush(struct kvm_vcpu *vcpu=
)
>>> static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int ir=
r)
>>> {
>>> =09struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
>>> +=09int tpr_threshold;
>>>
>>> =09if (is_guest_mode(vcpu) &&
>>> =09=09nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>>> =09=09return;
>>>
>>> -=09if (irr =3D=3D -1 || tpr < irr) {
>>> -=09=09vmcs_write32(TPR_THRESHOLD, 0);
>>> -=09=09return;
>>> -=09}
>>> -
>>> -=09vmcs_write32(TPR_THRESHOLD, irr);
>>> +=09tpr_threshold =3D ((irr =3D=3D -1) || (tpr < irr)) ? 0 : irr;
>>
>> Pascal parentheses? :)
>=20
> What do you mean?

Redundant parentheses around && or || are usually avoided in the kernel,
and they are typical of Pascal (which had weird operator precedence
rules and thus required operands of AND/OR to be parenthesized).

I can remove them when committing the series.

Paolo

