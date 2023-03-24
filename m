Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F946C7DB2
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjCXMGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbjCXMGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:06:32 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE4B241EE
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:06:28 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t10so6963600edd.12
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679659586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhiOmcNOw3CqusqBpuPxs3KEt9fJxbep8mlqY3W5XWg=;
        b=lPzQV0PjtZTAA6PZEbpMIVzLj2G7dlJqqRzl4zh/FxKZQ81KzyzcwhUCqdVVzNqY8g
         9JmE9/vNTc7Xt/HDdLqMdZrbYmEvie/HNnJKOhlb9z1RtCRXCrseLlY2PP74CmMDqjRA
         dErW+x0Vyni8/xZEKbgnBUIS+pXlFy9qKXXo7LdJ8I5NDECI6SqplOX4RWK0rRZ+X8CZ
         0CNt/tL0S6UFijw7wuRuf3zslAOraLL6MQgeRBGxwfdxdlCJ+Fbf0O3WRqoE/o0HKJag
         rmS+C9BxoCLNeXg+SJ+KtIQfzLS4JCzjZCk6u8KqDtqWmftuMoe00+1bc7Vxz5RQnnSp
         9Fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679659586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhiOmcNOw3CqusqBpuPxs3KEt9fJxbep8mlqY3W5XWg=;
        b=37pkuirUenRlM90Yjy7RjL3tBj3re8wliMhHqnbKxwUwOxhaExl4ziUaXw0qUHqX7p
         njfmNX3kJjjvjbtCtzgjLfcza4mEUVXB7+4Ah3R0fsIfUUmnTaxCBbFK46H8G6G6e0sp
         0wX3f31J7Ry9Yj+nbjydoU9JVVaaUqC2G3FgFIryvop3OsHz3KN0Cy05cVwjI/UK4ZFM
         uCJXMSnfHXCzaOr6+N8T1U7Jw8z5OqIlWn5oYM46oC/4/sp0GYud6aJo8MrdAcyf2tOe
         VoT9LiicEs1YmOXE9TpBSYRxFVFybHHIiIYW+Mj5MKTzyTGMOUk7CglMd2j2LIYzMYcs
         N86w==
X-Gm-Message-State: AAQBX9fQMPoTxSvRUiPh2SJmEFX8J3BvraQamq6ejyRWt23b85yNe9IF
        jccyaeCq4Q4fgjgZsh64FeanUxNDNGB18HoQT6I=
X-Google-Smtp-Source: AKy350b2VfVSgA+jj27WSv5Ya732xc0DHsKHhjDJYBeLneJWkOT6+FOh1pYGxLvp0PhQCNTl1KISMf3WZ4czCrUcF6E=
X-Received: by 2002:a17:906:868b:b0:934:b24e:26ba with SMTP id
 g11-20020a170906868b00b00934b24e26bamr1218699ejx.7.1679659586008; Fri, 24 Mar
 2023 05:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230324105418.3752-1-faithilikerun@gmail.com> <20230324105418.3752-2-faithilikerun@gmail.com>
In-Reply-To: <20230324105418.3752-2-faithilikerun@gmail.com>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Fri, 24 Mar 2023 20:05:59 +0800
Message-ID: <CAAAx-8JaBSYPckTLnq5OqHqW4mjWJex-7DskbvBEL3R8Te1Y0Q@mail.gmail.com>
Subject: Re: [PATCH v9 5/5] docs/zoned-storage:add zoned emulation use case
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, stefanha@redhat.com,
        Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        damien.lemoal@opensource.wdc.com, hare@suse.de,
        kvm@vger.kernel.org, Markus Armbruster <armbru@redhat.com>,
        dmitry.fomichev@wdc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sam Li <faithilikerun@gmail.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8824=E6=97=
=A5=E5=91=A8=E4=BA=94 18:54=E5=86=99=E9=81=93=EF=BC=9A
>
> Add the documentation about the example of using virtio-blk driver
> to pass the zoned block devices through to the guest.
>
> Signed-off-by: Sam Li <faithilikerun@gmail.com>
> ---
>  docs/devel/zoned-storage.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/docs/devel/zoned-storage.rst b/docs/devel/zoned-storage.rst
> index 6a36133e51..05ecf3729c 100644
> --- a/docs/devel/zoned-storage.rst
> +++ b/docs/devel/zoned-storage.rst
> @@ -41,3 +41,20 @@ APIs for zoned storage emulation or testing.
>  For example, to test zone_report on a null_blk device using qemu-io is:
>  $ path/to/qemu-io --image-opts -n driver=3Dhost_device,filename=3D/dev/n=
ullb0
>  -c "zrp offset nr_zones"
> +
> +To expose the host's zoned block device through virtio-blk, the command =
line
> +can be (includes the -device parameter):
> +    -blockdev node-name=3Ddrive0,driver=3Dhost_device,filename=3D/dev/nu=
llb0,
> +    cache.direct=3Don \
> +    -device virtio-blk-pci,drive=3Ddrive0
> +Or only use the -drive parameter:
> +    -driver driver=3Dhost_device,file=3D/dev/nullb0,if=3Dvirtio,cache.di=
rect=3Don
> +
> +Additionally, QEMU has several ways of supporting zoned storage, includi=
ng:
> +(1) Using virtio-scsi: --device scsi-block allows for the passing throug=
h of
> +SCSI ZBC devices, enabling the attachment of ZBC or ZAC HDDs to QEMU.
> +(2) PCI device pass-through: While NVMe ZNS emulation is available for t=
esting
> +purposes, it cannot yet pass through a zoned device from the host. To pa=
ss on
> +the NVMe ZNS device to the guest, use VFIO PCI pass the entire NVMe PCI =
adapter
> +through to the guest. Likewise, an HDD HBA can be passed on to QEMU all =
HDDs
> +attached to the HBA.
> --
> 2.39.2
>
