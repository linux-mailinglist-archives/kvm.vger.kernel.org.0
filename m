Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C0C7D5653
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbjJXP3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjJXP3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:29:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016691987
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:19:23 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32df66c691dso1712402f8f.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698160762; x=1698765562; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VEfz8HGhwcX+gjgFcsp72jn1Jb62YijVFIO7IeDxV9U=;
        b=dpmJ3Ezvclwjg56KpdK7TphxrK2GgAhsYpmDhzvYwXgkknysPqt8zyMMOOFBuec5wo
         Ue2mzzRBqg59PYqVPWnYIXmxKWCda9n9e1D3NfkErAmuqmsO6zwMkgTiCG5BHBeWBLic
         94lcbmi4Vp7m/CtHyFravw4I2BhskiERZdVE8xSeG5R6jpQUYC4j0MkfsCYh1bdPZ5yn
         h9Jdzd3+4l20t/5VY8pH03o7lAOCqpyJvMcT80djvguMtM0bAw6QlfEcj2yrVekMiRDH
         70ElYrcuwkPV13c9Z8YP2uog5j7L0NLlCX4MPeToQoMc90n7lXYiWLpnp8uCiFkk+9/m
         iBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698160762; x=1698765562;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEfz8HGhwcX+gjgFcsp72jn1Jb62YijVFIO7IeDxV9U=;
        b=WvJmwxpVClWTF5BDgVrJrz8/M5975knuBXEDqFDD9edi3wuU1ZuguxR6lymIOFav6V
         k9idLhoChKTLy1jT/S/pDeBsmXbkqFR69dgHDdmVOJ5jubP4yqvFL+f+TGcZ8XR+yHDu
         pvv2ZCGYkLQIkYMIbx2lrGH0HU9RBF5AGQJcdk4vrq6I8hpHr2SaFYYC6zhH/F4/dOSP
         93Tk3fnt+661FC7b5bQ0fnHgOS++TlDDMc0vkNWlq/q/cdvrZtikIG8vCNi21qnAAi0T
         4ZzdqsX1uIHERSgk0VwnkBnMnKCPG44FtdoVtqokNACND1yV44B92EGx5s3gqdWcSD5z
         8hmA==
X-Gm-Message-State: AOJu0YxVNa3BIwTakFHI/dhNxlVlJNWHs9xGF+mt+thaRqmAqJJnmQdn
        /+9emwuSgPo/MIv5VtF5VB0=
X-Google-Smtp-Source: AGHT+IFftEtEWBlIWSE4+gB3PiSf+ybDx5RYYWCq9oIN1LDrIU9iRO6mz1Q4jl+RB/Bs7pJY5A6gBQ==
X-Received: by 2002:adf:ef42:0:b0:32d:aa14:875d with SMTP id c2-20020adfef42000000b0032daa14875dmr9015766wrp.29.1698160762122;
        Tue, 24 Oct 2023 08:19:22 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id n1-20020a5d4001000000b0032dc1fc84f2sm10223557wrp.46.2023.10.24.08.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:19:21 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <88ce2b55-c933-4c72-933f-c8cd10470c7f@xen.org>
Date:   Tue, 24 Oct 2023 16:19:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 05/24] hw/xen: fix XenStore watch delivery to guest
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
 <20231019154020.99080-6-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231019154020.99080-6-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/2023 16:40, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When fire_watch_cb() found the response buffer empty, it would call
> deliver_watch() to generate the XS_WATCH_EVENT message in the response
> buffer and send an event channel notification to the guest… without
> actually *copying* the response buffer into the ring. So there was
> nothing for the guest to see. The pending response didn't actually get
> processed into the ring until the guest next triggered some activity
> from its side.
> 
> Add the missing call to put_rsp().
> 
> It might have been slightly nicer to call xen_xenstore_event() here,
> which would *almost* have worked. Except for the fact that it calls
> xen_be_evtchn_pending() to check that it really does have an event
> pending (and clear the eventfd for next time). And under Xen it's
> defined that setting that fd to O_NONBLOCK isn't guaranteed to work,
> so the emu implementation follows suit.
> 
> This fixes Xen device hot-unplug.
> 
> Fixes: 0254c4d19df ("hw/xen: Add xenstore wire implementation and implementation stubs")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_xenstore.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
> index 660d0b72f9..82a215058a 100644
> --- a/hw/i386/kvm/xen_xenstore.c
> +++ b/hw/i386/kvm/xen_xenstore.c
> @@ -1357,10 +1357,12 @@ static void fire_watch_cb(void *opaque, const char *path, const char *token)
>       } else {
>           deliver_watch(s, path, token);
>           /*
> -         * If the message was queued because there was already ring activity,
> -         * no need to wake the guest. But if not, we need to send the evtchn.
> +         * Attempt to queue the message into the actual ring, and send
> +         * the event channel notification if any bytes are copied.
>            */
> -        xen_be_evtchn_notify(s->eh, s->be_port);
> +        if (put_rsp(s) > 0) {
> +            xen_be_evtchn_notify(s->eh, s->be_port);
> +        }

There's actually the potential for an assertion failure there; if the 
guest has specified an oversize token then deliver_watch() will not set 
rsp_pending... then put_rsp() will fail its assertion that the flag is true.

   Paul

>       }
>   }
>   

