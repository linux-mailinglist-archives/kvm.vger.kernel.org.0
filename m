Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA3B2D25D2
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 09:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgLHI0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 03:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgLHI0l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 03:26:41 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E07C061749
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 00:25:55 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id h16so5351568edt.7
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 00:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CRRpx8acZX4QjtTnMIWAXX++AMuePl61ml+xI4XshWU=;
        b=fOK/3HgiuVBZ02q0KOifw6SzUXjBYw5+AuClkdFIgY1bJpmlwwdbHVyVivO0eg+aa2
         JhYZdRbBcHtFNThHnS9vSHXgzNgZeaJEBYXDf+pb/wF3NqwCKtbzTo4BTUNaoLugNuZH
         Pjmhf/0107cUNmr1PnADrcmbvF7Xsg9WQLMYay/4/HoolpX8IO6F7BV0/6z84Ayj6tyC
         t5UJEqv5AmQuY9sKeu1suv8qLhIIZKBjCrXblTOv0AkITuMqGH+5DqYFYgff4E0Yiawv
         voT9qUCZKgkr2A3wCFgycaL2kPM43WHTbx/qHUPsQYjC/mtOwMW7GE/3K/ArfNn4RJWd
         ZhVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CRRpx8acZX4QjtTnMIWAXX++AMuePl61ml+xI4XshWU=;
        b=pGs7hucIwACKQHcncZ4QeiIUAz+vZtcNRfdpV9L73S9QwXrPJITdP7HtOXlopAtR+G
         e9NsRatYLKmsoktwyCr05tdfwutbVhs6m0pxI0b4q0mv3Mv4GxPyWeJ1eBgmOzk1+i8O
         6OvtUjYbN9lXQ8kB0iFginfPr+99HjqU9lGYvXgUxkSIO/d2Dhpb9yLvjFh0Ix30cds6
         MxE6orq0eIuJ8yY0VVMZ8khfAHeZ3fHaCWmWYpPt6mVKnTJrhAc6nGOnMWkIszRZ3R4m
         CyLTWTPyb4j9UmvvhfJRZ73R6C4n6HpB5lhWI6huEcU7PO4T7EeesbWVRwEMUWukHwHO
         DG4w==
X-Gm-Message-State: AOAM5332YLT1mfo6+g0hLLT3N661kFJMXd3LtO0PwPXgHpdXlDDSfQlv
        KMTuRbOuML8fdg5g9FLawWQ=
X-Google-Smtp-Source: ABdhPJwgXgn+yrMMIjilMjVvsLWwQHozsuf+tTEAZtoyMOYhysd+aHWNX+tUMzVsB8iXuDrM/o5tQA==
X-Received: by 2002:a05:6402:3074:: with SMTP id bs20mr23700631edb.365.1607415954491;
        Tue, 08 Dec 2020 00:25:54 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id rs27sm15112106ejb.21.2020.12.08.00.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 00:25:53 -0800 (PST)
Date:   Tue, 8 Dec 2020 08:25:52 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>, kvm@vger.kernel.org,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Subject: Re: [RFC PATCH 16/27] virtio: Expose virtqueue_alloc_element
Message-ID: <20201208082552.GT203660@stefanha-x1.localdomain>
References: <20201120185105.279030-1-eperezma@redhat.com>
 <20201120185105.279030-17-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="80Ds8Z/hZmemMosa"
Content-Disposition: inline
In-Reply-To: <20201120185105.279030-17-eperezma@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--80Ds8Z/hZmemMosa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2020 at 07:50:54PM +0100, Eugenio P=E9rez wrote:
> Specify VirtQueueElement * as return type makes no harm at this moment.

The reason for the void * return type is that C implicitly converts void
pointers to pointers of any type. The function takes a size_t sz
argument so it can allocate a object of user-defined size. The idea is
that the user's struct embeds a VirtQueueElement field. Changing the
return type to VirtQueueElement * means that callers may need to
explicitly cast to the user's struct type.

It's a question of coding style but I think the void * return type
communicates what is going on better than VirtQueueElement *.

--80Ds8Z/hZmemMosa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/POJAACgkQnKSrs4Gr
c8iIOQf/eNAzxK1ncAAJ6gkC5ZN4/DQUgcfZBmB/a4jRwojXtH7Tkr9soSJU/TN+
1mJPWNebsod4iVWGO+yl0y+YL4Iif2d2TSFpiyZvwOyNY1KAXpSgm3TwsbBW1UkG
WduAcNnpl06uIFb+x2w1aQlVE7RMaCFKRSw7GgLxDxuBJipan4LO+cDLlgwJk62z
RMsgHlzhfHZ9Kq2MMbZkwF4Etz1sWFOkn80cbFQT247Mn6Kx0KtU3RM7ubowKDmY
fXsySdAnqcU8fNv+7Oi3lM1zHI2jWTVPbfvmFDK7cYghlUU5lQJlUSC2icXRKm1T
OtyLrwUxDfPwL4895JADTzpPAwngDA==
=Cecc
-----END PGP SIGNATURE-----

--80Ds8Z/hZmemMosa--
