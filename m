Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7B431CFA
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 15:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhJRNqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 09:46:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233380AbhJRNos (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 09:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634564557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGwdDK0TMF79qwbKBsot6xOhVGpu7mLY70WD1dRtw4I=;
        b=YNlmaxvHulvcqvyXjWZ8ZRWTW/J1DQdDCn/KeNgHHIHJykwzSxvdLEcpLUAB77E2vz6u/e
        WpZN01AM3xnnlom/pXLEAaj/h2OLmsQVLTXhumxL0WZM9NysknkokcQIfz9g2iQQgXaPrw
        WgMPD7/5/5I0kpkiOas0xY8TLfmDZxM=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-PBG-5Y8OMduVBxXqGgQbRA-1; Mon, 18 Oct 2021 09:42:35 -0400
X-MC-Unique: PBG-5Y8OMduVBxXqGgQbRA-1
Received: by mail-oi1-f197.google.com with SMTP id x17-20020a544011000000b00298d5769310so8874817oie.12
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 06:42:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PGwdDK0TMF79qwbKBsot6xOhVGpu7mLY70WD1dRtw4I=;
        b=T6OqMMdljyQ7BvNGYmmRIK27s/3fjpkLANCDh53rLRbKq2yjByjPEUSmBiDQPPfrc8
         jVERViMkPEMVf8DCcQs8q8xQDSTmMd9AlTBZhQ+Yc2lvK+ewrlj5KiQet9nV3FLw2iDm
         COxgYd18vADXOodNg+iAwfgsk82JzdEq5LpcrkV59bhzICqJLjhbrSz93UibrXgB/PEO
         RypEy/uZDHN+n91uLVYtIYy1tDjCf6q8egF2PZ0Lh8SJRtouJMZJRDhjD9Q4/SekKMb9
         J/RalWU+6Nh3+rFc7r8Zocrz4L02pZ4YtNUUxTd0i3drLKqV2vVyuNG4qIF1YQpq/Qn+
         dUdA==
X-Gm-Message-State: AOAM5323BPrSTCBpSuiNXT6OqPCLlMKY5iIyHMq9bjGndUsMsHuxcBJb
        /ZV1fAvBMvzU26JtG0xNMD5eBV8ppv53ou1gfneXyaPFmIE/btrLjWA1LlWt+Bp6VnUYFFy/8oi
        i1mOZKlIdJnmk
X-Received: by 2002:a4a:be0a:: with SMTP id l10mr16954229oop.64.1634564555075;
        Mon, 18 Oct 2021 06:42:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhJhlR6vLmGmo3Z8nrQemwIuTvv0570eg+HtwgDRYznhTkpMuUSXaqpXQXJLvqBt5GgUCUnw==
X-Received: by 2002:a4a:be0a:: with SMTP id l10mr16954207oop.64.1634564554871;
        Mon, 18 Oct 2021 06:42:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 95sm3022126otr.2.2021.10.18.06.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 06:42:34 -0700 (PDT)
Date:   Mon, 18 Oct 2021 07:42:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, <bhelgaas@google.com>,
        <saeedm@nvidia.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <kwankhede@nvidia.com>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211018074232.1008f54c.alex.williamson@redhat.com>
In-Reply-To: <c27a775f-f003-b652-ea80-f6ea988c0e78@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
        <20211013094707.163054-12-yishaih@nvidia.com>
        <20211015134820.603c45d0.alex.williamson@redhat.com>
        <20211015195937.GF2744544@nvidia.com>
        <20211015141201.617049e9.alex.williamson@redhat.com>
        <20211015201654.GH2744544@nvidia.com>
        <20211015145921.0abf7cb0.alex.williamson@redhat.com>
        <6608853f-7426-7b79-da1a-29c8fcc6ffc3@nvidia.com>
        <20211018115107.GM2744544@nvidia.com>
        <c27a775f-f003-b652-ea80-f6ea988c0e78@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Oct 2021 16:26:16 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 10/18/2021 2:51 PM, Jason Gunthorpe wrote:
> > On Sun, Oct 17, 2021 at 05:03:28PM +0300, Yishai Hadas wrote: =20
> >> On 10/15/2021 11:59 PM, Alex Williamson wrote: =20
> >>> On Fri, 15 Oct 2021 17:16:54 -0300
> >>> Jason Gunthorpe <jgg@nvidia.com> wrote:
> >>> =20
> >>>> On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote: =20
> >>>>> On Fri, 15 Oct 2021 16:59:37 -0300
> >>>>> Jason Gunthorpe <jgg@nvidia.com> wrote: =20
> >>>>>> On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote: =
=20
> >>>>>>>> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_d=
evice *mvdev,
> >>>>>>>> +				       u32 state)
> >>>>>>>> +{
> >>>>>>>> +	struct mlx5vf_pci_migration_info *vmig =3D &mvdev->vmig;
> >>>>>>>> +	u32 old_state =3D vmig->vfio_dev_state;
> >>>>>>>> +	int ret =3D 0;
> >>>>>>>> +
> >>>>>>>> +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_=
state))
> >>>>>>>> +		return -EINVAL; =20
> >>>>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VAL=
ID(state)) =20
> >>>>>> AFAICT this macro doesn't do what is needed, eg
> >>>>>>
> >>>>>> VFIO_DEVICE_STATE_VALID(0xF000) =3D=3D true
> >>>>>>
> >>>>>> What Yishai implemented is at least functionally correct - states =
this
> >>>>>> driver does not support are rejected. =20
> >>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID=
(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
> >>>>>
> >>>>> old_state is controlled by the driver and can never have random bits
> >>>>> set, user state should be sanitized to prevent setting undefined bi=
ts. =20
> >>>> In that instance let's just write
> >>>>
> >>>> old_state !=3D VFIO_DEVICE_STATE_ERROR
> >>>>
> >>>> ? =20
> >>> Not quite, the user can't set either of the other invalid states
> >>> either. =20
> >>
> >> OK so let's go with below as you suggested.
> >> if (!VFIO_DEVICE_STATE_VALID(old_state) ||
> >>       !VFIO_DEVICE_STATE_VALID(state) ||
> >>        (state & ~VFIO_DEVICE_STATE_MASK))
> >>              =20
> > This is my preference:
> >
> > if (vmig->vfio_dev_state !=3D VFIO_DEVICE_STATE_ERROR ||
> >      !vfio_device_state_valid(state) ||
> >      (state & !MLX5VF_SUPPORTED_DEVICE_STATES))
> > =20
>=20
> OK, let's go with this approach which enforces what the driver supports=20
> as well.
>=20
> We may have the below post making it accurate and complete.
>=20
> enum {
>      MLX5VF_SUPPORTED_DEVICE_STATES =3D VFIO_DEVICE_STATE_RUNNING |
>                                       VFIO_DEVICE_STATE_SAVING |
>                                       VFIO_DEVICE_STATE_RESUMING,
> };
>=20
> if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
>      !vfio_device_state_valid(state) ||
>      (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
>            return -EINVAL;
>=20
> >> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> >> index b53a9557884a..37376dadca5a 100644
> >> +++ b/include/linux/vfio.h
> >> @@ -15,6 +15,8 @@
> >>   #include <linux/poll.h>
> >>   #include <uapi/linux/vfio.h>
> >>
> >> +static const int VFIO_DEVICE_STATE_ERROR =3D VFIO_DEVICE_STATE_SAVING=
 |
> >> + VFIO_DEVICE_STATE_RESUMING; =20
> > Do not put static variables in header files
> >
> > Jason =20
>=20
> OK, we can come with an enum instead.
>=20
> enum {
>=20
> VFIO_DEVICE_STATE_ERROR =3D VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_=
RESUMING,
>=20
> };
>=20
> Alex,
>=20
> Do you prefer to=C2=A0 put it under include/uapi/vfio.h or that it can go=
=20
> under inlcude/linux/vfio.h for internal drivers usage ?

I don't understand why this wouldn't just be a continuation of the
#defines in the uapi header.  Thanks,

Alex

