Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F9453B180
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 04:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiFBCAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 22:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiFBCAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 22:00:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F27C2A7A96
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 19:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654135239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YBAqPDemohDoYgk1aoIRFIJVsyNoi84c0I5WJRZqFf4=;
        b=NXaS8eyjnLBPEoVMVgukUkDgGYVjNg0wrNQBx87jVa8MddOZB8qB0Mhzw6MsUve8V0YZ61
        57XnzueQtGs+ZxXu2sBnTa+UiqdPElnXzO4U+2lMoqIVhULEsazWWso+7XqrurSzIW9PCD
        xUA2gn3CvTUeDzO3Zqo+9TvzlHNtzmY=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-YEbPEo_KPT2iAj9xvUZZiw-1; Wed, 01 Jun 2022 22:00:38 -0400
X-MC-Unique: YEbPEo_KPT2iAj9xvUZZiw-1
Received: by mail-lf1-f70.google.com with SMTP id p36-20020a05651213a400b004779d806c13so1781753lfa.10
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 19:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YBAqPDemohDoYgk1aoIRFIJVsyNoi84c0I5WJRZqFf4=;
        b=P8W3hFk+w9GL9dOSaaCGWXHYBkm38vRtZYuU4cNqeH0+v7seX3LtYQDFLBbuf9ObIb
         aQcEvyJX8qFkLn2WhRPdV81+nibGuQbWimxAA4SmGS5M0ELmCORbY6ADrUV5XtUjLr2O
         DPL/+Xvi3H94G4W8cygP/Ovm5TEw7iojqDTUlT71U35XZih0XgvZtyfHM8MCv5jCW8NB
         KfOl7OmckU2dev3FvyNcdtkuSpPn+32/A9URXi0JVjhwZ481AQ2nUjLE3MaRFFQLJ4Et
         3a9uM1i0E+AYO40Ka1T8kpHsUBIzMkK5m9RLNtXQS+aN6OaDNSvKFvXEBubI8WE6tKof
         mlmQ==
X-Gm-Message-State: AOAM532egZgw+dyIVp6awss9xD5PR361KBLVhySimF6UGiks1HCzQ6Yh
        v9AIQXkmlweUrbLtnzUG7rsXB5gTOsBhZWn+GFi7OS0ey48A7i3zmgLsRAGZSncqCi+6qDKxmpM
        sykYFthdnr19Wwo5d71g5LSlbIxZ7
X-Received: by 2002:a05:6512:1588:b0:477:a556:4ab2 with SMTP id bp8-20020a056512158800b00477a5564ab2mr1731824lfb.376.1654135236350;
        Wed, 01 Jun 2022 19:00:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUrUCq3RcCVi51UnrwoiRoYGBE/u1c2zqyot4xytMyyLYLnsA4frnYnk43vssnr4u4dIBnj0FY2DMvEmzTEsY=
X-Received: by 2002:a05:6512:1588:b0:477:a556:4ab2 with SMTP id
 bp8-20020a056512158800b00477a5564ab2mr1731798lfb.376.1654135236157; Wed, 01
 Jun 2022 19:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com> <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 10:00:24 +0800
Message-ID: <CACGkMEsJJL34iUYQMxHguOV2cQ7rts+hRG5Gp3XKCGuqNdnNQg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 2, 2022 at 2:58 AM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Tuesday, May 31, 2022 10:42 PM
> >
> > Well, the ability to query the virtqueue state was proposed as another
> > feature (Eugenio, please correct me). This should be sufficient for making
> > virtio-net to be live migrated.
> >
> The device is stopped, it won't answer to this special vq config done here.

This depends on the definition of the stop. Any query to the device
state should be allowed otherwise it's meaningless for us.

> Programming all of these using cfg registers doesn't scale for on-chip memory and for the speed.

Well, they are orthogonal and what I want to say is, we should first
define the semantics of stop and state of the virtqueue.

Such a facility could be accessed by either transport specific method
or admin virtqueue, it totally depends on the hardware architecture of
the vendor.

>
> Next would be to program hundreds of statistics of the 64 VQs through a giant PCI config space register in some busy polling scheme.

We don't need giant config space, and this method has been implemented
by some vDPA vendors.

>
> I can clearly see how all these are inefficient for faster LM.
> We need an efficient AQ to proceed with at minimum.

I'm fine with admin virtqueue, but the stop and state are orthogonal
to that. And using admin virtqueue for stop/state will be more natural
if we use admin virtqueue as a transport.

Thanks

>
> > https://lists.oasis-open.org/archives/virtio-comment/202103/msg00008.html
> >
> > > Once the device is stopped, its state cannot be queried further as device
> > won't respond.
> > > It has limited use case.
> > > What we need is to stop non admin queue related portion of the device.

