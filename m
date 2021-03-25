Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004CF3499F7
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 20:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhCYTIZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 15:08:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49678 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYTH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 15:07:56 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616699275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vtkjjMXc3X2xxjn4WLNIi05eZwUjk0KJeKHvjJH0OKM=;
        b=4XFXwdCPgfny2nQClwNVfiwdraGbkPGPppRfktfYETZ9Bg4J/lyP/M+pJ4dx6+IqxJWKrZ
        QYajJSfwifCa9bZ96AB+ThBHFBAcRpQDhgpk8L3AGcpsKf+BgTI76gGQDkCDcvQReh7/uk
        mm5XUU4so0eShIWemNpMIFMJ5tLKm/pNuuQJPTqcm589FyW2CBUj9R689rOjV3Lx1r35EB
        UF4sIlac1S7bWf+Z1GDn6XMhIxSkGqCkdYQYfCqncAs3jimI9fkI+G39o6+BQxONHCw+j2
        1hPmfYjTNWh0TOEfcgvM9/94Tm1F7u0WFfgDpK0wSbiz6v33q5VkM/FBNKC+sQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616699275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vtkjjMXc3X2xxjn4WLNIi05eZwUjk0KJeKHvjJH0OKM=;
        b=lyXPJZS4dqguIAr1rEeaFfjrDt/5jKGhDz2dyy3YzObmcB0hkXXkGkWcyfB03MSQRX/SpJ
        piMoKy2++H9bL7DQ==
To:     Marc Zyngier <maz@kernel.org>, Megha Dey <megha.dey@intel.com>
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: Re: [Patch V2 12/13] irqchip: Add IMS (Interrupt Message Store) driver
In-Reply-To: <87zgyrqgbm.wl-maz@kernel.org>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com> <1614370277-23235-13-git-send-email-megha.dey@intel.com> <87zgyrqgbm.wl-maz@kernel.org>
Date:   Thu, 25 Mar 2021 20:07:54 +0100
Message-ID: <87eeg3vyph.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25 2021 at 17:43, Marc Zyngier wrote:
> On Fri, 26 Feb 2021 20:11:16 +0000,
> Megha Dey <megha.dey@intel.com> wrote:
>> +
>> +#include <linux/irqchip/irq-ims-msi.h>
>> +
>> +#ifdef CONFIG_IMS_MSI_ARRAY
>
> Given that this covers the whole driver, what is this #defined used
> for? You might as well make the driver depend on this config option.

That's a leftover from the initial version I wrote which had also
support for IMS_MSI_QUEUE to store the message in queue memory, but we
have no use case yet for it.

But yes, as things stand now it does not make any sense and IIRC at the
end they do not share anything in the C file except for some includes at
the very end.

Thanks,

        tglx


