Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753D32D3E78
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgLIJVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:21:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728168AbgLIJU5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 04:20:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607505571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l+l7dBCPMP3gMS8e5zBCrBOo5rv6snz/Y6HFXAn7Fpw=;
        b=b/9lPn4pYPZEFih79AyF+Dgw382egQO+0kFq5ttjeP4glGHsVMWWvysg9IMeBCyseoBeqT
        4xBssvPCK+4mWqC7udaKaol4GTf8hUot+0lJWblK1ojlkLWCTHKyBoVvlcs9bhwsIwikrO
        heIEqGoffU2R78wwz+mwsYueU/lG8U4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-Q8MbdI0BNaaGyLyFc-Q3EA-1; Wed, 09 Dec 2020 04:19:29 -0500
X-MC-Unique: Q8MbdI0BNaaGyLyFc-Q3EA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29F2A8143E5;
        Wed,  9 Dec 2020 09:19:28 +0000 (UTC)
Received: from [10.36.114.167] (ovpn-114-167.ams2.redhat.com [10.36.114.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B6DA60BF3;
        Wed,  9 Dec 2020 09:19:26 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: Move to GPL 2 and SPDX license
 identifiers
From:   David Hildenbrand <david@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201208150902.32383-1-frankja@linux.ibm.com>
 <20201208150902.32383-2-frankja@linux.ibm.com>
 <d0e8582e-8734-739b-d279-1e8004f379a3@redhat.com>
Organization: Red Hat GmbH
Message-ID: <5d484586-b984-4b7a-1b50-e6f3314645dc@redhat.com>
Date:   Wed, 9 Dec 2020 10:19:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <d0e8582e-8734-739b-d279-1e8004f379a3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.12.20 10:12, David Hildenbrand wrote:
> On 08.12.20 16:09, Janosch Frank wrote:
>> In the past we had some issues when developers wanted to use code
>> snippets or constants from the kernel in a test or in the library. To
>> remedy that the s390x maintainers decided to move all files to GPL
>> 2 (if possible).
>>
>> At the same time let's move to SPDX identifiers as they are much nicer
>> to read.
>>
> 
> If I am not wrong, your patch only replaces existing license text by
> SPDX identifiers. So I find this commit message rather confusing. The
> "at the same time" is actually the only thing that is being done - or am
> I missing something important?
> 
> I wonder of we can just convert everything to GPL-2.0-or-later, the list
> of people that contributed to most files is rather limited, so getting
> most acks should be easy.
> 

Aehm, I missed the "Library" part :D

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

