Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D406C3E460D
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 15:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhHINF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 09:05:56 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45835 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235001AbhHINFv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 09:05:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=chaowu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UiVb3bx_1628514328;
Received: from B-Q154MD6P-0029.local(mailfrom:ChaoWu@linux.alibaba.com fp:SMTPD_---0UiVb3bx_1628514328)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 09 Aug 2021 21:05:28 +0800
Subject: Re: [PATCH 0/2] Fix ptp_kvm_get_time_fn infinite loop and remove
 redundant EXPORT_SYMBOL_GPL
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, gerry@linux.alibaba.com,
        zhabin@linux.alibaba.com
References: <cover.1621505277.git.chaowu@linux.alibaba.com>
From:   Chao Wu <ChaoWu@linux.alibaba.com>
Message-ID: <125d01f6-cefa-8515-5a04-333747b9b7ef@linux.alibaba.com>
Date:   Mon, 9 Aug 2021 21:05:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1621505277.git.chaowu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping

在 2021/5/25 下午4:44, Chao Wu 写道:
> We fix the infinite loop bug in ptp_kvm_get_time_fn function and removes the redundant EXPORT_SYMBOL_GPL for pvclock_get_pvti_cpu0_va.
>
> Chao Wu (2):
>    ptp_kvm: fix an infinite loop in ptp_kvm_get_time_fn when vm has more than 64 vcpus
>    pvclock: remove EXPORT_SYMBOL_GPL for pvclock_get_pvti_cpu0_va
>
>   arch/x86/include/asm/kvmclock.h | 16 ++++++++++++++++
>   arch/x86/kernel/kvmclock.c      | 12 ++----------
>   arch/x86/kernel/pvclock.c       |  1 -
>   drivers/ptp/ptp_kvm.c           |  6 ++----
>   4 files changed, 20 insertions(+), 15 deletions(-)
>
