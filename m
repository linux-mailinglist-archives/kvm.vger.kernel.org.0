Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36C0202199
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 07:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgFTFNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Jun 2020 01:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgFTFNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Jun 2020 01:13:40 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412612389F
        for <kvm@vger.kernel.org>; Sat, 20 Jun 2020 05:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592630019;
        bh=XpxrOoscw7UDPYdpWYDnzCBo6kTqYNwo983zEEwpytI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QG36rmZwdhMS15Lbtj/5W7HPCSKgefaPRcAYLZbZb1cXj1AvMAoy4pOa3Nd25xTh/
         RcA2aMWDXBPrF+6zK26TiQTpqZrfX7bDmIB0tzItrot8/jzFaYkWawIsEJ8UUCnkXB
         q/CKKh7Xem92WEMLQfs+piYxG/GgNmwOmb3tWDlc=
Received: by mail-wm1-f54.google.com with SMTP id g75so2126603wme.5
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 22:13:39 -0700 (PDT)
X-Gm-Message-State: AOAM531l4t9jfI1lEKwebilPDM3QJNOQb3vtHpxQ5195/UX33eTSlGmp
        6YvKsOg0Cq8oMJwg3Emp9qYhOFVBH+ewHf21M7AkMg==
X-Google-Smtp-Source: ABdhPJyyB4QO+g3WOSHr/Wl98Qb7Rq+mvtzWS1L0jQTdsL9FSCsqPMc9nvEFUcIBqPizV6qaSeEtRlBtgFYD15XCOs4=
X-Received: by 2002:a1c:4804:: with SMTP id v4mr7078010wma.21.1592630017493;
 Fri, 19 Jun 2020 22:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200617190757.27081-1-john.s.andersen@intel.com> <20200617190757.27081-5-john.s.andersen@intel.com>
In-Reply-To: <20200617190757.27081-5-john.s.andersen@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 19 Jun 2020 22:13:25 -0700
X-Gmail-Original-Message-ID: <CALCETrXwzQDDd1rfBW+ptmijEjc2cMqfWGvJu-qqrqia5Ls=Uw@mail.gmail.com>
Message-ID: <CALCETrXwzQDDd1rfBW+ptmijEjc2cMqfWGvJu-qqrqia5Ls=Uw@mail.gmail.com>
Subject: Re: [PATCH 4/4] X86: Use KVM CR pin MSRs
To:     John Andersen <john.s.andersen@intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, mchehab+huawei@kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        pawan.kumar.gupta@linux.intel.com, Juergen Gross <jgross@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Oliver Neukum <oneukum@suse.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>, reinette.chatre@intel.com,
        vineela.tummalapalli@intel.com,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        caoj.fnst@cn.fujitsu.com, Baoquan He <bhe@redhat.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>, eric.auger@redhat.com,
        aaronlewis@google.com, Peter Xu <peterx@redhat.com>,
        makarandsonare@google.com,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 12:05 PM John Andersen
<john.s.andersen@intel.com> wrote:
> Guests using the kexec system call currently do not support
> paravirtualized control register pinning. This is due to early boot
> code writing known good values to control registers, these values do
> not contain the protected bits. This is due to CPU feature
> identification being done at a later time, when the kernel properly
> checks if it can enable protections. As such, the pv_cr_pin command line
> option has been added which instructs the kernel to disable kexec in
> favor of enabling paravirtualized control register pinning. crashkernel
> is also disabled when the pv_cr_pin parameter is specified due to its
> reliance on kexec.

Is there a plan for fixing this for real?  I'm wondering if there is a
sane weakening of this feature that still allows things like kexec.

What happens if a guest tries to reset?  For that matter, what happens
when a guest vCPU sends SIPI to another guest vCPU?  The target CPU
starts up in real mode, right?  There's no SMEP or SMAP in real mode,
and real mode has basically no security mitigations at all.

PCID is an odd case.  I see no good reason to pin it, and pinning PCID
on prevents use of 32-bit mode.
