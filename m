Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8A2190A82
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgCXKTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:19:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46805 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgCXKTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:19:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id j17so17274602wru.13
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=jNTB9UiCOvEmZjdiIH1rwukYdAv+6PN2ItTLYIoQp10=;
        b=BZFTuAGhrPosqNHtG2ThFLUKrJxn1iphk2I9uBufgX9715CyWvkWclFXFwjKFUBpUC
         XXR2vFMmN+rMpUCeI1rZynm1HlCWLwt1HrrvS1/X2GTjJme8ogdtZ1HffjIMVnKB+LmP
         ngOh51KctMLiewVGCknh4sVmHGmgtrGSN75IIn3Ag9oePsg4iTWZOllCbcE94vJWKgEp
         HJhE/Z5BBdc6YfkDK2Wx9COpjbbHI24U9UvkcELc1vONa0hwTZFPcz50/E3n6ivfgKc+
         5gU3GtcKtwPWRul4K0gurOzbPj1Rs68SLCzByOtdDL6/aLBycS5RVoOT4HXe+FzJCGxT
         FxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=jNTB9UiCOvEmZjdiIH1rwukYdAv+6PN2ItTLYIoQp10=;
        b=E2kOQlC2+VjOOuHEusfhGy7q6vICDuN2YC8Mc5V+o9qDMODrqJUNnQhDhKk0ljkXBW
         eqHVLtkXrs0bEmIMd3mdKhA7CE43Z8SW3mKe4My/E4Mh7giUUusqZaiOzBHhYAzucTBi
         83x9kj+73x9sn84E4v51HCLjTKe8HIt9iTvov4PD4sfqD3y5SL0YbTQ51+8SNsKZ5sZ2
         t5eTQ7IX+VMo6AK9GjilW8UWWBFtV+R2jtX8rNHgfDZKmIqtivronGDx/c9n098qdE0C
         0Uk3tdo7dd61TRtPOXMAhD3MhrrwSKBAatc60RidUcKuxnN9VPrcacGnpekLi6Xi7TS5
         WxiQ==
X-Gm-Message-State: ANhLgQ3ZawmhyXLG/pq38JV4H0deOjNZazK8D/OjDN2BJ9ty/xpjJ9my
        t6lnpNyY3PeewTVUgIdZb9x0IQ==
X-Google-Smtp-Source: ADFU+vv/B74lHFDdcqb1FElgKEv/8dK7Vt4iGG0rHUCyaQVT8JMJDur/53v+0aFjl3b5b50jwyj3WA==
X-Received: by 2002:adf:f310:: with SMTP id i16mr35512055wro.100.1585045152301;
        Tue, 24 Mar 2020 03:19:12 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j39sm29471981wre.11.2020.03.24.03.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 03:19:11 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 2C1211FF7E;
        Tue, 24 Mar 2020 10:19:10 +0000 (GMT)
References: <20200130163232.10446-1-philmd@redhat.com>
 <20200130163232.10446-8-philmd@redhat.com>
User-agent: mu4e 1.3.10; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Richard Henderson <rth@twiddle.net>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?utf-8?Q?Dan?= =?utf-8?Q?iel_P_=2E_Berrang=C3=A9?= 
        <berrange@redhat.com>, Michael Roth <mdroth@linux.vnet.ibm.com>,
        Max Reitz <mreitz@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 07/12] tests/acceptance: Remove shebang header
In-reply-to: <20200130163232.10446-8-philmd@redhat.com>
Date:   Tue, 24 Mar 2020 10:19:10 +0000
Message-ID: <87369yawdd.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> Patch created mechanically by running:
>
>   $ chmod 644 $(git grep -lF '#!/usr/bin/env python' \
>       | xargs grep -L 'if __name__.*__main__')
>   $ sed -i "/^#\!\/usr\/bin\/\(env\ \)\?python.\?$/d" \
>       $(git grep -lF '#!/usr/bin/env python' \
>       | xargs grep -L 'if __name__.*__main__')

OK, but my question is why? Aren't shebangs considered good practice for
finding the executable for a script?

If the acceptance scripts are special in this regard we should say why
in the commit message.

>
> Reported-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>  tests/acceptance/virtio_seg_max_adjust.py  | 1 -
>  tests/acceptance/x86_cpu_model_versions.py | 1 -
>  2 files changed, 2 deletions(-)
>  mode change 100755 =3D> 100644 tests/acceptance/virtio_seg_max_adjust.py
>
> diff --git a/tests/acceptance/virtio_seg_max_adjust.py b/tests/acceptance=
/virtio_seg_max_adjust.py
> old mode 100755
> new mode 100644
> index 5458573138..8d4f24da49
> --- a/tests/acceptance/virtio_seg_max_adjust.py
> +++ b/tests/acceptance/virtio_seg_max_adjust.py
> @@ -1,4 +1,3 @@
> -#!/usr/bin/env python
>  #
>  # Test virtio-scsi and virtio-blk queue settings for all machine types
>  #
> diff --git a/tests/acceptance/x86_cpu_model_versions.py b/tests/acceptanc=
e/x86_cpu_model_versions.py
> index 90558d9a71..01ff614ec2 100644
> --- a/tests/acceptance/x86_cpu_model_versions.py
> +++ b/tests/acceptance/x86_cpu_model_versions.py
> @@ -1,4 +1,3 @@
> -#!/usr/bin/env python
>  #
>  # Basic validation of x86 versioned CPU models and CPU model aliases
>  #


--=20
Alex Benn=C3=A9e
