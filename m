Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4871637B80D
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhELIeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhELIeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:34:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A1D611CE;
        Wed, 12 May 2021 08:33:05 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lgkIh-000qqq-B4; Wed, 12 May 2021 09:33:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 12 May 2021 09:33:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        drjones@redhat.com, alexandru.elisei@arm.com
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
In-Reply-To: <4e83daa3-3166-eeed-840c-39be71b1124d@redhat.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <YJRADhU4CcTE7bdm@google.com>
 <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
 <YJuDYZbqe8V47YCJ@google.com>
 <4e83daa3-3166-eeed-840c-39be71b1124d@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-12 09:19, Auger Eric wrote:
> Hi Ricardo,
> 
> On 5/12/21 9:27 AM, Ricardo Koller wrote:
>> On Fri, May 07, 2021 at 04:08:07PM +0200, Auger Eric wrote:
>>> Hi Ricardo,
>>> 
>>> On 5/6/21 9:14 PM, Ricardo Koller wrote:
>>>> On Thu, May 06, 2021 at 02:30:17PM +0200, Auger Eric wrote:
>>>>> Hi Ricardo,
>>>>> 
>>>> 
>>>> Hi Eric,
>>>> 
>>>> Thank you very much for the test.
>>>> 
>>>>> On 5/3/21 9:12 PM, Ricardo Koller wrote:
>>>>>> On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
>>>>>>> On Sat, 01 May 2021 00:24:06 +0100,
>>>>>>> Ricardo Koller <ricarkol@google.com> wrote:
>>>>>>>> 
>>>>>>>> Add the infrastructure needed to enable exception handling in 
>>>>>>>> aarch64
>>>>>>>> selftests. The exception handling defaults to an 
>>>>>>>> unhandled-exception
>>>>>>>> handler which aborts the test, just like x86. These handlers can 
>>>>>>>> be
>>>>>>>> overridden by calling vm_install_vector_handler(vector) or
>>>>>>>> vm_install_exception_handler(vector, ec). The unhandled 
>>>>>>>> exception
>>>>>>>> reporting from the guest is done using the ucall type introduced 
>>>>>>>> in a
>>>>>>>> previous commit, UCALL_UNHANDLED.
>>>>>>>> 
>>>>>>>> The exception handling code is heavily inspired on 
>>>>>>>> kvm-unit-tests.
>>>>> 
>>>>> running the test on 5.12 I get
>>>>> 
>> 
>> Hi Eric,
>> 
>> I'm able to reproduce the failure you are seeing on 5.6, specifically
>> with kernels older than this commit:
>> 
>>   4942dc6638b0 KVM: arm64: Write arch.mdcr_el2 changes since last 
>> vcpu_load on VHE
>> 
>> but not yet on v5.12. Could you share the commit of the kernel you are
>> testing, please?
> 
> my host is a 5.12 kernel (8404c9fbc84b)

Time to compare notes then. What HW are you using? Running VHE or not?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
