Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0544132085
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 08:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgAGHff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 02:35:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27555 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725987AbgAGHff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 02:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578382534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=9MB1EpwF/3QQ/vJ0P9V4XwfNz1wYN5CHQ5mAOEIgsWc=;
        b=igcD6iqOM8T2TukFvz30JZooeK5i4+fssuKNLmen1Sjqt4jHOkX3+CEW3cCPtO5msGyFus
        xM2RsGSElGcU3sieVeDjuscDdvIg1ss6UbAfbHp9OCLK3nVxSlMFLKlhuwAGWCn1mHXOYT
        IM0BCaHYm6CQrJa4nKjMiS5lqm7DY8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-FdoqD2fZOFKOIrQZOzg5-w-1; Tue, 07 Jan 2020 02:35:27 -0500
X-MC-Unique: FdoqD2fZOFKOIrQZOzg5-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4DCB801E76;
        Tue,  7 Jan 2020 07:35:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-116.ams2.redhat.com [10.36.116.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89F8E1C4;
        Tue,  7 Jan 2020 07:35:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 01/16] libcflat: Add other size defines
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-2-eric.auger@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cab416f2-4e86-4cae-97e9-d78cfb7f2781@redhat.com>
Date:   Tue, 7 Jan 2020 08:35:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191216140235.10751-2-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/2019 15.02, Eric Auger wrote:
> Introduce additional SZ_256, SZ_8K, SZ_16K macros that will
> be used by ITS tests.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  lib/libcflat.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index ea19f61..7092af2 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -36,7 +36,10 @@
>  #define ALIGN(x, a)		__ALIGN((x), (a))
>  #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
>  
> +#define SZ_256			(1 << 8)
>  #define SZ_4K			(1 << 12)
> +#define SZ_8K			(1 << 13)
> +#define SZ_16K			(1 << 14)
>  #define SZ_64K			(1 << 16)
>  #define SZ_2M			(1 << 21)
>  #define SZ_1G			(1 << 30)
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

