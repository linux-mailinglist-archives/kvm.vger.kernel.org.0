Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE2660CE6C
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 16:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiJYOId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 10:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiJYOIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 10:08:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FB5AE5A
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 07:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666706673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0X8kLg2Mr973JDZDwXtu8QCMF/fjU13T2x78OSbPG6M=;
        b=aTaJmngn8jFulhuCTwjMDtnxTLMk7oCl16yrNXOPePMPijBG+L3q5dNhi7YuAJqfmouWpx
        w8YRrx5YuGoyvG8KI1bJ91bZpmMJ68J1CVeyx2XGONLrQehFERud7Wi53gTeo/230Co/uv
        pm6Nl4eVKclnQq/a4MKmMF3H8+0O5eQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-qYmj1ikBNj2DVP1icGR1Bg-1; Tue, 25 Oct 2022 10:04:31 -0400
X-MC-Unique: qYmj1ikBNj2DVP1icGR1Bg-1
Received: by mail-qt1-f198.google.com with SMTP id gd8-20020a05622a5c0800b0039cb77202eeso9067135qtb.0
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 07:04:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0X8kLg2Mr973JDZDwXtu8QCMF/fjU13T2x78OSbPG6M=;
        b=yL8+85RHVzRlbOHi6w2n4jdXY/kLobPa530nvar6TS3jfZrk+jXi+DqV8v0pGfAuQK
         dJ4pclbUN4czILCs0PLP96285KC3UA7G3mNhf32PwoX8+x02RVNfEmm5itSSWI08/1BT
         GiVa2vPCgBrFYCaeIaPkFLiv2S5B2Q1T3cm6n/OUFHK3KGpzQ+Vcopnz9+BAV1+QHiTG
         gdzEaXOcX1dXzC1MGScGGiNPjNAst2x8Ho1A3VCDV0ZkBWZRQlW12TnsnDvu8vJ1ENDu
         RyqZex/sJ24IzbZEudMkSVeWyl5Dq2wVG8pi+itbuDHQvlYPDE0Oplh+NReIno33J3yA
         aE2w==
X-Gm-Message-State: ACrzQf01fY1W/X+ItXqIb7lA4a0ZjJtDD6fHHSFdEN/zvpWi4VjPoz4h
        KBPmEP9Z5lBIxGY8sTwQC0Zad57oMy6zTUqAuCGyAzi0auc32nTHotZ66LdLtWLecG9p8yd5C59
        w2l6CNXHaNHCk
X-Received: by 2002:ac8:7dc4:0:b0:39c:f95f:57fe with SMTP id c4-20020ac87dc4000000b0039cf95f57femr29366989qte.612.1666706670653;
        Tue, 25 Oct 2022 07:04:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4XDj2ZdcO2vuP0fTuPj6T4P9ZM3WwYYv3unxfrrCyKXPFtK9hBdVhf8XXPJM9IGvLFJ0f4Hw==
X-Received: by 2002:a05:620a:f10:b0:6cf:c0a6:5b1a with SMTP id v16-20020a05620a0f1000b006cfc0a65b1amr26171178qkl.121.1666706659581;
        Tue, 25 Oct 2022 07:04:19 -0700 (PDT)
Received: from [10.201.49.36] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.googlemail.com with ESMTPSA id k11-20020a05620a0b8b00b006cf3592cc20sm2069623qkh.55.2022.10.25.07.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 07:04:19 -0700 (PDT)
Message-ID: <22694a62-7c64-671b-a885-12b67ab2b5e9@redhat.com>
Date:   Tue, 25 Oct 2022 16:04:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [kvm-unit-tests GIT PULL 00/22] s390x: tests and fixes for PV,
 timing
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/22 13:43, Claudio Imbrenda wrote:
> * library fixes to allow multi-cpu PV guests
> * additional tests and fixes for uv-host
> * timing tests and library improvements
> * misc fixes

Merged, thanks!

Paolo

