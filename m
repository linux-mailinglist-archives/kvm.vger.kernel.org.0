Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7287135E45F
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346933AbhDMQxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 12:53:00 -0400
Received: from foss.arm.com ([217.140.110.172]:45028 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346928AbhDMQw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 12:52:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97E0E11B3;
        Tue, 13 Apr 2021 09:52:39 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A38123F73B;
        Tue, 13 Apr 2021 09:52:38 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
Date:   Tue, 13 Apr 2021 17:52:37 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210324171402.371744-1-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/2021 17:13, Nikos Nikoleris wrote:
> This set of patches makes small changes to the build system to allow
> easy integration of tests not included in the repository. To this end,
> it adds a parameter to the configuration script `--ext-dir=DIR` which
> will instruct the build system to include the Makefile in
> DIR/Makefile. The external Makefile can then add extra tests,
> link object files and modify/extend flags.
> 
> In addition, to demonstrate how we can use this functionality, a
> README file explains how to use litmus7 to generate the C code for
> litmus tests and link with kvm-unit-tests to produce flat files.
> 
> Note that currently, litmus7 produces its own independent Makefile as
> an intermediate step. Once this set of changes is committed, litmus7
> will be modifed to make use hook to specify external tests and
> leverage the build system to build the external tests
> (https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).
> 

Just wanted to add that if anyone's interested in trying out this series 
with litmus7 I am very happy to help. Any feedback on this series or the 
way we use kvm-unit-tests would be very welcome!

Thanks,

Nikos

> Nikos Nikoleris (3):
>    arm/arm64: Avoid wildcard in the arm_clean recipe of the Makefile
>    arm/arm64: Add a way to specify an external directory with tests
>    README: Add a guide of how to run tests with litmus7
> 
>   configure           |   7 +++
>   arm/Makefile.common |  11 +++-
>   README.litmus7.md   | 125 ++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 141 insertions(+), 2 deletions(-)
>   create mode 100644 README.litmus7.md
> 
