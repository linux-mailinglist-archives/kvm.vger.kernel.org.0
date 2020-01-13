Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B660D1397C7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgAMRdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 12:33:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57665 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726985AbgAMRdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 12:33:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578936793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYW22dyvB/rUGePxrtipcgCoGo1xD+N9jtUO/xfVRRE=;
        b=GpHyASH+Qfhg6iADGBJwmti2+7rYNFackB0DK/2n0Nk6MiE7egT0A4fBjsb4g0Ex13xf7g
        2GU36PVwyf2cpq/4TwalexZxaPwDJTBYuHxHPthd9cZVEclkXqfW3/M9WuJ7BfEFVZkGmz
        UOqnfP8wOYfPVMDpM6AgJ0B+b9HSkgs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-SHvAVZ53PRaXf6vVpaSz8Q-1; Mon, 13 Jan 2020 12:33:09 -0500
X-MC-Unique: SHvAVZ53PRaXf6vVpaSz8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07B0C107ACC4;
        Mon, 13 Jan 2020 17:33:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 690C181E31;
        Mon, 13 Jan 2020 17:33:02 +0000 (UTC)
Date:   Mon, 13 Jan 2020 18:33:00 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 05/16] arm/arm64: ITS: Introspection
 tests
Message-ID: <20200113173300.vhycoije77ouk4ls@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-6-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-6-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 03:54:01PM +0100, Eric Auger wrote:
...
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 8416dde..f9a6f57 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -6,6 +6,7 @@
>  #include <devicetree.h>
>  #include <asm/gic.h>
>  #include <asm/io.h>
> +#include <asm/gic-v3-its.h>
>  
>  struct gicv2_data gicv2_data;
>  struct gicv3_data gicv3_data;
> @@ -44,12 +45,14 @@ static const struct gic_common_ops gicv3_common_ops = {
>   * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
>   */
>  static bool
> -gic_get_dt_bases(const char *compatible, void **base1, void **base2)
> +gic_get_dt_bases(const char *compatible, void **base1, void **base2,
> +		 void **base3)

Here's another place that I would prefer using our 120 chars. No need to
put base3 on a new line.

Thanks,
drew

