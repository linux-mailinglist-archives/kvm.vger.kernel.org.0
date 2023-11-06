Return-Path: <kvm+bounces-783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E50B7E2937
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E9D61C20C11
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BB828E2E;
	Mon,  6 Nov 2023 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M3G0b72N"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1016128E06
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:59:01 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD6E191
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 07:59:00 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40842752c6eso35687805e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 07:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699286339; x=1699891139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YdRU2ICAmJ5fzVK5A8/S2GOgHKTlNLHwKSHWlkevpuU=;
        b=M3G0b72NS64h0Xdd9wGkpyy9wNhRJ5/kJxzvIrI6rgPd0zBszrwsydG8LHygFXhyAI
         uMdKLeOvKX27kyHq3w4aVyyw5SNdyLFNS7h24x6jQT2SiWdAxHr5rCQRG3Da1J4kO3sx
         r1t518Mn6pD3QaXjWZAcGinsHmnd1ioNvIXKGodFArtE1MB+VHhAsxX/5wfQ0YWs3EV0
         4wJ48IgfOThIYtx3kxsgsuZZQI3hNWVzMEuXOnch6uNXgOyd7xsWSHuIajtLwXf9F51g
         EuURy6WzHSomah/raseur77ZqY49VVpOZZASYrbN4CGl+vRWst6s3QLH7mfYhEjurJ1X
         hddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699286339; x=1699891139;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdRU2ICAmJ5fzVK5A8/S2GOgHKTlNLHwKSHWlkevpuU=;
        b=Z+AsBO7rBaGvsX0oZLp4PPXsb16PmAEseBlE6kb+LM9ni7DJ9VW+yDM8wodn8baJUT
         6DPYV8gXKZSGAKj9LK6AM+FK+Pu8mvWi/nOJoqrJVcmQdK54iWGU6L3uiIaEOZhugUKf
         KOqwGCPcYg39Pnd0QQk0gssjOaIcYDyKhP67+D0u2l289MzClZikZd166qzYc8x5XFae
         fBsxAZrmnxSHQVWHoivcM7CI3G09TLx/qMEip4hB/s2/2VmZ7Zk7wKDTKup0z8Khftf6
         tWm/uSjfiFhUgkQwvh0WrmmxLg3oMnL18RQjKFWpB9sRtLND+VjUN7XniqvN3aaMVnQa
         ogIw==
X-Gm-Message-State: AOJu0Yweqw9nwBICVeTHgElbx+DVHWd7rbJ6x1bMj+iqCY+G/MElDdT+
	1k1FhZYcb1YkarAOOfpLxAs=
X-Google-Smtp-Source: AGHT+IG+oPN1NQBnC7slICVrFKIK+QQJ+pHrO26W48S90buGxRQhChU5XJhSimZD7bEJ7PpCsy+dGA==
X-Received: by 2002:a5d:6051:0:b0:32d:a4c4:f700 with SMTP id j17-20020a5d6051000000b0032da4c4f700mr20821057wrt.38.1699286338898;
        Mon, 06 Nov 2023 07:58:58 -0800 (PST)
Received: from [10.95.110.31] (54-240-197-231.amazon.com. [54.240.197.231])
        by smtp.gmail.com with ESMTPSA id bs14-20020a056000070e00b0032d8eecf901sm10060456wrb.3.2023.11.06.07.58.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 07:58:58 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <e2cb5f62-9a32-4ea2-bb34-b551dcb0755c@xen.org>
Date: Mon, 6 Nov 2023 15:58:54 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v4 06/17] hw/xen: automatically assign device index to
 block devices
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
 <20231106143507.1060610-7-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231106143507.1060610-7-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/11/2023 14:34, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There's no need to force the user to assign a vdev. We can automatically
> assign one, starting at xvda and searching until we find the first disk
> name that's unused.
> 
> This means we can now allow '-drive if=xen,file=xxx' to work without an
> explicit separate -driver argument, just like if=virtio.
> 
> Rip out the legacy handling from the xenpv machine, which was scribbling
> over any disks configured by the toolstack, and didn't work with anything
> but raw images.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Acked-by: Kevin Wolf <kwolf@redhat.com>
> ---
>   blockdev.c                          |  15 +++-
>   hw/block/xen-block.c                | 118 ++++++++++++++++++++++++++--
>   hw/xen/xen_devconfig.c              |  28 -------
>   hw/xenpv/xen_machine_pv.c           |   9 ---
>   include/hw/xen/xen-legacy-backend.h |   1 -
>   5 files changed, 125 insertions(+), 46 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


