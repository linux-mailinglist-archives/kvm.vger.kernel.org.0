Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825C4B56C6
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 22:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbfIQUQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 16:16:42 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:34423 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729111AbfIQUQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 16:16:41 -0400
Received: by mail-wr1-f54.google.com with SMTP id a11so4564999wrx.1
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 13:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a/ipr7X5gEFLzKgZn2brsMn8tj1Lh0JIYzWkPolivz8=;
        b=Gd5MBX6TofGCeb7Ax8YRah4Pl2kMkoBf5KzrMmW6ipwrhArzol0mx3hWuRjLLFl27c
         VelJdWSEGfl+qFt+tG7+TJfxp1yWzsjQE34Y/gD2tNtaW3Pq9LbTgJj3XSVFcWqRL+hk
         KA+Zo3fuQG5K5rH61poyXRcjRsJokIfR/r7l/GJLbcAdVexqYhGjPx6625bW7D2KAjIx
         ZhpOE0Rt7Dat8yqNfCbJ9jAOvRD5ILqEn3KQWXYTxQOV9cEjvAhFMOfgtwf2LTicGsIK
         He0tP9iDGf7IlkIWgwMrb/hk9Ijupjt58p47VxaJGtJ6KEXw0oJ0o6vA/S+0Xe4oeqYt
         H1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a/ipr7X5gEFLzKgZn2brsMn8tj1Lh0JIYzWkPolivz8=;
        b=AP5cgxGzelSYbzjwikBZRkPeO0OXkkl51YeN6c+A82LVcMlovtiugng+y26AvIW8qZ
         +vNFMpgFhgOjVvDeGk671ZA0bs/cRujWZl2hHCFjAolmuHfY/HFyL+GFbQ5H1tzC44PA
         PvAv4s6BIHf/0qCPKgoKgONm7VL6oLe+uHmNe1UcLwkABL0FKSQ8VFf77CEqprebHYyg
         ZMD57ATlTsxfRsNiURCYrXpCbkdEy81x4umi9fFVhbV3JRPU9lAi0H9fJmtRQ2WRRO+E
         aHXBv3DHqudNWncL9WR7mZ3E64Iir/QOz32swlpo3O0y54NxIRVDHvNa+nfMFC2eykkx
         nblg==
X-Gm-Message-State: APjAAAXtAljaGWiZGyNkKAgKCIZlyN9hV2vKvO82n+rqBjNVRz3Suwkh
        Mx9FYHs4f5gweagkv/C2vhAmPttVMB9PWvdW3e/31g==
X-Google-Smtp-Source: APXvYqz2CRxtlEyTyFMUdfauufQaoueXERm06XZCpy0NO3Pi27c9gS24UEF9v82mWDVpGcss3LKlGt6EptVgD5iC+G4=
X-Received: by 2002:a05:6000:1281:: with SMTP id f1mr264345wrx.247.1568751398724;
 Tue, 17 Sep 2019 13:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190917185753.256039-1-marcorr@google.com> <20190917185753.256039-2-marcorr@google.com>
 <20190917194738.GD8804@linux.intel.com>
In-Reply-To: <20190917194738.GD8804@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 17 Sep 2019 13:16:27 -0700
Message-ID: <CAA03e5G94nbVj9vfOr5Gc7x89B6afh3HmxHnMMijtn8SzqgjTA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static void atomic_switch_msrs_test(int count)
> > +{
> > +     struct vmx_msr_entry *vm_enter_load;
> > +        struct vmx_msr_entry *vm_exit_load;
> > +        struct vmx_msr_entry *vm_exit_store;
>
> Spaces need to be replaced with tabs.

Done.

> > +     /* Exceeding the max MSR list size at exit trigers KVM to abort. */
>
> s/trigers/triggers
>
> The whole sentence kinda is kinda funky.  Maybe

Done.

> > +     int exit_count = count > max_allowed ? max_allowed : count;
>
> If only we had MIN()... ;-)

Done, thanks :-).

> > +     /* Cleanup. */
> > +     vmcs_write(ENT_MSR_LD_CNT, 0);
> > +     vmcs_write(EXI_MSR_LD_CNT, 0);
> > +     vmcs_write(EXI_MSR_ST_CNT, 0);
> > +     for (i = 0; i < cleanup_count; i++) {
> > +             enter_guest();
> > +             skip_exit_vmcall();
> > +     }
>
> I'm missing something, why do we need to reenter the guest after setting
> the count to 0?

It's for the failure code path, which fails to get into the guest and
skip the single vmcall(). I've refactored the code to make this clear.
Let me know what you think.
