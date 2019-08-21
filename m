Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 266AC98617
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 22:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbfHUU7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 16:59:32 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36316 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728485AbfHUU7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 16:59:32 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so7520499iom.3
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 13:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pNXmRyV8HhBr1Lrk0jUCfVqCK9CQ+Hb9D8YhUlZVj7s=;
        b=X7fv7CwskFqDc+s0gxK0LCtY8LpTH+pJDDq4YS9TOdwmtTU05FvfDRPsUVH2GN7MYq
         BoSVEnbfisxU2Aw0z/Ox5I9MtCl0FlkM8pGTVD4Je3Zk1TrbBSzktIzhnp/Bhsi+UhxM
         liPk3Bfna1GQ7nfuTzP5IG0uyYEJBIFDbU+Ed63mM7s8iDtYN9p9IBEdx61L6dauueUy
         JlCWI0bJss9pvaHuVpkp4pYPMkqPkUxxqo/xb6B0WIiQYJ8Zile+32LcOztQCsJVNJ9p
         TPQoVW2edIqCuZ63viXI0IIpmTLAE2+3kLi4CJARTsk8QB+fPvn9m6stWIxvE7D9bJM2
         SRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pNXmRyV8HhBr1Lrk0jUCfVqCK9CQ+Hb9D8YhUlZVj7s=;
        b=pmd5HOfA/pm0xB6QEYkODEyy0HQ8OXcjvg8b3UCkOKH9FwB9g3Na3v/oW29NnD8PhY
         s0UxM6WVCVTPTXrVWR02hhe5eT43iYgYDYQdPU8cxcGzUFnRNLAaNEm88Fkwnd+KNUp1
         smRWsH0uNrWO4sIBXAOHwAJ2zCqbFSXbPXeegajCcdfK4rnSKG/tRJriXuZ44l7PN82k
         KE2Nfh0xOUWTQDqxzRptw2GeMjsjyunX4180Oyo04ySdeUb1VRE3cshT76PfHkov7Ko+
         ceExNaZZkRK3B+ib20tiWhMdJ3wy6wP0M6/sqxwUEPE4BxSPzIztvjbeb1IDQY3toJJJ
         lRGg==
X-Gm-Message-State: APjAAAVfUdh6/BvwsJnDwk9CJVQyhzcJrh14RTjvC1WwX6Ytnl7UfHqu
        LaK4ecEktQN+p2KsaQOQMsNjdbGwPWna/ZQhTegEeA==
X-Google-Smtp-Source: APXvYqyUQ+/RANSlxPpHj0itgCJ4tC/kXp1GhBEFqTrIRPs2j3xLaPonYN1kjFHunseGfAi9br6q48EZuDVpUFqQVqg=
X-Received: by 2002:a6b:5116:: with SMTP id f22mr42849004iob.108.1566421171125;
 Wed, 21 Aug 2019 13:59:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
 <20190819214650.41991-2-nikita.leshchenko@oracle.com> <20190819221101.GF1916@linux.intel.com>
In-Reply-To: <20190819221101.GF1916@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 21 Aug 2019 13:59:20 -0700
Message-ID: <CALMp9eR4zO=BOZKzDowkVSR7O9Y2aqBXEvwepv6j85z4wvSyxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: Always indicate HLT activity support in
 VMX_MISC MSR
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 3:11 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Aug 20, 2019 at 12:46:49AM +0300, Nikita Leshenko wrote:
> > Before this commit, userspace could disable the GUEST_ACTIVITY_HLT bit in
> > VMX_MISC yet KVM would happily accept GUEST_ACTIVITY_HLT activity state in
> > VMCS12. We can fix it by either failing VM entries with HLT activity state when
> > it's not supported or by disallowing clearing this bit.
> >
> > The latter is preferable. If we go with the former, to disable
> > GUEST_ACTIVITY_HLT userspace also has to make CPU_BASED_HLT_EXITING a "must be
> > 1" control, otherwise KVM will be presenting a bogus model to L1.
> >
> > Don't fail writes that disable GUEST_ACTIVITY_HLT to maintain backwards
> > compatibility.
>
> Paolo, do we actually need to maintain backwards compatibility in this
> case?  This seems like a good candidate for "fix the bug and see who yells".

Google's userspace clears bit 6. Please don't fail that write!
