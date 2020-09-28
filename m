Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB327B292
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 18:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgI1QvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 12:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgI1QvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 12:51:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B17FC061755
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 09:51:07 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e17so1839405wme.0
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 09:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yFxbEr9bSlLl+yVJrW7RjTVSlWLw44mYCnVns5wz3ms=;
        b=kxJ5AcNmS5aURtxNxI/0s/bjeh1SXLCF1QDPSB8KwoHpgAHq05zFnCWflkkDbhgPlk
         kFdA2gn6+FhdZyIowIFqPlGV4XA8b+Sam3tSvgJ9NooxLVTnTJghh4IwDkgIzO2dV9wR
         SPIGxFICHttxByA3NTqcJXYLdKs3toLKEh+da8v7eKXYk3TD6FaTw6MEZJHmENjym+f+
         3BQb0IFc9V8jEE3NF4CZgBSn8QYFjz1ncPHFPVxmpspHMIkp+2sZNmvluYHLMqA720qb
         oB3gy5TWe+i8gBmRPUJy7L7pRwPaeVv/7jO6tX/gBe3EFSpJXm/NfN66YxqBV4X2W2s+
         nxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yFxbEr9bSlLl+yVJrW7RjTVSlWLw44mYCnVns5wz3ms=;
        b=cAgleb0rK2sqfGWLl6oGtu+ow0zOmS4lGr8z3LZAM+cOEazMcBXNVICtW7u8+bcl46
         jNiqYDQeMzBJmK7Ik9IkFbBKOdsFFPakSX34gAaEmCaDDywk/V8F6G0VD2PO4zjyE8Sz
         qSBUQ1XPIdfN6gd5KGNvUR8Lv2ID5B/sUyq8cGfDdwsNZMjgY6mYPpKCmeztWF08jgbW
         cDSYnxgVxvLEw8sxVIkNCtHNM/k9icHN39OIBizcre153sORqLxFzEvjAMILXJ0/6i6X
         TdG/b8FBHVuinvTv64g5CtQB36TY1DtXZ7wn4PwoWQrMatf0g0aZTLTGS7jJPwj2mquv
         PBSw==
X-Gm-Message-State: AOAM532JW/4LrTAiuwzpeufFoxUOfkSZBmGkWkDQYkyUPbTcodTM1QWu
        POnAVHmKPdF/attvaCwLyRqd2eDFk1g=
X-Google-Smtp-Source: ABdhPJzNzx6FSdbSIMTSO2ZVdJxQztF9HPQvJdUjKJ8dw/VI87h+25aPCuJ2fYTDv8OpqU210KrxHQ==
X-Received: by 2002:a1c:6341:: with SMTP id x62mr132207wmb.70.1601311866287;
        Mon, 28 Sep 2020 09:51:06 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id l19sm1732171wmi.8.2020.09.28.09.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 09:51:04 -0700 (PDT)
Date:   Mon, 28 Sep 2020 17:51:03 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     alex.williamson@redhat.com, cjia@nvidia.com,
        Zhengxiao.zx@alibaba-inc.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yan.y.zhao@intel.com, kvm@vger.kernel.org,
        eskultet@redhat.com, ziye.yang@intel.com, qemu-devel@nongnu.org,
        cohuck@redhat.com, shuangtai.tst@alibaba-inc.com,
        dgilbert@redhat.com, zhi.a.wang@intel.com, mlevitsk@redhat.com,
        pasic@linux.ibm.com, aik@ozlabs.ru, eauger@redhat.com,
        felipe@nutanix.com, jonathan.davies@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com
Subject: Re: [PATCH Kernel v24 1/8] vfio: UAPI for migration interface for
 device state
Message-ID: <20200928165103.GA176159@stefanha-x1.localdomain>
References: <1590697854-21364-1-git-send-email-kwankhede@nvidia.com>
 <1590697854-21364-2-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <1590697854-21364-2-git-send-email-kwankhede@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 29, 2020 at 02:00:47AM +0530, Kirti Wankhede wrote:
> + * The sequence to be followed while in pre-copy state and stop-and-copy state
> + * is as follows:
> + * a. Read pending_bytes, indicating the start of a new iteration to get device
> + *    data. Repeated read on pending_bytes at this stage should have no side
> + *    effects.
> + *    If pending_bytes == 0, the user application should not iterate to get data
> + *    for that device.

What if the device doesn't have any data yet but might have some later?
This seems to say that if pending_bytes reads 0 the first time then this
device doesn't support pre-copy at all.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl9yFHcACgkQnKSrs4Gr
c8gPzgf7B5GyzroX7Zn7RxtarkQx1r7bP/riDrgK/46FdBVBGr7mgVNC0n/hxi0+
jFfxozuaeGb2OGploZNOW195PgDW4NZVQYezcs8bbf0/vaYp9pUYVkYHVY8fxc3M
mstpszqlB501+OngR1IbmZJw8bi6bg/tjHhDoTikKa+US6GBSlRA9KoZtXsCogaU
qoqAanorit1HHRJX1G9gpkbnwXAWCKj+/UevG/9RTj0K4osVmo4SHT+9HwuecKJO
9+2yt+MOkgxwH33xo8dPFlQJccLe+ufXz9lEQUtsHd+ePuyk69N7c+YaLmpmuyae
ERgwQbqjmUz67S37RTrOMJ76zzm9OQ==
=8ZXc
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
