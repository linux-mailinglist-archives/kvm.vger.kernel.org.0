Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8EE391B20
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhEZPHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:07:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235245AbhEZPHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 11:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622041570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJpel+uDhX/kgRZr6JWUBJGv5HNhK9aHa7tgJEuNYsY=;
        b=Gp31hUr26WbzpAlPWu6/RGmK/lfPd/M5Zx8CZqJIZcX/lJHK6Ap5+WPj/7qX45kWT2JlwO
        tKbpj+vBlClcA61sQS4IKQEp7SxR1wYTlR7zQkYpojruyWZmTcGb8z9xxTD5k7yemLeVRu
        5uhh7Pid0xzy6H3SkqVwGF1tMFlmts0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-jKsLJlvwPX2JMs75ZUlJ5Q-1; Wed, 26 May 2021 11:06:06 -0400
X-MC-Unique: jKsLJlvwPX2JMs75ZUlJ5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AD44800D62;
        Wed, 26 May 2021 15:06:03 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2C9A136F5;
        Wed, 26 May 2021 15:06:00 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/4] arm64: enable its-migration tests
 for TCG
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org
Cc:     shashi.mallela@linaro.org, alexandru.elisei@arm.com,
        qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com,
        maz@kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-4-alex.bennee@linaro.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <32ada1c7-bc49-db4f-c9cd-64839ffe93c9@redhat.com>
Date:   Wed, 26 May 2021 17:05:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-4-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 5/25/21 7:26 PM, Alex Bennée wrote:
> With the support for TCG emulated GIC we can also test these now.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arm/unittests.cfg | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index f776b66..1a39428 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -194,7 +194,6 @@ arch = arm64
>  [its-migration]
>  file = gic.flat
>  smp = $MAX_SMP
> -accel = kvm
>  extra_params = -machine gic-version=3 -append 'its-migration'
>  groups = its migration
>  arch = arm64
> @@ -202,7 +201,6 @@ arch = arm64
>  [its-pending-migration]
>  file = gic.flat
>  smp = $MAX_SMP
> -accel = kvm
>  extra_params = -machine gic-version=3 -append 'its-pending-migration'
>  groups = its migration
>  arch = arm64
> 

