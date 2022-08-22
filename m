Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6A059C4E2
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbiHVRSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 13:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237139AbiHVRSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 13:18:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D70B25C1
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661188696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDT0NzG0FkOZTyIfEMiwc/td94ymUGlK2/HiuIYhkVw=;
        b=VCRD7T2Vikex064ekKgNnYPzP/DAPAtkiZSxAyuufUTDmOA6cud1sDCKaJrtoxiUiD6hvK
        UhWidu46vjYjS0YeHcrsgJjDCQBaxLqulbRzLo7ztbElbFsZdIJBSeL1vXNe6Psyzb2BhP
        h7S4mRR3Plg9MD1zLxvsbEel1nOjPOE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-668-tRhp4O2KNcaT31G3ymsGkw-1; Mon, 22 Aug 2022 13:18:15 -0400
X-MC-Unique: tRhp4O2KNcaT31G3ymsGkw-1
Received: by mail-wm1-f70.google.com with SMTP id r10-20020a1c440a000000b003a538a648a9so6644457wma.5
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 10:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fDT0NzG0FkOZTyIfEMiwc/td94ymUGlK2/HiuIYhkVw=;
        b=YpViFdiTYfKNr59hh6Pboj+bbr3dbW3471jtIbCX0klYOLXWd7MkvVbjLB13hiptjL
         utSl8uq3rEjldhWZs5wOaSo9EXRX9BEzwUDT3cY84cmQGplIH/+1M2dA9VDEaYB9X6Qz
         zQLNzQqLoDBSXDbwr+ncOk3wzjsOco2TkKFtdGu8hABNO2/UUHkvXP6vrWkmCpve23eF
         ZPHO6pAup22bfh+xy6ZjeGaJhkznMOaoCuzdg5dw3lGvEEcylvukkQRcdEnpld4BmbUr
         MLHCfB6sN9VGdeEpLa8uO7cm50mqWaKqbOqv1lMkrQhMO6ReUOlnI3ZuONa7juj0GcCF
         UBWA==
X-Gm-Message-State: ACgBeo0ML03KnLwlzwepRLZZgiA1x2ji5vmwYS9jV4WH/3PsSb4Xxwkq
        6Cw7TMypRTsAJtLn1clhzY8nSgthttnDcXAumJzJF0megc2wEWDK8Gd0sRIlN2mXESdubz9uvdt
        iGv3/fMQrOW7S
X-Received: by 2002:a05:600c:42ca:b0:3a6:3b06:92bd with SMTP id j10-20020a05600c42ca00b003a63b0692bdmr9729426wme.11.1661188694048;
        Mon, 22 Aug 2022 10:18:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6+IYglItshBwaPPpRAzS01T43FN9+dUi4FLjFhCug7p7YEh483os0Z+YBPlQqSBN5wAQivlA==
X-Received: by 2002:a05:600c:42ca:b0:3a6:3b06:92bd with SMTP id j10-20020a05600c42ca00b003a63b0692bdmr9729415wme.11.1661188693822;
        Mon, 22 Aug 2022 10:18:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id x2-20020adfffc2000000b0021e5bec14basm11950426wrs.5.2022.08.22.10.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 10:18:13 -0700 (PDT)
Message-ID: <aac8f6c9-c817-cde3-03ef-5c203899d269@redhat.com>
Date:   Mon, 22 Aug 2022 19:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] mailmap: Update Oliver's email address
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
References: <20220819190158.234290-1-oliver.upton@linux.dev>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220819190158.234290-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/19/22 21:01, Oliver Upton wrote:
> While I'm still at Google, I've since switched to a linux.dev account
> for working upstream.
> 
> Add an alias to the new address.
> 
> Signed-off-by: Oliver Upton<oliver.upton@linux.dev>

Queued, thanks.

Paolo

