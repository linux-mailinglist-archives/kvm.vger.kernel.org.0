Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200A2240837
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 17:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgHJPNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 11:13:44 -0400
Received: from foss.arm.com ([217.140.110.172]:57026 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgHJPNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 11:13:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E82021063;
        Mon, 10 Aug 2020 08:13:42 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F252C3F575;
        Mon, 10 Aug 2020 08:13:41 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool] virtio: Fix ordering of
 virtio_queue__should_signal()
To:     Milan Kocian <milon@wq.cz>
Cc:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        will@kernel.org, jean-philippe@linaro.org, andre.przywara@arm.com,
        Anvay Virkar <anvay.virkar@arm.com>
References: <20200804145317.51633-1-alexandru.elisei@arm.com>
 <20200805075327.GJ7810@msc.wq.cz>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <de921a64-ad78-87f3-6dc7-5e28dae0e21b@arm.com>
Date:   Mon, 10 Aug 2020 16:14:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805075327.GJ7810@msc.wq.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Milan,

On 8/5/20 8:53 AM, Milan Kocian wrote:
> Hello,
>
>> I *think* this also fixes the VM hang reported in [2], where several
>> processes in the guest were stuck in uninterruptible sleep. I am not
>> familiar with the block layer, but my theory is that the threads were stuck
>> in wait_for_completion_io(), from blk_execute_rq() executing a flush
>> request. Milan has agreed to give this patch a spin [3], but that might
>> take a while because the bug is not easily reproducible. I believe the
>> patch can be merged on its own.
>>
>> [1] http://diy.inria.fr/www/index.html?record=aarch64&cat=aarch64-v04&litmus=SB%2Bdmb.sys&cfg=new-web
>> [2] https://www.spinics.net/lists/kvm/msg204543.html
>> [3] https://www.spinics.net/lists/kvm/msg222201.html
>>
> Unfortunately it didn't help. I can see the problem again now.

Thank you for giving this a go. Unfortunately this means there's another bug
lurking in kvmtool. I'll put this on my todo list and I'll try to figure something
out when I have some spare time.

Thanks,
Alex
