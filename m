Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C785B3148
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIIICv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiIIICr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4CB915C3
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662710565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzEprpmYDxZoU/iLdscba5yKn41f2daHNxZoCNCbLwo=;
        b=B3TlE6MIu6iSHO5pZPYOuzxtuXZR0QtPW6KUgC+qIzxvP8JmpJxWZsGuPllenSXQw08/K2
        pdhdDFqxio/bM+5oDAbPCEAgPehBLbeRWjTpq01ZFF9DFe/WutF4rS18DFIP4pkjN95MQG
        M6oqCp0eT/31iykwBAq9La875o21tmQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-zXer8nFVPEuUfjyN3U6U3Q-1; Fri, 09 Sep 2022 04:02:44 -0400
X-MC-Unique: zXer8nFVPEuUfjyN3U6U3Q-1
Received: by mail-qt1-f198.google.com with SMTP id bz20-20020a05622a1e9400b003436a76c6e6so925547qtb.1
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 01:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yzEprpmYDxZoU/iLdscba5yKn41f2daHNxZoCNCbLwo=;
        b=4tYloq5HIyAx+iEFSDF5+c/aeu4ruhH3fGkuODCS7qAW9X1zlEkhU+XtvSkP6Sh4aE
         OdlGVS2+slgLYtA+jJrnqqz6dookATMIrJ/u7Ckf7sBYhnebdn2wV06RwWQ6XzlGxi7P
         MhKv22sRB7SJqO4iNzy8YRSHoQd+ixPgyinS/iPgKkQ2juXF6Vld5vnNqXyu3ZWkYVxr
         wuXueX6m6qEt1+MDYCf8o5RDU4aEe4KCKLLpqzrDDdTa0RmcCLERUYAxVNPPoKhOpQOr
         wkD9Jhl2LT6UV0YdVb1g9lphGxPjqOJiUnWYnfmlj2NiBn9QogvBlVZ0epfShDESik5a
         mdTA==
X-Gm-Message-State: ACgBeo1BHM5eF7zgntGxwFwo2LfR0Uiha/snOizOaI87XXew7kTRdhZS
        iVqS4fxrylC1x++kV38huddPXMGTwBVyK5eQrBISy1uicTOyj/qoiwT5gYWJl/IQrfWRVbEZReF
        +RUpponXFZHRn
X-Received: by 2002:a05:620a:192a:b0:6bc:5bb:ffe6 with SMTP id bj42-20020a05620a192a00b006bc05bbffe6mr9337377qkb.268.1662710563626;
        Fri, 09 Sep 2022 01:02:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4iEFAhLPrQKHexiJaIz+0O/BxP+mb3Uf6thTAzqXRTKL23hztrcJ82I1vFiM2v0zkIdQqdCQ==
X-Received: by 2002:a05:620a:192a:b0:6bc:5bb:ffe6 with SMTP id bj42-20020a05620a192a00b006bc05bbffe6mr9337364qkb.268.1662710563425;
        Fri, 09 Sep 2022 01:02:43 -0700 (PDT)
Received: from ?IPV6:2a04:ee41:4:31cb:e591:1e1e:abde:a8f1? ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id s5-20020a05620a254500b006bb9e4b96e6sm934946qko.24.2022.09.09.01.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 01:02:42 -0700 (PDT)
Message-ID: <ce712ede-5d9a-5675-321a-afa402cd1d61@redhat.com>
Date:   Fri, 9 Sep 2022 10:02:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 1/2] softmmu/memory: add missing begin/commit callback
 calls
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-2-eesposit@redhat.com> <Yv6UVMMX/hHFkGoM@xz-m1.local>
 <e5935ba7-dd60-b914-3b1d-fff4f8c01da3@redhat.com>
 <YwjVG+MR8ORLngjd@xz-m1.local> <YwqGtHrcsFrgzLzg@xz-m1.local>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YwqGtHrcsFrgzLzg@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 27/08/2022 um 23:03 schrieb Peter Xu:
> On Fri, Aug 26, 2022 at 10:13:47AM -0400, Peter Xu wrote:
>> On Fri, Aug 26, 2022 at 03:53:09PM +0200, Emanuele Giuseppe Esposito wrote:
>>> What do you mean "will empty all regions with those listeners"?
>>> But yes theoretically vhost-vdpa and physmem have commit callbacks that
>>> are independent from whether region_add or other callbacks have been called.
>>> For kvm and probably vhost it would be no problem, since there won't be
>>> any list to iterate on.
>>
>> Right, begin()/commit() is for address space update, so it should be fine
>> to have nothing to commit, sorry.
> 
> Hold on..
> 
> When I was replying to your patch 2 and reading the code around, I fount
> that this patch does affect vhost..  see region_nop() hook and also vhost's
> version of vhost_region_addnop().  I think vhost will sync its memory
> layout for each of the commit(), and any newly created AS could emptify
> vhost memory list even if registered on address_space_memory.
> 
> The other thing is address_space_update_topology() seems to be only used by
> address_space_init().  It means I don't think there should have any
> listener registered to this AS anyway.. :) So iiuc this patch (even if
> converting to loop over per-as memory listeners) is not needed.
> 
Agree, dropping this patch :)

Emanuele

