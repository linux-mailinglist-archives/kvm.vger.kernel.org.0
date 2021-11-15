Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE97450A80
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 18:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhKORKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 12:10:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhKORJ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 12:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636995983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RzHfOtlOwL/xRZgmhHoEsdUmvHa8Hhdv3GzxS4wRJOw=;
        b=Z6iDim6FyOkS4/aOxhoHEICq39er4tLGVotnByhl9uzrQIjEDwtk1voW3lFDNw7D4gR9+U
        Vsu5BHVQXFzYA2EKw0czOXiGnBAwV5WO7Tu8qI0qCtH1QqBKuS+NE0EWcKIPxnuJlKAnff
        Ovt3W3EOzVdx2imvaXnOPo+Dd4YTztY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-sUFKmz8COQy55XjLkSNE8Q-1; Mon, 15 Nov 2021 12:06:20 -0500
X-MC-Unique: sUFKmz8COQy55XjLkSNE8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ABEF1572D;
        Mon, 15 Nov 2021 17:06:18 +0000 (UTC)
Received: from [10.39.195.133] (unknown [10.39.195.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7717100164A;
        Mon, 15 Nov 2021 17:06:09 +0000 (UTC)
Message-ID: <ab419d8b-3e5d-2879-274c-ee609254890c@redhat.com>
Date:   Mon, 15 Nov 2021 18:06:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Vihas Mak <makvihas@gmail.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211114164312.GA28736@makvihas>
 <YZJH0Hd/ETYWJGTX@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZJH0Hd/ETYWJGTX@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 12:43, Peter Zijlstra wrote:
> On Sun, Nov 14, 2021 at 10:13:12PM +0530, Vihas Mak wrote:
>> change 0 to false and 1 to true to fix following cocci warnings:
>>
>>          arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
>>          arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool
> 
> That script should be deleted, it's absolute garbage.
> 

Only a Sith deals in absolutes.

Paolo

