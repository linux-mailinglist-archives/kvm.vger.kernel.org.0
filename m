Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C2F18DAE2
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgCTWH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:07:29 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39251 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgCTWH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:07:28 -0400
Received: by mail-ed1-f66.google.com with SMTP id a43so8969458edf.6
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 15:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wh832PW/B1ZgleHxeKKirrgEKzecxyBhNJtn0lhwADc=;
        b=MEta4Wf9GQWtqP9zfzhGnHT1uVRTqhsv0k0HpdrMcd5nXqYD/oZ5XQkcvyjcRBLxvK
         4sjs3srDN4vRDd/1/A5aywN1VHgeJ56SUmTLpj37QG+9Q+Sar4AK4yxSIAbjCDAocg8I
         bEuiugbnwliceIspvKxYjjPcJxE6UuklQR9VqVhpMo+Um3Yea4J9S7JI5Av+XvDYhkwv
         uvwRdatsyTBwel1vtOBU3nWvcPLEWjmk18oTq8WiEWmkIKLVTsx06V63yofilVl69glZ
         wIb1bdf3V6k6bHQCg+WGKkP49BmZcXUBFbzf0HtfTkbEl7uJP7esc0Q3H2i8f0Ma0s0F
         ZD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wh832PW/B1ZgleHxeKKirrgEKzecxyBhNJtn0lhwADc=;
        b=LNEuCkKI/mwW5hvhQQ1uNZK9iPrJO4yRqunJovuS5Mo7KFYjRcp8Vko3yAEs3J85cZ
         BQCnxKhDOa0FnX+79nY3mCBAB6XFiRG2Gq5nn8rb/mim+GgYg+YqlJyBg+HoGNtCqnDz
         35H+w8nVCF2LNvrbhj9c2QSAWMAi3ahxCm6LJGLS+HTyJRnEROpeI3XMc7mmDofkddM2
         orbZViXw6mrsk3Bz83HSqikqew5YZ9xldflK4Mw0gsxsKjQapvGsySxKkQgz2NRJHC1v
         LG8VeWsWcuqx3HQGR6eY8Rnfw2TQ3iuJ909Ne67c/Jge6p2C3MRCqZmfCBlcBAMgnJC+
         +++w==
X-Gm-Message-State: ANhLgQ2h9DH5OsdVElLaCq6WAeTMUqEUm+TiI58FEskR5FzCxpy6pre6
        o0TgIwS7oGJ5+Nvm+yeP83uEQC4o2sPGnV9rcttuZA==
X-Google-Smtp-Source: ADFU+vvMZyPS+wPi1ycr/20HKTaxuIp65bGgppsOIattbmrIpYaU1PgnwSdKnstpYWRRM5ZFTdryZbvhjNC04CydJL8=
X-Received: by 2002:a05:6402:22c7:: with SMTP id dm7mr10403457edb.283.1584742046426;
 Fri, 20 Mar 2020 15:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200320175910.180266-1-yonghyun@google.com> <20200320123425.49c6568e@w520.home>
 <CAEauFbx1Su7Lg5kdxXnvUwfwLCH67qaGB6EZ7g3OOH-tbRfBBA@mail.gmail.com> <20200320145935.4617c7c0@w520.home>
In-Reply-To: <20200320145935.4617c7c0@w520.home>
From:   Yonghyun Hwang <yonghyun@google.com>
Date:   Fri, 20 Mar 2020 15:07:15 -0700
Message-ID: <CAEauFbyE547joLxswMVLn2mreKgp-kEeQ_S4xyOQmmRsOqr_Wg@mail.gmail.com>
Subject: Re: [PATCH] vfio-mdev: support mediated device creation in kernel
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Moritz Fischer <mdf@kernel.org>,
        Joshua Lang <joshualang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If my patch is not aligned with the direction, it results in a
maintenance burden for the kernel. Thanks for sharing the direction
and  Yan's vendor-ops approach[1].

Thank you,
Yonghyun

On Fri, Mar 20, 2020 at 1:59 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Fri, 20 Mar 2020 13:46:04 -0700
> Yonghyun Hwang <yonghyun@google.com> wrote:
>
> > On Fri, Mar 20, 2020 at 11:34 AM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > On Fri, 20 Mar 2020 10:59:10 -0700
> > > Yonghyun Hwang <yonghyun@google.com> wrote:
> > >
> > > > To enable a mediated device, a device driver registers its device to VFIO
> > > > MDev framework. Once the mediated device gets enabled, UUID gets fed onto
> > > > the sysfs attribute, "create", to create the mediated device. This
> > > > additional step happens after boot-up gets complete. If the driver knows
> > > > how many mediated devices need to be created during probing time, the
> > > > additional step becomes cumbersome. This commit implements a new function
> > > > to allow the driver to create a mediated device in kernel.
> > >
> > > But pre-creating mdev devices seems like a policy decision.  Why can't
> > > userspace make such a policy decision, and do so with persistent uuids,
> > > via something like mdevctl?  Thanks,
> > >
> > > Alex
> >
> > Yep, it can be viewed as the policy decision and userspace can make
> > the decision. However, it would be handy and plausible, if a device
> > driver can pre-create "fixed or default" # of mdev devices, while
> > allowing the device policy to come into play after bootup gets
> > complete. Without this patch, a device driver should release the
> > policy and the policy should be aligned with the driver, which would
> > be cumbersome (sometimes painful) in a cloud environment. My use case
> > with mdev is to enable a subset of vfio-pci features without losing my
> > device driver.
>
> Does this last comment suggest the parent device is not being
> multiplexed through mdev, but only mediated?  If so, would something
> like Yan's vendor-ops approach[1] be better?  Without a multiplexed
> device, the lifecycle management of an mdev device doesn't make a lot
> of sense, and I wonder if that's what you're trying to bypass here.
> Even SR-IOV devices have moved to userspace enablement with most module
> options to enable a default number of VFs being deprecated.  I do see
> that that transition left a gap, but I'm not sure that heading in the
> opposite direction with mdevs is a good idea either.  Thanks,
>
> Alex
>
> [1]https://lore.kernel.org/kvm/20200131020803.27519-1-yan.y.zhao@intel.com/
>
>
> > > > Signed-off-by: Yonghyun Hwang <yonghyun@google.com>
> > > > ---
> > > >  drivers/vfio/mdev/mdev_core.c | 45 +++++++++++++++++++++++++++++++++++
> > > >  include/linux/mdev.h          |  3 +++
> > > >  2 files changed, 48 insertions(+)
> > > >
> > > > diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> > > > index b558d4cfd082..a6d32516de42 100644
> > > > --- a/drivers/vfio/mdev/mdev_core.c
> > > > +++ b/drivers/vfio/mdev/mdev_core.c
> > > > @@ -350,6 +350,51 @@ int mdev_device_create(struct kobject *kobj,
> > > >       return ret;
> > > >  }
> > > >
> > > > +/*
> > > > + * mdev_create_device : Create a mdev device
> > > > + * @dev: device structure representing parent device.
> > > > + * @uuid: uuid char string for a mdev device.
> > > > + * @group: index to supported type groups for a mdev device.
> > > > + *
> > > > + * Create a mdev device in kernel.
> > > > + * Returns a negative value on error, otherwise 0.
> > > > + */
> > > > +int mdev_create_device(struct device *dev,
> > > > +                     const char *uuid, int group)
> > > > +{
> > > > +     struct mdev_parent *parent = NULL;
> > > > +     struct mdev_type *type = NULL;
> > > > +     guid_t guid;
> > > > +     int i = 1;
> > > > +     int ret;
> > > > +
> > > > +     ret = guid_parse(uuid, &guid);
> > > > +     if (ret) {
> > > > +             dev_err(dev, "Failed to parse UUID");
> > > > +             return ret;
> > > > +     }
> > > > +
> > > > +     parent = __find_parent_device(dev);
> > > > +     if (!parent) {
> > > > +             dev_err(dev, "Failed to find parent mdev device");
> > > > +             return -ENODEV;
> > > > +     }
> > > > +
> > > > +     list_for_each_entry(type, &parent->type_list, next) {
> > > > +             if (i == group)
> > > > +                     break;
> > > > +             i++;
> > > > +     }
> > > > +
> > > > +     if (!type || i != group) {
> > > > +             dev_err(dev, "Failed to find mdev device");
> > > > +             return -ENODEV;
> > > > +     }
> > > > +
> > > > +     return mdev_device_create(&type->kobj, parent->dev, &guid);
> > > > +}
> > > > +EXPORT_SYMBOL(mdev_create_device);
> > > > +
> > > >  int mdev_device_remove(struct device *dev)
> > > >  {
> > > >       struct mdev_device *mdev, *tmp;
> > > > diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> > > > index 0ce30ca78db0..b66f67998916 100644
> > > > --- a/include/linux/mdev.h
> > > > +++ b/include/linux/mdev.h
> > > > @@ -145,4 +145,7 @@ struct device *mdev_parent_dev(struct mdev_device *mdev);
> > > >  struct device *mdev_dev(struct mdev_device *mdev);
> > > >  struct mdev_device *mdev_from_dev(struct device *dev);
> > > >
> > > > +extern int mdev_create_device(struct device *dev,
> > > > +                     const char *uuid, int group_idx);
> > > > +
> > > >  #endif /* MDEV_H */
> > >
> >
>
