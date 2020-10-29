Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BD529E697
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 09:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgJ2ImV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 04:42:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7096 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgJ2ImR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 04:42:17 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CMFW34pjhzLr1d;
        Thu, 29 Oct 2020 14:13:35 +0800 (CST)
Received: from [10.174.187.138] (10.174.187.138) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 29 Oct 2020 14:13:24 +0800
Message-ID: <5F9A5D84.6000707@huawei.com>
Date:   Thu, 29 Oct 2020 14:13:24 +0800
From:   AlexChen <alex.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <chenhc@lemote.com>, <pasic@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <mtosatti@redhat.com>,
        <cohuck@redhat.com>, <zhengchuan@huawei.com>,
        <qemu-s390x@nongnu.org>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <zhang.zhanghailiang@huawei.com>
Subject: Re: [PATCH 0/4] kvm: Add a --enable-debug-kvm option to configure
References: <5F97FD61.4060804@huawei.com> <5F991998.2020108@huawei.com> <404f58a5-180d-f3d7-dbcc-b533a29e6a94@redhat.com>
In-Reply-To: <404f58a5-180d-f3d7-dbcc-b533a29e6a94@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/10/28 15:44, Paolo Bonzini wrote:
> On 28/10/20 08:11, AlexChen wrote:
>> The current 'DEBUG_KVM' macro is defined in many files, and turning on
>> the debug switch requires code modification, which is very inconvenient,
>> so this series add an option to configure to support the definition of
>> the 'DEBUG_KVM' macro.
>> In addition, patches 3 and 4 also make printf always compile in debug output
>> which will prevent bitrot of the format strings by referring to the
>> commit(08564ecd: s390x/kvm: make printf always compile in debug output).
> 
> Mostly we should use tracepoints, but the usefulness of these printf
> statements is often limited (except for s390 that maybe could make them
> unconditional error_reports).  I would leave this as is, maintainers can
> decide which tracepoints they like to have.
> 
Thanks for your review, I agree with you to leave 'DEBUG_KVM' as is.
In addition, patches 3 and 4 resolved the potential risk of bitrot of the format strings,
could you help review these two patches?

Thanks,
Alex
