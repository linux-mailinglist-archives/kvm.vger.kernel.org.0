Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349E51BC75C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 20:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgD1SBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 14:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbgD1SBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 14:01:00 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1CAC03C1AB
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 11:00:59 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id f82so21374191ilh.8
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 11:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Afnfs23o5ojskhjA7pHz0YVUkEJPQsaZb+msDxVtXZk=;
        b=ZlMj4lWcO3uAGE541G0U0ClZ1r3ESia7qhWkFQZB+99m5QeCK2jGxqWc6KObA9xz2H
         vfM0tSZhyphHa41Gtbjm32bs0p8zq+fCdEVZ9e4IOgFoQNjdEG2NvDtmyZVHOj8Vrm5m
         d26z9hzfn/54/Whff4J91PcXivBtbXU2hT4J5PdnTcbCnizr8KGOKCqKVIeC0rND/5Yg
         JHUslZAmOkv1G9eUCKrOtdKLIFSP4pORNL+6tt+C/ObYucnSPogTelrrrh2gFmTeMWQn
         +CdiieK/CACenkvSSsyNrhujY8DNZfl0CkwQSMYfHYeYMtPt0DB5t9mAXQmTJMYF/un+
         cGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Afnfs23o5ojskhjA7pHz0YVUkEJPQsaZb+msDxVtXZk=;
        b=rxXpprKyh4WBmZduWXbt25ksW+ZZO+N3CexTBIl3WIE7NqFXS60FPtmaKCmOjZ6sx6
         9ybFLIoWA/Mz9Y5ThKAwii4/A1lmKgkDYAIzfsU9SLTvoOYZVuAIMLfBjRE2NJL5lIUI
         AkU/9Fa24pCTgTSU4hBnZvY8xlqTfiNYApC/JsvTQY1dr7JDvA01me+nrtVyDTqvdPDp
         1by2iUf90Maqq+PfGAD3ofVpsQOb8OwsEL0+XPNwTotuapTa057S9JD+MC1H7GZe3iY5
         RP99YEuzLPt5t0ez7gMKhirOu17AEQsBZGv6Yg6aofqt6wBf9oGY9pngqVqB5EYf/TSL
         Hzow==
X-Gm-Message-State: AGi0PuZsAh1W5rwON3en28gFcTtHnDB7PDPOEIlA5CSpbL2s2NwptWEZ
        uEgDF/KNn3o9qn1R7A02mJPMGWnHeWSpb4v+aaxnWQ==
X-Google-Smtp-Source: APiQypLhMzzOq69G01HpbrP/xwyH2wblwtx0fE5oCQrckOc4Ai47y8PTGHXDg9K3TxuaAlaHIcN3FnxVFSSo3nVIl58=
X-Received: by 2002:a92:d8ca:: with SMTP id l10mr27570356ilo.118.1588096858932;
 Tue, 28 Apr 2020 11:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com> <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com> <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
 <20200418015545.GB15609@linux.intel.com> <c37b9429-0cb8-6514-44a7-65544873dba0@redhat.com>
 <02a49d40-fe80-2715-d9a8-17770e72c7a3@oracle.com> <11ce961c-d98c-3c4c-06a7-3c0f8336a340@redhat.com>
 <a5bf92bd-d4df-8d6c-8df2-9c993b31459a@oracle.com>
In-Reply-To: <a5bf92bd-d4df-8d6c-8df2-9c993b31459a@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 11:00:47 -0700
Message-ID: <CALMp9eSqWoXW5r60d7F9uDop8cNyO0zTiapPocXGagJnr7JsBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted guest"
 VM-execution control in vmcs02 if vmcs12 doesn't set it
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 10:39 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 4/28/20 1:14 AM, Paolo Bonzini wrote:
> > On 28/04/20 09:25, Krish Sadhukhan wrote:
> >>> Absolutely.  Unrestricted guest requires EPT, but EPT is invisible to
> >>> the guest.  (Currently EPT requires guest MAXPHYADDR = host MAXPHYADDR,
> >>> in the sense that the guest can detect that the host is lying about
> >>> MAXPHYADDR; but that is really a bug that I hope will be fixed in 5.8,
> >>> relaxing the requirement to guest MAXPHYADDR <= host PHYADDR).
> >> Should EPT for the nested guest be set up in the normal way (PML4E ->
> >> PDPTE-> PDE -> PTE) when GUEST_CR0.PE is zero ? Or does it have to be a
> >> special set up like only the PTEs are needed because no protection and
> >> no paging are used ?
> > I don't understand.  When EPT is in use, the vmcs02 CR3 is simply set to
> > the vmcs12 CR3.
>
>
> Sorry, I should have framed my question in a better way.
>
> My question is  how should L1 in the test code set up EPTP for L2 when
> L2 is an unrestricted guest with no protection (GUEST_CR0.PE = 0) and no
> paging (GUEST_CR0.PG = 0) ? Should EPTP in test code be set up in the
> same way as when L2 is an unrestricted guest with protection and paging
> enabled ?

The EPT maps guest physical addresses to host physical addresses. That
mapping is the same regardless of whether the guest is using paging or
not.
