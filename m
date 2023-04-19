Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DA16E7B65
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjDSN6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjDSN6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:58:33 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E6C83
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:58:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o9-20020a05600c510900b003f17012276fso1495418wms.4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681912711; x=1684504711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ET1g5s88Za81XSG4fZ4cFV5Ia4lcrv3FS3/NsrLqZkI=;
        b=uuePFdO4v2UghKX+MTK8f0+vrFuq3RyKA3+4cFBeLh6f3cm5V16J/h0owv58trG+GZ
         zN4ymHghx9Zbv2xmOvZdvdf2PAV4DInk90+zayX9cDqjCkaTii9WkDmZBYV0SpCB7z58
         TVAzNGrHwwgnnPy553bQw62K8B/wsq6ygY+a9hS/YRi/8j62lZ8XwDvop+j6a4r1hK/s
         yR7AzswWtRoK2A/9NhXsFHHUBtZvnZc4Kaa2HNZNGlNL+MorUUPr3KP0U2dKeKLg9tI1
         WU5BNY+pTyFfJJSr/42B0v9sD5w8zCoZYA50nePbSM00TJ/IwgdcWx9flHmRi1foibAJ
         P7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912711; x=1684504711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ET1g5s88Za81XSG4fZ4cFV5Ia4lcrv3FS3/NsrLqZkI=;
        b=OgiPEwS8PiXoQgvyAz1lt4UpY8nxLtBckggOfS8ph1C3AqqqTIsMat88daXArSqSm9
         Y+gj2ymSSvMNNtTTl1IOrMCE6iUTcYpAovsw/gaq6eedwB0Qd+c6YiBOskCEbYNGLFlp
         inikD2715O4W+5hxh1XdP5H4a0udsv9IaURC3wKfySomGqnAzXAwXgyZiorSCr9LpTFB
         pWr4RZKQ9YSOHK6it5mHo5egqK0mDYcZ5oaM2FeG6m7EBAlVvynv9NOQGVlfbJgSJMsX
         bgpwr8eQ2pgEP3+dWB7CxvsPZb82aoDgJ2gv//XUqC2LJXRCmFMbF/tvjh4degEAmxU5
         SgZA==
X-Gm-Message-State: AAQBX9eQIEj5JctwR8JNAeg73VuAQ28oK4J3y/ZV1eC2fvhj3Yn2/X85
        PNvo8dvgHqitRWPsP8aEOLLrsQ==
X-Google-Smtp-Source: AKy350YPDnwxScKV5iLOySJXN2pK5mahAe4kPwaLnxfreAdzflU/9hzueCXgz8BTSP+/GWiJeKZLRQ==
X-Received: by 2002:a7b:c848:0:b0:3f1:7368:ccc6 with SMTP id c8-20020a7bc848000000b003f17368ccc6mr7851771wml.25.1681912710867;
        Wed, 19 Apr 2023 06:58:30 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id l26-20020a1ced1a000000b003eeb1d6a470sm2289649wmh.13.2023.04.19.06.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:58:30 -0700 (PDT)
Date:   Wed, 19 Apr 2023 14:58:32 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Fix virtio/rng handling in low entropy
 situations
Message-ID: <20230419135832.GB94027@myrica>
References: <20230413165757.1728800-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413165757.1728800-1-andre.przywara@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 05:57:55PM +0100, Andre Przywara wrote:
> I am not sure we now really need patch 2 anymore (originally I had this
> one before I switched to /dev/urandom). I *think* even a read from
> /dev/urandom can return early (because of a signal, for instance), so
> a return with 0 bytes read seems possible.

Given that this should be very rare, maybe a simple loop would be better
than switching the blocking mode?  It's certainly a good idea to apply the
"MUST" requirements from virtio.

Thanks,
Jean
