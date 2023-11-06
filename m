Return-Path: <kvm+bounces-788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F5727E296E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFE971C20BE8
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7F829406;
	Mon,  6 Nov 2023 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aD5tj1AA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C84628E06
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:10:17 +0000 (UTC)
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EFB1BF
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 08:10:13 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-586a5d76413so2608441eaf.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 08:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699287012; x=1699891812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o9tVeKqMjlN1sJbwbYzCcGCuISPVc7ZyUOuNd53U1po=;
        b=aD5tj1AAoj1V+YOaz70nZcZAoUCvtUZdV8flydqdRoN9JbmO9lVaHKhbJCtovuZDcw
         IcflfQdVG9jtPRMKN5XZ2KJyUy+Qp33e8pI2o9P9qtvxREJaAYsXdJoHBv6Ag/6RYG73
         9d4H0llYx+KfrV1m1WOFhuK9BXDvB8qVczEZ4D2cZohFhqVM0n14gYDgR7Cxw69tsXZW
         fAvNkkpF97fc4uBEKXUxSs7IY4pD+WlvYnT79Hy19FCGwSdSRoPDexfL08TGXyDjBBxx
         YNJMSEdkUwNSBkXii46WtPdD7W8Na7jj10kxaBmnIWwImWdznzVxiH6s08vsX5LwnvzZ
         NPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699287012; x=1699891812;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9tVeKqMjlN1sJbwbYzCcGCuISPVc7ZyUOuNd53U1po=;
        b=gyQqki/YK3FjZmPa5r6WpLUbcbRDZlSbxPXEaDmo8BLsgmqqoteNaXuW9p/8C3oiXI
         PWu30pzIvnkMazBjJb6FYkB4MvkMXMmNLHsToCFdIt2NX+3UV10T6QXvcuj45BYK7dIR
         KCb0XoIam+IhtchIZO9gBKvFhVPUxbmSrnPSy4Vbg0ZDhU1TUJQSannTAomWlzx6pf2S
         oWlRGL6/5ZCz/+++MVmRKIa1L4FtwkBkp8OYLwZYtauFpeTuIpCfWIAvEf3tCC3JLcBp
         Sn2BxgloT9G9krcAwN9uBOgsW6Cvmh/Ga+YpwfgPOOqTvGRjCZzZHk4pQEpZSKb0gfJD
         knbA==
X-Gm-Message-State: AOJu0Ywwu3htfUh2EJ5CVe7QWcbpyHAZCrujOKhvwflUW3LTv3IrHuXI
	h6oz8/wfMr6WWEirIEt2/AU=
X-Google-Smtp-Source: AGHT+IE/sRaTmVzjjCiO2dK5s1AvjHxOUyoPSJxnyNWlqiA3OF+6Q3xTw5HxTC+nzv/U1i2QoMa6WQ==
X-Received: by 2002:a05:6870:788:b0:1e9:c7cc:df9a with SMTP id en8-20020a056870078800b001e9c7ccdf9amr148125oab.11.1699287012406;
        Mon, 06 Nov 2023 08:10:12 -0800 (PST)
Received: from [10.95.110.31] (54-240-197-231.amazon.com. [54.240.197.231])
        by smtp.gmail.com with ESMTPSA id d31-20020ab014a2000000b007b0f0d45133sm1599687uae.25.2023.11.06.08.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 08:10:12 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <9f15534c-8b79-4127-9b91-0dc449547833@xen.org>
Date: Mon, 6 Nov 2023 16:10:05 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v4 17/17] docs: update Xen-on-KVM documentation
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
 <20231106143507.1060610-18-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231106143507.1060610-18-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2023 14:35, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Add notes about console and network support, and how to launch PV guests.
> Clean up the disk configuration examples now that that's simpler, and
> remove the comment about IDE unplug on q35/AHCI now that it's fixed.
> 
> Update the -initrd option documentation to explain how to quote commas
> in module command lines, and reference it when documenting PV guests.
> 
> Also update stale avocado test filename in MAINTAINERS.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   MAINTAINERS              |   2 +-
>   docs/system/i386/xen.rst | 107 +++++++++++++++++++++++++++++----------
>   qemu-options.hx          |  14 +++--
>   3 files changed, 91 insertions(+), 32 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


