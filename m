Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC483B733A
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhF2NfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:35:13 -0400
Received: from foss.arm.com ([217.140.110.172]:51240 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233957AbhF2NfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Jun 2021 09:35:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31C94106F;
        Tue, 29 Jun 2021 06:32:45 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72F043F718;
        Tue, 29 Jun 2021 06:32:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
 <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <d28b8ee3-6957-a987-10da-727110343b8e@arm.com>
Date:   Tue, 29 Jun 2021 16:32:36 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

On 14/04/2021 11:42, Andrew Jones wrote:
> On Tue, Apr 13, 2021 at 05:52:37PM +0100, Nikos Nikoleris wrote:
>> On 24/03/2021 17:13, Nikos Nikoleris wrote:
>>> This set of patches makes small changes to the build system to allow
>>> easy integration of tests not included in the repository. To this end,
>>> it adds a parameter to the configuration script `--ext-dir=DIR` which
>>> will instruct the build system to include the Makefile in
>>> DIR/Makefile. The external Makefile can then add extra tests,
>>> link object files and modify/extend flags.
>>>
>>> In addition, to demonstrate how we can use this functionality, a
>>> README file explains how to use litmus7 to generate the C code for
>>> litmus tests and link with kvm-unit-tests to produce flat files.
>>>
>>> Note that currently, litmus7 produces its own independent Makefile as
>>> an intermediate step. Once this set of changes is committed, litmus7
>>> will be modifed to make use hook to specify external tests and
>>> leverage the build system to build the external tests
>>> (https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).
>>>
>>
>> Just wanted to add that if anyone's interested in trying out this series
>> with litmus7 I am very happy to help. Any feedback on this series or the way
>> we use kvm-unit-tests would be very welcome!
> 
> Hi Nikos,
> 
> It's on my TODO to play with this. I just haven't had a chance yet. I'm
> particularly slow right now because I'm in the process of handling a
> switch of my email server from one type to another, requiring rewrites
> of filters, new mail synchronization methods, and, in general, lots of
> pain... Hopefully by the end of this week all will be done. Then, I can
> start ignoring emails on purpose again, instead of due to the fact that
> I can't find them :-)
> 
> Thanks,
> drew
> 

Just wanted to revive the discussion on this. In particular there are 
two fairly small changes to the build system that allow us to add 
external tests (in our case, generated using litmus7) to the list of 
tests we build. This is specific to arm builds but I am happy to look 
into generalizing it to include all archs.

Thanks,

Nikos


>>
>> Thanks,
>>
>> Nikos
>>
>>> Nikos Nikoleris (3):
>>>     arm/arm64: Avoid wildcard in the arm_clean recipe of the Makefile
>>>     arm/arm64: Add a way to specify an external directory with tests
>>>     README: Add a guide of how to run tests with litmus7
>>>
>>>    configure           |   7 +++
>>>    arm/Makefile.common |  11 +++-
>>>    README.litmus7.md   | 125 ++++++++++++++++++++++++++++++++++++++++++++
>>>    3 files changed, 141 insertions(+), 2 deletions(-)
>>>    create mode 100644 README.litmus7.md
>>>
>>
> 
