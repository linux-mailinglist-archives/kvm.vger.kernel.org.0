Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0A278491
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgIYJ5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727290AbgIYJ5m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:57:42 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601027861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/1e0qHXA904gQnWjp6I66Ravy3kIO+VK/spdLu5K/Pc=;
        b=Gp7c/JQx5PIYyu53ERYtbjmpSuQefjYogTXkTuyVVbLRPnB2vLG5wgpYaQuhfWQN0rz9ct
        OSzp8lg4gXjz5diT2DG1jUBfk9XLgWfeJ1U5f7n4SppSj3e8KRWhIhRJK1kNuE8avK7ynL
        FgvQ/6Ocle1P+M1tvngIKnXsAxXVAK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-U9OZeLLBMQi3QaYKo-_SXA-1; Fri, 25 Sep 2020 05:57:39 -0400
X-MC-Unique: U9OZeLLBMQi3QaYKo-_SXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61B0256C2F;
        Fri, 25 Sep 2020 09:57:38 +0000 (UTC)
Received: from gondolin (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CECA5C230;
        Fri, 25 Sep 2020 09:57:33 +0000 (UTC)
Date:   Fri, 25 Sep 2020 11:57:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] travis.yml: Update the list of s390x
 tests
Message-ID: <20200925115730.6cd4748a.cohuck@redhat.com>
In-Reply-To: <20200924161612.144549-10-thuth@redhat.com>
References: <20200924161612.144549-1-thuth@redhat.com>
        <20200924161612.144549-10-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Sep 2020 18:16:12 +0200
Thomas Huth <thuth@redhat.com> wrote:

> With the new QEMU from Ubuntu Focal, we can now run more tests with TCG.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index f1bcf3d..6080326 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -116,7 +116,8 @@ jobs:
>        env:
>        - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
>        - BUILD_DIR="."
> -      - TESTS="diag10 diag308"
> +      - TESTS="cpumodel css diag10 diag288 diag308 emulator intercept sclp-1g
> +          sclp-3g selftest-setup"
>        - ACCEL="tcg,firmware=s390x/run"
>  
>      - addons:
> @@ -124,7 +125,7 @@ jobs:
>        env:
>        - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
>        - BUILD_DIR="s390x-builddir"
> -      - TESTS="sieve"
> +      - TESTS="sieve skey stsi vector"
>        - ACCEL="tcg,firmware=s390x/run"
>  
>      - os: osx

Nice.

Acked-by: Cornelia Huck <cohuck@redhat.com>

