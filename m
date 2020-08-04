Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDA923BA2D
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 14:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgHDMW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 08:22:27 -0400
Received: from foss.arm.com ([217.140.110.172]:43332 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgHDMW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 08:22:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B161F30E;
        Tue,  4 Aug 2020 05:14:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C65BF3F71F;
        Tue,  4 Aug 2020 05:14:30 -0700 (PDT)
Subject: Re: [PATCH kvmtool] virtio: Fix ordering of
 virt_queue__should_signal()
To:     Milan Kocian <milon@wq.cz>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        will@kernel.org, jean-philippe@linaro.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
References: <20200731101427.16284-1-alexandru.elisei@arm.com>
 <20200731220547.GD7810@msc.wq.cz>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b744ab38-dc28-683c-9e73-bf413210209e@arm.com>
Date:   Tue, 4 Aug 2020 13:15:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731220547.GD7810@msc.wq.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Milan,

On 7/31/20 11:05 PM, Milan Kocian wrote:
> Hello,
>  
>> I *think* this also fixes the VM hang reported in [1], where several
>> processes in the guest were stuck in uninterruptible sleep. I am not
>> familiar with the block layer, but my theory is that the threads were stuck
>> in wait_for_completion_io(), from blk_execute_rq() executing a flush
>> request. It would be great if Milan could give this patch a spin and see if
>> the problem goes away. Don't know how reproducible it is though.
>>
>> [1] https://www.spinics.net/lists/kvm/msg204543.html
>>
> Okay, I will test it but it takes some time. Because I migrated to the
> qemu due this problem :-) so I need to prepare new environment. And
> because the problem happens randomly. My environment can run days/few weeks
> without this problem.

Thank you for giving this a go, much appreciated!

It's unfortunate that you had to stop using kvmtool because of the bug, hopefully
this patch fixes it.

Thanks,
Alex
