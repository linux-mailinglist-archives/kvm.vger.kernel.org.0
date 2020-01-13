Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91181138F1E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 11:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgAMKb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 05:31:26 -0500
Received: from foss.arm.com ([217.140.110.172]:37300 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgAMKb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 05:31:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DFF713D5;
        Mon, 13 Jan 2020 02:31:25 -0800 (PST)
Received: from arm.com (e112269-lin.cambridge.arm.com [10.1.194.52])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 571363F534;
        Mon, 13 Jan 2020 02:31:23 -0800 (PST)
Date:   Mon, 13 Jan 2020 10:31:18 +0000
From:   Steven Price <steven.price@arm.com>
To:     yezengruan <yezengruan@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "maz@kernel.org" <maz@kernel.org>,
        James Morse <James.Morse@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH v2 3/6] KVM: arm64: Support pvlock preempted via shared
 structure
Message-ID: <20200113103117.GA44375@arm.com>
References: <20191226135833.1052-1-yezengruan@huawei.com>
 <20191226135833.1052-4-yezengruan@huawei.com>
 <468e2bb4-8986-5e1e-8c4a-31aa56a9ae4f@arm.com>
 <c479977c-3824-4b53-ef46-300d59ac35de@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c479977c-3824-4b53-ef46-300d59ac35de@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 11, 2020 at 07:30:42AM +0000, yezengruan wrote:
> Hi Steve,
> 
> On 2020/1/9 23:02, Steven Price wrote:
> > On 26/12/2019 13:58, Zengruan Ye wrote:
> >> Implement the service call for configuring a shared structure between a
> >> VCPU and the hypervisor in which the hypervisor can tell the VCPU is
> >> running or not.
> >>
> >> The preempted field is zero if 1) some old KVM deos not support this filed.
> > 
> > NIT: s/deos/does/
> 
> Thanks for posting this.
> 
> > 
> > However, I would hope that the service call will fail if it's an old KVM not simply return zero.
> 
> Sorry, I'm not sure what you mean. The service call will fail if it's an old KVM, and the Guest will use __native_vcpu_is_preempted.

You previously said the "field is zero if [...] some old KVM does not
support this field". This seems a bit of an odd statement, because the
field just doesn't exist (it's an old KVM so won't have allocated it),
and if the guest attempts to find the field using the service call then
the call will fail.

So I'm not sure in what situation you are expecting the field to be zero
on an old KVM.

Steve
