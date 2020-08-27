Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E30254564
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 14:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgH0Mwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 08:52:42 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50104 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729135AbgH0Mv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 08:51:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04392;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0U7.HW59_1598532682;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U7.HW59_1598532682)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Aug 2020 20:51:23 +0800
Subject: Re: [PATCH v6 5/5] KVM: MIPS: clean up redundant kvm_run parameters
 in assembly
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, chenhuacai@gmail.com
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-6-tianjia.zhang@linux.alibaba.com>
 <e447bb5c-8b83-dfb1-a293-f2e9e586c2ec@flygoat.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <fdc4635f-7e44-3227-ea65-db28abde42d6@linux.alibaba.com>
Date:   Thu, 27 Aug 2020 20:51:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <e447bb5c-8b83-dfb1-a293-f2e9e586c2ec@flygoat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo


Do you need any other comments on this patch?


Thanks,

Tianjia


On 7/16/20 10:10 AM, Jiaxun Yang wrote:
>
>
> ÔÚ 2020/6/23 21:14, Tianjia Zhang Ð´µÀ:
>> In the current kvm version, 'kvm_run' has been included in the 
>> 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> Reviewed-by: Huacai Chen <chenhc@lemote.com>
>
> Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>
> Can confirm it works on Loongson-3A4000.
>
> Thanks!
>
>> ---
>
