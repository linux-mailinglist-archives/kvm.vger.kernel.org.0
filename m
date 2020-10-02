Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9736928165A
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388168AbgJBPQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:16:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBPQo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601651803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2fpkYqU9iJCXIBox2lJsKSpHcKUZmyboo4d5mAPzLM=;
        b=XzOFfRrhwsR/tNUeIeFHfaIQUWCcASE88tA0Uike/6kjMUhif/HcnOIfczPeQHhYhn56QD
        T1xiyepvwPpe/YOBFLjf9w5deaSWSZgeLtRR7SQLOT9ctL4+fd599lgPkKtPIAI5wPvDU8
        BRq/wNmK32P2jjDpBajVwl+jwQds8+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-8bnMP2yQMveGWDrI6HNghg-1; Fri, 02 Oct 2020 11:16:40 -0400
X-MC-Unique: 8bnMP2yQMveGWDrI6HNghg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1A3B84F226;
        Fri,  2 Oct 2020 15:16:39 +0000 (UTC)
Received: from [10.10.120.38] (ovpn-120-38.rdu2.redhat.com [10.10.120.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 380325C1DA;
        Fri,  2 Oct 2020 15:16:39 +0000 (UTC)
Subject: Re: KVM call for agenda for 2020-10-06
To:     quintela@redhat.com, kvm-devel <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org
References: <874kndm1t3.fsf@secure.mitica>
From:   John Snow <jsnow@redhat.com>
Message-ID: <c64f5686-b656-226d-8c4c-95965dcc574a@redhat.com>
Date:   Fri, 2 Oct 2020 11:16:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <874kndm1t3.fsf@secure.mitica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/20 5:09 AM, Juan Quintela wrote:
> 
> 
> Hi
> 
> Please, send any topic that you are interested in covering.
> 
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
> 
> 
> For this call, we have agenda!!
> 
> John Snow wants to talk about his new (and excting) developments with
> x-configure.  Stay tuned.
> 

I'm working on an email to qemu-devel now detailing some of our work 
trying to make good on a renewed effort for better APIs for QEMU.

In short, I'd like to discuss a roadmap for converting our CLI to 
something QAPI-based, and discuss ways to coordinate and distribute this 
work to interested maintainers and developers.

Look out for it!

--js

> 
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
> 
>   Call details:
> 
> By popular demand, a google calendar public entry with it
> 
>    https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
> 
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
> 
> If you need phone number details,  contact me privately
> 
> Thanks, Juan.
> 

