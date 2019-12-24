Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5284D129FAB
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 10:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfLXJ20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 04:28:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54594 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbfLXJ20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 04:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577179704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sdq63IePYHAZah7URn5zkx4Y6XBmFNMvwu4Q1uK3z8k=;
        b=LROux0RQd1gbYcTyt5TDT0z3yxS+2u00Tl7CDNt9LXYZXo34nCybMM7u/ra+MDVV66H+JA
        ZHbWNKzpQB1V+ozTTQys7SntdkyGXaVJgF2qLY1+lcIsIt3zX7/rG4IV0EaxS1qdGdIMBp
        1cYO5SfqPhNxeBou/cWcEOkkBcXuwms=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-v7-MTawxNBGgy-Yn-9Hh6A-1; Tue, 24 Dec 2019 04:28:23 -0500
X-MC-Unique: v7-MTawxNBGgy-Yn-9Hh6A-1
Received: by mail-wr1-f71.google.com with SMTP id z15so6700126wrw.0
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2019 01:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=sdq63IePYHAZah7URn5zkx4Y6XBmFNMvwu4Q1uK3z8k=;
        b=qog0QQ3pjIUC9dBpQVL1krhP5JhGpy8ATy02ZUVivMdyRPVH9PM+3ZNk8ZUo8kneNr
         pH+xShB5j+D4ZS0rLPZuT7zxVTYGSmB4/mjAmmZSWc3nzmkC6xbS5V5FiKhP6kRvpLXT
         Xdd3EwkM2HjuaSKMFsGPZPUTsWhgFizbOhAnzMTwKniwGminZPkMbgW7ZgKpnFXBbYVU
         /A50zdoqcyZbTOkpy/7jTuOKg3l8ZWmUwOMHRVKxdNSX9Wwou/O+wRXbkEATejIKCM6g
         inHb5v8AzSn5Aq066bVom0F0busKnJA2TvRqrad6LjKmsLhKitxeX4+YmsOweCHPMP3J
         o4Bg==
X-Gm-Message-State: APjAAAU33HVv9fMIndyLSY1ZXQpoclx/y9jfUsIGCIZr+hRWtUVTyLYh
        RfVF8XDGtps/p3EGZ6BsIsa4wVK/rC/e52coz2o94KQCp9CHnfDTubKac/v4xtd2hoHJSE/IBr5
        Gg7kDILqwdRzZ
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr35990748wrs.276.1577179701900;
        Tue, 24 Dec 2019 01:28:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9/TSLj5c5X1JnE2/hzqVf4qICkFRn7uD3XRturCTmvjkz0LR8yv7IDInsAtlJzkhhu/UF3g==
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr35990685wrs.276.1577179701626;
        Tue, 24 Dec 2019 01:28:21 -0800 (PST)
Received: from ?IPv6:2003:d8:2f31:4c00:d9fc:8de:fc42:5adc? (p200300D82F314C00D9FC08DEFC425ADC.dip0.t-ipconnect.de. [2003:d8:2f31:4c00:d9fc:8de:fc42:5adc])
        by smtp.gmail.com with ESMTPSA id s3sm2070447wmh.25.2019.12.24.01.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 01:28:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH RFC v4 00/13] virtio-mem: paravirtualized memory
Date:   Tue, 24 Dec 2019 10:28:20 +0100
Message-Id: <2828152B-D0EB-4802-A304-4A90CA5C4B6C@redhat.com>
References: <91ED8152-61FC-4E87-9F7B-44CD05C77279@linux.alibaba.com>
Cc:     David Hildenbrand <david@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
In-Reply-To: <91ED8152-61FC-4E87-9F7B-44CD05C77279@linux.alibaba.com>
To:     teawater <teawaterz@linux.alibaba.com>
X-Mailer: iPhone Mail (17C54)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 24.12.2019 um 08:04 schrieb teawater <teawaterz@linux.alibaba.com>:
>=20
> =EF=BB=BFHi David,
>=20
> Thanks for your work.
>=20
> I Got following build fail if X86_64_ACPI_NUMA is n with rfc3 and rfc4:
> make -j8 bzImage
>  GEN     Makefile
>  DESCEND  objtool
>  CALL    /home/teawater/kernel/linux-upstream3/scripts/atomic/check-atomic=
s.sh
>  CALL    /home/teawater/kernel/linux-upstream3/scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  CC      drivers/virtio/virtio_mem.o
> /home/teawater/kernel/linux-upstream3/drivers/virtio/virtio_mem.c: In func=
tion =E2=80=98virtio_mem_translate_node_id=E2=80=99:
> /home/teawater/kernel/linux-upstream3/drivers/virtio/virtio_mem.c:478:10: e=
rror: implicit declaration of function =E2=80=98pxm_to_node=E2=80=99 [-Werro=
r=3Dimplicit-function-declaration]
>   node =3D pxm_to_node(node_id);
>          ^~~~~~~~~~~
> cc1: some warnings being treated as errors
> /home/teawater/kernel/linux-upstream3/scripts/Makefile.build:265: recipe f=
or target 'drivers/virtio/virtio_mem.o' failed
> make[3]: *** [drivers/virtio/virtio_mem.o] Error 1
> /home/teawater/kernel/linux-upstream3/scripts/Makefile.build:503: recipe f=
or target 'drivers/virtio' failed
> make[2]: *** [drivers/virtio] Error 2
> /home/teawater/kernel/linux-upstream3/Makefile:1649: recipe for target 'dr=
ivers' failed
> make[1]: *** [drivers] Error 2
> /home/teawater/kernel/linux-upstream3/Makefile:179: recipe for target 'sub=
-make' failed
> make: *** [sub-make] Error 2
>=20

Thanks Hui,

So it has to be wrapped in an ifdef, thanks!

Cheers!=

