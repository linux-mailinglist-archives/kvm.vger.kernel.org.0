Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB539FCA36
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 16:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKNPrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 10:47:48 -0500
Received: from foss.arm.com ([217.140.110.172]:45320 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbfKNPrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 10:47:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3F05328;
        Thu, 14 Nov 2019 07:47:46 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9842A3F52E;
        Thu, 14 Nov 2019 07:47:45 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Vladimir Murzin <vladimir.murzin@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvmarm@lists.cs.columbia.edu,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com>
 <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
 <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
 <90cdc695-f761-26bd-d2a7-f8655ce04463@arm.com>
 <187393bb-a32d-092d-d0ea-44c58a54d1de@arm.com>
 <CAFEAcA_kcQwrnJxtCynX9+hMEvnFN0yBnim_Kn-uut5P4fshew@mail.gmail.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <241e3df3-e3e3-14a0-3fbe-5398a1bf9d00@arm.com>
Date:   Thu, 14 Nov 2019 15:47:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_kcQwrnJxtCynX9+hMEvnFN0yBnim_Kn-uut5P4fshew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/14/19 3:27 PM, Peter Maydell wrote:
> On Thu, 14 Nov 2019 at 15:21, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> TCG emulates a GIC with a single security state for me:
>>
>> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=3,accel=tcg
>> -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd
>> -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel
>> arm/gic.flat -append irq
> The virt board doesn't do EL3 by default, but if you add -machine secure=true
> to your command line then it it should emulate it, including a
> trustzone-aware GIC.
>
> thanks
> -- PMM

Indeed, and that made the test fail because apparently qemu implements it as
RAZ/WI (which is allowed by the architecture). Thank you for the suggestion!

Thanks,
Alex


