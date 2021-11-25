Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704F045E159
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 21:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356990AbhKYUMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 15:12:36 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54398 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbhKYUKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 15:10:35 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637870842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fM8fZEPgI+ZaVrV7U42fERlATFFsfVVZK24pZYDog/Y=;
        b=kQI8Xp1PScLcBFD7dIVEvx+V4SvEBbveVfL5BwmpAq7KJ1JcxdClFitDPiIuqJ5FPDzTvw
        5P0cjk7JUiTJOorK+KBrA0LBLWhG6LFJ5DsHtb7LM3Wko/jZqMXyIHfZM7dbPHSP68PAyU
        kyIOt/jKPO0WmdCpTOBAcbIJcjdxEsmkDkBbvst6yrDg4p7DK0urdJqWQKGcrOhiKMJ2ad
        fS+7KNoHjop6KoM1zwJoOHTh4s5zIrtDJfSoDICjOJSDX0eHCCA5INiTv0+jGh9AmbdvGE
        V3gWjXLZzCkiWSHNsZyad5wffW1dQwumYqmM3NAkNubiMfCh4qTKK6yAESB2JA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637870842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fM8fZEPgI+ZaVrV7U42fERlATFFsfVVZK24pZYDog/Y=;
        b=v7gJ6SNgCrDYIsAV9YtIH1AncLj71MlWAxPhgUzx6bhM4h1H6Ph39xK6/ml09Nr6mr+dbz
        HoqbEIRe3dJZmqDQ==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 41/59] KVM: VMX: Split out guts of EPT violation
 to common/exposed function
In-Reply-To: <8ddf2b32dd94e97921a94faac11ae9cd99a6dfb5.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <8ddf2b32dd94e97921a94faac11ae9cd99a6dfb5.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 21:07:21 +0100
Message-ID: <87sfvkhudi.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>

Moar why?
