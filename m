Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A9E6522E6
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiLTOnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiLTOnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:43:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7651012AB5
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671547387;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CqJYR9K3jFJrTzhaRCwv2Yb3dP4lQ2MezcXHFtzEQlc=;
        b=U5I02isX91kVO0x1z76nQBA5WCg7HuPGxClyEztClDvTOOEkgCUaiiBtDK3kvyCWp/VE/G
        Rx752oKdu2mTWuym4UCAJD5kXWaN/QSSJ8J2kQ5EtGt3vYQAtR/FAB+D7wcZJB6dEdsBgm
        xsVSIzIUGttTpAQQEmvgW+jY11DpFEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-ImH0RgviNtG7s1PLEnUpJw-1; Tue, 20 Dec 2022 09:43:04 -0500
X-MC-Unique: ImH0RgviNtG7s1PLEnUpJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2112101A55E;
        Tue, 20 Dec 2022 14:43:03 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8367112132C;
        Tue, 20 Dec 2022 14:43:02 +0000 (UTC)
Date:   Tue, 20 Dec 2022 14:43:00 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 1/3] tcg: Silent -Wmissing-field-initializers warning
Message-ID: <Y6HJ9KI8Hmgk4+s4@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20221220143532.24958-1-philmd@linaro.org>
 <20221220143532.24958-2-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221220143532.24958-2-philmd@linaro.org>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 03:35:30PM +0100, Philippe Mathieu-Daudé wrote:
> Silent when compiling with -Wextra:
> 
>   tcg/i386/tcg-target.opc.h:34:1: warning: missing field 'args_ct' initializer [-Wmissing-field-initializers]
>   DEF(x86_punpckl_vec, 1, 2, 0, IMPLVEC)
>   ^
>   ../tcg/tcg-common.c:30:66: note: expanded from macro 'DEF'
>          { #s, oargs, iargs, cargs, iargs + oargs + cargs, flags },
>                                                                  ^
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  tcg/tcg-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

