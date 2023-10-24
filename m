Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC757D54A3
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjJXPEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjJXPEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:04:05 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343D510C9
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:04:03 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40839807e82so26865215e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698159841; x=1698764641; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C1Qt2wllMLDF+l8+9ma3m0C77TgrERD8kIo4WEkyC+k=;
        b=NBZrLr8vbh7nXV9sl5Ipz9pDFj6GgQPa2tuNlNILveVNVsU7+PMl19nl+N/z2Hf9+j
         pHtH+zrGTMcArr1NvjN2FuoYGDYRbwoRLssRG1WkUg9uGV/Y8m0EQ7n0zruA7ensFQiW
         M26nSJQpVriM7Az4tWr9yc87sUhvCq22VMXzKTUTc3KeueS8Undoll5yfxs7wwMuxFhu
         cP6Dz74s6i04uJm30pN8paPGkr0BBCGATEDIqxzVGFDhOdTnEuWQfa6/bAetLZ3G/fhy
         siMpj58EfLoDlZO/LcyiUUlaMWl/NmquGx3BSrKClZw5K3Zm2ubn5QhOIw0eLf7k9PAB
         n0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698159841; x=1698764641;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1Qt2wllMLDF+l8+9ma3m0C77TgrERD8kIo4WEkyC+k=;
        b=hwPO+jBnN7fEOaKU5XbtSJLh4onzEIgjcip0J/4ijnd2jRzJvJR+mr50LyIR6v4CHQ
         DlfGF1HTA/OY51mrWi1K2/Rp/MbCaH3jYjKz2/+Nt9EAnOPSHMfDsWW8YeEZUelxurqm
         DNzGkdLqhNpKDpqoqgok14U+5SJ3nyfero1iBeWjzSReaRRMRS/M58RiYXAY0DyC17p3
         zoiH3G8yrbGVbrIUnKWYQC6UaqRy2Zr5CL6UT1TFdJ43It8ch+Lnq0sDCbL4RIhqUbAG
         qUaxRVGOw9fJLP05bkEY430/pyfnECXw66nbGwsVpc6kxGccddqG9ILEl2I7zm5+aUNC
         e4hw==
X-Gm-Message-State: AOJu0Yz7RDfufm6qDw5wl4MRxM2t1kjEkYG9Umqv02bzjMfDse2BZusl
        dZKx0c1kD+2Px48bN3j3bFc=
X-Google-Smtp-Source: AGHT+IGm54ISKlvZ6ARRotUsrpXMLiaRdkUDxht2f3+ks747mTY2+cIYmiFMPEYmjUe2mjy+rnM4zA==
X-Received: by 2002:a05:600c:450d:b0:405:409e:1fcb with SMTP id t13-20020a05600c450d00b00405409e1fcbmr12972927wmo.5.1698159841241;
        Tue, 24 Oct 2023 08:04:01 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id f5-20020a056000128500b0031c6581d55esm10091262wrx.91.2023.10.24.08.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:04:00 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c13a1ff5-0853-41f7-883d-abae08f9ad09@xen.org>
Date:   Tue, 24 Oct 2023 16:03:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 04/24] hw/xen: don't clear map_track[] in
 xen_gnttab_reset()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231019154020.99080-1-dwmw2@infradead.org>
 <20231019154020.99080-5-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231019154020.99080-5-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 16:40, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The refcounts actually correspond to 'active_ref' structures stored in a
> GHashTable per "user" on the backend side (mostly, per XenDevice).
> 
> If we zero map_track[] on reset, then when the backend drivers get torn
> down and release their mapping we hit the assert(s->map_track[ref] != 0)
> in gnt_unref().
> 
> So leave them in place. Each backend driver will disconnect and reconnect
> as the guest comes back up again and reconnects, and it all works out OK
> in the end as the old refs get dropped.
> 
> Fixes: de26b2619789 ("hw/xen: Implement soft reset for emulated gnttab")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_gnttab.c | 2 --
>   1 file changed, 2 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

