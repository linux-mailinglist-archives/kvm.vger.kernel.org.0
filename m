Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DE7452F35
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhKPKig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:38:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234263AbhKPKiS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:38:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637058921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5IMSSPCR9oeB51h9/sKbMEOEXKuhLQ/uXDrBGTudfQ=;
        b=ULIOOhiMWnzJBHA9ndFIRnLKlI1VWs9aG42WTNndGGHYrKLaB2sY0NABKm+VXXS1rdfTc2
        jSITOey93FWbqRlhyar+hEWL8mdX2zYZ2U3zMpPBRJYYMvWJtSsEyUtMC7+4CTeP3anVpH
        u0DtF4J/HcNDUrNVuEnwkpaeprjPCfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-oohaC8_fO4SwqqqavejBrQ-1; Tue, 16 Nov 2021 05:35:17 -0500
X-MC-Unique: oohaC8_fO4SwqqqavejBrQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3F3B8799E0;
        Tue, 16 Nov 2021 10:35:16 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80CCF10016F4;
        Tue, 16 Nov 2021 10:35:15 +0000 (UTC)
Message-ID: <3a22201a-d921-1d2d-f72b-2d4bfea050a9@redhat.com>
Date:   Tue, 16 Nov 2021 11:35:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH kvm-unit-tests 0/2] Groups are separated by spaces
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, marcorr@google.com, zxwang42@gmail.com
References: <20211112133739.103327-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211112133739.103327-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 14:37, Andrew Jones wrote:
> I wrote these patches quite a while ago and forgot to send them. Sending
> now, now that I rediscovered them.
> 
> Andrew Jones (2):
>    unittests.cfg: groups should be space separated
>    runtime: Use find_word with groups
> 
>   README.md            | 2 +-
>   arm/unittests.cfg    | 2 +-
>   scripts/runtime.bash | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 

Queued, thanks.

Paolo

