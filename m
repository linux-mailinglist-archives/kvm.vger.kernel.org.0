Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E40B7D939E
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbjJ0JZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbjJ0JZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:25:58 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FCD40
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:25:54 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40906fc54fdso14523005e9.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698398752; x=1699003552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=omznWtzf1XKHmZ/Z5NbQjoHVHixpWX6ejbkUDaU7VuQ=;
        b=VOU/lcbLzikErx4/yPSJYVhPWHFaRt22Vyx4pkm4GefLjRaC+Dnl0LZk3EDKm5uRJG
         N9ulsjr47zd5KD+9rLsgqh7TW0jH/MtlCvdGP8mIG8u3apV9PHe1fk7KMH9AQTojyp2v
         bt09ZXXeyb7wxJKMHBcMlJCzsiQ91IhvbFuSmbXRMu8GQjOBl+Mq7/yFMJU5GydwXagn
         623yT1D3tjM3QCwMlAAL/KRAFJHEiaGzt//fZtVXCC8HB8FpBTRepjaayW+aseJMYVJ7
         GUzLmXMBJAkBpOR07JQVhleMwXMH3YUC350WulDKZcdhkzK/op1vFEz24wAADp22tt0z
         /xaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698398752; x=1699003552;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omznWtzf1XKHmZ/Z5NbQjoHVHixpWX6ejbkUDaU7VuQ=;
        b=NPJAgovLkGZjgcsrRl9hoe54lRv9lGDmDH/Q3QMkicSGsnQbdxiZ79xDL/GV34TY0d
         36yw7q0i5ADP5d++0CXBxVVgcJhyKlSmEwzMUKyBHDTySDBFhUZpEbum7k4v6j+X+2v+
         xAGjpZVrCErzragTRDJ4sph9JKkro6xZ2lipdu9x0MJ3JH70GCKPnGPAWzsN0i0XAho6
         Dan+rVmrTp1bxUJXTFmfO0hluLnXwYfO1nwfm5o9LXmAeHCB4VhxRdDAcxn48fEuC01K
         oQkJc/CLaRzGEvDQkQhhWbGdbh3uF3GwTp0lUi+YhB+FWoiN4Xpd4ck6OWVLj9YIwYCJ
         rr6w==
X-Gm-Message-State: AOJu0YyEWoiiPOKqpiGRjKeuVw+Q6ROZQqslWjwJhUHjVQH56/jud1+h
        qpLCZf7g7jQYD9Vn1EZQhPw=
X-Google-Smtp-Source: AGHT+IHJSsP+G8xwzCbhqRxELYFim76cG7KxRmQWj9AASSXVf0gXlQDLn+wC5l6TMdiRtV9QnIFltg==
X-Received: by 2002:a05:600c:468e:b0:408:3739:68fd with SMTP id p14-20020a05600c468e00b00408373968fdmr1901178wmo.6.1698398751572;
        Fri, 27 Oct 2023 02:25:51 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id s13-20020a05600c45cd00b004083bc9ac90sm1171371wmo.24.2023.10.27.02.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:25:51 -0700 (PDT)
Message-ID: <e4bf8f7a-9635-4315-b0e1-6dfb6c524631@gmail.com>
Date:   Fri, 27 Oct 2023 10:25:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 22/28] net: add qemu_{configure,create}_nic_device(),
 qemu_find_nic_info()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-23-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-23-dwmw2@infradead.org>
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

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Most code which directly accesses nd_table[] and nb_nics uses them for
> one of two things. Either "I have created a NIC device and I'd like a
> configuration for it", or "I will create a NIC device *if* there is a
> configuration for it".  With some variants on the theme around whether
> they actually *check* if the model specified in the configuration is
> the right one.
> 
> Provide functions which perform both of those, allowing platforms to
> be a little more consistent and as a step towards making nd_table[]
> and nb_nics private to the net code.
> 
> Also export the qemu_find_nic_info() helper, as some platforms have
> special cases they need to handle.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   include/net/net.h |  7 ++++++-
>   net/net.c         | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 57 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

