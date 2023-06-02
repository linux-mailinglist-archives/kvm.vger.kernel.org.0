Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5937208FB
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjFBSTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 14:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236571AbjFBSTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 14:19:30 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C81A1
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 11:19:03 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2af1822b710so34134411fa.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 11:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685729935; x=1688321935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFLBip0rXYVzmkQxhrZxBqTTTRzpwp6Ec+4ePpr28UE=;
        b=L1tGtijkILSagPNle+rdISWwsz3O38nl1v2cDhWnnMdXclTZRlRHFmQG0fm8uctfgW
         Q87845GyNa0TJgBV1ADgo8quuHxLzwE5fK3czUONxXuMtw8ANAm4UTU/zdjzKZwYAEJ1
         P9yRSpO7vVoNRfKjZ9Zhz+dldExb5p4rAtVt3qucI3YaqgIdSD+x00W7sfgIEmIYwcKb
         akwG9GxVsyNjeOhVLhj1rAskGSkv4DDMnkU1DFR84Y7TTb5OLI/hlRpD/4oIthkX/oYW
         Nz0jy/jJ6q+IjwdsH/KLnJ5HBp6PeZ2jG7ekSZQ5K9nrlLDONEi7igjOEQb7kN6X8WVo
         9U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685729935; x=1688321935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cFLBip0rXYVzmkQxhrZxBqTTTRzpwp6Ec+4ePpr28UE=;
        b=beFaoJ0x0eRXIsl+FrSiLdqcdklDutLDaklybeqEFqJcZMlxJDg1Fc05N3uIiXOIGR
         TilQPYWtZN/jo+1EYKQCvyPXbJmxs7x0dK2MkLh0vRnOcZgA0dQE2UMj96IP4ddDf8Og
         kiykFU4ErHClcpZQckIkuIP25vrf5egz6MMDsYzILWJdAYN9ObwM+z4YxfGsMHQtSnqa
         DOaxVOW8NwKcwnpcNsk8Q0BBkbqqFEBnvbaBRlXNII6cBNNr/pOOg3acytlHP/0RhyaP
         FnF7QIheMB1BNED8z1KpVVJmbheJhyOTE4G6TGNK14fkVEdLKwWId9YxVgmK7ahS41ks
         lp5g==
X-Gm-Message-State: AC+VfDx1FsbJ+fcDrhubBx6Bk5Bdi/bLG3SOknWz8QT84IX+d2MemERH
        FagGhSXdmtqJ0qX6hXofxom1My1BixWyu5x68bc=
X-Google-Smtp-Source: ACHHUZ4D+NVU5tIhflX4LDmEO7sPEy1kMkng+glJgOwWwm8sS7OpohPaCgKW+1z6j5C/RFo/eKJF4vsuppl7x7wH+ZI=
X-Received: by 2002:a2e:8783:0:b0:2ae:db65:2d01 with SMTP id
 n3-20020a2e8783000000b002aedb652d01mr504681lji.23.1685729934212; Fri, 02 Jun
 2023 11:18:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230515160506.1776883-1-stefanha@redhat.com> <20230515160506.1776883-3-stefanha@redhat.com>
 <8b0ced3c-2fb5-2479-fe78-f4956ac037a6@linux.ibm.com>
In-Reply-To: <8b0ced3c-2fb5-2479-fe78-f4956ac037a6@linux.ibm.com>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Sat, 3 Jun 2023 02:18:27 +0800
Message-ID: <CAAAx-8Km7J8dfz_63y1W5wE8MH7hJXo04ajY1A-ctv--x9CpGA@mail.gmail.com>
Subject: Re: [PULL v2 02/16] block/file-posix: introduce helper functions for
 sysfs attributes
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matthew Rosato <mjrosato@linux.ibm.com> =E4=BA=8E2023=E5=B9=B46=E6=9C=881=
=E6=97=A5=E5=91=A8=E5=9B=9B 02:21=E5=86=99=E9=81=93=EF=BC=9A
>
> On 5/15/23 12:04 PM, Stefan Hajnoczi wrote:
> > From: Sam Li <faithilikerun@gmail.com>
> >
> > Use get_sysfs_str_val() to get the string value of device
> > zoned model. Then get_sysfs_zoned_model() can convert it to
> > BlockZoneModel type of QEMU.
> >
> > Use get_sysfs_long_val() to get the long value of zoned device
> > information.
>
> Hi Stefan, Sam,
>
> I am having an issue on s390x using virtio-blk-{pci,ccw} backed by an NVM=
e partition, and I've bisected the root cause to this commit.
>
> I noticed that tests which use the partition e.g. /dev/nvme0n1p1 as a bac=
king device would fail, but those that use the namespace e.g. /dev/nvme0n1 =
would still succeed.  The root issue appears to be that the block device as=
sociated with the partition does not have a "max_segments" attribute, and p=
rior to this patch hdev_get_max_segment() would return -ENOENT in this case=
.  After this patch, however, QEMU is instead crashing.  It looks like g_fi=
le_get_contents is returning 0 with a len =3D=3D 0 if the specified sysfs p=
ath does not exist.  The following diff on top seems to resolve the issue f=
or me:
>
>
> diff --git a/block/file-posix.c b/block/file-posix.c
> index 0ab158efba2..eeb0247c74e 100644
> --- a/block/file-posix.c
> +++ b/block/file-posix.c
> @@ -1243,7 +1243,7 @@ static int get_sysfs_str_val(struct stat *st, const=
 char *attribute,
>                                  major(st->st_rdev), minor(st->st_rdev),
>                                  attribute);
>      ret =3D g_file_get_contents(sysfspath, val, &len, NULL);
> -    if (ret =3D=3D -1) {
> +    if (ret =3D=3D -1 || len =3D=3D 0) {
>          return -ENOENT;
>      }
>

Hi Matthew,

Thanks for the information. After some checking, I think the bug here
is that g_file_get_contens returns g_boolean value and the error case
will return 0 instead of -1 in my previous code. Can the following
line fix your issue on the s390x device?

+ if (ret =3D=3D FALSE) {

https://docs.gtk.org/glib/func.file_get_contents.html

Thanks,
Sam




>
>
>
> >
> > Signed-off-by: Sam Li <faithilikerun@gmail.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> > Acked-by: Kevin Wolf <kwolf@redhat.com>
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Message-id: 20230508045533.175575-3-faithilikerun@gmail.com
> > Message-id: 20230324090605.28361-3-faithilikerun@gmail.com
> > [Adjust commit message prefix as suggested by Philippe Mathieu-Daud=C3=
=A9
> > <philmd@linaro.org>.
> > --Stefan]
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  include/block/block_int-common.h |   3 +
> >  block/file-posix.c               | 135 ++++++++++++++++++++++---------
> >  2 files changed, 100 insertions(+), 38 deletions(-)
> >
> > diff --git a/include/block/block_int-common.h b/include/block/block_int=
-common.h
> > index 4909876756..c7ca5a83e9 100644
> > --- a/include/block/block_int-common.h
> > +++ b/include/block/block_int-common.h
> > @@ -862,6 +862,9 @@ typedef struct BlockLimits {
> >       * an explicit monitor command to load the disk inside the guest).
> >       */
> >      bool has_variable_length;
> > +
> > +    /* device zone model */
> > +    BlockZoneModel zoned;
> >  } BlockLimits;
> >
> >  typedef struct BdrvOpBlocker BdrvOpBlocker;
> > diff --git a/block/file-posix.c b/block/file-posix.c
> > index c7b723368e..97c597a2a0 100644
> > --- a/block/file-posix.c
> > +++ b/block/file-posix.c
> > @@ -1202,15 +1202,89 @@ static int hdev_get_max_hw_transfer(int fd, str=
uct stat *st)
> >  #endif
> >  }
> >
> > -static int hdev_get_max_segments(int fd, struct stat *st)
> > +/*
> > + * Get a sysfs attribute value as character string.
> > + */
> > +#ifdef CONFIG_LINUX
> > +static int get_sysfs_str_val(struct stat *st, const char *attribute,
> > +                             char **val) {
> > +    g_autofree char *sysfspath =3D NULL;
> > +    int ret;
> > +    size_t len;
> > +
> > +    if (!S_ISBLK(st->st_mode)) {
> > +        return -ENOTSUP;
> > +    }
> > +
> > +    sysfspath =3D g_strdup_printf("/sys/dev/block/%u:%u/queue/%s",
> > +                                major(st->st_rdev), minor(st->st_rdev)=
,
> > +                                attribute);
> > +    ret =3D g_file_get_contents(sysfspath, val, &len, NULL);
> > +    if (ret =3D=3D -1) {
> > +        return -ENOENT;
> > +    }
> > +
> > +    /* The file is ended with '\n' */
> > +    char *p;
> > +    p =3D *val;
> > +    if (*(p + len - 1) =3D=3D '\n') {
> > +        *(p + len - 1) =3D '\0';
> > +    }
> > +    return ret;
> > +}
> > +#endif
> > +
> > +static int get_sysfs_zoned_model(struct stat *st, BlockZoneModel *zone=
d)
> >  {
> > +    g_autofree char *val =3D NULL;
> > +    int ret;
> > +
> > +    ret =3D get_sysfs_str_val(st, "zoned", &val);
> > +    if (ret < 0) {
> > +        return ret;
> > +    }
> > +
> > +    if (strcmp(val, "host-managed") =3D=3D 0) {
> > +        *zoned =3D BLK_Z_HM;
> > +    } else if (strcmp(val, "host-aware") =3D=3D 0) {
> > +        *zoned =3D BLK_Z_HA;
> > +    } else if (strcmp(val, "none") =3D=3D 0) {
> > +        *zoned =3D BLK_Z_NONE;
> > +    } else {
> > +        return -ENOTSUP;
> > +    }
> > +    return 0;
> > +}
> > +
> > +/*
> > + * Get a sysfs attribute value as a long integer.
> > + */
> >  #ifdef CONFIG_LINUX
> > -    char buf[32];
> > +static long get_sysfs_long_val(struct stat *st, const char *attribute)
> > +{
> > +    g_autofree char *str =3D NULL;
> >      const char *end;
> > -    char *sysfspath =3D NULL;
> > +    long val;
> > +    int ret;
> > +
> > +    ret =3D get_sysfs_str_val(st, attribute, &str);
> > +    if (ret < 0) {
> > +        return ret;
> > +    }
> > +
> > +    /* The file is ended with '\n', pass 'end' to accept that. */
> > +    ret =3D qemu_strtol(str, &end, 10, &val);
> > +    if (ret =3D=3D 0 && end && *end =3D=3D '\0') {
> > +        ret =3D val;
> > +    }
> > +    return ret;
> > +}
> > +#endif
> > +
> > +static int hdev_get_max_segments(int fd, struct stat *st)
> > +{
> > +#ifdef CONFIG_LINUX
> >      int ret;
> > -    int sysfd =3D -1;
> > -    long max_segments;
> >
> >      if (S_ISCHR(st->st_mode)) {
> >          if (ioctl(fd, SG_GET_SG_TABLESIZE, &ret) =3D=3D 0) {
> > @@ -1218,44 +1292,27 @@ static int hdev_get_max_segments(int fd, struct=
 stat *st)
> >          }
> >          return -ENOTSUP;
> >      }
> > -
> > -    if (!S_ISBLK(st->st_mode)) {
> > -        return -ENOTSUP;
> > -    }
> > -
> > -    sysfspath =3D g_strdup_printf("/sys/dev/block/%u:%u/queue/max_segm=
ents",
> > -                                major(st->st_rdev), minor(st->st_rdev)=
);
> > -    sysfd =3D open(sysfspath, O_RDONLY);
> > -    if (sysfd =3D=3D -1) {
> > -        ret =3D -errno;
> > -        goto out;
> > -    }
> > -    ret =3D RETRY_ON_EINTR(read(sysfd, buf, sizeof(buf) - 1));
> > -    if (ret < 0) {
> > -        ret =3D -errno;
> > -        goto out;
> > -    } else if (ret =3D=3D 0) {
> > -        ret =3D -EIO;
> > -        goto out;
> > -    }
> > -    buf[ret] =3D 0;
> > -    /* The file is ended with '\n', pass 'end' to accept that. */
> > -    ret =3D qemu_strtol(buf, &end, 10, &max_segments);
> > -    if (ret =3D=3D 0 && end && *end =3D=3D '\n') {
> > -        ret =3D max_segments;
> > -    }
> > -
> > -out:
> > -    if (sysfd !=3D -1) {
> > -        close(sysfd);
> > -    }
> > -    g_free(sysfspath);
> > -    return ret;
> > +    return get_sysfs_long_val(st, "max_segments");
> >  #else
> >      return -ENOTSUP;
> >  #endif
> >  }
> >
> > +static void raw_refresh_zoned_limits(BlockDriverState *bs, struct stat=
 *st,
> > +                                     Error **errp)
> > +{
> > +    BlockZoneModel zoned;
> > +    int ret;
> > +
> > +    bs->bl.zoned =3D BLK_Z_NONE;
> > +
> > +    ret =3D get_sysfs_zoned_model(st, &zoned);
> > +    if (ret < 0 || zoned =3D=3D BLK_Z_NONE) {
> > +        return;
> > +    }
> > +    bs->bl.zoned =3D zoned;
> > +}
> > +
> >  static void raw_refresh_limits(BlockDriverState *bs, Error **errp)
> >  {
> >      BDRVRawState *s =3D bs->opaque;
> > @@ -1297,6 +1354,8 @@ static void raw_refresh_limits(BlockDriverState *=
bs, Error **errp)
> >              bs->bl.max_hw_iov =3D ret;
> >          }
> >      }
> > +
> > +    raw_refresh_zoned_limits(bs, &st, errp);
> >  }
> >
> >  static int check_for_dasd(int fd)
>
