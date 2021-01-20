Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9AD2FD5EE
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 17:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391621AbhATQnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 11:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391659AbhATQlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 11:41:47 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13596C061575;
        Wed, 20 Jan 2021 08:41:06 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id 143so25855756qke.10;
        Wed, 20 Jan 2021 08:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6cgRNQyvwqoOzrnPDmHwEwehw3UJ3BnFoyNANdWEhcs=;
        b=A+DQWxSy/SvL7lr93IkBN+cn6fxDJbsm0KZN1mKcBCanmMbc1jJXX9aKLE3r+hSIL/
         APH3ovJ5ozPOv+XO96yoJBgwXxehA98sdUl1WND+h+93MkW4HhuS+BCOP3BcFccOtTOi
         hBRghF0tAkk2KRD4qcoYp1iOjqg+UJw9yvgxqduUrpfkyj6mJJefjSgTjF6glRkXTwYD
         K5KITRPviTggIspBtJKBa3q4XMfF5VXdchZ5RNmN/ahWqdW9cVGU1x06fSAp4UPbQeAa
         CQ+0bQiCnO6mZpYpaIbr6+EynJhVJAMeeaA/rdL5RgFqTjqnkUxcbrtw3WJ+6oVXgiGK
         SEYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6cgRNQyvwqoOzrnPDmHwEwehw3UJ3BnFoyNANdWEhcs=;
        b=k7w/Kn9AqOREpKhySjvGfup8CZXBMOSUXoBkbFDgT5QAC9HLzwRs7idLYQSDbhfy85
         ecBr6YhFzlW4jc3ltldfxalW6nf82zouyqKEst6K4xDWtGT0gnELOTgXWO3MkDL9wxSf
         S9f0dis8bpEdl1CGZhdRivmKMtyNo6VEiqK/NbEwqP6cPiQMdsBYx+OvMHUBqWIA2i8S
         lT+lk+U/ok2D/bAOq7VSCTngod+Y30uZDlnag5nSx4PewAEToEr0csZUgTElwGQ/Og8o
         ps0toATJ/vhBYmkK8hXq05eyP3KPMeJaUrhI1K1QGkv5omCP9MS8H+LRZz2tFxqxvNdT
         j2eQ==
X-Gm-Message-State: AOAM533vEq/egD3iEO6EKzv9RWtUL9cCw5k8mjM5gXUTVaZ/6UONXvS7
        opCaTef+QpezzWTdGm7wrx8=
X-Google-Smtp-Source: ABdhPJwdZRSRaK/1/ILzVUERzSOKAJqO2pvmpgMqgS8PDN6Io+7tOh/2k6BQMYml55X2jnkHqyY9cg==
X-Received: by 2002:a05:620a:21cd:: with SMTP id h13mr4789637qka.204.1611160865147;
        Wed, 20 Jan 2021 08:41:05 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:1b8f])
        by smtp.gmail.com with ESMTPSA id x49sm1550543qtx.6.2021.01.20.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:41:04 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 20 Jan 2021 11:40:18 -0500
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
Message-ID: <YAhc8khTUc2AFDcd@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAfYL7V6E4/P83Mg@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Jan 19, 2021 at 11:13:51PM -0800, Vipin Sharma wrote:
> > Can you please elaborate? I skimmed through the amd manual and it seemed to
> > say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
> > case for mixing those two?
> 
> For example, customers can be given options for which kind of protection they
> want to choose for their workloads based on factors like data protection
> requirement, cost, speed, etc.

So, I'm looking for is a bit more in-depth analysis than that. ie. What's
the downside of SEV && !SEV-ES and is the disticntion something inherently
useful?

> In terms of features SEV-ES is superset of SEV but that doesn't mean SEV
> ASIDs are superset of SEV ASIDs. SEV ASIDs cannot be used for SEV-ES VMs
> and similarly SEV-ES ASIDs cannot be used for SEV VMs. Once a system is
> booted, based on the BIOS settings each type will have their own
> capacity and that number cannot be changed until the next boot and BIOS
> changes.

Here's an excerpt from the AMD's system programming manual, section 15.35.2:

  On some systems, there is a limitation on which ASID values can be used on
  SEV guests that are run with SEV-ES disabled. While SEV-ES may be enabled
  on any valid SEV ASID (as defined by CPUID Fn8000_001F[ECX]), there are
  restrictions on which ASIDs may be used for SEV guests with SEV- ES
  disabled. CPUID Fn8000_001F[EDX] indicates the minimum ASID value that
  must be used for an SEV-enabled, SEV-ES-disabled guest. For example, if
  CPUID Fn8000_001F[EDX] returns the value 5, then any VMs which use ASIDs
  1-4 and which enable SEV must also enable SEV-ES.

> We are not mixing the two types of ASIDs, they are separate and used
> separately.

Maybe in practice, the key management on the BIOS side is implemented in a
more restricted way but at least the processor manual says differently.

> > I'm very reluctant to ack vendor specific interfaces for a few reasons but
> > most importantly because they usually indicate abstraction and/or the
> > underlying feature not being sufficiently developed and they tend to become
> > baggages after a while. So, here are my suggestions:
> 
> My first patch was only for SEV, but soon we got comments that this can
> be abstracted and used by TDX and SEID for their use cases.
> 
> I see this patch as providing an abstraction for simple accounting of
> resources used for creating secure execution contexts. Here, secure
> execution is achieved through different means. SEID, TDX, and SEV
> provide security using different features and capabilities. I am not
> sure if we will reach a point where all three and other vendors will use
> the same approach and technology for this purpose.
> 
> Instead of each one coming up with their own resource tracking for their
> features, this patch is providing a common framework and cgroup for
> tracking these resources.

What's implemented is a shared place where similar things can be thrown in
bu from user's perspective the underlying hardware feature isn't really
abstracted. It's just exposing whatever hardware knobs there are. If you
look at any other cgroup controllers, nothing is exposing this level of
hardware dependent details and I'd really like to keep it that way.

So, what I'm asking for is more in-depth analysis of the landscape and
inherent differences among different vendor implementations to see whether
there can be better approaches or we should just wait and see.

> > * If there can be a shared abstraction which hopefully makes intuitive
> >   sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
> >   something arbitrary to specific vendors.
> 
> I think we should see these as features provided on a host. Tasks can
> be executed securely on a host with the guarantees provided by the
> specific feature (SEV, SEV-ES, TDX, SEID) used by the task.
> 
> I don't think each H/W vendor can agree to a common set of security
> guarantees and approach.

Do TDX and SEID have multiple key types tho?

> > * If we aren't there yet and vendor-specific interface is a must, attach
> >   that part to an interface which is already vendor-aware.
> Sorry, I don't understand this approach. Can you please give more
> details about it?

Attaching the interface to kvm side, most likely, instead of exposing the
feature through cgroup.

Thanks.

-- 
tejun
