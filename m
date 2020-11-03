Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE5D2A4C88
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 18:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgKCRRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 12:17:45 -0500
Received: from foss.arm.com ([217.140.110.172]:52514 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbgKCRRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 12:17:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 027C1106F;
        Tue,  3 Nov 2020 09:17:40 -0800 (PST)
Received: from C02W217MHV2R.local (unknown [10.57.19.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D6C33F718;
        Tue,  3 Nov 2020 09:17:38 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 0/2] arm: MMU extentions to enable litmus7
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
 <20201103170927.a4lxfu66ot2ez2kv@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <af57b60c-a7fd-7598-d054-5da162fd776d@arm.com>
Date:   Tue, 3 Nov 2020 17:17:37 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103170927.a4lxfu66ot2ez2kv@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2020 17:09, Andrew Jones wrote:
> On Mon, Nov 02, 2020 at 11:53:09AM +0000, Nikos Nikoleris wrote:
>> Hi all,
>>
>> litmus7 [1][2], a tool that we develop and use to test the memory
>> model on hardware, is building on kvm-unit-tests to encapsulate full
>> system tests and control address translation. This series extends the
>> kvm-unit-tests arm MMU API and adds two memory attributes to MAIR_EL1
>> to make them available to the litmus tests.
>>
>> [1]: http://diy.inria.fr/doc/litmus.html
>> [2]: https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/expanding-memory-model-tools-system-level-architecture
> 
> Hi Nikos,
> 
> I'm glad to see this application of kvm-unit-tests. It'd be nice to
> extract some of the overview and howto from the blog [2] into a
> markdown file that we can add to the kvm-unit-tests repository.
> 

Hi Drew,

Thanks for the reviews!

Very happy to do that I will work with Jade and Luc to write a howto and
will post a patch soon.

Thanks,

Nikos

> Thanks,
> drew
> 
