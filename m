Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280D515A747
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgBLLB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:01:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbgBLLB5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 06:01:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581505317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T27ElMuoylKBPGugg4+OYoDfqDLuAN7noVnRa3NDg88=;
        b=MKwu4KFGll4kwmlUm3KWAfGztaUnJtYicrdh9DdLRRkzLR5pUKjr+7palaegAQqJ3zF5KI
        K1QNhjA67FNi6JvsqYWImRj5Vs5K17Xis0UJmF5pV58y97b3NqsfMFGkdBAON81X0mGVxD
        jC3e0BzeirX6xXosA5tJh1BQH7LiPgc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-tJYJUgLuNnepzXWjSPKFOw-1; Wed, 12 Feb 2020 06:01:47 -0500
X-MC-Unique: tJYJUgLuNnepzXWjSPKFOw-1
Received: by mail-wm1-f72.google.com with SMTP id g26so568924wmk.6
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 03:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=T27ElMuoylKBPGugg4+OYoDfqDLuAN7noVnRa3NDg88=;
        b=bRWIyY9Rh4BOkjnKmX8nOWa0FVCGKQfvs5dEO2ZaJy1jP0bMJwnxrVQ/KvKHt1/IyJ
         dek+4VsHLKJ52PbY3ocmQ5sk7Hh7QsPLc9ECAIW9bK0ylVTzp7mPxtJ7ZGdZnyeiLXLE
         pyD2ruVjXszeQt4Fkae1/YggUGzs/EOkf0Kz2ASQLN/s+i75DzCA/0e1Zn4AaE31IVPO
         7OVlAdF1Ad/Gch9euXU3sZYFYtVtnGWI8hIFCEcZSRCJa6/JegfhD9CQ/lw+DDbNiSIW
         6BfV4u/GaYAet1Te/4PvUhtYNtW9yi5AR15HHfFGTCclxdKLF8J9bJ/t/Nj3TlGGsiSM
         DChw==
X-Gm-Message-State: APjAAAVYGCcCMlcm0v7s4tk7giattXnJGFB87pbWHGWay21BzwKcSZSU
        VKljBFJVDhYOZaIq2gEt0VJxWwSDFTV2md0fyyatnALN2qvuOrH7W/atQdJTTcn01LxUYImZXAX
        ly03+yOEXe+cH
X-Received: by 2002:a7b:c652:: with SMTP id q18mr11943542wmk.123.1581505306145;
        Wed, 12 Feb 2020 03:01:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqwyqa8cQeBtKGTW8YRWjrc70ein63AyyDIBxHp4zzgsUMqiABjStD7hG7hqC+qnOvGeePptLQ==
X-Received: by 2002:a7b:c652:: with SMTP id q18mr11943516wmk.123.1581505305811;
        Wed, 12 Feb 2020 03:01:45 -0800 (PST)
Received: from ?IPv6:2a01:e0a:466:71c0:11f2:4fa3:b547:8d2a? ([2a01:e0a:466:71c0:11f2:4fa3:b547:8d2a])
        by smtp.gmail.com with ESMTPSA id 5sm150029wrc.75.2020.02.12.03.01.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2020 03:01:45 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: CPU vulnerabilities in public clouds
From:   Christophe de Dinechin <dinechin@redhat.com>
In-Reply-To: <CAJSP0QW0XqgVfBbS9ip8xL+TkMfu24A+GyKVQLurCwWc2fTEvQ@mail.gmail.com>
Date:   Wed, 12 Feb 2020 12:01:44 +0100
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3EF2160E-1D1F-4389-8C5E-AC6A84630711@redhat.com>
References: <CAJSP0QW0XqgVfBbS9ip8xL+TkMfu24A+GyKVQLurCwWc2fTEvQ@mail.gmail.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 5 Feb 2020, at 17:06, Stefan Hajnoczi <stefanha@gmail.com> wrote:
>=20
> Hi Vitaly,
> I just watched your FOSDEM talk on CPU vulnerabilities in public =
clouds:
> =
https://mirror.cyberbits.eu/fosdem/2020/H.1309/vai_pubic_clouds_and_vulner=
able_cpus.webm
>=20
> If I understand correctly the situation for cloud users is:
> 1. The cloud provider takes care of hypervisor and CPU microcode fixes
> but the instance may still be vulnerable to inter-process or guest
> kernel attacks.
> 2. /sys/devices/system/cpu/vulnerabilities lists vulnerabilities that
> the guest kernel knows about.  This might be outdated if new
> vulnerabilities have been discovered since the kernel was installed.
> False negatives are possible where your slides show the guest kernel
> thinks there is no mitigation but you suspect the cloud provider has a
> fix in place.
> 3. Cloud users still need to learn about every vulnerability to
> understand whether inter-process or guest kernel attacks are possible.
>=20
> Overall this seems to leave cloud users in a bad situation.  They
> still need to become experts in each vulnerability and don't have
> reliable information on their protection status.
>=20
> Users with deep pockets will pay someone to do the work for them. For
> many users the answer will probably be to apply guest OS updates and
> hope for the best? :(
>=20
> It would be nice if /sys/devices/system/cpu/vulnerabilities was at
> least accurate...  Do you have any thoughts on improving the situation
> for users?

I understand your concern, and it=E2=80=99s a great point.

However, /sys is about the local system, so I=E2=80=99m not overly =
shocked
that it does not know about what is outside the system :-)

What could be nice, though, is if /sys/=E2=80=A6/vulnerabilities exposed
a list of CVEs that have been taken into account at the time
the kernel was built.

# cat /sys/devices/system/cpu/vulnerabilities/CVE_list=20
2017-5715
2017-5753
2017-5754
2018-3615
2018-3620
2018-3646
2018-12207
2018-12130
2018-12126
2018-12127
2019-11091
2018-3639
2019-11135

That way, you would know at least what you are measuring against.
The implementation is quite easy, see experiment here:

https://github.com/c3d/linux/commits/cpu-bugs-cve-list

Do you think that would have any value?


Thanks
Christophe

>=20
> Stefan
>=20

