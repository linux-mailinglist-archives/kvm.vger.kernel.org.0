Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DBE60DF73
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 13:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiJZLYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 07:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiJZLYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 07:24:05 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC8C896E
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 04:24:04 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id r19so9614260qtx.6
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 04:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sx2xbr1NC8AnnRMO3Ei0gCkeI1CeU4UmyXqu0gB41xU=;
        b=eZhpqPZev3eEn+/ZDv3mkRCAwXZYi7i39WaphRbGffBc3qzCoy4bcckeJdjIqd0blf
         NE96B2+mqBKuSCYTI4WjJ5eLkjTq2hZOabIxs6sXcD2RY11oA+szVBs/nWXOzUGHBOj1
         HIzUiH4rEzCFmVSoaKjRuQ8f71ViXRbOtnvk2Rai6EwOru/M59/22zrYSG2FAZV3aRcn
         Z9GRisuZtM9CEx1GPU2w1UEjiiM6C9sam955LEkooI32L44R/IBMZMiO+fVNZY0KZ0mR
         k6b8zwfE+KnxXBKpfcrK7HNaaTP7beU7R29UQpIfCOenA29HaIXJzZcnavGzJjwCE7Yr
         QUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sx2xbr1NC8AnnRMO3Ei0gCkeI1CeU4UmyXqu0gB41xU=;
        b=WOCNIItoD5tMYgoB5vTJH2d43qV81JezmeOnlAm/cszblEjGsdvZ6ypWd5vGQPGeEP
         eAvWESv03J9fdL7I9mhlDbbrsZg6rr5yr6EKnBwon2x40NPBeZQtaANJCMcjgiRnCKNI
         /A/MRXSao/rdgFq5FWjhZs4z4d/YAulJXVcOKiH4eOdPUCEqi55e05u17ExpRABGtiB6
         DaPRa4NP5q0LItcmEIIXgsLNEUI3Ofzz8yiLkUw+mfnp6A1FsQnwykeiKNI6suds2nW5
         FDf21hxUwlXo1TDksAbtd/nPyGGqg2Kj/Eaqc8eK/ZD7NKZV8wB5LREMe3/2qCqZXpNk
         bhig==
X-Gm-Message-State: ACrzQf3zS5VfLWCLaMx10FxcE5CW3mrN+Qiw7ZsGXgJtX5Y9+bIIHQgx
        j88lVoQU9tlpDFICV4t3gUIpOA==
X-Google-Smtp-Source: AMsMyM53MmKfoUw3RTYXw+GXtejS2UbZc/Rxdgq2UxTG0npK6A799BitC/RL7xBfz6FBBeJEo4xQ7g==
X-Received: by 2002:a05:622a:1002:b0:39c:d841:9ad6 with SMTP id d2-20020a05622a100200b0039cd8419ad6mr35685003qte.572.1666783443422;
        Wed, 26 Oct 2022 04:24:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id x11-20020a05620a258b00b006ceb933a9fesm3837229qko.81.2022.10.26.04.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 04:24:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oneVs-00Fn3C-4D;
        Wed, 26 Oct 2022 08:24:00 -0300
Date:   Wed, 26 Oct 2022 08:24:00 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Anthony DeRossi <ajderossi@gmail.com>
Cc:     kvm@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        yishaih@nvidia.com, kevin.tian@intel.com
Subject: Re: [PATCH] vfio: Decrement open_count before close_device()
Message-ID: <Y1kY0I4lr7KntbWp@ziepe.ca>
References: <20221025193820.4412-1-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025193820.4412-1-ajderossi@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022 at 12:38:20PM -0700, Anthony DeRossi wrote:
> The implementation of close_device() for vfio-pci inspects the
> open_count of every device in the device set to determine whether a
> reset is needed. Unless open_count is decremented before invoking
> close_device(), the device set will always contain a device with
> open_count > 0, effectively disabling the reset logic.

This seems to miss the reason why this was done:

    Eliminate the calls to vfio_group_add_container_user() and add
    vfio_assert_device_open() to detect driver mis-use. This causes the
    close_device() op to check device->open_count so always leave it elevated
    while calling the op.

If we let it be zero then vfio_assert_device_open() will trigger on
other drivers.

I think the best approach is to change vfio_pci to understand that
open_count == 1 means it is the last close.

Thanks,
Jason
