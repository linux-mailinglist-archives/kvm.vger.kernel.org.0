Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25E035452C
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242379AbhDEQbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242368AbhDEQbR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 12:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9lG+nLR5IoYSNGo0IQTIdcrOzj+guXrJm8gXPF7fbQI=;
        b=Yj3uRqpiww+0TqZHKlgcXM3o6OpbE0pr5HRuCSzsUYxne7tjbLry6qgd4ptMsWyAPZjwcW
        4AzXg1yV56pUznnwushwdL1EYMe6pmwKTGY8IcTgiyyqmtsQf1+EWt23pxUHZ7UXETpPBy
        4tKcGsy53NYsHyx0rVjCTJPJQR4YMGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-TM7Gs4ibP2GI3VgXCeSJwQ-1; Mon, 05 Apr 2021 12:31:07 -0400
X-MC-Unique: TM7Gs4ibP2GI3VgXCeSJwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E83EF802575;
        Mon,  5 Apr 2021 16:31:05 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB0E01349A;
        Mon,  5 Apr 2021 16:31:00 +0000 (UTC)
Subject: Re: [PATCH v5 0/8] KVM/ARM: Some vgic fixes and init sequence KVM
 selftests
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20210404172243.504309-1-eric.auger@redhat.com>
 <877dlhf3ae.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <051db106-791c-46e7-d921-23e2bfb68b7e@redhat.com>
Date:   Mon, 5 Apr 2021 18:30:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <877dlhf3ae.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/5/21 12:12 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On Sun, 04 Apr 2021 18:22:35 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> While writting vgic v3 init sequence KVM selftests I noticed some
>> relatively minor issues. This was also the opportunity to try to
>> fix the issue laterly reported by Zenghui, related to the RDIST_TYPER
>> last bit emulation. The final patch is a first batch of VGIC init
>> sequence selftests. Of course they can be augmented with a lot more
>> register access tests, but let's try to move forward incrementally ...
>>
>> Best Regards
>>
>> Eric
>>
>> This series can be found at:
>> https://github.com/eauger/linux/tree/vgic_kvmselftests_v5
>>
>> History:
>> v4 -> v5:
>> - rewrite the last bit detection according to Marc's
>>   interpretation of the spec and modify the kvm selftests
>>   accordingly
> 
> Have you dropped v4's patch #1? It did seem to fix an actual issue,
> didn't it?

Hum no that was not my intent :-( Resending ...

Eric
> 
> Thanks,
> 
> 	M.
> 

