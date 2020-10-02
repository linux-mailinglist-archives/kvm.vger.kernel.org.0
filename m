Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7545C281D1B
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgJBUsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgJBUsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 16:48:18 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F90DC0613E2
        for <kvm@vger.kernel.org>; Fri,  2 Oct 2020 13:48:17 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x22so2109556pfo.12
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 13:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cLATYwuDqnhajc5QXKEUsa/OcJ1TmbemJ0CgVdLo4Ek=;
        b=jpNf1D4Wi5BJQOSFaL6zihdxze85N1qgFBus9S+8h5/Gbq4JX0IBUfUdmxgRJRqj+9
         B9enPn1Dj0RqI12GOSTJ7/ZUqmD5+HRZ0XKm2oEUgDPMl5/c5ZgtjkacrUBlCudalMil
         DT1Mo+CRme+xk894/UHRuj0UUf5XJ356AoYcVldnSbVinqtZlsd7Wl3zMbc0TUPkIR+A
         B44n8cH7lzw9MSbwCaVx2wILWeF+ZHpS183wHCPCP0PjRNQ8m34+1dcSheoQJ7RE0sgH
         lwjpwsK44adXVgfd6/V51TZaCfgs4ISlGvXCVOG/c2RZJ5/IpvnUQdQAe0Qfklvp2WVz
         YIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cLATYwuDqnhajc5QXKEUsa/OcJ1TmbemJ0CgVdLo4Ek=;
        b=C+nlOsxs7ufJil/EfITu7CMcB2ptYDmCdOiBuT1ylkNqhc2kQeivuFMIqnaqSzntWD
         smkfagh4B9FQ2VWECSuk83raR3MZPplFEntSaht/FOSIXBEolJpkvyAVeBfIsK4yZACe
         zJv2owdKinRbYp25HrbK4BBGEb95vDFzkGwkAFmhG5qlMN1hAwg9dJe/pKuLatUv3qFE
         h6wX9SaDfG/KWhV539vfDZ8Bl7es49maTxiVQ7eeHcSsptMYko/vtNB52A/bRSRbsU8U
         fnubiDi6AH7OoZVhDGzA/V6plNj0U1CA2et134eWavfXFTuyrfL2+oo6i2n9EDs/UTjQ
         Jqlg==
X-Gm-Message-State: AOAM533w2bU9bBEV5rQDUovWYAQrwZkvTSvsXq1GcZe1L7LEAhdCKyoC
        rR6kORm6eWzfp2nrE7J1wo6TFg==
X-Google-Smtp-Source: ABdhPJxwzc6rFv0usOMnH38FiAyqbm/CY3bJyzbwqfG3tsfqs+vUWEAzUChtCseDztixr5Be67J6KQ==
X-Received: by 2002:a63:c547:: with SMTP id g7mr3805983pgd.234.1601671695860;
        Fri, 02 Oct 2020 13:48:15 -0700 (PDT)
Received: from google.com ([2620:0:1008:10:1ea0:b8ff:fe75:b885])
        by smtp.gmail.com with ESMTPSA id z21sm1779419pfr.43.2020.10.02.13.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 13:48:14 -0700 (PDT)
Date:   Fri, 2 Oct 2020 13:48:10 -0700
From:   Vipin Sharma <vipinsh@google.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org,
        lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        gingell@google.com, rientjes@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Message-ID: <20201002204810.GA3179405@google.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922014836.GA26507@linux.intel.com>
 <20200922211404.GA4141897@google.com>
 <20200924192116.GC9649@linux.intel.com>
 <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com>
 <20200925222220.GA977797@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925222220.GA977797@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:
> On Thu, Sep 24, 2020 at 02:55:18PM -0500, Tom Lendacky wrote:
> > On 9/24/20 2:21 PM, Sean Christopherson wrote:
> > > On Tue, Sep 22, 2020 at 02:14:04PM -0700, Vipin Sharma wrote:
> > > > On Mon, Sep 21, 2020 at 06:48:38PM -0700, Sean Christopherson wrote:
> > > > > On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > This patch series adds a new SEV controller for tracking and limiting
> > > > > > the usage of SEV ASIDs on the AMD SVM platform.
> > > > > > 
> > > > > > SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
> > > > > > but this resource is in very limited quantity on a host.
> > > > > > 
> > > > > > This limited quantity creates issues like SEV ASID starvation and
> > > > > > unoptimized scheduling in the cloud infrastructure.
> > > > > > 
> > > > > > SEV controller provides SEV ASID tracking and resource control
> > > > > > mechanisms.
> > > > > 
> > > > > This should be genericized to not be SEV specific.  TDX has a similar
> > > > > scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
> > > > > (gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
> > > > > would change anything, I think it'd just be a bunch of renaming.  The hardest
> > > > > part would probably be figuring out a name :-).
> > > > > 
> > > > > Another idea would be to go even more generic and implement a KVM cgroup
> > > > > that accounts the number of VMs of a particular type, e.g. legacy, SEV,
> > > > > SEV-ES?, and TDX.  That has potential future problems though as it falls
> > > > > apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
> > > > > account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
> > > > > light of day.
> > > > 
> > > > I read about the TDX and its use of the KeyID for encrypting VMs. TDX
> > > > has two kinds of KeyIDs private and shared.
> > > 
> > > To clarify, "shared" KeyIDs are simply legacy MKTME KeyIDs.  This is relevant
> > > because those KeyIDs can be used without TDX or KVM in the picture.
> > > 
> > > > On AMD platform there are two types of ASIDs for encryption.
> > > > 1. SEV ASID - Normal runtime guest memory encryption.
> > > > 2. SEV-ES ASID - Extends SEV ASID by adding register state encryption with
> > > > 		 integrity.
> > > > 
> > > > Both types of ASIDs have their own maximum value which is provisioned in
> > > > the firmware
> > > 
> > > Ugh, I missed that detail in the SEV-ES RFC.  Does SNP add another ASID type,
> > > or does it reuse SEV-ES ASIDs?  If it does add another type, is that trend
> > > expected to continue, i.e. will SEV end up with SEV, SEV-ES, SEV-ES-SNP,
> > > SEV-ES-SNP-X, SEV-ES-SNP-X-Y, etc...?
> > 
> > SEV-SNP and SEV-ES share the same ASID range.
> > 
> > Thanks,
> > Tom
> > 
> > > 
> > > > So, we are talking about 4 different types of resources:
> > > > 1. AMD SEV ASID (implemented in this patch as sev.* files in SEV cgroup)
> > > > 2. AMD SEV-ES ASID (in future, adding files like sev_es.*)
> > > > 3. Intel TDX private KeyID
> > > > 4. Intel TDX shared KeyID
> > > > 
> > > > TDX private KeyID is similar to SEV and SEV-ES ASID. I think coming up
> > > > with the same name which can be used by both platforms will not be easy,
> > > > and extensible with the future enhancements. This will get even more
> > > > difficult if Arm also comes up with something similar but with different
> > > > nuances.
> > > 
> > > Honest question, what's easier for userspace/orchestration layers?  Having an
> > > abstract but common name, or conrete but different names?  My gut reaction is
> > > to provide a common interface, but I can see how that could do more harm than
> > > good, e.g. some amount of hardware capabilitiy discovery is possible with
> > > concrete names.  And I'm guessing there's already a fair amount of vendor
> > > specific knowledge bleeding into userspace for these features...
> 
> I agree with you that the abstract name is better than the concrete
> name, I also feel that we must provide HW extensions. Here is one
> approach:
> 
> Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to
> suggestions)
> 
> Control files: slots.{max, current, events}
> 
> Contents of the slot.max:
> default max
> 	default: Corresponds to all kinds of encryption capabilities on
> 		 a platform. For AMD, it will be SEV and SEV-ES.  For
> 		 Intel, it will be TDX and MKTME. This can also be used
> 		 by other devices not just CPU.
> 
> 	max: max or any number to denote limit on the cgroup.
> 
> A user who wants the finer control, then they need to know about the
> capabilities a platform provides and use them, e.g. on AMD:
> 
> $ echo "sev-es 1000" > slot.max
> $ cat slots.max
> default max sev-es 1000
> 
> This means that in the cgroup maximum SEV-ES ASIDs which can be used is
> 1000 and SEV ASIDs is max (default, no limit).  Each platform can
> provide their own extensions which can be overwritten by a user,
> otherwise extensions will have the default limit.
> 
> This is kind of similar to the IO and the rdma controller.
> 
> I think it is keeping abstraction for userspace and also providing finer
> control for HW specific features.
> 
> What do you think about the above approach?  
> 
Hi Sean,

Any feedback/concern for the above abstraction approach?

Thanks
