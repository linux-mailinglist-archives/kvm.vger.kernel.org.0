Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B0A26D568
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 09:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIQH6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 03:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgIQH6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 03:58:01 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC54C06174A
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 00:57:59 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q9so1007850wmj.2
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 00:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=F5tUFeKbpaEUrhow1U7w2I/lFPTZrbFATqkKv3cbFJA=;
        b=FNSk40xnigWgLlCaL62kHnc+P/yjp8QdcnH0aWaO96WYn0BmXic2joO/YFkThuDp4m
         gjGwwcqEO0+wPsVkP+Kv78yf9OIjYzMi88kt9zd/WrUMdtldCiDvzcoK4pTIbMfTaurL
         hjpUAji34/NkrNUAWEKQDPs8/MGafty1jcLdq6ZVTOouX5+NS7gKeW0YkOEdgIUZG7Fh
         Mmdh3S6nhYIVzKsTbpD3eCHB13hvKV6FRo7HTNrkU2pyGy2weIaKXKxC9vCF2qNpNJQh
         LtSUJD8k7S9juvysgja6hanFQKMglfE6PTxmx80iyLzWhPZeUndH30FwDZHOLlG9Hc51
         qQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:cc:references:in-reply-to
         :subject:date:message-id:mime-version:content-transfer-encoding
         :content-language:thread-index;
        bh=F5tUFeKbpaEUrhow1U7w2I/lFPTZrbFATqkKv3cbFJA=;
        b=i80MV3joBiS+WLCh07usUYOLA3bK747i4EaKMWZHouqpNzW6cwSQfgpohUFDuq1zfc
         MF2An3y3fTRI9iYJlTTI1IDIQ70TfMMzt+3cxxltfg8XGsyylq53kIj9NCQkaLDRdCkQ
         4C+m8srY9QbxfsDztuSMBz/MQOxFHyT2UCaweHvJNBt8hgWHiD0h4F63geSR29KzwNwx
         iKnRIcxt+AtmssUIgsBhcOszr0PPt7DVNhs38nWUJEZCVTykvNkVZv70X5+zh2cKd8pC
         wxl1ME/FLtSmfc4gbkwolOLlFtZAjndDTTk8AYf/bpun5F1urqK/AoZNwICQrXQvcYgJ
         Vaog==
X-Gm-Message-State: AOAM533dYfx+S13ln0t7DNw1yON7/me+vPmgZkeyqAmzvj47uE/MOmWp
        xbQfCSrCdiXco0zRn+fJAGc=
X-Google-Smtp-Source: ABdhPJxkLn4nLGdKW7V2mqOMQI69SYGDw7w/jcuyd53OGVblkZrELtEp9tgShRP5K992kz6iGt4boQ==
X-Received: by 2002:a1c:6a11:: with SMTP id f17mr8064960wmc.143.1600329477743;
        Thu, 17 Sep 2020 00:57:57 -0700 (PDT)
Received: from CBGR90WXYV0 (host86-176-94-160.range86-176.btcentralplus.com. [86.176.94.160])
        by smtp.gmail.com with ESMTPSA id c25sm9433892wml.31.2020.09.17.00.57.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 00:57:57 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: "Paul Durrant" <paul@xen.org>
Reply-To: <paul@xen.org>
To:     "'Eduardo Habkost'" <ehabkost@redhat.com>, <qemu-devel@nongnu.org>
Cc:     "'Paolo Bonzini'" <pbonzini@redhat.com>,
        "'Daniel P. Berrange'" <berrange@redhat.com>,
        "'Gonglei \(Arei\)'" <arei.gonglei@huawei.com>,
        "'Igor Mammedov'" <imammedo@redhat.com>,
        "'Laurent Vivier'" <lvivier@redhat.com>,
        "'Amit Shah'" <amit@kernel.org>,
        "'Stefan Berger'" <stefanb@linux.ibm.com>,
        "'Michael S. Tsirkin'" <mst@redhat.com>,
        "'Greg Kurz'" <groug@kaod.org>,
        "'Christian Schoenebeck'" <qemu_oss@crudebyte.com>,
        "'Marcel Apfelbaum'" <marcel.apfelbaum@gmail.com>,
        "'Aleksandar Markovic'" <aleksandar.qemu.devel@gmail.com>,
        =?utf-8?Q?'Philippe_Mathieu-Daud=C3=A9'?= <f4bug@amsat.org>,
        "'Aurelien Jarno'" <aurelien@aurel32.net>,
        "'Richard Henderson'" <rth@twiddle.net>,
        "'Peter Maydell'" <peter.maydell@linaro.org>,
        "'Rob Herring'" <robh@kernel.org>,
        "'Joel Stanley'" <joel@jms.id.au>,
        "'Jan Kiszka'" <jan.kiszka@web.de>,
        "'Andrzej Zaborowski'" <balrogg@gmail.com>,
        "'Radoslaw Biernacki'" <rad@semihalf.com>,
        "'Leif Lindholm'" <leif@nuviainc.com>,
        "'Edgar E. Iglesias'" <edgar.iglesias@gmail.com>,
        "'Alistair Francis'" <alistair@alistair23.me>,
        "'Gerd Hoffmann'" <kraxel@redhat.com>,
        "'Michael Walle'" <michael@walle.cc>,
        "'John Snow'" <jsnow@redhat.com>,
        "'Kevin Wolf'" <kwolf@redhat.com>,
        "'Max Reitz'" <mreitz@redhat.com>,
        =?utf-8?Q?'Marc-Andr=C3=A9_Lureau'?= <marcandre.lureau@redhat.com>,
        "'Igor Mitsyanko'" <i.mitsyanko@gmail.com>,
        "'Fabien Chouteau'" <chouteau@adacore.com>,
        "'KONRAD Frederic'" <frederic.konrad@adacore.com>,
        "'Alberto Garcia'" <berto@igalia.com>,
        "'Thomas Huth'" <huth@tuxfamily.org>,
        "'David Gibson'" <david@gibson.dropbear.id.au>,
        "'Mark Cave-Ayland'" <mark.cave-ayland@ilande.co.uk>,
        =?utf-8?Q?'Herv=C3=A9_Poussineau'?= <hpoussin@reactos.org>,
        "'Aleksandar Rikalo'" <aleksandar.rikalo@syrmia.com>,
        "'BALATON Zoltan'" <balaton@eik.bme.hu>,
        "'Guan Xuetao'" <gxt@mprc.pku.edu.cn>,
        "'Helge Deller'" <deller@gmx.de>,
        "'Corey Minyard'" <cminyard@mvista.com>,
        "'Stefano Stabellini'" <sstabellini@kernel.org>,
        "'Anthony Perard'" <anthony.perard@citrix.com>,
        "'Chris Wulff'" <crwulff@gmail.com>,
        "'Marek Vasut'" <marex@denx.de>,
        "'Huacai Chen'" <chenhc@lemote.com>,
        "'Jiaxun Yang'" <jiaxun.yang@flygoat.com>,
        "'Artyom Tarasenko'" <atar4qemu@gmail.com>,
        "'Jason Wang'" <jasowang@redhat.com>,
        "'Dmitry Fleytman'" <dmitry.fleytman@gmail.com>,
        "'Max Filippov'" <jcmvbkbc@gmail.com>,
        "'Sven Schnelle'" <svens@stackframe.org>,
        "'Christian Borntraeger'" <borntraeger@de.ibm.com>,
        "'Cornelia Huck'" <cohuck@redhat.com>,
        "'Halil Pasic'" <pasic@linux.ibm.com>,
        "'David Hildenbrand'" <david@redhat.com>,
        "'Matthew Rosato'" <mjrosato@linux.ibm.com>,
        "'Fam Zheng'" <fam@euphon.net>,
        "'Yoshinori Sato'" <ysato@users.sourceforge.jp>,
        "'Samuel Thibault'" <samuel.thibault@ens-lyon.org>,
        "'Tony Krowiak'" <akrowiak@linux.ibm.com>,
        "'Pierre Morel'" <pmorel@linux.ibm.com>,
        "'Alex Williamson'" <alex.williamson@redhat.com>,
        "'Ben Warren'" <ben@skyportsystems.com>,
        "'Beniamino Galvani'" <b.galvani@gmail.com>,
        "'Niek Linnenbank'" <nieklinnenbank@gmail.com>,
        "'Andrew Baumann'" <Andrew.Baumann@microsoft.com>,
        "'Antony Pavlov'" <antonynpavlov@gmail.com>,
        "'Jean-Christophe Dubois'" <jcd@tribudubois.net>,
        "'Peter Chubb'" <peter.chubb@nicta.com.au>,
        "'Andrey Smirnov'" <andrew.smirnov@gmail.com>,
        "'Subbaraya Sundeep'" <sundeep.lkml@gmail.com>,
        "'Michael Rolnik'" <mrolnik@gmail.com>,
        "'Sarah Harris'" <S.E.Harris@kent.ac.uk>,
        "'Peter Xu'" <peterx@redhat.com>,
        =?utf-8?Q?'C=C3=A9dric_Le_Goater'?= <clg@kaod.org>,
        "'Andrew Jeffery'" <andrew@aj.id.au>,
        "'Laszlo Ersek'" <lersek@redhat.com>,
        "'Paul Burton'" <paulburton@kernel.org>,
        "'Palmer Dabbelt'" <palmer@dabbelt.com>,
        "'Sagar Karandikar'" <sagark@eecs.berkeley.edu>,
        "'Bastian Koppelmann'" <kbastian@mail.uni-paderborn.de>,
        "'Anup Patel'" <anup.patel@wdc.com>,
        "'Eric Farman'" <farman@linux.ibm.com>,
        "'Raphael Norwitz'" <raphael.norwitz@nutanix.com>,
        "'Dr. David Alan Gilbert'" <dgilbert@redhat.com>,
        "'Stefan Hajnoczi'" <stefanha@redhat.com>,
        "'Eric Auger'" <eric.auger@redhat.com>,
        "'Juan Quintela'" <quintela@redhat.com>,
        "'Pavel Dovgalyuk'" <pavel.dovgaluk@ispras.ru>,
        "'Zhang Chen'" <chen.zhang@intel.com>,
        "'Li Zhijian'" <lizhijian@cn.fujitsu.com>, <qemu-arm@nongnu.org>,
        <qemu-block@nongnu.org>, <qemu-ppc@nongnu.org>,
        <kvm@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <qemu-s390x@nongnu.org>, <qemu-riscv@nongnu.org>
References: <20200916182519.415636-1-ehabkost@redhat.com> <20200916182519.415636-6-ehabkost@redhat.com>
In-Reply-To: <20200916182519.415636-6-ehabkost@redhat.com>
Subject: RE: [PATCH 5/5] [automated] Use OBJECT_DECLARE_SIMPLE_TYPE when possible
Date:   Thu, 17 Sep 2020 08:57:54 +0100
Message-ID: <007d01d68cc8$4146b8b0$c3d42a10$@xen.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AQIelPz0+HUIa2jn7mxP/pozU40YBAFKLlCOqNIUBNA=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Eduardo Habkost <ehabkost@redhat.com>
> Sent: 16 September 2020 19:25
> To: qemu-devel@nongnu.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Daniel P. Berrange =
<berrange@redhat.com>; Gonglei (Arei)
> <arei.gonglei@huawei.com>; Igor Mammedov <imammedo@redhat.com>; =
Laurent Vivier <lvivier@redhat.com>;
> Amit Shah <amit@kernel.org>; Stefan Berger <stefanb@linux.ibm.com>; =
Michael S. Tsirkin
> <mst@redhat.com>; Greg Kurz <groug@kaod.org>; Christian Schoenebeck =
<qemu_oss@crudebyte.com>; Marcel
> Apfelbaum <marcel.apfelbaum@gmail.com>; Aleksandar Markovic =
<aleksandar.qemu.devel@gmail.com>;
> Philippe Mathieu-Daud=C3=A9 <f4bug@amsat.org>; Aurelien Jarno =
<aurelien@aurel32.net>; Richard Henderson
> <rth@twiddle.net>; Peter Maydell <peter.maydell@linaro.org>; Rob =
Herring <robh@kernel.org>; Joel
> Stanley <joel@jms.id.au>; Jan Kiszka <jan.kiszka@web.de>; Andrzej =
Zaborowski <balrogg@gmail.com>;
> Radoslaw Biernacki <rad@semihalf.com>; Leif Lindholm =
<leif@nuviainc.com>; Edgar E. Iglesias
> <edgar.iglesias@gmail.com>; Alistair Francis <alistair@alistair23.me>; =
Gerd Hoffmann
> <kraxel@redhat.com>; Michael Walle <michael@walle.cc>; John Snow =
<jsnow@redhat.com>; Kevin Wolf
> <kwolf@redhat.com>; Max Reitz <mreitz@redhat.com>; Marc-Andr=C3=A9 =
Lureau <marcandre.lureau@redhat.com>;
> Igor Mitsyanko <i.mitsyanko@gmail.com>; Fabien Chouteau =
<chouteau@adacore.com>; KONRAD Frederic
> <frederic.konrad@adacore.com>; Alberto Garcia <berto@igalia.com>; =
Thomas Huth <huth@tuxfamily.org>;
> David Gibson <david@gibson.dropbear.id.au>; Mark Cave-Ayland =
<mark.cave-ayland@ilande.co.uk>; Herv=C3=A9
> Poussineau <hpoussin@reactos.org>; Aleksandar Rikalo =
<aleksandar.rikalo@syrmia.com>; BALATON Zoltan
> <balaton@eik.bme.hu>; Guan Xuetao <gxt@mprc.pku.edu.cn>; Helge Deller =
<deller@gmx.de>; Corey Minyard
> <cminyard@mvista.com>; Stefano Stabellini <sstabellini@kernel.org>; =
Anthony Perard
> <anthony.perard@citrix.com>; Paul Durrant <paul@xen.org>; Chris Wulff =
<crwulff@gmail.com>; Marek Vasut
> <marex@denx.de>; Huacai Chen <chenhc@lemote.com>; Jiaxun Yang =
<jiaxun.yang@flygoat.com>; Artyom
> Tarasenko <atar4qemu@gmail.com>; Jason Wang <jasowang@redhat.com>; =
Dmitry Fleytman
> <dmitry.fleytman@gmail.com>; Max Filippov <jcmvbkbc@gmail.com>; Sven =
Schnelle <svens@stackframe.org>;
> Christian Borntraeger <borntraeger@de.ibm.com>; Cornelia Huck =
<cohuck@redhat.com>; Halil Pasic
> <pasic@linux.ibm.com>; David Hildenbrand <david@redhat.com>; Matthew =
Rosato <mjrosato@linux.ibm.com>;
> Fam Zheng <fam@euphon.net>; Yoshinori Sato =
<ysato@users.sourceforge.jp>; Samuel Thibault
> <samuel.thibault@ens-lyon.org>; Tony Krowiak <akrowiak@linux.ibm.com>; =
Pierre Morel
> <pmorel@linux.ibm.com>; Alex Williamson <alex.williamson@redhat.com>; =
Ben Warren
> <ben@skyportsystems.com>; Beniamino Galvani <b.galvani@gmail.com>; =
Niek Linnenbank
> <nieklinnenbank@gmail.com>; Andrew Baumann =
<Andrew.Baumann@microsoft.com>; Antony Pavlov
> <antonynpavlov@gmail.com>; Jean-Christophe Dubois =
<jcd@tribudubois.net>; Peter Chubb
> <peter.chubb@nicta.com.au>; Andrey Smirnov <andrew.smirnov@gmail.com>; =
Subbaraya Sundeep
> <sundeep.lkml@gmail.com>; Michael Rolnik <mrolnik@gmail.com>; Sarah =
Harris <S.E.Harris@kent.ac.uk>;
> Peter Xu <peterx@redhat.com>; C=C3=A9dric Le Goater <clg@kaod.org>; =
Andrew Jeffery <andrew@aj.id.au>;
> Laszlo Ersek <lersek@redhat.com>; Paul Burton <paulburton@kernel.org>; =
Palmer Dabbelt
> <palmer@dabbelt.com>; Sagar Karandikar <sagark@eecs.berkeley.edu>; =
Bastian Koppelmann
> <kbastian@mail.uni-paderborn.de>; Anup Patel <anup.patel@wdc.com>; =
Eric Farman <farman@linux.ibm.com>;
> Raphael Norwitz <raphael.norwitz@nutanix.com>; Dr. David Alan Gilbert =
<dgilbert@redhat.com>; Stefan
> Hajnoczi <stefanha@redhat.com>; Eric Auger <eric.auger@redhat.com>; =
Juan Quintela
> <quintela@redhat.com>; Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>; =
Zhang Chen <chen.zhang@intel.com>;
> Li Zhijian <lizhijian@cn.fujitsu.com>; qemu-arm@nongnu.org; =
qemu-block@nongnu.org; qemu-
> ppc@nongnu.org; kvm@vger.kernel.org; xen-devel@lists.xenproject.org; =
qemu-s390x@nongnu.org; qemu-
> riscv@nongnu.org
> Subject: [PATCH 5/5] [automated] Use OBJECT_DECLARE_SIMPLE_TYPE when =
possible
>=20
> This converts existing DECLARE_INSTANCE_CHECKER usage to
> OBJECT_DECLARE_SIMPLE_TYPE when possible.
>=20
> $ ./scripts/codeconverter/converter.py -i \
>   --pattern=3DAddObjectDeclareSimpleType $(git grep -l '' -- '*.[ch]')
>=20
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>

Acked-by: Paul Durrant <paul@xen.org>

