Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF62FDC6F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 12:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKOLmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 06:42:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbfKOLmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 06:42:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573818141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F+ah94JjIHAJkEXOkzgz1b2OLU4RdWluX9thdv65FgM=;
        b=Lqze+I56wH6RrnquJuLnhMbOwo5mHINOwEwZPONyJap3E0S6PBLn7nzwnmwyzR1FwCV79o
        kN5aCYZifY6xSHEktL9xLEprRBRlAFG/Qb0qopzQmaP17pKX5kP7z6oGhT0Pq7wTXv2x9W
        lj7NuRTFceBiV7J8b72LsN9ugEZ6NpY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-woJtPsJbMH-1UPoZq1lkvw-1; Fri, 15 Nov 2019 06:42:20 -0500
Received: by mail-wm1-f71.google.com with SMTP id g14so6748676wmk.9
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 03:42:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hxb2jgKJMs2gsGu5l56FuM8E4NRRgeTB5uJFr0x4TRs=;
        b=JwEStaBGQZR4r+ILqaDy0G60QNdi7bGcUYal8w3Os5Hg8rleONtomhA87t85Fx5MSb
         fFFAlbn10UbA81OYSkn7dCl+UX6uIfI7zTU8Wy2/NLMxcNAtkNzvb4tx+u8Wo8Q85/TG
         psMlVatqwenODUqc5c1Y76S+v0iZyfmq2t4mGOXbb5u6sBGaGMqya6YMB2sZFZfG/ES6
         3JTU9fYafXMZjPCnpVxC/uAwGScLTCd8tDoSmSk49KMsZ1XEIAQHWC6KgTp7jTVf3H7d
         Wfb9QsTlnHWYbJgqCvA37s9h56vrp5YdBV55g1IkvFOrwJ/SamFptH8k3lpNM64zDUxO
         LK9Q==
X-Gm-Message-State: APjAAAVQsxvsbuv5psJ3xPJ1+0CeAsvDwnyojQ6Ocuc/Tla/4PgsQUKz
        h4+8RLE7iaHRh00ddud7sR6JIkVXfeKr63O1YbfKB7YjClMoKiv0wpCztOa4sHAVY6qKNSg6GOH
        7mIIPRg3CTDA4
X-Received: by 2002:a1c:810d:: with SMTP id c13mr15188434wmd.154.1573818139121;
        Fri, 15 Nov 2019 03:42:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGasUjgqXCBd9dvIblf/+C+DTV5gb8s6utybkKwRh0ywQvj8FbpSaozDHM9eCd/LWtAp2jOQ==
X-Received: by 2002:a1c:810d:: with SMTP id c13mr15188391wmd.154.1573818138714;
        Fri, 15 Nov 2019 03:42:18 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id 76sm10292047wma.0.2019.11.15.03.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 03:42:18 -0800 (PST)
Subject: Re: KVM_GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <CALMp9eQ3NcXOJ9MDMBhm2Fi2cvMW7X5GxVgDw97zS=H5vOMvgw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a5845d60-fe38-afc6-e433-4c5a12813026@redhat.com>
Date:   Fri, 15 Nov 2019 12:42:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ3NcXOJ9MDMBhm2Fi2cvMW7X5GxVgDw97zS=H5vOMvgw@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: woJtPsJbMH-1UPoZq1lkvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 21:09, Jim Mattson wrote:
> Can someone explain this ioctl to me? The more I look at it, the less
> sense it makes to me.

It certainly has some historical baggage in it, much like
KVM_GET_MSR_INDEX_LIST.  But (unlike KVM_GET_MSR_INDEX_LIST) it's mostly
okay; the issues you report boil down to one of:

1) KVM_GET_SUPPORTED_CPUID being a system ioctl

2) supporting the simple case of taking the output of
KVM_GET_SUPPORTED_CPUID and passing it to KVM_SET_CPUID2

3) CPUID information being poorly designed, or just Intel doing
undesirable things

> Let's start with leaf 0. If I see 0xd in EAX, does that indicate the
> *maximum* supported value in EAX?

This is easy, you can always supply a subset of the values to the guest,
and this includes reducing the value of integer values (such as the
number of leaves) or clearing bits.  It should be documented better,
possibly including with a list of leaves that can be filled by the VMM
as it likes (e.g. cache topology).

> Or does that mean that only a value
> of 0xd is supported for EAX? If I see "AuthenticAMD" in EBX/EDX/ECX,
> does that mean that "GenuineIntel" is *not* supported? I thought
> people were having reasonable success with cross-vendor migration.

This is (2).  But in general passing the host value is the safe choice,
everything else has reasonable success but it's not something I would
recommend in production (and it's something I wouldn't mind removing,
really).

> What about leaf 7 EBX? If a bit is clear, does that mean setting the
> bit is unsupported? If a bit is set, does that mean clearing the bit
> is unsupported? Do those answers still apply for bits 6 and 13, where
> a '1' indicates the absence of a feature?

Again, clearing bits is always supported in theory, but I say "in
theory" because of course bits 6 and 13 are indeed problematic. And
unfortunately the only solutions for those is to stick your head in the
sand and pretend they don't exist.  If bits 6 and 13 were handled
strictly, people would not be able to migrate VMs between e.g. Haswell
and Ivy Bridge machines within the same fleet, which is something people
want to do.  So, this is (3).

A similar case is CPUID[0Ah].EBX (unavailable architectural events).

> What about leaf 0xa? Kvm's api.txt says, "Note that certain
> capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may expose cpuid
> features (e.g. MONITOR) which are not supported by kvm in its default
> configuration. If userspace enables such capabilities, it is
> responsible for modifying the results of this ioctl appropriately."
> However, it appears that the vPMU is enabled not by such a capability,
> but by filling in leaf 0xa.

Right, the supported values are provided by KVM_GET_SUPPORTED_CPUID.  So
as long as you don't zero the PMU version id to 0, PMU is enabled.

> How does userspace know what leaf 0xa
> values are supported by both the hardware and kvm?

Reducing functionality is supported---fewer GP or fixed counters, or
disabling events by *setting* bits in EBX or reducing EAX[31:24].

> And as for KVM_CAP_X86_DISABLE_EXITS, in particular, how is userspace
> supposed to know what the appropriate modification to
> KVM_GET_SUPPORTED_CPUID is? Is this documented somewhere else?
>=20
> And as for the "certain capabilities" clause above, should I assume
> that any capability enabled by userspace may require modifications to
> KVM_GET_SUPPORTED_CPUID?  What might those required modifications be?
> Has anyone thought to document them, or better yet, provide an API to
> get them?

And finally this is (1).  It should be documented by the individual
capabilities or ioctls.

With KVM_ENABLE_CAP, the only one that is _absent_ from
KVM_GET_SUPPORTED_CPUID the MONITOR bit.

The opposite case is X2APIC, which is reported as supported in
KVM_GET_SUPPORTED_CPUID even though requires KVM_CREATE_IRQCHIP (or
KVM_ENABLE_CAP + KVM_CAP_SPLIT_IRQCHIP).  Of course any serious VMM uses
in-kernel irqchip, but still it's ugly.

Providing an API to get a known-good value of CPUID for the current VM
(a KVM_GET_SUPPORTED_CPUID vm-ioctl, basically) would be a fine idea.
If anybody is interested, I can think of other cases where this applies.
 It would provide a better way to do (2), essentially.

> What about the processor brand string in leaves 0x80000000-0x80000004?
> Is a string of NULs really the only supported value?

Indeed this should probably return the host values, at least for
consistency with the vendor.

> And just a nit, but why does this ioctl bother returning explicitly
> zeroed leaves for unsupported leaves in range?

No particular reason, it just keeps the code simpler.

> It would really be nice if I could use this ioctl to write a
> "HostSupportsGuest" function based in part on an existing guest's
> CPUID information, but that doesn't seem all that feasible, without
> intimate knowledge of how the host's implementation of kvm works.

It does not depend that much on knowledge of the host's implementation
of KVM.  However, it does depend on tiny details of the CPUID bits.

Thanks,

Paolo

