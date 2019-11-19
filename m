Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE4A102453
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 13:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfKSM04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 07:26:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30296 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726555AbfKSM0z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 07:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574166414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3mOxYKpBUtrD3Eqhq7wj1DaBWOdzGNG7B02AqP8/hk=;
        b=bN2FxnB10vB131p8Xkt55M12mxH5qcXTH0IBtZhpxw1sLXHlCIAXen2J7TnxKcQLEa286n
        zSffA3OJer/8O5aZBM5UkHWIlro3B1pXGhrurB5sGED8HlANh79mE9jkwk+bYcdBvk7sUb
        RExAEKNi3GljIWJTxUTQ+r1icB8tJm8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84--MEvi0MTNgyR8BABDs7p2A-1; Tue, 19 Nov 2019 07:26:53 -0500
Received: by mail-wm1-f72.google.com with SMTP id f14so2177400wmc.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 04:26:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=awmu6I9Y99dmJSWRPIQLmc8tQlVRK2cI0mOpA3pzvDw=;
        b=nUwhTu16El0K+pzbCwXu4rx43EyemDw1RCz3KRWkQOSNSWx+e7kiGliKnEDT7/AEcq
         DjaCdeXJU7qYoHgOadeHss0zy1Z7lR7lfcn41c4ej9rdIilK0bN576X6ExF8oHXcJli8
         JKBkXCcMsWFJ4EQX9and0SeNSqn2zfPMl23XJn4ZtBuQlOhL1Np66dij/dbG5YyF1Px5
         t1Naly32ITbRlr58bFhD5h7kj7qzcjYa89PJw0dIUMBRi/gOM53gK8HWE7hsgbidNSut
         E5eUXQrRwcwuWEmq+/GX0W5KTDy10QSY1leJp226ddv/GIq3udC8MY7dJsDP2P0aQG87
         B2cA==
X-Gm-Message-State: APjAAAUPFYGo0Fl8i/yrkYsXNm7AHlatCh8VoEUY2PRBBhO6UpjI8KGb
        ykO8KYJH/WAgox52tzgrIYu81bsIyFZ9a0bTsOhd34kyxVhTyiXsFhUWCApvDU1FV3Rx2x9ht6j
        8VszUbmGWpX3e
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr24376671wrv.216.1574166412578;
        Tue, 19 Nov 2019 04:26:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqzB7t6Kre2ZE9oFyNHnTMEuPPAI1X0nkDnc5BMRHHjljrglZNrSttKN8ypZKLm/cv+A52kMjQ==
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr24376651wrv.216.1574166412383;
        Tue, 19 Nov 2019 04:26:52 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n13sm2816854wmi.25.2019.11.19.04.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 04:26:51 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
In-Reply-To: <CANRm+CzcWDvRA0+iaQZ6hd2HGRKyZpRnurghQXdagDCffKaSPg@mail.gmail.com>
References: <1574145389-12149-1-git-send-email-wanpengli@tencent.com> <87r224gjyt.fsf@vitty.brq.redhat.com> <CANRm+CzcWDvRA0+iaQZ6hd2HGRKyZpRnurghQXdagDCffKaSPg@mail.gmail.com>
Date:   Tue, 19 Nov 2019 13:26:51 +0100
Message-ID: <87lfscgigk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: -MEvi0MTNgyR8BABDs7p2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> On Tue, 19 Nov 2019 at 19:54, Vitaly Kuznetsov <vkuznets@redhat.com> wrot=
e:
>>
>> Wanpeng Li <kernellwp@gmail.com> writes:
>>
>> > From: Wanpeng Li <wanpengli@tencent.com>
>> >
>> > +     if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) =
{
>> > +             /*
>> > +              * fastpath to IPI target, FIXED+PHYSICAL which is popul=
ar
>> > +              */
>> > +             index =3D kvm_rcx_read(vcpu);
>> > +             data =3D kvm_read_edx_eax(vcpu);
>> > +
>> > +             if (((index - APIC_BASE_MSR) << 4 =3D=3D APIC_ICR) &&
>>
>> What if index (RCX) is < APIC_BASE_MSR?
>
> How about if (index =3D=3D (APIC_BASE_MSR + 0x300) &&
>

What about ' << 4', don't we still need it? :-) And better APIC_ICR
instead of 0x300...

Personally, I'd write something like

if (index > APIC_BASE_MSR && (index - APIC_BASE_MSR) =3D=3D APIC_ICR >> 4)

and let compiler optimize this, I bet it's going to be equally good.

--=20
Vitaly

