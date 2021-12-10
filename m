Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB10470F15
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 00:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhLJX6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 18:58:24 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52020 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbhLJX6X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 18:58:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V-CCmdI_1639180485;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V-CCmdI_1639180485)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 11 Dec 2021 07:54:46 +0800
Message-ID: <b66710af-4f52-4097-9cba-27703c49f784@linux.alibaba.com>
Date:   Sat, 11 Dec 2021 07:54:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: VM_BUG_ON in vmx_prepare_switch_to_guest->__get_current_cr3_fast
 at kvm/queue
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
References: <YbOVBDCcpuwtXD/7@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <YbOVBDCcpuwtXD/7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/11 01:57, David Matlack wrote:
> While testing some patches I ran into a VM_BUG_ON that I have been able to
> reproduce at kvm/queue commit 45af1bb99b72 ("KVM: VMX: Clean up PI
> pre/post-block WARNs").
> 
> To repro run the kvm-unit-tests on a kernel built from kvm/queue with
> CONFIG_DEBUG_VM=y. I was testing on an Intel Cascade Lake host and have not
> tested in any other environments yet. The repro is not 100% reliable, although
> it's fairly easy to trigger and always during a vmx* kvm-unit-tests
> 
> Given the details of the crash, commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3
> in vmx_prepare_switch_to_guest()") and surrounding commits look most suspect.

Hello, is it producible if this commit is reverted?

Which test in kvm-unit-tests can trigger it?
