Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E56B4EEB
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfIQNOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 09:14:23 -0400
Received: from foss.arm.com ([217.140.110.172]:55752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfIQNOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 09:14:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6957F28;
        Tue, 17 Sep 2019 06:14:22 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6A843F575;
        Tue, 17 Sep 2019 06:14:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Move the GICv4 residency flow to be
 driven by vcpu_load/put
To:     Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <Andre.Przywara@arm.com>
References: <20190903155747.219802-1-maz@kernel.org>
 <5ab75fec-6014-e3b4-92a3-63d5015814c1@huawei.com>
 <07ddb304-9a7a-64a3-386a-96eea4516346@kernel.org>
 <dcc5a10b-c9ca-f833-4a60-e5d3726fa0b9@huawei.com>
 <3b2d4a15-5658-f50f-0214-1da708cd4923@huawei.com>
From:   Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <c068036a-e9e2-0cb1-d1b5-9cf6d53e963f@kernel.org>
Date:   Tue, 17 Sep 2019 14:14:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3b2d4a15-5658-f50f-0214-1da708cd4923@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/2019 11:17, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2019/9/17 17:31, Zenghui Yu wrote:
>>
>> But this time I got the following WARNING:
> 
> Please ignore it. I think this is mostly caused by my local buggy
> patch... Sorry for the noise.

Right. I couldn't quite figure out how this could happen with the
current state of the code...

	M.
-- 
Jazz is not dead, it just smells funny...
