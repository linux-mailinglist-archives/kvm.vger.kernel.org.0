Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991F53AA2D4
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 20:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhFPSGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 14:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFPSGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 14:06:48 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECA4C06175F
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 11:04:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id r5so5772724lfr.5
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 11:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QL+p+jTvyBCoLxHGaGA1zRf3kZytampV5ZR7Ur3gf3U=;
        b=fc72JuPUMioH4fKcNp+iPSBFNFwPDf9vgPJdUSG3pw+STeGrnlJ9Ykw74FPB2eMydA
         Sqz9/CE4otVTzoV3HvOTnxoTeIPshc58RynzPKMqktwF+8M37v22nUpbn2fUK4p80EA/
         u+jDv0yLybYMqBYCsGGy1+uAjdoOYIPiVI+GMwvC8MVkrgIbkzWddLjLMtwjfV7JUFlx
         tMRPD64MsgNUMHxn1FEeM87Wj3TDYYrkOaoTd9AAiTHYZ7yBM0mQ9RRNy99pEcalkMNO
         bgUfYhJ4wiiU1aq2mWNaQr4ASs7AcbLZbwp/pDFZNTInyx4sL7X4HU1iZ2JHMIh3xvXt
         NHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QL+p+jTvyBCoLxHGaGA1zRf3kZytampV5ZR7Ur3gf3U=;
        b=MHMtRhvaD3aE21LkUp28M18aTxzXvE7dBqeShClcXexVWJhHS8UNQAsWE/Slwz98N0
         Bi4pP/T+2vmolgdlBCZuvQCeV/KJRBMrrDVpN+bp5O1XvvKd3CMHNoT9IX5ujEldzJpC
         eskIShYW5YmqNHjELSn3ahNPmicNWzyZF/a7vVD4KxArw/rXDCTsj5BSHB1MP2Glajra
         cV9sBfcgZ2hCqyEodPBYGPRt2D0aoJSpdwkE5Mtv2UGw6AehHaGCmukXc0tuun7CfrLt
         B/X/eQ78lF6h9WpapEKelZoutM+aFkhu8TIaEtuXsBtFTIm0cJ/sfZ2bEpf9PZsi1LYf
         UoaQ==
X-Gm-Message-State: AOAM530vIePhFRj3I6hZfsEeeKi1V2EsNiOrR6qknTLdfYMb1G2WG4aO
        vNQWwFwzYMCl/Q4xUwRxbriM9D2+b09907Gw8mN6VIRBmoc=
X-Google-Smtp-Source: ABdhPJy4bQ7Jt4JKRNwI4lBCx0kB2MjipwAUemjUdaMvVbQnSwyfIs30xmfWtPQ46Uafcxy5ggZv35nXlECeV1DCBO4=
X-Received: by 2002:a05:6512:33c4:: with SMTP id d4mr713703lfg.536.1623866679050;
 Wed, 16 Jun 2021 11:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-3-jingzhangos@google.com> <60b0d569-e484-f424-722b-eb7ba415e19b@redhat.com>
In-Reply-To: <60b0d569-e484-f424-722b-eb7ba415e19b@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 16 Jun 2021 13:04:28 -0500
Message-ID: <CAAdAUthShFyjhsdAPVhUSf78QsiBCfD1rbcJXhFZ5BsQG2f4Mg@mail.gmail.com>
Subject: Re: [PATCH v9 2/5] KVM: stats: Add fd-based API to read binary stats data
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
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 16, 2021 at 12:12 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/06/21 23:21, Jing Zhang wrote:
> > +     /* Copy kvm stats values */
> > +     copylen = header->header.data_offset + size_stats - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = stats + pos - header->header.data_offset;
> > +             if (copy_to_user(dest, src, copylen))
> > +                     return -EFAULT;
> > +             remain -= copylen;
> > +             pos += copylen;
> > +             dest += copylen;
> > +     }
>
> Hi Jing,
>
> this code is causing usercopy warnings because the statistics are not
> part of the vcpu slab's usercopy region.  You need to move struct
> kvm_vcpu_stat next to struct kvm_vcpu_arch, and adjust the call to
> kmem_cache_create_usercopy in kvm_init.
>
> Can you post a new version of the series, and while you are at it
> explain the rationale for binary stats in the commit message for this
> patch?  This should include:
>
> - the problem statement (e.g. frequency of the accesses)
>
> - what are the benefits compared to debugfs
>
> - why the schema is included in the file descriptor as well
>
> You can probably find a lot or all of the information in my emails from
> the last couple days, but you might also have other breadcrumbs from
> Google's internal implementation of binary stats.
>
> Thanks,
>
> Paolo
>
Hi Paolo

Will fix the usercopy warnings, add more explanations and post another version.
And thanks for all the information in your emails.

Jing
