Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765712FE1EF
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 06:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbhAUFnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 00:43:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbhAUFdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 00:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611207141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhzezIaDiEli+f4zaC7lNoQ36t1Sq3yzOIKTumKoc18=;
        b=GtEp3yk3a3N0DcyaWappWFrnNZzeG4hgRhBA5JFutK/tDed5nUtihbaPE1pSZzC9cC08NL
        3pH3ktV0IELvUJNR+S6JPsMpGIMs0uja6xjWFfVaVHPShyX1ADwScUteOjzShe/5NRYKsV
        0vaJHqaKVtC5AayJcRahhzbeDG71LW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-stz7GTY2NzClsp0sFyTTtQ-1; Thu, 21 Jan 2021 00:32:18 -0500
X-MC-Unique: stz7GTY2NzClsp0sFyTTtQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E63310054FF;
        Thu, 21 Jan 2021 05:32:17 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5744C709A4;
        Thu, 21 Jan 2021 05:32:11 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 04/11] lib/asm: Fix definitions of
 memory areas
To:     David Matlack <dmatlack@google.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm list <kvm@vger.kernel.org>, frankja@linux.ibm.com,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, cohuck@redhat.com,
        Laurent Vivier <lvivier@redhat.com>, nadav.amit@gmail.com,
        krish.sadhukhan@oracle.com
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
 <20210115123730.381612-5-imbrenda@linux.ibm.com>
 <CALzav=ehg9zWe2POxKg0FDciyfT7QsWRDDNqZ7_WRqtdWMEtaA@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <64b3aba4-9040-6b72-43c6-2871beee97c1@redhat.com>
Date:   Thu, 21 Jan 2021 06:32:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CALzav=ehg9zWe2POxKg0FDciyfT7QsWRDDNqZ7_WRqtdWMEtaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2021 02.23, David Matlack wrote:
> Hi Claudio,
> 
> On Fri, Jan 15, 2021 at 8:07 AM Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>>
>> Fix the definitions of the memory areas.
> 
> The test x86/smat.flat started falling for me at this commit. I'm
> testing on Linux 5.7.17.

FWIW, seems like this was also happening on Travis, just before it became 
useless. Build #15 is still fine:

  https://travis-ci.com/gitlab/kvm-unit-tests/kvm-unit-tests/builds/213551621

But build #18 reported a broken smat test:

  https://travis-ci.com/gitlab/kvm-unit-tests/kvm-unit-tests/builds/213564672

The job logs say that the builders there use kernel version  5.4.0-1034-gcp

  Thomas

