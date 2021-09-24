Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B1A4177F9
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347170AbhIXPmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 11:42:46 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:28460 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347139AbhIXPmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 11:42:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpRpLVz_1632498059;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UpRpLVz_1632498059)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Sep 2021 23:41:00 +0800
Subject: Re: [PATCH V2 03/10] KVM: Remove tlbs_dirty
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org
References: <20210918005636.3675-1-jiangshanlai@gmail.com>
 <20210918005636.3675-4-jiangshanlai@gmail.com>
 <8dfdae11-7c51-530d-5c0d-83f778fa1e14@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <8833ef9b-3156-7272-4171-66c4749145ab@linux.alibaba.com>
Date:   Fri, 24 Sep 2021 23:40:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8dfdae11-7c51-530d-5c0d-83f778fa1e14@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/9/23 23:23, Paolo Bonzini wrote:
> On 18/09/21 02:56, Lai Jiangshan wrote:

> 
> Queued up to here for 5.15, thanks!
> 
> Paolo

Any comments on other commits?

Thanks
Lai
