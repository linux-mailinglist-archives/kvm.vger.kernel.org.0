Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0981172DE
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 18:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLIRdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 12:33:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbfLIRdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 12:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575912830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=OlDPXh2mC0hLohB43GwmnQm7Dnot73Ok6gIajPYntwk=;
        b=e7vIdr+SlD5iC3zm4IhUAbZ2red+9cWyYUn+NcyUJuBA4T1F6yutWY6RFfpcTn+CxmN9be
        MmRCCwTKpp7vJeoTe/exui6yve2ewT+24F9r+SrD3Xa6ktAVdQYJdwWlVPhu+GOGFrX/uP
        v4Cl+RvWx5wnpeak9BM7Qve7mlVe34E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-4DP058O6M82Bqaf8uAotWA-1; Mon, 09 Dec 2019 12:33:49 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9324C1005512
        for <kvm@vger.kernel.org>; Mon,  9 Dec 2019 17:33:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD0465D9D6;
        Mon,  9 Dec 2019 17:33:45 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Remove ioapic from the x86
 tests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>
References: <20191205151610.19299-1-thuth@redhat.com>
 <d592da1d-2a5f-a005-0002-9fde866ed421@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7a9b05a0-37e3-91ba-de23-84fd968ca185@redhat.com>
Date:   Mon, 9 Dec 2019 18:33:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <d592da1d-2a5f-a005-0002-9fde866ed421@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 4DP058O6M82Bqaf8uAotWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/2019 18.12, Paolo Bonzini wrote:
> On 05/12/19 16:16, Thomas Huth wrote:
>> The test recently started to fail (likely do to a recent change to
>> "x86/ioapic.c). According to Nitesh, it's not required to keep this
>> test running with TCG, and we already check it with KVM on Travis,
>> so let's simply disable it here now.
> 
> It works for me though:
> 
> $ /usr/bin/qemu-system-x86_64 -nodefaults -device pc-testdev -device
> isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device
> pci-testdev -machine accel=tcg -kernel x86/ioapic.flat

You have to run the test with "-smp 4" (like in x86/unittests.cfg), then
it hangs.

 Thomas

