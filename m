Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0822D1D18E6
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 17:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgEMPOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 11:14:40 -0400
Received: from foss.arm.com ([217.140.110.172]:48996 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729039AbgEMPOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 11:14:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4E7231B;
        Wed, 13 May 2020 08:14:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1CFF3F305;
        Wed, 13 May 2020 08:14:38 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 00/30] Add reassignable BARs and PCIE 1.1
 support
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <a395e1f397699053840e58207918866b@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1f0fb8bc-664d-4f6c-9aa6-2c74c90c9c24@arm.com>
Date:   Wed, 13 May 2020 16:15:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a395e1f397699053840e58207918866b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/13/20 3:56 PM, Marc Zyngier wrote:
> Hi all,
>
> On 2020-01-23 13:47, Alexandru Elisei wrote:
>> kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
>> it from trying to reassign the BARs. Let's make the BARs reassignable so
>> we can get rid of this band-aid.
>
> Is there anything holding up this series? I'd really like to see it
> merged in mainline kvmtool, as the EDK2 port seem to have surfaced
> (and there are environments where running QEMU is just overkill).
>
> It'd be good if it could be rebased and reposted.

Thank you for the interest, v3 is already out there, by the way, and the first 18
patches are already merged.

I finished working on v4 and I was just getting ready to run the finally battery
of tests. If I don't discover any bugs (fingers crossed!), I'll send v4 tomorrow.

Thanks,
Alex
