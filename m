Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE4153758
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 19:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgBESRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 13:17:40 -0500
Received: from foss.arm.com ([217.140.110.172]:50672 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgBESRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 13:17:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A420A1FB;
        Wed,  5 Feb 2020 10:17:39 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F98E3F52E;
        Wed,  5 Feb 2020 10:17:36 -0800 (PST)
Subject: Re: [PATCH kvmtool 05/16] kvmtool: Use MB consistently
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-6-git-send-email-alexandru.elisei@arm.com>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <0ca0ae4b-80db-c728-12a2-0d35224be4a7@arm.com>
Date:   Wed, 5 Feb 2020 18:17:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1569245722-23375-6-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 14:35, Alexandru Elisei wrote:
> The help text for the -m/--mem argument states that the guest memory size
> is in MiB (mebibyte). We all know that MB (megabyte) is the same thing as
> MiB, and indeed this is how MB is used throughout kvmtool.
> 
> So replace MiB with MB, so people don't get the wrong idea and start
> believing that for kvmtool a MB is 10^6 bytes, because it isn't.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
