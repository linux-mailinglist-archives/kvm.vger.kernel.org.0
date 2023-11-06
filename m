Return-Path: <kvm+bounces-784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC487E2949
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C91D1C20C67
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186B228E3A;
	Mon,  6 Nov 2023 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSMTv1OX"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC27465
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:01:30 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7C5D42
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 08:01:28 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40842752c6eso35710555e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 08:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699286487; x=1699891287; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VuSTMH9ud0jYjriaosHkWWyigJusFLw9itadu/Ef8us=;
        b=dSMTv1OXjgHD38Tt46FpwUmk7jjQoc4fsf/KRV5NCScfmA90sszjlkiZhfVXGS0Hh1
         Y/Xmn0/n70DytPkAyw/O7f26PILjQQ4hxPH8dxuKL3EWYxw+xsna3kSBEsh7dxl9Kuwo
         yc7acnZm5mO92mTukfz52J8P5ae+HPcLZXxaOmpfWcHWfyJCRcApY5UsgKB38YuzfOxQ
         59i2JDBUxjeh0zHQeAEYhYm1h9vowa8WP7Jlbe11F+FtccCQGwIEaK/RGFSl0sXnBkXo
         gnbSO+/UkVM2YSCIclW/bzwWFaWsm5HcdIbDUTUjyKI24YIyvPOS4mPf/VMch64IhVS+
         9qJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699286487; x=1699891287;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VuSTMH9ud0jYjriaosHkWWyigJusFLw9itadu/Ef8us=;
        b=ETTJ7kwGlz1mEgjSMY4Wwf8WxftA+PUW7yhdyb9cJM/rW6hAIdS11uizCC5An3CQLc
         h89Zb7gZbgtb93VYe25AeQ7RAbI0h3+B2nfR7oHW4D16MZeJ+9C+0fJwMZQI/Ct9PbzL
         D8R/AXvFj2kftfqE1NUJQin5xOe0kssDyKsZNqyV+rwGwpOMQmR2OE8eCpW9T4OnGCRZ
         cEkp+eCd70O945kZ9OzuCFXdRLEayuq+qDDn4jrP2Gs0o+cCAnEKOV6+HTl6X0cA3x+V
         /hjKHIOTnfnIovQtSLpH+FZPd+rIyZzh2tSNqRhYHY8TW8bUo1S8oLKGYzUv9f4iWYgG
         mhJQ==
X-Gm-Message-State: AOJu0Ywy7mgKPjdm09cNPPbrQd5sw6tYYTBFufEovJi5bqflbNBRRvMw
	1OASl6VEyiEZmP/bcmuJx9Uq9VD5FphL0Q==
X-Google-Smtp-Source: AGHT+IE+3PRRsyWElc9zPvKSrIuMWGE4WXTjXvI2QsMrBJiC6CPa5U2EB5CV13HsYIol7JDB6fOz+Q==
X-Received: by 2002:a5d:6485:0:b0:32f:a7d5:4ef with SMTP id o5-20020a5d6485000000b0032fa7d504efmr11943384wri.44.1699286486710;
        Mon, 06 Nov 2023 08:01:26 -0800 (PST)
Received: from [10.95.110.31] (54-240-197-231.amazon.com. [54.240.197.231])
        by smtp.gmail.com with ESMTPSA id h3-20020a5d5043000000b0032dba85ea1bsm9838958wrt.75.2023.11.06.08.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 08:01:24 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <71dc2018-9840-458e-8ca6-3cb8ab86666d@xen.org>
Date: Mon, 6 Nov 2023 16:01:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v4 13/17] hw/i386/pc: support '-nic' for xen-net-device
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony Perard <anthony.perard@citrix.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 qemu-block@nongnu.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231106143507.1060610-1-dwmw2@infradead.org>
 <20231106143507.1060610-14-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231106143507.1060610-14-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2023 14:35, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The default NIC creation seems a bit hackish to me. I don't understand
> why each platform has to call pci_nic_init_nofail() from a point in the
> code where it actually has a pointer to the PCI bus, and then we have
> the special cases for things like ne2k_isa.
> 
> If qmp_device_add() can *find* the appropriate bus and instantiate
> the device on it, why can't we just do that from generic code for
> creating the default NICs too?
> 
> But that isn't a yak I want to shave today. Add a xenbus field to the
> PCMachineState so that it can make its way from pc_basic_device_init()
> to pc_nic_init() and be handled as a special case like ne2k_isa is.
> 
> Now we can launch emulated Xen guests with '-nic user'.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/pc.c             | 11 ++++++++---
>   hw/i386/pc_piix.c        |  2 +-
>   hw/i386/pc_q35.c         |  2 +-
>   hw/xen/xen-bus.c         |  4 +++-
>   include/hw/i386/pc.h     |  4 +++-
>   include/hw/xen/xen-bus.h |  2 +-
>   6 files changed, 17 insertions(+), 8 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


