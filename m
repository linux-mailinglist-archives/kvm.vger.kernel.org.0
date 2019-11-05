Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24BF0940
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfKEWXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:23:39 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45818 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbfKEWXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572992618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=UeIATy8qXoFIqGxUug8BNh34jZck/SjLcDeZTxonxVc=;
        b=d8YVO9Dy//Sb3fxBXjnwZSXMCUaBx2hlz6o+IxLVbgFxD+d3esHK3U+e5t2vCZ97EyNbcU
        uT9I8fiM4VZgDpelhPv7S/cMZwn6HeTp2aLn+nGje54LR/aqK5/GE/rw4unEhU4hT9XBdZ
        Iv/TnWSWVAkkXWMPiBpw7laWChT7CGA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-0nKMF_2vPQy6C_U0YqVeIg-1; Tue, 05 Nov 2019 17:23:36 -0500
Received: by mail-wr1-f71.google.com with SMTP id 92so13068356wro.14
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 14:23:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8QrwOnPNyzTCxh+P9ehSed7lMK03UnxRQoeF45ckyF0=;
        b=FkJkYiJkeqT1kWKVh0lXkvoeYrPvoLj+KzR8azIupanbtx75SrbzzcvZNqZqSmi/pS
         FwBYZc8OAAROgp6RZ23cVcRkwIERKhESLup4oaGEeIdDFKiLFWjtRZV9NULwG1I/OvVX
         Zxve2e4/KF06dGfoCOoUVb5m72yeu4aixH7wcZg26y5R3MGKo+xuadOSgJcFDCF9Tlgr
         pRV4vy6mLcWBPFhnCCE5diNWCFv4Je2SyIauC+JZF2A/3yNzdcOdpxN2xvSbREcFch9Y
         NyIYjAK64QdMOtIO+VhNalvMf2TyQx81ndeD1A0ffRer30syk7kmJNrdVotKlwZFyijp
         dSgg==
X-Gm-Message-State: APjAAAWlHJU6kWjyxv8kRWDAwQJoTM4fWx5TVhB4qhDYcId8JBdizLeq
        zodPSbXZp2WA2avi0KKJXh3XRLK6kOqIT+2t4siRWj2E6cVpxD5F4dICjxxgmmnAgy11Dcd/Gnx
        Y4Yg7wPRNaiaE
X-Received: by 2002:a1c:c28a:: with SMTP id s132mr1037831wmf.162.1572992615348;
        Tue, 05 Nov 2019 14:23:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqzwJbeO5zNSr+QBI++DJnGPTWCkZwC3j94+ggop09oYvVIIJxQI+OFPiwJa23D2RQzU/1mzwA==
X-Received: by 2002:a1c:c28a:: with SMTP id s132mr1037810wmf.162.1572992615022;
        Tue, 05 Nov 2019 14:23:35 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 189sm1117519wmc.7.2019.11.05.14.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:23:34 -0800 (PST)
Subject: Re: [PATCH v2] kvm: x86: Add cr3 to struct kvm_debug_exit_arch
To:     Ken Hofsass <hofsass@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>
References: <20191024195431.183667-1-jmattson@google.com>
 <895ce968-7f70-000b-0510-c9040125f93a@redhat.com>
 <CAL1xVq00-EwHfiZgsFLm3GuAdbDajCBxuKxm7xTbKKUaf0wzPQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <408e91de-2b0b-4b99-650b-686faf5fe31b@redhat.com>
Date:   Tue, 5 Nov 2019 23:23:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAL1xVq00-EwHfiZgsFLm3GuAdbDajCBxuKxm7xTbKKUaf0wzPQ@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: 0nKMF_2vPQy6C_U0YqVeIg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/19 19:07, Ken Hofsass wrote:
> On Thu, Oct 24, 2019 at 3:18 PM Paolo Bonzini <pbonzini@redhat.com> wrote=
:
>> On 24/10/19 21:54, Jim Mattson wrote:
>>> From: Ken Hofsass <hofsass@google.com>
>>>
>>> A userspace agent can use cr3 to quickly determine whether a
>>> KVM_EXIT_DEBUG is associated with a guest process of interest.
>>>
>>> KVM_CAP_DEBUG_EVENT_PDBR indicates support for the extension.
>>>
>>> Signed-off-by: Ken Hofsass <hofsass@google.com>
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Cc: Peter Shier <pshier@google.com>
>>> ---
>>> v1 -> v2: Changed KVM_CAP_DEBUG_EVENT_PG_BASE_ADDR to KVM_CAP_DEBUG_EVE=
NT_PDBR
>>>           Set debug.arch.cr3 in kvm_vcpu_do_singlestep and
>>>                               kvm_vcpu_check_breakpoint
>>>           Added svm support
>>
>> Perhaps you have already considered using KVM_CAP_SYNC_REGS instead,
>> since Google contributed it in the first place, but anyway...  would it
>> be enough for userspace to request KVM_SYNC_X86_SREGS when it enables
>> breakpoints or singlestep?
>=20
> Hi Paolo, from a functional perspective, using KVM_SYNC_X86_SREGS is
> totally reasonable. But it currently introduces a non-trivial amount
> of overhead because it affects all exits.
>=20
> This change is a targeted optimization for use in instrumentation
> scenarios. Specifically where debug breakpoint exits are a small
> percentage of total exits and only a small percentage of the debug
> exits are from processes of interest.

Sorry for the delayed response, mostly due to KVM Forum.

Is this due to Google's non-upstream userspace emulation patches?  With
a properly configured guest and in-kernel emulation, userspace exits
should be so few as to make KVM_CAP_SYNC_REGS's overhead low.

But in any case, what about adding a new KVM_SYNC_X86_CR3 that is a
subset of SREGS?

Thanks,

Paolo

