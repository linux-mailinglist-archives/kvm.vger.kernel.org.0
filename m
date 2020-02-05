Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A06A15358A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgBEQrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:47:10 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727454AbgBEQrK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 11:47:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580921229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXKBQ6DcT+GgFj5oJJCnQJ1xWQaE9fLJMHWSVE37mDE=;
        b=C5fKAhJbCWQzUIfgztvAFMFMT6091fdMRTkiv6o1y1X6cqn7/Aw2lF1tJr5+IO5r/B7Rkm
        DkUMkBOomJT3+Ev/okh7fZuG+9m6iJK93r2DRPATpQOPp7qn4k/vwmdn0vMP346V3xJPw9
        CQkzpinz6ssYJ7dOSZZQgKe9+jj++FQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-aJQFl2ZLNBizWU6__3D2aw-1; Wed, 05 Feb 2020 11:47:04 -0500
X-MC-Unique: aJQFl2ZLNBizWU6__3D2aw-1
Received: by mail-wr1-f71.google.com with SMTP id d8so1446619wrq.12
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 08:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hXKBQ6DcT+GgFj5oJJCnQJ1xWQaE9fLJMHWSVE37mDE=;
        b=Yfi9EAFU+EsT2OH9mmZvWSMp7Ya1tX2PEEEn/O9NRrjjGrBpfGF5X7l+93j25wBzqj
         NlvpMHAD9DKJ32P7SDoSuGkDqbrPherJrYr0AeuwhFGdMxvx4y0BIYX1tg6QKXscMpsx
         47yK0eLmblvsEALJ4U1cJH0XMKitFu2o+JQsTdXwhPOv0T8quyU4V3FRoF4cT3DDgC7z
         xfIUDn3WcsAlUgJ6tNEujEB4r1cpWE+eNwecdhVgZvgiZmym1odHN+2AdYCERDg2JK8l
         2H02h92tX0QzDhc2DQhtiTEJxJG/GAZ8s11cEDhn3pnVOLF/kJo+wRw1l86EPx1JWnCL
         xrZw==
X-Gm-Message-State: APjAAAVAhqsbcKnx2+dfI5JRdtf7gGCyPlRwvlq1NnG+/KGp+BEMWzwm
        fnmkCSbKMYcuXrEBneDUwkXVTVTcrDw3zWav1EjJN+ZhvE6ZgnQ4XT08ek2P5KL7dFB15Mu9kzP
        JNDYbfrCj/EFJ
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr6254436wmd.184.1580921222679;
        Wed, 05 Feb 2020 08:47:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtVzxs+25OCq0w2wMbcM1N6ksyLaUBDn1onqbcvGJUHfLKfLODOU9u8cJMe45yVqNgf7JYDg==
X-Received: by 2002:a05:600c:351:: with SMTP id u17mr6254410wmd.184.1580921222362;
        Wed, 05 Feb 2020 08:47:02 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x11sm127812wmg.46.2020.02.05.08.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 08:47:01 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>
Subject: Re: CPU vulnerabilities in public clouds
In-Reply-To: <CAJSP0QW0XqgVfBbS9ip8xL+TkMfu24A+GyKVQLurCwWc2fTEvQ@mail.gmail.com>
References: <CAJSP0QW0XqgVfBbS9ip8xL+TkMfu24A+GyKVQLurCwWc2fTEvQ@mail.gmail.com>
Date:   Wed, 05 Feb 2020 17:47:01 +0100
Message-ID: <87wo91j81m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stefan Hajnoczi <stefanha@gmail.com> writes:

> Hi Vitaly,
> I just watched your FOSDEM talk on CPU vulnerabilities in public clouds:
> https://mirror.cyberbits.eu/fosdem/2020/H.1309/vai_pubic_clouds_and_vulnerable_cpus.webm
>
> If I understand correctly the situation for cloud users is:
> 1. The cloud provider takes care of hypervisor and CPU microcode fixes
> but the instance may still be vulnerable to inter-process or guest
> kernel attacks.

Correct.

> 2. /sys/devices/system/cpu/vulnerabilities lists vulnerabilities that
> the guest kernel knows about.  This might be outdated if new
> vulnerabilities have been discovered since the kernel was installed.

We don't know what we don't know, yes.

> False negatives are possible where your slides show the guest kernel
> thinks there is no mitigation but you suspect the cloud provider has a
> fix in place.

Well, I'm assuming that cloud providers are not crazy :-)

In particular, when you don't see STIBP/IBPB features on your instance
*now* there are two options:
1) Microcode wasn't updated since 2017
2) Features are deliberately hidden from you.

Why are these features hidden? Well, performace. When guest kernel sees
them it will start using them! And it doesn't come for free.

The situation with MDS/TAA is somewhat unique. To flush these internal
CPU buffers, an existing 'verw' instruction was re-purposed so if the
guest sees 'md_clear' flag it knows that the flush is happening,
however, if it doesn't see the flag (e.g. it was hidden by the
hypervisor) it cannot tell for sure if microcode update was deployed or
not. Linux made a choice to still try by default (MDS_MITIGATION_VMWERV/
TAA_MITIGATION_UCODE_NEEDED).

> 3. Cloud users still need to learn about every vulnerability to
> understand whether inter-process or guest kernel attacks are possible.
>
> Overall this seems to leave cloud users in a bad situation.  They
> still need to become experts in each vulnerability and don't have
> reliable information on their protection status.

The situation is not any better outside of cloud space. Linux (upstream
or vendors) tries to make reasonable choices for its defaults but they
may or may not work well for everyone. E.g. for mitigating Spectre_v2 we
now default to 'conditional' STIBP/IBPB meaning it will be enabled for
seccomp'ed tasks and tasks which explicitly ask for it with
prctl(). This is a good default but not a universal solution for
everyone.

>
> Users with deep pockets will pay someone to do the work for them. For
> many users the answer will probably be to apply guest OS updates and
> hope for the best? :(

Yes, it is, of course, possible that the user is in danger, however, to
mount an attack an intruder needs to have local access so it's mostly
multi-tenant environments which are at risk (or, if you're running an
untrusted code in your environment. Just don't).

>
> It would be nice if /sys/devices/system/cpu/vulnerabilities was at
> least accurate...  Do you have any thoughts on improving the situation
> for users?

The biggest ambiguity I see now is with Spectre_v2, I was sending an RFC
last week:
https://lore.kernel.org/lkml/20200121160257.302999-1-vkuznets@redhat.com/
but it seems I'm not the only one who noticed that.

Also, for KVM we probably should adjust our defaults for
L1TF/ITLB_MULTIHIT when running as a nested (L1) hypervisor.

There is also a big question with SMT (and I need to revive my
'NO_NONARCH_CORESHARING' work).

-- 
Vitaly

