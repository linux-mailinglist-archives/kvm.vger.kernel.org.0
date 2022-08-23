Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A088E59E796
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245038AbiHWQh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 12:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbiHWQhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 12:37:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276E9D7413
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 07:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661265868;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRe0jPg5g71Ku2k6CDoiCaJUXXhBhO61wFjdlKJm7j4=;
        b=Qim+l2t0sZ+cEKLphSn9pPIOcH/f7AnswbViJUKeclNKBQtxqsp7x6MBGilOeZ5wz/OWrE
        K34tpvXRuKjZUMgYKuoiyTMvaHlLQn9xLh3m0In0gtCeMNushrksP4ihpPuks38O8F9RyU
        yd5IWC105/zKuTdIOognRZ//+7P6XOo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-E_koNjaMMk6-jkxqgoWEgg-1; Tue, 23 Aug 2022 10:44:23 -0400
X-MC-Unique: E_koNjaMMk6-jkxqgoWEgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1CC5185A7A4;
        Tue, 23 Aug 2022 14:44:22 +0000 (UTC)
Received: from redhat.com (unknown [10.33.37.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AACF4010FA4;
        Tue, 23 Aug 2022 14:44:21 +0000 (UTC)
Date:   Tue, 23 Aug 2022 15:44:18 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Michal =?utf-8?B?UHLDrXZvem7DrWs=?= <mprivozn@redhat.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 1/3] Update linux headers to 6.0-rc1
Message-ID: <YwTnwhcy7rPM+99W@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220817020845.21855-1-chenyi.qiang@intel.com>
 <20220817020845.21855-2-chenyi.qiang@intel.com>
 <f3bc61c8-d491-f79c-15d7-191208c57224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f3bc61c8-d491-f79c-15d7-191208c57224@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022 at 05:00:03PM +0200, Michal Pr=C3=ADvozn=C3=ADk wrote:
> On 8/17/22 04:08, Chenyi Qiang wrote:
> > commit 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
> >=20
> > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > ---
> >  include/standard-headers/asm-x86/bootparam.h  |   7 +-
> >  include/standard-headers/drm/drm_fourcc.h     |  73 +++++++-
> >  include/standard-headers/linux/ethtool.h      |  29 +--
> >  include/standard-headers/linux/input.h        |  12 +-
> >  include/standard-headers/linux/pci_regs.h     |  30 ++-
> >  include/standard-headers/linux/vhost_types.h  |  17 +-
> >  include/standard-headers/linux/virtio_9p.h    |   2 +-
> >  .../standard-headers/linux/virtio_config.h    |   7 +-
> >  include/standard-headers/linux/virtio_ids.h   |  14 +-
> >  include/standard-headers/linux/virtio_net.h   |  34 +++-
> >  include/standard-headers/linux/virtio_pci.h   |   2 +
> >  linux-headers/asm-arm64/kvm.h                 |  27 +++
> >  linux-headers/asm-generic/unistd.h            |   4 +-
> >  linux-headers/asm-riscv/kvm.h                 |  22 +++
> >  linux-headers/asm-riscv/unistd.h              |   3 +-
> >  linux-headers/asm-s390/kvm.h                  |   1 +
> >  linux-headers/asm-x86/kvm.h                   |  33 ++--
> >  linux-headers/asm-x86/mman.h                  |  14 --
> >  linux-headers/linux/kvm.h                     | 172 +++++++++++++++++-
> >  linux-headers/linux/userfaultfd.h             |  10 +-
> >  linux-headers/linux/vduse.h                   |  47 +++++
> >  linux-headers/linux/vfio.h                    |   4 +-
> >  linux-headers/linux/vfio_zdev.h               |   7 +
> >  linux-headers/linux/vhost.h                   |  35 +++-
> >  24 files changed, 523 insertions(+), 83 deletions(-)
> >=20
>=20
>=20
> > diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> > index bf6e96011d..46de10a809 100644
> > --- a/linux-headers/asm-x86/kvm.h
> > +++ b/linux-headers/asm-x86/kvm.h
> > @@ -198,13 +198,13 @@ struct kvm_msrs {
> >  	__u32 nmsrs; /* number of msrs in entries */
> >  	__u32 pad;
> > =20
> > -	struct kvm_msr_entry entries[0];
> > +	struct kvm_msr_entry entries[];
> >  };
> > =20
>=20
> I don't think it's this simple. I think this needs to go hand in hand wit=
h kvm_arch_get_supported_msr_feature().
>=20
> Also, this breaks clang build:
>=20
> clang -m64 -mcx16 -Ilibqemu-x86_64-softmmu.fa.p -I. -I.. -Itarget/i386 -I=
=2E./target/i386 -Iqapi -Itrace -Iui -Iui/shader -I/usr/include/pixman-1 -I=
/usr/include/spice-server -I/usr/include/spice-1 -I/usr/include/glib-2.0 -I=
/usr/lib64/glib-2.0/include -fcolor-diagnostics -Wall -Winvalid-pch -Werror=
 -std=3Dgnu11 -O0 -g -isystem /home/zippy/work/qemu/qemu.git/linux-headers =
-isystem linux-headers -iquote . -iquote /home/zippy/work/qemu/qemu.git -iq=
uote /home/zippy/work/qemu/qemu.git/include -iquote /home/zippy/work/qemu/q=
emu.git/tcg/i386 -pthread -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEFI=
LE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wundef -Wwrite-strings -Wm=
issing-prototypes -fno-strict-aliasing -fno-common -fwrapv -Wold-style-defi=
nition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-q=
ualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defin=
ed -Wno-initializer-overrides -Wno-missing-include-dirs -Wno-shift-negative=
-value -Wno-string-plus-int -Wno-typedef-redefinition -Wno-tautological-typ=
e-limit-compare -Wno-psabi -fstack-protector-strong -O0 -ggdb -fPIE -isyste=
m../linux-headers -isystemlinux-headers -DNEED_CPU_H '-DCONFIG_TARGET=3D"x8=
6_64-softmmu-config-target.h"' '-DCONFIG_DEVICES=3D"x86_64-softmmu-config-d=
evices.h"' -MD -MQ libqemu-x86_64-softmmu.fa.p/target_i386_kvm_kvm.c.o -MF =
libqemu-x86_64-softmmu.fa.p/target_i386_kvm_kvm.c.o.d -o libqemu-x86_64-sof=
tmmu.fa.p/target_i386_kvm_kvm.c.o -c ../target/i386/kvm/kvm.c
> ../target/i386/kvm/kvm.c:470:25: error: field 'info' with variable sized =
type 'struct kvm_msrs' not at the end of a struct or class is a GNU extensi=
on [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct kvm_msrs info;
>                         ^
> ../target/i386/kvm/kvm.c:1701:27: error: field 'cpuid' with variable size=
d type 'struct kvm_cpuid2' not at the end of a struct or class is a GNU ext=
ension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct kvm_cpuid2 cpuid;
>                           ^
> ../target/i386/kvm/kvm.c:2868:25: error: field 'info' with variable sized=
 type 'struct kvm_msrs' not at the end of a struct or class is a GNU extens=
ion [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct kvm_msrs info;
>                         ^
> 3 errors generated.

We're perfectly OK with using GNU extensions  in QEMU (eg the g_auto stuff),
so IMHO just set  -Wno-gnu-variable-sized-type-not-at-end to turn off this
warning that's only relevant to people striving for fully portable C
code.


With regards,
Daniel
--=20
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange=
 :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com=
 :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange=
 :|

