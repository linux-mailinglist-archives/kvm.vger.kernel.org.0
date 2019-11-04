Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F348EEDC28
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 11:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfKDKLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 05:11:03 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60928 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbfKDKLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 05:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572862262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ARBam5+v9MDzT700RHLlC5uIj2GXcDZmu0AH+HXN3rQ=;
        b=g4Ga9VgR+Y6FAut6SnantF2Byeo+KfJFy/kS9JTdFK/fj7PXsGHsWC5+VckKoRf1IBuCCP
        Pz8I1RBtPN/UAYw8gCPjSLzbn45PeWfdjBpfO0TuHLGn5pkUTh+ycYKn6oqQNppYhLZhEC
        Ayrm7AuhAx8XYs4bX7OpU3jgbkHhV9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-InF7Uv4_OA6oGxc54aKxQA-1; Mon, 04 Nov 2019 05:11:01 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0338C1005500;
        Mon,  4 Nov 2019 10:11:00 +0000 (UTC)
Received: from [10.36.118.62] (unknown [10.36.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49E0A5D6C5;
        Mon,  4 Nov 2019 10:10:58 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 0/5] s390x: SCLP Unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <5aae4df3-e95b-d866-3eca-26b39df935bf@redhat.com>
Date:   Mon, 4 Nov 2019 11:10:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: InF7Uv4_OA6oGxc54aKxQA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.10.19 19:06, Claudio Imbrenda wrote:
> This patchset contains some minor cleanup, some preparatory work and
> then the SCLP unit test itself.
>=20
> The unit test checks the following:
>     =20
>      * Correctly ignoring instruction bits that should be ignored
>      * Privileged instruction check
>      * Check for addressing exceptions
>      * Specification exceptions:
>        - SCCB size less than 8
>        - SCCB unaligned
>        - SCCB overlaps prefix or lowcore
>        - SCCB address higher than 2GB
>      * Return codes for
>        - Invalid command
>        - SCCB too short (but at least 8)
>        - SCCB page boundary violation
>=20
> v1 -> v2
> * fix many small issues that came up during the first round of reviews
> * add comments to each function
> * use a static buffer for the SCCP template when used
>=20
> Claudio Imbrenda (5):
>    s390x: remove redundant defines
>    s390x: improve error reporting for interrupts
>    s390x: sclp: expose ram_size and max_ram_size
>    s390x: sclp: add service call instruction wrapper
>    s390x: SCLP unit test

Queued patch 1-3 to

https://github.com/davidhildenbrand/kvm-unit-tests.git s390x-next

Thanks!

--=20

Thanks,

David / dhildenb

