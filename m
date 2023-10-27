Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765387D8FA1
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbjJ0HWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345389AbjJ0HWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:22:14 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4811B1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:22:12 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40839807e82so10032135e9.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698391331; x=1698996131; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PqXLD4gsUSCQcm/bEiQQT7bGyjP9upwq2OK6iOIPglM=;
        b=JPtXT557nuEe/eKzs/F3x3HQSvrPp30FOmjV7JpKS4PonJsNXzirn48naHQxQ3Vb7f
         R/uLfsoWfuzLkTRAe8cyX+WY+NgoJWYvz6EXpCTrn1GL1YUrJmxH5XtLWglOR+7CuOpJ
         9KD61Jcpkav6WGP3d9P5Nw2clN9IltH0b6DLX/qotApX9nHt0vGUmMfcvXMSM0AvfavR
         t0fr954sCBBgVsYzOGy7NUR+l39JDwQnEoAjFgC8iJUmZhRMfVtPDuYsl7TWcCh/SA0e
         dKpSYMNzPm2mUf7ce8icL41se4jP9GbC7jtaOKDQARPKmO/OsR6h1KwrgZhBpqXP6nbG
         ScMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698391331; x=1698996131;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PqXLD4gsUSCQcm/bEiQQT7bGyjP9upwq2OK6iOIPglM=;
        b=W7moudP49RYuZFXdDVoMcyV1zHH9Fop40ZlXaKItyx74tXLvpCuYdnwgq3qJUpj/9D
         4T/EQgzKBsKYEGgpLhH3at19INTkDVqrsBvSBX2zGaVhVejcOzi2nOQ1mGLLMaYaVexg
         qtDgIHPfXeniLbtNQ1M3saD6oSvcV+CZ9jtsdnz284fah3wha23Mz/1P9oxyUVwuqjMb
         4iRSG6demwHb7MwmApUSm/JYQp4SyzuML8WXteTNHMHIXx3dWS5p/sLw8fGEXl8FXUVj
         +d1p7e5prTnkO1BSgUQtFKGFHLFlpyLCloA0ZMCfwmIPeo8/Vg9h6phvkFHsj0IkW1d5
         S2Dg==
X-Gm-Message-State: AOJu0YzFO+iRu/hq+Bc9ZRpx0UYEAr+JIK64UX1JvQOIG9eW1KJ115U8
        McLutBuQROEyIbfZCPlkqPQ=
X-Google-Smtp-Source: AGHT+IGU6tTMgK6RwsBlq8F1RDINHIo2QB0XP1KOkIfo88Tr96dL8LD0Q31Rr4FqnFe7pGXkQLUMWQ==
X-Received: by 2002:a05:600c:2d8c:b0:408:33ba:569a with SMTP id i12-20020a05600c2d8c00b0040833ba569amr6011223wmg.8.1698391330510;
        Fri, 27 Oct 2023 00:22:10 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id d16-20020adfef90000000b0032326908972sm1126352wro.17.2023.10.27.00.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 00:22:10 -0700 (PDT)
Message-ID: <ae99776d-bf6a-4b24-b617-fde8c76d087d@gmail.com>
Date:   Fri, 27 Oct 2023 08:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 07/28] hw/xen: use correct default protocol for
 xen-block on x86
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
 <20231025145042.627381-8-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-8-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Even on x86_64 the default protocol is the x86-32 one if the guest doesn't
> specifically ask for x86-64.
> 
> Fixes: b6af8926fb85 ("xen: add implementations of xen-block connect and disconnect functions...")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/block/xen-block.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

