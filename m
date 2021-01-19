Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75ACF2FBBCB
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 16:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391716AbhASP4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 10:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390750AbhASPww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 10:52:52 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E98CC061575;
        Tue, 19 Jan 2021 07:52:11 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id et9so9318405qvb.10;
        Tue, 19 Jan 2021 07:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QcyMDDVr7CULOAn4Y79GHadhfUa6Q0T6oHNJlZ8GjWw=;
        b=Yer91Bx8c4Zuf1jc7YE1BhjV1iCXJqwpcbRE/LVgACcNIm3xYd/qExI++Vi5WEHKWn
         h4Q3B9iNjHGBstOD7f7waSofR3i2l0oNGDU9laQHLyX+/zYYktlFoV0ZTe7fjLqqo7fd
         sIiq82ij96CVIZIpR+mIPzExMbuBALZCMme1Nrmb0DboFYLMIBQLK05OPJO+ZyqTc05a
         daKfvHLmry82KJR9/iqFcLQOQFZLGjLOmSspQyJ7tY0LKKjX5aiZ107DAR/NlIGF3PiX
         XfTgFPaVwKS6MVwb49o+BNhXvKTxY4pd+TrVD35ssENsLzTINILsfmIxnI6Y8se5xAeu
         vmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QcyMDDVr7CULOAn4Y79GHadhfUa6Q0T6oHNJlZ8GjWw=;
        b=VDj7R91xJZSC8nABJ+VsSQYOEKILcSxhnMVbnOxk3xudlRnIRVzqkHdtC98td7Vx9l
         08Qx2WaCQM2yHAs8kxCYA25ZDPCrZLNBnrJYMVbYAcrGSDcM7zVx6ow2jvua02ICF+fe
         /h4cPZfmwxxGebpzQYpD2poWrsFp+sCC49cOGJkI52aH6YHl4afL1wCAu1TNhLFqJbVe
         E5EDVTShxrvNF2EGnZdnV8wsKZJEEuET95GLAFCOS/FNU27YYeJaoMsvB1DbS7PmRXVs
         EpianYAGXnTUU7uQyhLpnAdwTh60VyIndblOwWG/9Z/AKT83bi1OgVilrljYLANfFMzh
         cRRA==
X-Gm-Message-State: AOAM531iViPnMHGwtXdjBnzzwQwetzkH/CKYHhth4vRZB7JwY1aZFY8M
        U3KEMjcMoiE+d7v/vbZLSNU=
X-Google-Smtp-Source: ABdhPJz4PPSSVhf5I0deb91RGl3FbA/YHzb6yFRs2tv9zKL0ZEo+6Q0S21fXAdtf2SgRXv1OWNTsMg==
X-Received: by 2002:ad4:5901:: with SMTP id ez1mr4795454qvb.6.1611071530224;
        Tue, 19 Jan 2021 07:52:10 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:4cbf])
        by smtp.gmail.com with ESMTPSA id e7sm5571073qto.46.2021.01.19.07.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:52:09 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 19 Jan 2021 10:51:24 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAJsUyH2zspZxF2S@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Fri, Jan 15, 2021 at 08:32:19PM -0800, Vipin Sharma wrote:
> SEV-ES has stronger memory encryption gurantees compared to SEV, apart
> from encrypting the application memory it also encrypts register state
> among other things. In a single host ASIDs can be distributed between
> these two types by BIOS settings.
> 
> Currently, Google Cloud has Confidential VM machines offering using SEV.
> ASIDs are not compatible between SEV and SEV-ES, so a VM running on SEV
> cannot run on SEV-ES and vice versa
> 
> There are use cases for both types of VMs getting used in future.

Can you please elaborate? I skimmed through the amd manual and it seemed to
say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
case for mixing those two?

> > > > > Other ID types can be easily added in the controller in the same way.
> > > > 
> > > > I'm not sure this is necessarily a good thing.
> > > 
> > > This is to just say that when Intel and PowerPC changes are ready it
> > > won't be difficult for them to add their controller.
> > 
> > I'm not really enthused about having per-hardware-type control knobs. None
> > of other controllers behave that way. Unless it can be abstracted into
> > something common, I'm likely to object.
> 
> There was a discussion in Patch v1 and consensus was to have individual
> files because it makes kernel implementation extremely simple.
> 
> https://lore.kernel.org/lkml/alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com/#t

I'm very reluctant to ack vendor specific interfaces for a few reasons but
most importantly because they usually indicate abstraction and/or the
underlying feature not being sufficiently developed and they tend to become
baggages after a while. So, here are my suggestions:

* If there can be a shared abstraction which hopefully makes intuitive
  sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
  something arbitrary to specific vendors.

* If we aren't there yet and vendor-specific interface is a must, attach
  that part to an interface which is already vendor-aware.

> This information is not available anywhere else in the system. Only
> other way to get this value is to use CPUID instruction (0x8000001F) of
> the processor. Which also has disdvantage if sev module in kernel
> doesn't use all of the available ASIDs for its work (right now it uses
> all) then there will be a mismatch between what user get through their
> code and what is actually getting used in the kernel by sev.
> 
> In cgroup v2, I didn't see current files for other cgroups in root
> folder that is why I didn't show that file in root folder.
> 
> Will you be fine if I show two files in the root, something like:
> 
> encids.sev.capacity
> encids.sev.current
> 
> In non root folder, it will be:
> encids.sev.max
> encids.sev.current
> 
> I still prefer encids.sev.stat, as it won't repeat same information in
> each cgroup but let me know what you think.

Yeah, this will be a first and I was mostly wondering about the same number
appearing under different files / names on root and !root cgroups. I'm
leaning more towards capacity/current but let me think about it a bit more.

Thank you.

-- 
tejun
