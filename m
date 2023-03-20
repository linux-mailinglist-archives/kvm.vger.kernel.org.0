Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B236C13F0
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjCTNtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjCTNtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:49:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C547EC6
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679320112;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nB8jDRvF4InxzdYsKwDk5IU8RqNst0djb4nl+V9qIeY=;
        b=bIeutRX8Z3wfQo0zeakwGDXdKrRCxs+rJ9JMbvICrDeUf8Zd1uYmfF84IgEJAvPojIKw7+
        U45Kzx7KIjNy0YZ+nYjew5zr5z4cH7P4gbX6giL56pJak+KqdsZ6hoZ9mM/YwEsRGcaSv4
        /XohY1KQCC8JOwhnrzwlFx/eHaRqRvM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-CV0XY9JSOlCYuAhr_QvM2g-1; Mon, 20 Mar 2023 09:48:28 -0400
X-MC-Unique: CV0XY9JSOlCYuAhr_QvM2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DACD800B23;
        Mon, 20 Mar 2023 13:48:27 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 957E8C15BA0;
        Mon, 20 Mar 2023 13:48:21 +0000 (UTC)
Date:   Mon, 20 Mar 2023 13:48:18 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, qemu-block@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Tyrone Ting <kfting@nuvoton.com>, Hao Wu <wuhaotsh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefan Weil <sw@weilnetz.de>, Riku Voipio <riku.voipio@iki.fi>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: Re: [PATCH-for-8.1 4/5] bulk: Do not declare function prototypes
 using extern keyword
Message-ID: <ZBhkIjelEtR7lckj@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230320134219.22489-1-philmd@linaro.org>
 <20230320134219.22489-5-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230320134219.22489-5-philmd@linaro.org>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 02:42:18PM +0100, Philippe Mathieu-Daudé wrote:
> By default, C function prototypes declared in headers are visible,
> so there is no need to declare them as 'extern' functions.
> Remove this redundancy in a single bulk commit; do not modify:
> 
>   - meson.build (used to check function availability at runtime)
>   - pc-bios
>   - libdecnumber
>   - *.c
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  block/dmg.h                    |  8 +++----
>  bsd-user/bsd-file.h            |  6 ++---
>  crypto/hmacpriv.h              | 13 +++++------
>  hw/xen/xen_pt.h                |  8 +++----
>  include/crypto/secret_common.h | 14 +++++-------
>  include/exec/page-vary.h       |  4 ++--
>  include/hw/misc/aspeed_scu.h   |  2 +-
>  include/hw/nvram/npcm7xx_otp.h |  4 ++--
>  include/hw/qdev-core.h         |  4 ++--
>  include/qemu/crc-ccitt.h       |  4 ++--
>  include/qemu/osdep.h           |  2 +-
>  include/qemu/rcu.h             | 14 ++++++------
>  include/qemu/sys_membarrier.h  |  4 ++--
>  include/qemu/uri.h             |  6 ++---
>  include/sysemu/accel-blocker.h | 14 ++++++------
>  include/sysemu/os-win32.h      |  4 ++--
>  include/user/safe-syscall.h    |  4 ++--
>  target/i386/sev.h              |  6 ++---
>  target/mips/cpu.h              |  4 ++--
>  tcg/tcg-internal.h             |  4 ++--
>  tests/tcg/minilib/minilib.h    |  2 +-
>  include/exec/memory_ldst.h.inc | 42 +++++++++++++++++-----------------
>  roms/seabios                   |  2 +-

Accidental submodule commit.,

>  23 files changed, 84 insertions(+), 91 deletions(-)
> 
> diff --git a/block/dmg.h b/block/dmg.h
> index e488601b62..ed209b5dec 100644
> --- a/block/dmg.h
> +++ b/block/dmg.h
> @@ -51,10 +51,10 @@ typedef struct BDRVDMGState {
>      z_stream zstream;
>  } BDRVDMGState;
>  
> -extern int (*dmg_uncompress_bz2)(char *next_in, unsigned int avail_in,
> -                                 char *next_out, unsigned int avail_out);
> +int (*dmg_uncompress_bz2)(char *next_in, unsigned int avail_in,
> +                          char *next_out, unsigned int avail_out);
>  
> -extern int (*dmg_uncompress_lzfse)(char *next_in, unsigned int avail_in,
> -                                   char *next_out, unsigned int avail_out);
> +int (*dmg_uncompress_lzfse)(char *next_in, unsigned int avail_in,
> +                            char *next_out, unsigned int avail_out);

These are variable declarations, so with this change you'll get multiple
copies of the variable if this header is included from multiple source
files. IOW, the 'extern' usage is correct.

> diff --git a/roms/seabios b/roms/seabios
> index ea1b7a0733..3208b098f5 160000
> --- a/roms/seabios
> +++ b/roms/seabios
> @@ -1 +1 @@
> -Subproject commit ea1b7a0733906b8425d948ae94fba63c32b1d425
> +Subproject commit 3208b098f51a9ef96d0dfa71d5ec3a3eaec88f0a

Nope !

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

