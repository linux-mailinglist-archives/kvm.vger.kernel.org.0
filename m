Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7B51E22D
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 01:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444772AbiEFW3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 18:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444739AbiEFW24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 18:28:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2F7151E60
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 15:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651875910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RgFbm9kJsCIUxN6DPfmWZBVh/E5fK0dWlMTpNrK8rxY=;
        b=DtKjZBUrUyH2dLiIHgj3WAi1EcKztPUKs0HMEQtyu6agHHMt0VKheJAWuUYItFn5EMms0J
        iDq51is5l91ydGdwjavuGW5eop7NuCtrFybJnEGdhIakM1KO9sTcQk3x9CnvjkxhMaz0o2
        PuTLRFDC+4URdEOCQ/M/uDsA+Wv1KNI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-icr6Zo9DOWiUFgSPi6uenQ-1; Fri, 06 May 2022 18:25:09 -0400
X-MC-Unique: icr6Zo9DOWiUFgSPi6uenQ-1
Received: by mail-io1-f71.google.com with SMTP id o4-20020a0566022e0400b0065ab2047d69so3828339iow.7
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 15:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RgFbm9kJsCIUxN6DPfmWZBVh/E5fK0dWlMTpNrK8rxY=;
        b=FD8+45vr/pCJF6vZFVJM6S3RH4q6nEQuTvUbpmQ8BhLHwnDgTQAPK5b+l9/ehOYywg
         yhc8MvamBJ5I7JFrdM7UIAoBpbovd7KegFGof124S+MKfpSuK29W5OL3mDmpFlrA0oZH
         CbnxNsE3kErxCbj5556JV28nx8t4VIuhb+pMbxcT215hi/8slKLM0UM+W/plKhi8JTMm
         IDUuvX/cgRmP3M3PTudOUJLCwBTLLDSdTf7l2EIO0BRtR6qQMfQcnyn1qd3VZon7QnzC
         fZ+yb2hI1zd3vRg0HD8ySNIuu6KM3ogWWfzIVCyi9/Yj4y7vyWrhcRwARwKAj87kZCA0
         eGOg==
X-Gm-Message-State: AOAM533jLStpshYrT+Fj4Diu0+E+uQ0s996phB37cyAFmn/yZFIXo5Pw
        bjxymjNpp+TNw9lfpVioEm0mSYwgPF9tS/IyQQF9yl+NG3KGluFzGYjAWEiGBthXRTcNEazdI4p
        pM8HlLMUirddv
X-Received: by 2002:a05:6638:34a4:b0:32b:b205:ca82 with SMTP id t36-20020a05663834a400b0032bb205ca82mr2268864jal.165.1651875908732;
        Fri, 06 May 2022 15:25:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQf3Q60edHYS0PXIaVhmgrvlnKD1uAMd+fK2LadW8tM7BURk1T274hpw+B70BiVsYLsH6tnw==
X-Received: by 2002:a05:6638:34a4:b0:32b:b205:ca82 with SMTP id t36-20020a05663834a400b0032bb205ca82mr2268855jal.165.1651875908219;
        Fri, 06 May 2022 15:25:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h5-20020a02cd25000000b0032b5e4281d3sm1650589jaq.62.2022.05.06.15.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 15:25:07 -0700 (PDT)
Date:   Fri, 6 May 2022 16:25:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 0/8] Remove vfio_group from the struct file facing
 VFIO API
Message-ID: <20220506162501.457063f6.alex.williamson@redhat.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  4 May 2022 16:14:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
...
>  virt/kvm/vfio.c                  | 381 ++++++++++++++-----------------
>  4 files changed, 262 insertions(+), 307 deletions(-)

Hi Paolo,

Reviews obviously welcome here, but all the changes are on the vfio
side of the interface if you'd like to toss an ack for this series.
Thanks,

Alex

