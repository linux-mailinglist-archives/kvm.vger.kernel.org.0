Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5889F114E85
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 10:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfLFJ7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 04:59:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40530 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726084AbfLFJ7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 04:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575626339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0F+lzQ0icwJGjPRIoluqter/tV86KGOaRnZsDGwu88Y=;
        b=jLQiH7yXhnd2YWxI3tvKaKsLw4g4uiDHg6cXYc52oqmov6xG7XNjuM1j6wr/WW3f8BpKD9
        r6+87hbyZIAh/5ELDhyQvXhicxV/uwl7a8/qXpQOezgHCDdq1pQLpyz2YXgo/J6GdoHS/T
        SKYYNe7HKOoZRsCYm+NfD0ifRLsv9wI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-3XswbCrqNcuuOmCV0Tr8_g-1; Fri, 06 Dec 2019 04:58:56 -0500
Received: by mail-wm1-f69.google.com with SMTP id f191so1677594wme.1
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 01:58:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3cpaQm+0+937DKjCOTLRMzPIARAMl3LKNy0NaEqKVcw=;
        b=TSlCoMBaATbUGrz37LZpCqr4eGeU9hkn7FBtvaW6ZHCpC4hx5Tg27omjIOnlPb/8fY
         F6tbtiRCb90FRg5dc9AztoeoYm9nBO3evMFZ5k1DHkDg6TZ1X8YZ02FpJmvYKU2v5foy
         /KgyewhiF48d4QB2t3uxke92p1jTO/WNzLKCkLDd0g9eERwtiBdzqi7aGjD1c32y6g32
         fhVBSHu0E4dyExQBkyvkp2Q9yUtrWiMTQUEn+T7B+sy4fCxOPoTxFfgrlFQb+5KNReoB
         K2XefZ7bboqG5zRlZinpkf/jmv9sgPnpmZK8cqMKPGhaZDvpDUMD5oILf7EczPFNpMbJ
         J0bQ==
X-Gm-Message-State: APjAAAVPHbN74mZGEw+w40Wln3Er9FpcIYSFm6fZsr15GjSL3/1J/En1
        0DVwaQ0kgki76RzwsEYywRpuKRm7qR4C2RWkMjESacs0QdmhGO7jKsAb5B8Bbb+b3/sekoqHP3V
        XhiXiY++6hjas
X-Received: by 2002:a5d:6048:: with SMTP id j8mr14780044wrt.41.1575626335375;
        Fri, 06 Dec 2019 01:58:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzAezlll6D3MHh/Vw7ZdARixd/jtxnH59A2S8YY3RSIVP/dx+eZEXyTv/h9t/gVpui8sdd/Qg==
X-Received: by 2002:a5d:6048:: with SMTP id j8mr14780004wrt.41.1575626335092;
        Fri, 06 Dec 2019 01:58:55 -0800 (PST)
Received: from [10.201.49.168] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id z8sm15558731wrq.22.2019.12.06.01.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 01:58:53 -0800 (PST)
Subject: Re: [PATCH] KVM: vmx: remove unreachable statement in
 vmx_get_msr_feature()
To:     linmiaohe <linmiaohe@huawei.com>, Wanpeng Li <kernellwp@gmail.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <6c7423896f6f49f2a2b439afe809db08@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7b20a96-0b75-32a4-0448-30c6061fc6cb@redhat.com>
Date:   Fri, 6 Dec 2019 10:58:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6c7423896f6f49f2a2b439afe809db08@huawei.com>
Content-Language: en-US
X-MC-Unique: 3XswbCrqNcuuOmCV0Tr8_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/19 04:41, linmiaohe wrote:
> Wanpeng Li <kernellwp@gmail.com> wrote:
>>>
>>>>
>>>> I personally just prefer to remove the =E2=80=9Cdefault=E2=80=9D case =
and change this =E2=80=9Creturn 0;=E2=80=9D to =E2=80=9Creturn 1;=E2=80=9D.
>>>> But it=E2=80=99s a matter of taste of course.
>>>>
>>> Yes. As what " Turnip greens, all have love " said. ^_^
>>
>> Actually it is a great appreciated to introduce something more useful in=
stead of tons of cleanups, I saw guys did one cleanup and can incur several=
 bugs before.
>>
> I'd like to introduce something more useful, but side corner cleanups may=
 be hard to
> found out something to introduce. And such cleanups can also be validated=
 by code inspection
> to avoid something bad. Many thanks.
>=20

Yeah, I think you have been doing a good job.  Usually, when the
cleanups introduce bugs there are many other "suspicious" things.  For
me it's clear that you're learning the code and not just messing around.

Paolo

