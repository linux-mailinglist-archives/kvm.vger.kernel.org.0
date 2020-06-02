Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C101EBD6C
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgFBN4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:56:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41403 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgFBN4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 09:56:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id j10so3498747wrw.8;
        Tue, 02 Jun 2020 06:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xEDuRNO0hoLyf2dsuZwG9i6NBcBwN5Cee5iDNQjzrxQ=;
        b=sDLREcBGj2jSzWIFevjiFSJJcDTJO4UJHigdV6fIuVZzx8gxKVUdHElBp2NBqX0/vr
         KSPApcOMVc3IsPnMAXJQN8H+0fPqRW1jxzVliYzq0V+DhXMPfXX5y6mkowcv8ZoHnAsz
         uV/6QmvIHlFi66mcB3bC53zYv3pSqjUtl+Hk4S166Rd3NvpOypamqzz2WyFdQD54RuBl
         IrwWM/RCI70IA9Y587C9fN+o90FR788sDsBO53QzLRNq/87JLh4VafslxMGpORIdERzV
         BXlDftWjbe2WDsDtXlnnbczrF+tG3Q8JvVJXwU0P3s6PBSQOgI0t7mOfgBHU6rjn1NbK
         Xyrw==
X-Gm-Message-State: AOAM533ddfF1Ex7YgE8o+m1CAUMBkoj0oxeP1uANuUtiMmJLDwGclTUP
        YZg+yt6xz3H+SqR86ZsALeo8s0wv
X-Google-Smtp-Source: ABdhPJwZR7zeuOOwd/F1h13TwWHbHDPsMBVbMUzwHWSM9A39cAGwW8kkkg0ywrN5jAe9fY9AUT0R8Q==
X-Received: by 2002:adf:cf06:: with SMTP id o6mr26086363wrj.163.1591106181464;
        Tue, 02 Jun 2020 06:56:21 -0700 (PDT)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g187sm3851690wma.17.2020.06.02.06.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:56:20 -0700 (PDT)
Date:   Tue, 2 Jun 2020 13:56:18 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Doron <arilou@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: linux-next: manual merge of the hyperv tree with the kvm tree
Message-ID: <20200602135618.5iw6zd2jqzqqcwxm@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
References: <20200602171802.560d07bc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602171802.560d07bc@canb.auug.org.au>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 02, 2020 at 05:18:02PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the hyperv tree got a conflict in:
> 
>   arch/x86/include/asm/hyperv-tlfs.h
> 
> between commit:
> 
>   22ad0026d097 ("x86/hyper-v: Add synthetic debugger definitions")
> 

Paolo

As far as I can tell you merged that series a few days ago. Do you plan
to submit it to Linus in this merge window? How do you want to proceed
to fix the conflict?

Wei.

> from the kvm tree and commit:
> 
>   c55a844f46f9 ("x86/hyperv: Split hyperv-tlfs.h into arch dependent and independent files")
> 
> from the hyperv tree.
> 
> I fixed it up (I removed the conficting bits from that file and added
> the following patch) and can carry the fix as necessary. This is now fixed
> as far as linux-next is concerned, but any non trivial conflicts should
> be mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer
> of the conflicting tree to minimise any particularly complex conflicts.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 2 Jun 2020 17:15:49 +1000
> Subject: [PATCH] x86/hyperv: merge fix for hyperv-tlfs.h split
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/asm-generic/hyperv-tlfs.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 262fae9526b1..e73a11850055 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -145,6 +145,9 @@ struct ms_hyperv_tsc_page {
>  #define HVCALL_SET_VP_REGISTERS			0x0051
>  #define HVCALL_POST_MESSAGE			0x005c
>  #define HVCALL_SIGNAL_EVENT			0x005d
> +#define HVCALL_POST_DEBUG_DATA			0x0069
> +#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
> +#define HVCALL_RESET_DEBUG_SESSION		0x006b
>  #define HVCALL_RETARGET_INTERRUPT		0x007e
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
> @@ -177,6 +180,7 @@ enum HV_GENERIC_SET_FORMAT {
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>  #define HV_STATUS_INVALID_ALIGNMENT		4
>  #define HV_STATUS_INVALID_PARAMETER		5
> +#define HV_STATUS_OPERATION_DENIED		8
>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>  #define HV_STATUS_INVALID_PORT_ID		17
>  #define HV_STATUS_INVALID_CONNECTION_ID		18
> -- 
> 2.26.2
> 
> -- 
> Cheers,
> Stephen Rothwell


