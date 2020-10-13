Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A20628C800
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 06:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbgJMEa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 00:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgJMEa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 00:30:59 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5ACC0613D0
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 21:30:59 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id v6so4952137lfa.13
        for <kvm@vger.kernel.org>; Mon, 12 Oct 2020 21:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uHznmbCYbnVYecu07LGVp8fB7JwZJ5KDqnd/eEunNDM=;
        b=hbSfxJ5CVGioEMU5n741pcODDKPoNH5SSgkekndiWv1TT4qukDXBS5vlebLXLizLhR
         b4/xZNkOX8GUCTMfRcbFxVTmHfXDintMAv+I0dCZu8x10B0BeVAb1EK6iyIwsKelyB6W
         49HWvQPmRhTPe7czs0xYGmBuAxhIKguXdm6U/LkmhdQaXYY/6HK690XILw4aD60MQzPP
         2hX5naXiVNg0y+rLLAeVix/vfEo/6fwcLnJnfLFGi7Q59OdXMtQEC9mfQysKcWYV0z1R
         6Y+HGXCqylbL01C3ndpfSZsNs6QT594drgNLbt2xh6sWKUtdoaoXvp7rjDZ078WFKoIH
         YX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uHznmbCYbnVYecu07LGVp8fB7JwZJ5KDqnd/eEunNDM=;
        b=SCJYjppt28PFY29JXp5sStudINaZNvdh+JxZzASFUSh7SeIr6kp3/nAzBx9vV6rIoj
         G/wjIu/gw6SopCHjIpJcfDGYi7FfbubLrsneAKnbL53ugsuhyvNxwQR6D10+38uSeuX8
         wx44KRAJHZDM9PmwR17ffwIcZjDxpTEnmoc/vtkqSY8y+Azxiwgif3PbtWrMdfZjiJ2X
         lI1UWoSHgatFq2fJ+3KYlufOT/DcFttGY4cCb3xeCkQ81IrSCoKDdvYdflWhLFt6qRN5
         h9GFn/IOvPoc3r/mBE3Yo0WjWU1nHqxm5QrJRUlVIiz/H3gyaXmK045bWKo6VKb75LVe
         2Iuw==
X-Gm-Message-State: AOAM531APpoZnPwLy9E9s4F8YazF6XlNeBxpmW+Bi3aVgQvq9qOLXSHN
        IAalL6dmpntyplWarMX/6HlAvyv2IDIf7IetXZQ=
X-Google-Smtp-Source: ABdhPJw5ESgwC0DgMZ9wENbc2k3XxUS8EJuXNnfvWh0zkKlUw6sic73+LBqE6Y3TydBD4veYlUsxLM4tVDHZ9ncz+Gk=
X-Received: by 2002:a19:c6cc:: with SMTP id w195mr2030275lff.24.1602563456727;
 Mon, 12 Oct 2020 21:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com> <20201012165428.GD26135@linux.intel.com>
In-Reply-To: <20201012165428.GD26135@linux.intel.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Tue, 13 Oct 2020 00:30:39 -0400
Message-ID: <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thank you very much for your thorough explanations. Please see my
inline replies as follows. Thanks!

On Mon, Oct 12, 2020 at 12:54 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> No, the guest physical address spaces is not intrinsically tied to the host
> virtual address spaces.  The fact that GPAs and HVAs are related in KVM is a
> property KVM's architecture.  EPT/NPT has absolutely nothing to do with HVAs.
>
> As Maxim pointed out, KVM links a guest's physical address space, i.e. GPAs, to
> the host's virtual address space, i.e. HVAs, via memslots.  For all intents and
> purposes, this is an extra layer of address translation that is purely software
> defined.  The memslots allow KVM to retrieve the HPA for a given GPA when
> servicing a shadow page fault (a.k.a. EPT violation).
>
> When EPT is enabled, a shadow page fault due to an unmapped GPA will look like:
>
>  GVA -> [guest page tables] -> GPA -> EPT Violation VM-Exit
>
> The above walk of the guest page tables is done in hardware.  KVM then does the
> following walks in software to retrieve the desired HPA:
>
>  GPA -> [memslots] -> HVA -> [host page tables] -> HPA

Do you mean that GPAs are different from their corresponding HVAs when
KVM does the walks (as you said above) in software?

Thanks,
Harry
