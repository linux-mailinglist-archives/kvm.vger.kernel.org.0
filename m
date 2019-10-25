Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36275E509C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 17:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395563AbfJYP5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 11:57:14 -0400
Received: from foss.arm.com ([217.140.110.172]:42634 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388136AbfJYP5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 11:57:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C30B328;
        Fri, 25 Oct 2019 08:57:13 -0700 (PDT)
Received: from C02TF0J2HF1T.local (C02TF0J2HF1T.cambridge.arm.com [10.1.26.186])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78F003F71A;
        Fri, 25 Oct 2019 08:57:10 -0700 (PDT)
Date:   Fri, 25 Oct 2019 16:57:08 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v7 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
Message-ID: <20191025155708.GB999@C02TF0J2HF1T.local>
References: <20191021152823.14882-1-steven.price@arm.com>
 <20191021152823.14882-11-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021152823.14882-11-steven.price@arm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 04:28:23PM +0100, Steven Price wrote:
> Enable paravirtualization features when running under a hypervisor
> supporting the PV_TIME_ST hypercall.
> 
> For each (v)CPU, we ask the hypervisor for the location of a shared
> page which the hypervisor will use to report stolen time to us. We set
> pv_time_ops to the stolen time function which simply reads the stolen
> value from the shared page for a VCPU. We guarantee single-copy
> atomicity using READ_ONCE which means we can also read the stolen
> time for another VCPU than the currently running one while it is
> potentially being updated by the hypervisor.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
