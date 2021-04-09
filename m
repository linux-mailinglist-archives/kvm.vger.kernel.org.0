Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CDB35A7CB
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 22:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhDIUZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 16:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233674AbhDIUZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 16:25:01 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF1FC061763
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 13:24:44 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e186so7183243iof.7
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 13:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mB7kxR56sLSER8I5oyS023AqFo1fyl/hBCTPjDto6bI=;
        b=j8Pjc2Kd72z72kc52//ILW4NWwnRjwF/pfUnWmlnQR/ykKiGz1xy9GHg5iYu7VyjmD
         j1JxTubGUrpBsEs17+U7BGm3rj8JPA8LeX2GG2Kz2cmZ+IJ7vioNX2b2DC1nSn4bfKBW
         0Ho1VAN1shuQZ69Pr5VQBBA6D6JkXjhpg+LCM3RmzH+DHnrxrPxRzc/uEl2EEgdyv23Z
         KFn7TX1to39jk+byfwbeTVmibxJnAGZeLkUMAO8iXVraZy14b+GUlkrrlmltwwv7L8gG
         IvNiosr1cxIu7NefOiN9+F+grD6c8nyPlEJ+AN0h7ZbAr0U4yVjT2FIghdpFG+FIGRlR
         EzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mB7kxR56sLSER8I5oyS023AqFo1fyl/hBCTPjDto6bI=;
        b=ejHB/WPAmAg+r5kwtWIWB/oq9W3zU2UCJl4p8UfgqJLhQc1S2O9KDPi6Q1UjW5C8S/
         TfDqOfpQLmu7j5VtcZ3ZPNtRUgVi8jlYvtSW6PC3xIg1w5hcULCW5hdhJhfEM9sgCqDW
         XQtJBQZbscChBO6qCx9CPtCNLBNj13pcD0RdKCWkF6X0QInHhCBEU/hZPOB4XhUhhMKC
         XYLCprTRVcZ+Dwm9e0IXTaVlkm+EeWSCllcYQxVCeuFbUmqF3VEdmzHVPxDTrqqnGqmV
         qiszKnYtgThnSLgH2yVuB3Xc9Zxm2cQDb3ZOjs1RK2D/bCyg1p7RGJdXbIXp2i71Zqj7
         Ykag==
X-Gm-Message-State: AOAM533UUpMvSXvBVbShtWh3H6rcytWGwLH3sJQYa3rfSRqaRF8nXzKg
        8bRUG/ue7pdK9bb4B4LF0oM7oTgL5FjBOFZVEj2bzg==
X-Google-Smtp-Source: ABdhPJwU/0efdeCg18merwiu9BwHt5WAPMlkmFgvshdnzNmAe42X3Cc0ucddlzeVpenW3Xh1h38+kcrqcMrv/kRW6nM=
X-Received: by 2002:a05:6638:3a8:: with SMTP id z8mr16413394jap.111.1617999883243;
 Fri, 09 Apr 2021 13:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210316014027.3116119-1-natet@google.com> <20210402115813.GB17630@ashkalra_ubuntu_server>
 <87bdd3a6-f5eb-91e4-9442-97dfef231640@redhat.com> <936fa1e7755687981bdbc3bad9ecf2354c748381.camel@linux.ibm.com>
 <CABayD+cBdOMzy7g6X4W-M8ssMpbpDGxFA5o-Nc5CmWi-aeCArQ@mail.gmail.com>
 <fc32a469ae219763f80ef1fc9f151a62cfe76ed6.camel@linux.ibm.com>
 <CABayD+c22hgPtjJBLkhyvyt+WAKXhoQOM6n0toVR1XrFY4WHAw@mail.gmail.com>
 <75863fa3f1c93ffda61f1cddfef0965a0391ef60.camel@linux.ibm.com> <ed7c38cd-4cfd-9f36-dd81-b8d699fd498d@redhat.com>
In-Reply-To: <ed7c38cd-4cfd-9f36-dd81-b8d699fd498d@redhat.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 9 Apr 2021 13:24:06 -0700
Message-ID: <CABayD+dCiuXXD=erOuVFEZOULrDvdqOTyHSA4drHArvBicTzcw@mail.gmail.com>
Subject: Re: [RFC v2] KVM: x86: Support KVM VMs sharing SEV context
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     jejb@linux.ibm.com, Ashish Kalra <ashish.kalra@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        dovmurik@linux.vnet.ibm.com, lersek@redhat.com, frankeh@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 9, 2021 at 1:14 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/04/21 03:18, James Bottomley wrote:
> > If you want to share ASIDs you have to share the firmware that the
> > running VM has been attested to.  Once the VM moves from LAUNCH to
> > RUNNING, the PSP won't allow the VMM to inject any more firmware or do
> > any more attestations.
>
> I think Steve is suggesting to just change the RIP of the mirror VM,
> which would work for SEV but not SEV-ES (the RAM migration helper won't
> *suffice* for SEV-ES, but perhaps you could use the PSP to migrate the
> VMSA and the migration helper for the rest?).
Exactly: you can use the existing PSP flows to migrate both the
migration helper itself and the necessary VMSAs.
>
> If you want to use a single firmware binary, SEC does almost no I/O
> accesses (the exception being the library constructor from
> SourceLevelDebugPkg's SecPeiDebugAgentLib), so you probably can:
>
> - detect the migration helper hardware in PlatformPei, either from
> fw_cfg or based on the lack of it
>
> - either divert execution to the migration helper through
> gEfiEndOfPeiSignalPpiGuid, or if it's too late add a new boot mode and
> PPI to DxeLoadCore.
>
> Paolo
>
> > What you mirror after this point can thus only
> > contain what has already been measured or what the guest added.  This
> > is why we think there has to be a new entry path into the VM for the
> > mirror vCPU.
>
