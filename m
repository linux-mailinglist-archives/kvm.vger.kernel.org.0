Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE413A432B
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFKNnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 09:43:45 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:45917 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhFKNnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 09:43:43 -0400
Received: by mail-lf1-f48.google.com with SMTP id a1so8579439lfr.12
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 06:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VAgpxI0j7t6r6tnNN0LDsrTuOsaMVKhAYb54Y9rji0=;
        b=R6HK/NJxHEZTezhNED+ResyUbr+sC601m/iO/yfsGQgv6ogP2SdmM5iYweIFBi+81P
         hyF9E/8Xrldy8fIf8GayGtdco3cQrPxbrr6+/VnjT57oUnU0JHiWvCKCdunlXn5JDwIx
         Jf8RrszvH2/kPhgoitfHztj1hflGpwARazZuN8JqgjX/r6rahbdqT704CgMt52xFNjx+
         jd9QIGoU6NqAn2WCvCywUPJNfMGD1iBAceqc3mhlCZfuY8wtzlxpHztJ47QiaBCsYC4L
         rLQblEYrRoF4996ROTgZ1ptPvyBrxnj2cPeGJJUJGJzpvgUobPC0lVTmbD92+xt19t9h
         QaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VAgpxI0j7t6r6tnNN0LDsrTuOsaMVKhAYb54Y9rji0=;
        b=Nfod7NOe+QZqDE7hYlIIXe1KpqUAFKMS1ET6V8744BVMmeqaij7wYuB1jexnb7B0YK
         lQKrehSAC0Qb5NS5KpohnkKY4yBms6mixhOWLo5VMpcCKEyTQvhq+j9x2zuZM6CntOXd
         ViCC5bvK3hAasuMpHKKkQskprUT0d4NP01VvGck1QAMeR8ptqYYHBgJHQjUKOzBfK4jB
         Hyzc+I47gz2vsGEmjkaZImaJLyU8wILYItkSQLc0rjBdHPPyeaE2AuuJ8VhGueRDgnPQ
         DFWd9c01lThc0RKyPXLgLw/bCn7IJjtyQidmK2jEC8xkPMlbS1E5K2hYUj9UXjnlRN2o
         9bOQ==
X-Gm-Message-State: AOAM531m7qXMibPaBf7V69AzgchyN3OqzDDAJEQ6zRhzn7OgwXiGwvFO
        Qdf3pKYr6IWUn+J38B2kp9IOa6LzK3KWfQIfZVRwcg==
X-Google-Smtp-Source: ABdhPJyd/EWKehnkyt/vEE7X4dLTk7ydhohkYIDaOlTtBlusLIXCnO+/tsxRSHdwRgbB5WhF0L3bzLcFmsQAmgprGWM=
X-Received: by 2002:a19:ed18:: with SMTP id y24mr2814385lfy.359.1623418844699;
 Fri, 11 Jun 2021 06:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210611124624.1404010-1-jingzhangos@google.com> <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
In-Reply-To: <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 11 Jun 2021 08:40:33 -0500
Message-ID: <CAAdAUthF98tacvqb-WR8xX4EJzjhu0yeM=-qVk7oViiOF12kEw@mail.gmail.com>
Subject: Re: [PATCH v8 0/4] KVM statistics data fd-based binary interface
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Fri, Jun 11, 2021 at 8:35 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 11/06/21 14:46, Jing Zhang wrote:
> > This patchset provides a file descriptor for every VM and VCPU to read
> > KVM statistics data in binary format.
> > It is meant to provide a lightweight, flexible, scalable and efficient
> > lock-free solution for user space telemetry applications to pull the
> > statistics data periodically for large scale systems. The pulling
> > frequency could be as high as a few times per second.
> > In this patchset, every statistics data are treated to have some
> > attributes as below:
> >    * architecture dependent or generic
> >    * VM statistics data or VCPU statistics data
> >    * type: cumulative, instantaneous,
> >    * unit: none for simple counter, nanosecond, microsecond,
> >      millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> > Since no lock/synchronization is used, the consistency between all
> > the statistics data is not guaranteed. That means not all statistics
> > data are read out at the exact same time, since the statistics date
> > are still being updated by KVM subsystems while they are read out.
>
> The binary interface itself looks good.  Can you do a follow-up patch to
> remove struct kvm_stats_debugfs_item and avoid the duplication?  I'd
> rather have that too before committing the code.
>
> Thanks,
>
> Paolo
>
Sure. Will do.

Thanks,
Jing
