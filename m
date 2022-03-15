Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0622E4D968A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 09:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346087AbiCOIo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 04:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346043AbiCOIoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 04:44:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 454ABFF9
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647333790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ws46Mm4AeMY5ZL6XjAXUl4ERDO6VAVFfSe3QGONNiyc=;
        b=Crex/a+lc3C1PNagTN6aSU/ERU6eXe1jRWxjsqdsAtk/DqXn3BRNu2j5/WkvFzUttLZwVN
        rFHsQahN/8z4jVXZNc+rHJRsrpZFeaOBeyuQbTdcX+w/rTbuv91L7VMybiLa4KHzX4DBoz
        z8oIM2jWoqdabo3qs/VVGIzyRjwTd7s=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-TK9d7WzhM2Cs4uHEgzgwYw-1; Tue, 15 Mar 2022 04:43:06 -0400
X-MC-Unique: TK9d7WzhM2Cs4uHEgzgwYw-1
Received: by mail-qv1-f72.google.com with SMTP id n8-20020a0ce488000000b0043519e2750cso16026614qvl.4
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 01:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ws46Mm4AeMY5ZL6XjAXUl4ERDO6VAVFfSe3QGONNiyc=;
        b=u3TTheFugAzfJW5URxvLwZU1NJwZNQ1Wlt3IYrq3zc41qbZyAPumZMJUJC2j452h/n
         jA0AE9vB+4zTvcFEGkw2auKM+3V1KRq3p+38y96ESmLOwkCB/6JUq5xuycgpTjs149r0
         KI6iZDrSQrdkUVnjoxUEUVCNE02H+dpsBjXxH4m9kS9Eet3hoy66I7QJ+ByFbMniaiGb
         bFhzWNRKH11VjrFHO1bvtLtK9g82YluWdsyotzhZI6sv1uNf6mpnK+/oipYDqkBgPHtP
         VToQs+NVcI8BWwUn3bU655/Zt+dT1lxK53jRPmfgrzMmmz0bzPZY+P1eSh0m6t4HdvSi
         d8hw==
X-Gm-Message-State: AOAM532hZAMsoH5dq8EX/p0Sb54Q/X8m4jGSVOP6L+/TucDv2djFz0m+
        QmpuVya7Ur3V3hmbw/6cMZrAF8k9u0QoY4nlyNKq3SMT3dzAEjRZH09jjXiVjPb/3pJIGzMKdN/
        /LVnNFggPX/a0
X-Received: by 2002:a05:6214:411e:b0:435:7ef8:bfef with SMTP id kc30-20020a056214411e00b004357ef8bfefmr20319588qvb.1.1647333786292;
        Tue, 15 Mar 2022 01:43:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3oHkYwl/EHW6+VU5/edFtgukOuNs5P/czgeVeppYp8cc7Uf17rwKyNVm6Cb0TeigCA4dttw==
X-Received: by 2002:a05:6214:411e:b0:435:7ef8:bfef with SMTP id kc30-20020a056214411e00b004357ef8bfefmr20319574qvb.1.1647333786022;
        Tue, 15 Mar 2022 01:43:06 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id a15-20020ac85b8f000000b002e1c6a303f9sm7149201qta.95.2022.03.15.01.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 01:43:05 -0700 (PDT)
Date:   Tue, 15 Mar 2022 09:42:57 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/3] af_vsock: add two new tests for SOCK_SEQPACKET
Message-ID: <20220315084257.lbrbsilpndswv3zy@sgarzare-redhat>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arseniy,

On Fri, Mar 11, 2022 at 10:52:36AM +0000, Krasnov Arseniy Vladimirovich wrote:
>This adds two tests: for receive timeout and reading to invalid
>buffer provided by user. I forgot to put both patches to main
>patchset.
>
>Arseniy Krasnov(2):
>
>af_vsock: SOCK_SEQPACKET receive timeout test
>af_vsock: SOCK_SEQPACKET broken buffer test
>
>tools/testing/vsock/vsock_test.c | 170 +++++++++++++++++++++++++++++++++++++++
>1 file changed, 170 insertions(+)

Thank you for these tests!

I left a few comments and I'm not sure about the 'broken buffer test' 
behavior.

About the series, it sounds like something is wrong with your setup, 
usually the cover letter is "patch" 0. In this case I would have 
expected:

     [0/2] af_vsock: add two new tests for SOCK_SEQPACKET
     [1/2] af_vsock: SOCK_SEQPACKET receive timeout test
     [2/2] af_vsock: SOCK_SEQPACKET broken buffer test

Are you using `git send-email` or `git publish`?


When you will remove the RFC, please add `net-next` label:
[PATCH net-next 0/2], etc..

Thanks,
Stefano

