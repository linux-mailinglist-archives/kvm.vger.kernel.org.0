Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9354313C6FA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 16:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgAOPIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 10:08:43 -0500
Received: from foss.arm.com ([217.140.110.172]:38726 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbgAOPIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 10:08:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 716B031B;
        Wed, 15 Jan 2020 07:08:42 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 717783F718;
        Wed, 15 Jan 2020 07:08:41 -0800 (PST)
Subject: Re: [PATCH kvmtool 09/16] arm/pci: Do not use first PCI IO space
 bytes for devices
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        sami.mujawar@arm.com
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
 <20191125103033.22694-10-alexandru.elisei@arm.com>
 <20191202121500.GA4770@e121166-lin.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5986fb48-5df3-c106-4f25-68bb8039f695@arm.com>
Date:   Wed, 15 Jan 2020 15:08:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191202121500.GA4770@e121166-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/2/19 12:15 PM, Lorenzo Pieralisi wrote:
>> Just allocate those bytes to prevent future allocation assigning it to
>> devices.
> I do not understand what this means; if the kernel reassigns IO BARs
> within the IO window kvmtool provides (through DT host controller
> bindings - ranges property) this patch should not be needed.
>
> Furthermore I don't think there should be any dependency in kvmtool
> to the Linux PCIBIOS_MIN_IO offset (which happens to be 0x1000 but
> kvmtool must not rely on that).
>
> To sum it up: kvmtool should assign sensible IO ports default values
> to BARs (even though that's *not* mandatory) and let the OS reassign
> values according to the IO port windows provided through DT bindings
> (ie ranges property).
>
> It is likely there is something I am missing in this patch logic,
> apologies for asking but I don't think this patch should be required.

This patch was needed because we advertise the PCI node as 'linux,pci-probe-only'.
Any ioports below PCIBIOS_MIN_IO that kvmtool allocates are not accessible by a
Linux guest.

However, once we have support for reassignable BARs, you are indeed correct in
saying that this patch will no longer be needed. I'll drop it from the series.

Thanks,
Alex
>
> Thanks,
> Lorenzo
>
