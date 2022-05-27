Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F2D5359A2
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 08:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344363AbiE0Gu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 02:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344514AbiE0Gu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 02:50:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7ADE0ED8E6
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 23:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653634254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KwscvJb+e3wCc50yy7+Oyvg5tXhryYMBM/Mq6KPfxIo=;
        b=WXgVfsqZOiY6hqWMKT+sS9hWI+1UBMDCMb31Y7xgmCSMqtkGrMN44tslRukkxmokpkhfep
        gm8O0CNGaGVSD2Nw3kYRdYSH5M5kQ+tJze6V7/3X2okAcx5ayXgi5LglW97pmhfJc44dJz
        qB2Os1gxewTCs7vkNcYJlDHZSpDeoeE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-W4Hh4sRaO4yzI2T7ZqOlqA-1; Fri, 27 May 2022 02:50:52 -0400
X-MC-Unique: W4Hh4sRaO4yzI2T7ZqOlqA-1
Received: by mail-qt1-f198.google.com with SMTP id u17-20020a05622a199100b002fbc827c739so3688453qtc.8
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 23:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwscvJb+e3wCc50yy7+Oyvg5tXhryYMBM/Mq6KPfxIo=;
        b=N11EndZtKjk8JmqSmJ8FAxv68DcEZThOhcI29m4MYh3yayVPbc3np7TMbH1V/rqkIU
         LzIK+2nE7GmOrOOkWtuKXDuERkvYCE/u+8Kx4hXvWiHXgrX7YD7B+SYyNvuiuR+6Ut+N
         B+XEd549lv0At3eKZk5/k0XyNKIdL69YqRkUzYi9BWOa8Bdbu5fCmqPVTnDbGqOZFctm
         BWwkVeaSBw7UCwFGeWr6Oj11Scyz03y3oDZyOXbG8V1NQWXhe9SNR8tWPuRfjhhsypWO
         0Y6BQYiun3KT0bNEPA4Eh7ycfnOZKKYMFxYbsfyz+hph0ehoamYU3RD+1JgeYFHzq6z6
         xUvg==
X-Gm-Message-State: AOAM533A7c+HD81YCBVF3EYq7185Q7vgdcuAWnba3kNnYDf1i2JeOse5
        ka7Nn4+fbG9GPt4bcaMZgGqCVla5kMFdDJFFxtE1rBt3hGCuaKgaqWq/qgHMMVxCZqK5baQQvVh
        5ukUmVQnILMU4DRBzVgtxeETZep9w
X-Received: by 2002:ac8:4e81:0:b0:2f9:34e4:8955 with SMTP id 1-20020ac84e81000000b002f934e48955mr19432010qtp.459.1653634252359;
        Thu, 26 May 2022 23:50:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywUtKw1p3mNXU5kTpnVECY4gR+23BPRrwgtbbZy68mg1DnclyCldN2lpPi96HQHPp+NMNAgvooJ44JkNz4TYU=
X-Received: by 2002:ac8:4e81:0:b0:2f9:34e4:8955 with SMTP id
 1-20020ac84e81000000b002f934e48955mr19432002qtp.459.1653634252144; Thu, 26
 May 2022 23:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220525105922.2413991-1-eperezma@redhat.com> <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
 <20220526090706.maf645wayelb7mcp@sgarzare-redhat> <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
 <20220526132038.GF2168@kadam> <CAJaqyWe4311B6SK997eijEJyhwnAxkBUGJ_0iuDNd=wZSt0DmQ@mail.gmail.com>
 <20220526190630.GJ2168@kadam>
In-Reply-To: <20220526190630.GJ2168@kadam>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 27 May 2022 08:50:16 +0200
Message-ID: <CAJaqyWdfWgC-uthR0aCjitCrBf=ca=Ee1oAB=JumffK=eSLgng@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 9:07 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> On Thu, May 26, 2022 at 07:00:06PM +0200, Eugenio Perez Martin wrote:
> > > It feels like returning any literal that isn't 1 or 0 should trigger a
> > > warning...  I've written that and will check it out tonight.
> > >
> >
> > I'm not sure this should be so strict, or "literal" does not include pointers?
> >
>
> What I mean in exact terms, is that if you're returning a known value
> and the function returns bool then the known value should be 0 or 1.
> Don't "return 3;".  This new warning will complain if you return a known
> pointer as in "return &a;".  It won't complain if you return an
> unknown pointer "return p;".
>

Ok, thanks for the clarification.

> > As an experiment, can Smatch be used to count how many times a
> > returned pointer is converted to int / bool before returning vs not
> > converted?
>
> I'm not super excited to write that code...  :/
>

Sure, I understand. I meant if it was possible or if that is too far
beyond its scope.

> >
> > I find Smatch interesting, especially when switching between projects
> > frequently. Does it support changing the code like clang-format? To
> > offload cognitive load to tools is usually good :).
>
> No.  Coccinelle does that really well though.
>

Understood.

Thanks!

> regards,
> dan carpenter
>

