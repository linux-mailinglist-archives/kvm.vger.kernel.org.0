Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8D23AF234
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 19:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhFURpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 13:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhFURpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 13:45:02 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEFBC061760
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 10:42:46 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i13so31492310lfc.7
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qfK/SVz4it+B5UPXi3JJjfN4xS2rz4IlLdh/dhi7P/A=;
        b=pywx1GKnLV8rMPGg0yESPQxjjJELUUA6eFGxQfp1SLreFtlNjvMnVkBKCsMTmOd55H
         L2Ov1NYXG6PlckYJH8Gw//+mcOBRMDwUXKZ+OXAi5Nyj1KRLWBLsJCtqGFb1mQ50QAep
         +66Iks8s9xqkwilngZ/CjQPCJsYngQFefHmEiKXBRFcuGdGgcDy7nbwnYmWpFSIzb8JM
         Cjf5+S39y3LrfjOsEEnW09/kn8GvhArY29GOk3d0VywwjXhx383+3K6zA3KOodjnfkQi
         8CQsP6Ze09t1BHzCBmmEOfUrgWwOaLawqHrTy11NMe7lYNZNHRIg3ZSNWKHZDD1fW8kp
         ZZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qfK/SVz4it+B5UPXi3JJjfN4xS2rz4IlLdh/dhi7P/A=;
        b=jJ2OoJ7M6vg6kSNiNGQRjV4hRfSZAx8NXe7X4yew+pIUVKjuT50PO5ecrRKLQHMiR+
         MIQoS7cJHIoPF/9PaNuYtiG9P53ULDoTkWxgAw2+Dx1/Xec9/Eh1CESZnkHXV9yL23v5
         pEZ6sKGDKFlD6+QIhZy+UEWGZGAptQunIO0UT/qsdgyNEytFh76Q9thPkApzULS6zZrT
         3dFpTLtMHzFXajWH5CXK0WOUTt046sPyPd+wn5uFOob9v6eqyjvs8Gd5rHRgz7K2Y094
         X62gVJUK//HKTaNfeix+bykpGaPiwzMFjSWpa5dj0WKITS7eIb6VSLj5+T3tYQhNUazg
         8Gfw==
X-Gm-Message-State: AOAM530uxfYo7wgvDTlmS86/WBgeNOnaw5+lAqOrjlAuMDz5uXmvOkoV
        KtrOY+PsBsc2iZmaasbfq1iY5iqpaQaEMxxX97FJsg==
X-Google-Smtp-Source: ABdhPJze+ab86EoUTOPQeCvTUOFZdayN8Zdi+mpGgTYzSXakq0/1emu/tNIwi9+QdEI2rk/c2bFMigguUMCYbOuXxYw=
X-Received: by 2002:a05:6512:39ca:: with SMTP id k10mr15161030lfu.473.1624297364420;
 Mon, 21 Jun 2021 10:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-5-jingzhangos@google.com> <d8bb52e6-3d1c-7008-388f-699f1a872e80@redhat.com>
In-Reply-To: <d8bb52e6-3d1c-7008-388f-699f1a872e80@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 21 Jun 2021 12:42:33 -0500
Message-ID: <CAAdAUtiC68ViKRH=1_N9VPzNszZHUN5Yc0GNXJ3BFL+8=tz0Gw@mail.gmail.com>
Subject: Re: [PATCH v12 4/7] KVM: stats: Support binary stats retrieval for a VCPU
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
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 11:46 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/06/21 00:27, Jing Zhang wrote:
> > +     struct kvm_vcpu_stat stat;
> >       struct kvm_dirty_ring dirty_ring;
> > +     char stats_id[KVM_STATS_NAME_SIZE];
>
> I think stats_id needs to be part of the usercopy region too.
>
> You can also use
>
> offsetofend(struct kvm_vcpu, stats_id) - offsetof(struct kvm_vcpu, arch)
>
> to compute the size.
Sure! Will do.
>
> Paolo
>

Thanks,
Jing
