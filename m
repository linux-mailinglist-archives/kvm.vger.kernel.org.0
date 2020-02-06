Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F018154377
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 12:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgBFLth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 06:49:37 -0500
Received: from foss.arm.com ([217.140.110.172]:57570 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgBFLth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 06:49:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D6F230E;
        Thu,  6 Feb 2020 03:49:36 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05CE23F68E;
        Thu,  6 Feb 2020 03:49:33 -0800 (PST)
Subject: Re: [PATCH kvmtool 07/16] arm: Remove redundant define
 ARM_PCI_CFG_SIZE
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, julien.grall@arm.com, andre.przywara@arm.com
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <1569245722-23375-8-git-send-email-alexandru.elisei@arm.com>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <b6fbd2c6-8b23-f89e-c020-6b58608c6fea@arm.com>
Date:   Thu, 6 Feb 2020 11:49:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1569245722-23375-8-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 14:35, Alexandru Elisei wrote:
> ARM_PCI_CFG_SIZE has the same value as PCI_CFG_SIZE. The pci driver uses
> PCI_CFG_SIZE and arm uses ARM_PCI_CFG_SIZE when generating the pci DT node.
> Having two defines with the same value is confusing, and can lead to bugs
> if one define is changed and the other isn't. So replace all instances of
> ARM_PCI_CFG_SIZE with PCI_CFG_SIZE.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
