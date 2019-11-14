Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC85FC652
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 13:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfKNM3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 07:29:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44197 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726057AbfKNM3j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 07:29:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573734578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UnIkCUacQNg4w++pcNB0Kqh5gy0FXF4jAoSzEDZnZMY=;
        b=eNxMC1f8w38AhY85K9wEdiJr4i1yFW6GNqqshMrmomw/qDmq9t2sdBMcgQ3/4pvd6ld01g
        bapaHB0fbqcws4ScaXXFgjfsn0jBdhsfp/5SmOL8TvDvUhro/uWad8/1NuOG21g4YPpKh9
        aDQunZGtKBN951759AMjAcydyV0idzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-eqGZBHZjP0Ox-d6lWlECKg-1; Thu, 14 Nov 2019 07:29:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40365477;
        Thu, 14 Nov 2019 12:29:36 +0000 (UTC)
Received: from [10.36.117.13] (ovpn-117-13.ams2.redhat.com [10.36.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1815A61367;
        Thu, 14 Nov 2019 12:29:34 +0000 (UTC)
Subject: Re: [kvm-unit-test PATCH 0/5] Improvements for the Travis CI
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20191113112649.14322-1-thuth@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <9c969381-4d53-5b54-e207-c0e9314bd1e0@redhat.com>
Date:   Thu, 14 Nov 2019 13:29:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: eqGZBHZjP0Ox-d6lWlECKg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.11.19 12:26, Thomas Huth wrote:
> The first two patches make the test matrix a little bit more flexible,
> and the fourth patch enables the 32-bit builds on x86.
>=20
> But the most important patch is likely the third one: It is possible to
> test with KVM on Travis now, so we can run the tests within a real KVM
> environment, without TCG! The only caveat is that qemu-system-x86_64
> has to run as root ... fixing only the permissions of /dev/kvm did
> not help here, I still got a "Permission denied" in that case.
>=20
> Thomas Huth (5):
>    travis.yml: Re-arrange the test matrix
>    travis.yml: Install only the required packages for each entry in the
>      matrix
>    travis.yml: Test with KVM instead of TCG (on x86)
>    travis.yml: Test the i386 build, too
>    travis.yml: Expect that at least one test succeeds
>=20
>   .travis.yml | 155 +++++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 104 insertions(+), 51 deletions(-)
>=20

As discussed, queued to

https://github.com/davidhildenbrand/kvm-unit-tests.git s390x-next

for now. PULL request early next week.

--=20

Thanks,

David / dhildenb

