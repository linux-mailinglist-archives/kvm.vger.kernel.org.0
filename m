Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E6D73ED12
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 23:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjFZVsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 17:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjFZVsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 17:48:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D05E6F
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:48:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c0f35579901so3925673276.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687816096; x=1690408096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZVFLEwCNz6O5VSX0dKeV/2hfaxawROSg/UwuvPb7KA=;
        b=QbFhbyGMP77zQoxyBWcuFmcKZufP0/xanTgxOrKGk772Ft+Peae3q0m3lPZ3JTsLXB
         LRM6NDzCEIhuyuzhKe0bcBhs0B5kRUuvw6iZEjIj2cGCFyVSKbNY3OHbUvrG6J6kmvAM
         50OWIRgkM4yZE3M3MeNj12jwl+sVhH1ig7zTI17o91Z12gvOlfQk/VBXUo7o0JPpiXff
         /ETda+Ecl1FtH4LQrAWH53lLlfkcziNzQde8VuSGd4qbjS9RfiOY7jIjrMWJWrzkCQ+U
         Zu/PDjh2O+B7SGx31VeCXNREQ+pjgGgIkVCVSCbFiAG9B7VBaBrF24XhKXjmk8t3ZS1U
         tT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687816096; x=1690408096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZVFLEwCNz6O5VSX0dKeV/2hfaxawROSg/UwuvPb7KA=;
        b=KaYEgxImuZXiECXIhtxutVeALVsTVjj6ZyfwaKiMxCShj9S+3FPCKFS7YUkNwqbAhP
         7FT6uAo6ANorq8D+YArSdMnc5gyBpy5h+xt++5jJg9MfptQMbjW7i/s5uvjA1IfbAbbx
         noGZQ409Rljhm1MXlSrtpenXafltnDFqBqcfePH1mSzjMjz4z7zZtjuuo3NUem7d97BX
         FVNdkQLAA1ncogucYIzEuDjQcfPnH/uw1MF50ROlLUVXl1f/Mqilkll7ZLBMga+8QCd0
         pyGWTMhdvpgHDCuxnEOnV4JLev5E7l5mob2unHIKReGwdDkrvSsumotu44sZuQbMi0qq
         TNQg==
X-Gm-Message-State: AC+VfDwNsjUZFPxR7wyYJleYNZRqpDGtx7fA71u5W5V1cPOTfLgpEfOJ
        QnmyFh5vYZX7OeOXQWbaXwAUecxbFA8=
X-Google-Smtp-Source: ACHHUZ6QHacu0vmaWyfYkBFmM6ESWSZg2AruFnD5EFFU2sXqMHPOlYKXjh4rAsPaHNGFPgotAGgeI+0SkiU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d387:0:b0:bd6:9fb7:69bb with SMTP id
 e129-20020a25d387000000b00bd69fb769bbmr13450357ybf.13.1687816095794; Mon, 26
 Jun 2023 14:48:15 -0700 (PDT)
Date:   Mon, 26 Jun 2023 14:48:14 -0700
In-Reply-To: <93404a98324f1a4e93a6b6e711b209bc57c831de.camel@intel.com>
Mime-Version: 1.0
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <b659f86ac7128965e05a7a660c38734667530fc0.1687474039.git.isaku.yamahata@intel.com>
 <37b868c53c9f35e8ec051573562a4598df38d72d.camel@intel.com>
 <20230623025429.GB3436214@ls.amr.corp.intel.com> <ZJXS7tU6iukBXSuv@google.com>
 <93404a98324f1a4e93a6b6e711b209bc57c831de.camel@intel.com>
Message-ID: <ZJoHNPn/tppcJDLG@google.com>
Subject: Re: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error
 code for the KVM page fault
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "ackerleytng@google.com" <ackerleytng@google.com>,
        Bo2 Chen <chen.bo@intel.com>, Sagi Shahar <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vishal Annapurve <vannapurve@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 24, 2023, Kai Huang wrote:
> 
> > From: Sean Christopherson <seanjc@google.com>
> > Date: Fri, 23 Jun 2023 09:46:38 -0700
> > Subject: [PATCH] KVM: x86/mmu: Guard against collision with KVM-defined
> >  PFERR_IMPLICIT_ACCESS
> > 
> > Add an assertion in kvm_mmu_page_fault() to ensure the error code provided
> > by hardware doesn't conflict with KVM's software-defined IMPLICIT_ACCESS
> > flag.  In the unlikely scenario that future hardware starts using bit 48
> > for a hardware-defined flag, preserving the bit could result in KVM
> > incorrectly interpreting the unknown flag as KVM's IMPLICIT_ACCESS flag.
> > 
> > WARN so that any such conflict can be surfaced to KVM developers and
> > resolved, but otherwise ignore the bit as KVM can't possibly rely on a
> > flag it knows nothing about.
> 
> I think the fundamental problem is we mix synthetic bit(s) with the hardware
> error code together into a single 'u64'.  Given there's no guarantee from
> hardware vendors (Intel/AMD) that some bits will be always reserved for software
> use, there's no guarantee the synthetic bit(s) won't conflict with those
> hardware defined bits.
> 
> Perhaps a fundamental fix is to use a new 'u64' as parameter for software-
> defined error code passing to all relevant code paths.

Yeah, in an ideal world KVM wouldn't usurp error code bits.  But I don't know
that it's worth plumbing in an extra param to all the affected helpers.  From a
functional perspective, unless someone runs with panic_on_warn=1 in production,
or I'm missing something, the warn-and-clear approach is sufficient.  If we get
more synthetic "access" bits, then we should revisit this, but I think for now
it's ok

> But I think your fix (or detection) below should be good enough perhaps for a
> long time, and even in the future when such conflict merges, we can move the
> synthetic bit to another bit.  The only problem is probably we will need
> relevant patch(es) back-ported to stable kernels.
