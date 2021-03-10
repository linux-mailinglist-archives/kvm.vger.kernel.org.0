Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E5733418B
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 16:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhCJPag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 10:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232408AbhCJPae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 10:30:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA67964F95;
        Wed, 10 Mar 2021 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615390234;
        bh=bLPrYJC1BcpB13zDjdG1OkrEvZsw6ZD+RF8inzAoyb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rS8nxjbC7V0QP/QlY8hu9UamkqcjcKZOGcI+RsvFq4L2b4qyKIKKJcxnLlNcK6Gko
         5dmG9WbzRb02cpPpTZ2uedXsKUb05mmuGEctHq8yBU8f1mKBziEgeIJ6yEPGk48OGz
         dxGh1qNy+on5/Og3UmM9cw3HPmU8xk1OfbZciEEn3XJRnySKSkaED2UFp8U4Ig+JHM
         7FYrxP1GcFm9MKimBYFTEx4ny7DxCXbjdn+CaBqQpJKvtdWIAx5vMVQopPmFepNawX
         mdvEYGD2Toy8bC19dhfF0w2Y3eSUaWE9vINBAafpTzDxdluVJhtgAYLTs3ct/J4Uuq
         T81Lv7/KORdwQ==
Date:   Wed, 10 Mar 2021 17:30:09 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <YEjmARc/e/TQoGAg@kernel.org>
References: <20210301100037.GA6699@zn.tnic>
 <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
 <20210301103043.GB6699@zn.tnic>
 <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
 <20210301105346.GC6699@zn.tnic>
 <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
 <20210301113257.GD6699@zn.tnic>
 <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
 <op.0zmwm1ogwjvjmi@arkane-mobl1.gar.corp.intel.com>
 <22f8a4be-b0ec-dfc5-cf05-a2586ce7557c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22f8a4be-b0ec-dfc5-cf05-a2586ce7557c@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 07:58:37AM -0800, Dave Hansen wrote:
> On 3/2/21 7:48 AM, Haitao Huang wrote:
> > 
> > Hi Haitao, Jarkko,
> > 
> > Do you have more concrete use case of needing "sgx2" in /proc/cpuinfo?
> 
> Kai, please remove it from your series.  I'm not hearing any arguments
> remotely close enough to what Boris would require in order to keep it.

Agreed.

/Jarkko
