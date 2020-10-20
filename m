Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A52293471
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 07:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391763AbgJTFx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 01:53:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36167 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391759AbgJTFx6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 01:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603173236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IO8mqQP8viTih7BxwdVCRxHdeokgDkWpgYtMoz+bqqc=;
        b=ZmAATp9w+GtrkQO7rSDMpMYmLxEod/5mRPcKy8x9dmikn2nHWOu4d9ejkLJYmQTlIsDgNe
        TJM4U/HWgjtcB5SwpoFbWqgwwXrbbj4APTnc1dwWbHKJx7CfFkiOAal3d9rKNRBvERtXid
        tT1WpDYhvlr7B7SgqwMfEOrkgfOpf4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-PS4KOyj6N6uaSkfZFD3pIQ-1; Tue, 20 Oct 2020 01:53:54 -0400
X-MC-Unique: PS4KOyj6N6uaSkfZFD3pIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 561D418A0727;
        Tue, 20 Oct 2020 05:53:53 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6284E5B4A3;
        Tue, 20 Oct 2020 05:53:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic
 test
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>, kvm@vger.kernel.org
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <1b9e716f-fb13-9ea3-0895-0da0f9e9e163@redhat.com>
 <20201016174044.eg72aordkchdr5l2@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <1e37df99-2d5c-be4c-4f42-1534f6164982@redhat.com>
Date:   Tue, 20 Oct 2020 07:53:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201016174044.eg72aordkchdr5l2@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2020 19.40, Andrew Jones wrote:
> On Fri, Oct 16, 2020 at 07:02:57PM +0200, Paolo Bonzini wrote:
>> On 15/10/20 18:35, Sean Christopherson wrote:
>>> The port80 test in particular is an absolute waste of time.
>>>
>>
>> True, OTOH it was meant as a benchmark.  I think we can just delete it
>> or move it to vmexit.
>>
> 
> If you want to keep the code, but only run it manually sometimes,
> then you can mark the test as nodefault.

Please let's avoid that. Code that does not get run by default tends to
bitrot. I suggest to decrease the amount of loops by default, and if
somebody still wants to run this as a kind of benchmark, maybe the amount of
loops could be made configurable? (i.e. so that you could control it via an
argv[] parameter?)

 Thomas

