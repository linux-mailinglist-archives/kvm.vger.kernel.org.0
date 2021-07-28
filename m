Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19C23D967A
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 22:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhG1US1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 16:18:27 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41988 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhG1US0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 16:18:26 -0400
Received: from [192.168.86.36] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0BFCB20B36E0;
        Wed, 28 Jul 2021 13:18:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0BFCB20B36E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1627503504;
        bh=8VjrjYQKrOT17RDifYWaDqoWrFEqj1Yk42rjWoibe7M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=G2JcZwGvwJfr6vKJZMUtIkEn/M+HVCbDXqob6BeE4lPpletGmHoCc6ZBCJnYI/VC6
         RrLSxW5xjI0bY6V52F3Rhp0zGN5kTBMc3XfuSXZg/IX1YErwEZDlefkmVdbHLu1Jeb
         S8E4GCme+oZxzUfGwyMwNCP0ZGW4aEw8nataKnpc=
Subject: Re: [PATCH] KVM: SVM: delay svm_vcpu_init_msrpm after svm->vmcb is
 initialized
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210726165843.1441132-1-pbonzini@redhat.com>
 <87zgu76ary.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <1d82501c-05fd-deff-9652-790cde052644@linux.microsoft.com>
Date:   Wed, 28 Jul 2021 16:18:21 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87zgu76ary.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/27/2021 11:23 AM, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> Right now, svm_hv_vmcb_dirty_nested_enlightenments has an incorrect
>> dereference of vmcb->control.reserved_sw before the vmcb is checked
>> for being non-NULL.  The compiler is usually sinking the dereference
>> after the check; instead of doing this ourselves in the source,
>> ensure that svm_hv_vmcb_dirty_nested_enlightenments is only called
>> with a non-NULL VMCB.
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Cc: Vineeth Pillai <viremana@linux.microsoft.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> [Untested for now due to issues with my AMD machine. - Paolo]
Finally got hold of an AMD machine and tested nested virt: windows on 
linux on
windows with the patches applied. Did basic boot and minimal verification.

Tested-by: Vineeth Pillai <viremana@linux.microsoft.com>

Thanks,
Vineeth

