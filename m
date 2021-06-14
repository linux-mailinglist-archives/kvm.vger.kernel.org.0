Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2966D3A5E34
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhFNISn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 04:18:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232530AbhFNISm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 04:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623658599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NWYh+JN15Re9hA/u8sox/DeHyV8EZ/VNFeCGPr+FHI0=;
        b=BmyI3zkksOgAkfOjbDoln4Td45aW8r5/lxu3eUcZLjJf+wih+k2OKdd5kTWgULjQ/HMryj
        qZQKhmkC74uSiQN+4cN6uB4CCJeQUUX+SWeouxvfdaqnTNzbOAv2jPyqetOLiRTXMCWoJ/
        MPN+dL34RTep7+WH6ltUwqyy/fAxlRw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-Z0Vw8cFpMzObnz1RnhBskw-1; Mon, 14 Jun 2021 04:16:38 -0400
X-MC-Unique: Z0Vw8cFpMzObnz1RnhBskw-1
Received: by mail-ej1-f69.google.com with SMTP id e11-20020a170906080bb02903f9c27ad9f5so2721041ejd.6
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 01:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NWYh+JN15Re9hA/u8sox/DeHyV8EZ/VNFeCGPr+FHI0=;
        b=mYze7FQQznC6G81+PbDBzntO6iwJWPq0YzX3xbeZ9/BJc6bP/aEBl65SQDGVOAn/Wx
         BwEBsKZ6wB7L+1n3gAFcDQLpPdX8PUnH35GhAddBScM8V/8JU3UaBytCG6vjPqY+TCZx
         R1yGyPXBu+8Z26B8AtweSIqkBZ0qr0x2Xt8i1CtMMa3w+YACqdf24ihBqoMCYaKd61b/
         AmLbM6I/Nv0Eh2bWJiqKHcwpm5SCRD6E8J0wNgyHLmcl2oz3d626QQYWVC73ySTKBtq8
         e+VNFVK1kIxBmycpkHHkQNUdcupzdHPbPB4IARfgQT2nyhn+adPr+W+6vMolxqZkKJoB
         7GTA==
X-Gm-Message-State: AOAM531RrlanMbEnV5iXeOsaRNJB9X+J4qWZo5+ldiof7ExPPqhGHk2g
        zbw5hxRU98sVQzJ+iXCC71B0n/HCZZmvUq7Q/dMwWTnGVnk09bX2nUppC9Whl5bNBpV5zcssRRX
        cmev+xuMnJtiS
X-Received: by 2002:a05:6402:19b9:: with SMTP id o25mr15353507edz.192.1623658597179;
        Mon, 14 Jun 2021 01:16:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/KTRQYhU+Vh3BamwYE6Ifgg3evkGYd7DRr9k1n6WQ3groQvMruoCvWoppWBg5CVzFipDzmA==
X-Received: by 2002:a05:6402:19b9:: with SMTP id o25mr15353493edz.192.1623658597033;
        Mon, 14 Jun 2021 01:16:37 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h26sm8017727edz.76.2021.06.14.01.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 01:16:36 -0700 (PDT)
Date:   Mon, 14 Jun 2021 10:16:35 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] configure: arm: Update kvmtool UART
 address
Message-ID: <20210614081635.4arskb7yjcsm33mn@gator.home>
References: <20210611152621.34242-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611152621.34242-1-alexandru.elisei@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 04:26:21PM +0100, Alexandru Elisei wrote:
> kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher
> addresses") changed the UART address from 0x3f8 to 0x1000000. Update the
> UART early address accordingly when kvm-unit-tests is configured with
> --target=kvmtool.
> 
> Users of older kvmtool versions can still enjoy having a working early UART
> by configuring kvm-unit-tests with --earlycon=uart,mmio,0x3f8. Note that in
> this case --target=kvmtool is still recommended because it enables all
> erratas.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure b/configure
> index 4ad5a4bcd782..bd0c14edb777 100755
> --- a/configure
> +++ b/configure
> @@ -189,7 +189,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      if [ "$target" = "qemu" ]; then
>          arm_uart_early_addr=0x09000000
>      elif [ "$target" = "kvmtool" ]; then
> -        arm_uart_early_addr=0x3f8
> +        arm_uart_early_addr=0x1000000
>          errata_force=1
>      else
>          echo "--target must be one of 'qemu' or 'kvmtool'!"
> -- 
> 2.32.0
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

