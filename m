Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01E5443E38
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 09:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhKCIRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 04:17:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231491AbhKCIRX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 04:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635927287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EemDZ50X1yIjR15F6yhH4ayqdelD/Va+WjQkzWymm1g=;
        b=aWUvWyzOT5D33bBlB+p2fmAkq2RCHQqJoTsV4ZTEEZ9+mh4UG8Dn7k1w/LTx8gfbqVJxC/
        CMX8KkB1ew/k9UOhzsN/Zh+BC5O1/UmkhE/rPPBMZTDzPWZ6jJxxvm+ft7Adi2EV2Iq+Yj
        6cZX36TNR7OhrAYvZzeN/JfbkFROYHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-DRNK_fXfM-K_IJyMD0QHEg-1; Wed, 03 Nov 2021 04:14:44 -0400
X-MC-Unique: DRNK_fXfM-K_IJyMD0QHEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA1E08066F0;
        Wed,  3 Nov 2021 08:14:42 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50A3F5D9D3;
        Wed,  3 Nov 2021 08:14:31 +0000 (UTC)
Message-ID: <c977b200-ba2d-d3eb-eae0-75a17d16496d@redhat.com>
Date:   Wed, 3 Nov 2021 09:14:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-7-git-send-email-pmorel@linux.ibm.com>
 <20211103075636.hgxckmxs62bsdrha@gator.home>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 6/7] s390x: virtio tests setup
In-Reply-To: <20211103075636.hgxckmxs62bsdrha@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/2021 08.56, Andrew Jones wrote:
> On Fri, Aug 27, 2021 at 12:17:19PM +0200, Pierre Morel wrote:
>> +
>> +#define VIRTIO_ID_PONG         30 /* virtio pong */
> 
> I take it this is a virtio test device that ping-pong's I/O. It sounds
> useful for other VIRTIO transports too. Can it be ported? Hmm, I can't
> find it in QEMU at all?

I also wonder whether we could do testing with an existing device instead? 
E.g. do a loopback with a virtio-serial device? Or use two virtio-net 
devices, connect them to a QEMU hub and send a packet from one device to the 
other? ... that would be a little bit more complicated here, but would not 
require a PONG device upstream first, so it could also be used for testing 
older versions of QEMU...

  Thomas


