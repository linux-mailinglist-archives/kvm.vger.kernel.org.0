Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EF76522F4
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiLTOpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiLTOpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:45:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2751ADA2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671547482;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d1GQMUICO6xYhLtmXgALecJ35uu1YT3hnQQmSZ/JoBo=;
        b=IxTCt33qHCa5cLiNnw03EpQorMO5ZcOsiPwjVSUO8gTOaDn8uUK3DXlqsWV94D4D6+n77g
        wEmhMKUz9jCAVyTvKpQVkUsJ4ixx6eFd6tlb2slEV1SP1CsD1C/C0kL5ihzYCVGujVSpu3
        aDyZ+/NKoxPgST9Fw4pawVpvTb0rUPA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-ydMB-aspPqiZcfRjT7B0kw-1; Tue, 20 Dec 2022 09:44:38 -0500
X-MC-Unique: ydMB-aspPqiZcfRjT7B0kw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F819280559B;
        Tue, 20 Dec 2022 14:44:38 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 76AEF112132D;
        Tue, 20 Dec 2022 14:44:37 +0000 (UTC)
Date:   Tue, 20 Dec 2022 14:44:35 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 2/3] accel/kvm: Silent -Wmissing-field-initializers
 warning
Message-ID: <Y6HKUyUmjZ8LzsSJ@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20221220143532.24958-1-philmd@linaro.org>
 <20221220143532.24958-3-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221220143532.24958-3-philmd@linaro.org>
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

On Tue, Dec 20, 2022 at 03:35:31PM +0100, Philippe Mathieu-Daudé wrote:
> Silent when compiling with -Wextra:
> 
>   ../accel/kvm/kvm-all.c:2291:17: warning: missing field 'num' initializer [-Wmissing-field-initializers]
>         { NULL, }
>                 ^
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  accel/kvm/kvm-all.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

