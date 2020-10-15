Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1675628F67E
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbgJOQOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 12:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389469AbgJOQOL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 12:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602778450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xiF1tjvPpBQLAR/j0ihoe0nvfGob42s8DfEcgYbq1E=;
        b=YONoZYyKp/dl5se/LUPdcv0wa9zdL0wPmDRSds5igadB9OQYDlQzzimFbKbeay5GAbN9Ww
        bQx6+nusDi0Ny5qcFkxFc1qlxbpYFJ96LCI4dWWXjNtONpDY0tiyX75fEDxXUWBdOLVJsN
        RPG0MyB0kArEpKFPR8IBpoI4CJHX6sc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-RgIOqphDPhe3Cgwp9pk2EQ-1; Thu, 15 Oct 2020 12:14:08 -0400
X-MC-Unique: RgIOqphDPhe3Cgwp9pk2EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 024508015F7;
        Thu, 15 Oct 2020 16:14:07 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-184.ams2.redhat.com [10.36.113.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1B605C22D;
        Thu, 15 Oct 2020 16:14:02 +0000 (UTC)
Subject: Re: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com
References: <20201014192710.66578-1-walling@linux.ibm.com>
 <dc00c982-8d36-3df4-f896-ebe197b97274@redhat.com>
 <99917e28-7c77-c7c3-5641-c711b107cf70@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c0db7f04-3511-8b55-9551-1da3befd04a3@redhat.com>
Date:   Thu, 15 Oct 2020 18:14:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <99917e28-7c77-c7c3-5641-c711b107cf70@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/2020 17.26, Collin Walling wrote:
> On 10/15/20 3:55 AM, Thomas Huth wrote:
[...]
>>> @@ -206,6 +210,7 @@ static void test_normal(void)
>>>  	/* Create VM */
>>>  	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
>>>  	run = vcpu_state(vm, VCPU_ID);
>>> +	run->s.regs.diag318 = get_diag318_info();
>>>  	sync_regs = &run->s.regs;
>>
>> Not sure, but don't you have to mark KVM_SYNC_DIAG318 in run->kvm_valid_regs
>> and run->kvm_dirty_regs here...
> 
> Hmm... you're right. I need to do that...
> 
> Looks like the normal reset case is failing now. I must've missed
> setting the value to 0 in KVM's normal reset handler...
> 
> It's a one-line fix (and truthfully, there isn't much harm done). I'll
> toss it up on the list.

Even if it's just a small issue, it's always great to see that the KVM
selftests help to find bugs :-)

 Thomas

