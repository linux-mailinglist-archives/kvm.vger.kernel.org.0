Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1583B32B574
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356190AbhCCHRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240809AbhCBSGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:06:15 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C49C061225;
        Tue,  2 Mar 2021 09:54:06 -0800 (PST)
Received: from [10.130.51.25] (dynamic-046-114-035-025.46.114.pool.telefonica.de [46.114.35.25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DB4B31EC0419;
        Tue,  2 Mar 2021 18:54:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614707643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++1uon9cBlN0dbDj/X3dayJGsnXBiQOjWiDUluqfe1s=;
        b=eaceNnuTckvTP/ytCLvr+V/BqQ3H2lReO0SJtAepSie1LmVP0o8yF4yXQWitRnk/HgKeoc
        mLAnU/4x3F6C417wjIcyqpFar2UnKVjBmWApmGZrlPAFii4klieqi3WIj9zSKHq2xGWSRf
        7H8qjwvmvZ4IiO3oqf+rZc1eP471q6k=
Date:   Tue, 02 Mar 2021 18:53:59 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <YD5hhah9Sgj1YGqw@google.com>
References: <cover.1614590788.git.kai.huang@intel.com> <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com> <20210301100037.GA6699@zn.tnic> <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com> <20210301103043.GB6699@zn.tnic> <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com> <20210301105346.GC6699@zn.tnic> <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com> <20210301113257.GD6699@zn.tnic> <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com> <YD5hhah9Sgj1YGqw@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
To:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
CC:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
From:   Boris Petkov <bp@alien8.de>
Message-ID: <9971018C-8250-4E51-9EF9-72ED6CBD2E47@alien8.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On March 2, 2021 5:02:13 PM GMT+01:00, Sean Christopherson <seanjc@google=
=2Ecom> wrote:
>The KVM use case is to query /proc/cpuinfo to see if sgx2 can be
>enabled in a
>guest=2E

You mean before the guest ia created? I sure hope there's a better way to =
query HV-supported features than grepping /proc/cpuinfo=2E=2E=2E

>The counter-argument to that is we might want sgx2 in /proc/cpuinfo to
>mean sgx2
>is enabled in hardware _and_ supported by the kernel=2E  Userspace can
>grep for
>sgx in /proc/cpuinfo, and use cpuid to discover sgx2, so it's not a
>blocker=2E

Question is, what exactly that flag should denote: that EDMM is supported =
in the HV and guests can do the dynamic thing of adding/rwmoving EPC pages?=
 Is that the only feature behind SGX2?

>That being said, adding some form of capability/versioning to SGX seems
>inevitable, not sure it's worth witholding sgx2 from /proc/cpuinfo=2E

See what I typed earlier - no objections from me if a proper use case is i=
dentified and written down=2E

Thx=2E
--=20
Sent from a small device: formatting sux and brevity is inevitable=2E 
