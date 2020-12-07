Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2F42D1AB9
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgLGUmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgLGUmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 15:42:46 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C5FC061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 12:42:05 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c79so11354499pfc.2
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 12:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CH8YCzhb8HI7GBPHk9uPWdpCDz/yeRpmZct4IBChnGg=;
        b=INO5DAYmf8kU6q7ciFzTXnbrg8EDg6/9S1FUKBhoWy1nhBNtbNIzi460u9jYxCVXrS
         Y13KL66BKD//SCrnvGOE65/CnrI7nyehabbSB4V9frlRqlK7v8Pqe/Rr2CkTUr/iUbPN
         HLj15A9VGpPv3UiG8B3tIOvTdf2GyuEbcfu3GND7Ooaag/rLr4fboKCs9kVP1V1nvhv+
         9LlGNncJnfi0tuZo6ZAmv9is5VXRVjlSKQjKPBkoC5obeYR8zQjDmpT0UC5kCZLXComY
         NT7UjeSi1IW0sVdgegcvnHQZ+2XRZPol4tCwS8QDakqqxcgbHFd+GbCza6b7VOA69mZH
         oSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CH8YCzhb8HI7GBPHk9uPWdpCDz/yeRpmZct4IBChnGg=;
        b=ccZ2L58/ImS3+7DBNZZoFU9cHk6PZq9fYBjVePP62dX2GIE+idzrI9uMwoWM2Fia7w
         hytqyxPugU0bCrMxo7jnziOmBUljwQBv0LB5miQjaU/dAS9CIWDy+h5Sw+4wtxPL5DN9
         ryBG+sPC3vhM0DyK5hnNbAU92INRvh9XlBhW8Z6iI/o4YWwUFyeMqPqqRRA+J3EuECpH
         KKy1vPa1MJY4OOeGjCCrspklJD6/H+wb5RisGwIm4qnCKsfo6fkfeDA66htX3TDc7KSg
         OHcqRvOuXT2kBZyJISTW6PRx1dQ9hX5sdNn5X2KgPr7Hnlz62Yty5PCIQMIayFJMLHMB
         xTCw==
X-Gm-Message-State: AOAM532gdfgLhlt2RDIkOvDHyW7nYRy4vSJ3eRDXvipbeksol36VHd8t
        1EfpYi54LE8ZnDXRw8lkbb+x5g==
X-Google-Smtp-Source: ABdhPJxKnvYSQUDE2dtTbW4EIlJgai5ChGkpNkdcQ1jvxCZKFuMEspMLKN57sXKhzppEB0rLjEUYug==
X-Received: by 2002:a17:90a:193:: with SMTP id 19mr187238pjc.45.1607373725342;
        Mon, 07 Dec 2020 12:42:05 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id x18sm3663814pfr.158.2020.12.07.12.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 12:42:04 -0800 (PST)
Date:   Mon, 7 Dec 2020 12:41:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v2 1/9] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <X86Tlin14Ct38zDt@google.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
 <b6bc54ed6c8ae4444f3acf1ed4386010783ad386.1606782580.git.ashish.kalra@amd.com>
 <X8gyhCsEMf8QU9H/@google.com>
 <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d63529ce-d613-9f83-6cfc-012a8b333e38@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 06, 2020, Paolo Bonzini wrote:
> On 03/12/20 01:34, Sean Christopherson wrote:
> > On Tue, Dec 01, 2020, Ashish Kalra wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > 
> > > KVM hypercall framework relies on alternative framework to patch the
> > > VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> > > apply_alternative() is called then it defaults to VMCALL. The approach
> > > works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> > > will be able to decode the instruction and do the right things. But
> > > when SEV is active, guest memory is encrypted with guest key and
> > > hypervisor will not be able to decode the instruction bytes.
> > > 
> > > Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> > > will be used by the SEV guest to notify encrypted pages to the hypervisor.
> > 
> > What if we invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> > and opt into VMCALL?  It's a synthetic feature flag either way, and I don't
> > think there are any existing KVM hypercalls that happen before alternatives are
> > patched, i.e. it'll be a nop for sane kernel builds.
> > 
> > I'm also skeptical that a KVM specific hypercall is the right approach for the
> > encryption behavior, but I'll take that up in the patches later in the series.
> 
> Do you think that it's the guest that should "donate" memory for the bitmap
> instead?

No.  Two things I'd like to explore:

  1. Making the hypercall to announce/request private vs. shared common across
     hypervisors (KVM, Hyper-V, VMware, etc...) and technologies (SEV-* and TDX).
     I'm concerned that we'll end up with multiple hypercalls that do more or
     less the same thing, e.g. KVM+SEV, Hyper-V+SEV, TDX, etc...  Maybe it's a
     pipe dream, but I'd like to at least explore options before shoving in KVM-
     only hypercalls.

  2. Tracking shared memory via a list of ranges instead of a using bitmap to
     track all of guest memory.  For most use cases, the vast majority of guest
     memory will be private, most ranges will be 2mb+, and conversions between
     private and shared will be uncommon events, i.e. the overhead to walk and
     split/merge list entries is hopefully not a big concern.  I suspect a list
     would consume far less memory, hopefully without impacting performance.
