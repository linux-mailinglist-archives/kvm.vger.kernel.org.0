Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD64717E9D
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbfEHQ5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:57:23 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45494 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbfEHQ5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:57:23 -0400
Received: by mail-io1-f65.google.com with SMTP id b3so11968073iob.12
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 09:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9T9+Q+/L1JER3sHDK1R5LWLHhF+gCnqCE9Lr/AMbTtk=;
        b=q+xshXHMFDkNosdhGXort+4WgzORoOh5YhHZ1BPvLC+NkYnqAunR9BkjsKMprwYr81
         tYHICrr+aYNHwLO8PFiU+UC+fbGo7pAwwDgeUq4RIG1Vn7ANbKHB7+GGq17LeWV8wxK7
         kMgoQWT8n2kkTjoyzCYLWJbZltn9e0YQFwzJdiorxPw2PjYJr0XxDhKHIFQgGEEkasU5
         cMsl3dIurlgj7E4D1T4aBcgSMIaAXB8F9zyc6dS9h/9U2SrK30I9nJjwCngpQhO4LZPz
         ORvWeTtz4+0uLMTqoleYXIi55mW6hX9MvpLP70fwkgh5v5Hx58nTpnXPmpw0c0G/M3Aq
         XHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9T9+Q+/L1JER3sHDK1R5LWLHhF+gCnqCE9Lr/AMbTtk=;
        b=YlCBuHvrb23EiiThFCFR7vKY6nUhTcTOR+o3rBt/0YaynEZLEelks+ypJjVsjmcvDq
         UGIs9Ja3XrZe4tgjOAIxSqME0bw3G6kedKi2ojQ+l1XhkW/zekLH4vhq2VAVElHpLM+3
         D9JM6dEhnWzhMkzfjOI7F0kgeC10fbWcuidkpuolSUu7gikorHL3Y6+7GWwVgQ+zKMbG
         4AupBXWUf61p4MFeT0VVaohQx7zpOOcCah0YAQCbvqp00+gXawpUTI2u/1OWe+Git2ZO
         L9GNuHdaHYStwqRyYhqdC7bCHsJdscN6nZ6T9IO1k1oC9HAf6pn2wcZ1WCI5E394NvU2
         o1AA==
X-Gm-Message-State: APjAAAXJ8XLikpN4gTNR/W//FlxDL5gd6KlvRGlg6mABz2mYiuDisyDA
        O4kTI5yIgxg+3CmK+PO1cayI0829TWC/nP2hxUKXUg==
X-Google-Smtp-Source: APXvYqwbh5Ilxxmk3yPhtysUNXRWHY1Aw2eZczyFvFhCGZGUxWNoFviun0tzHiwNuUOMT0GXdKYtZn3puTzqSFR6XY4=
X-Received: by 2002:a6b:f101:: with SMTP id e1mr15002691iog.262.1557334642488;
 Wed, 08 May 2019 09:57:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190508160819.19603-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190508160819.19603-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 May 2019 09:57:11 -0700
Message-ID: <CALMp9eSrpi=Pagdt_3UhcWpDpHcVc6c2t0HAszZz105kN+ehsA@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest
 supports PMU"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 8, 2019 at 9:08 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> The RDPMC-exiting control is dependent on the existence of the RDPMC
> instruction itself, i.e. is not tied to the "Architectural Performance
> Monitoring" feature.  For all intents and purposes, the control exists
> on all CPUs with VMX support since RDPMC also exists on all VCPUs with
> VMX supported.  Per Intel's SDM:
>
>   The RDPMC instruction was introduced into the IA-32 Architecture in
>   the Pentium Pro processor and the Pentium processor with MMX technology.
>   The earlier Pentium processors have performance-monitoring counters, but
>   they must be read with the RDMSR instruction.
>
> Because RDPMC-exiting always exists, KVM requires the control and refuses
> to load if it's not available.  As a result, hiding the PMU from a guest
> breaks nested virtualization if the guest attemts to use KVM.

Is it true that the existence of instruction <X> implies the
availaibility of the VM-execution control <X>-exiting (if such a
VM-execution control exists)? What about WBINVD? That instruction has
certainly been around forever, but there were VMX-capable processors
that did not support WBINVD-exiting.

Having said that, I think our hands are tied by the assumptions made
by existing hypervisors, whether or not those assumptions are true.
(VMware's VMM, for instance, requires MONITOR-exiting and
MWAIT-exiting even when MONITOR/MWAIT are not enumerated by CPUID.)

> While it's not explicitly stated in the RDPMC pseudocode, the VM-Exit
> check for RDPMC-exiting follows standard fault vs. VM-Exit prioritization
> for privileged instructions, e.g. occurs after the CPL/CR0.PE/CR4.PCE
> checks, but before the counter referenced in ECX is checked for validity.
>
> In other words, the original KVM behavior of injecting a #GP was correct,
> and the KVM unit test needs to be adjusted accordingly, e.g. eat the #GP
> when the unit test guest (L3 in this case) executes RDPMC without
> RDPMC-exiting set in the unit test host (L2).
>
> This reverts commit e51bfdb68725dc052d16241ace40ea3140f938aa.
>
> Fixes: e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU")
> Reported-by: David Hill <hilld@binarystorm.net>
> Cc: Saar Amar <saaramar@microsoft.com>
> Cc: Mihai Carabas <mihai.carabas@oracle.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
