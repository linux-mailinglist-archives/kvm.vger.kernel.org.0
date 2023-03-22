Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02CD6C4734
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 11:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVKFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 06:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCVKFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 06:05:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9989A1A665
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 03:05:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 625A6AD7;
        Wed, 22 Mar 2023 03:06:22 -0700 (PDT)
Received: from [10.57.53.198] (unknown [10.57.53.198])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D95C3F67D;
        Wed, 22 Mar 2023 03:05:37 -0700 (PDT)
Message-ID: <4ef9cf26-bc5d-2b67-9a9c-249e12b749a3@arm.com>
Date:   Wed, 22 Mar 2023 10:05:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v4 04/30] lib: Apply Lindent to acpi.{c,h}
Content-Language: en-GB
To:     Andrew Jones <andrew.jones@linux.dev>,
        Shaoqin Huang <shahuang@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-5-nikos.nikoleris@arm.com>
 <5a8887b2-a276-b087-964e-fa3f98826185@redhat.com>
 <20230321173210.kojqm6owufly7upk@orel>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230321173210.kojqm6owufly7upk@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/03/2023 17:32, Andrew Jones wrote:
> On Thu, Mar 09, 2023 at 03:11:56PM +0800, Shaoqin Huang wrote:
> ...
>>> +#define ACPI_TABLE_HEADER_DEF		/* ACPI common table header */			\
>>> +	u32 signature;			/* ACPI signature (4 ASCII characters) */	\
>>> +	u32 length;			/* Length of table, in bytes, including header */ \
>>> +	u8  revision;			/* ACPI Specification minor version # */	\
>>> +	u8  checksum;			/* To make sum of entire table == 0 */		\
>>> +	u8  oem_id [6];			/* OEM identification */			\
>>                    ^
>>> +	u8  oem_table_id [8];		/* OEM table identification */			\
>>                          ^
>>> +	u32 oem_revision;		/* OEM revision number */			\
>>> +	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
>>                             ^
>> nit: These space should also be deleted.
>>
> 
> Yes, but the fixup belongs in the next patch that does manual style
> changes.
> 

Thank you both, I will address this in the next patch.

Thanks,

Nikos
