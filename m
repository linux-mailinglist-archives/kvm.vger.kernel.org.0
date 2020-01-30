Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F6714DCD7
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgA3Oee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:34:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36783 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727139AbgA3Oee (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 09:34:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580394873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPSUVb6MzaF6rprazc+hsrUDCKr9uya0+zR9zr3B0wk=;
        b=E3mdIMdg/YvyTvSU43KKEpLaQkhrimf7Oj4gO4bIns201dbhOpF2H7mmKF8qgvv0fkrO0R
        XYpcQBvxLt1fxki84lehZOQakQyT+Ie6ZWop1psM58KkAedSvPQ1C5KbR3VvbnEnFjDQfD
        UcnM7pCOQTV0l9c5N1FTKzaFYleUrmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-O69FqmQHMeSNV4gB8-ZL2g-1; Thu, 30 Jan 2020 09:34:31 -0500
X-MC-Unique: O69FqmQHMeSNV4gB8-ZL2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89489801E6C;
        Thu, 30 Jan 2020 14:34:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-40.gru2.redhat.com [10.97.116.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 039F460C85;
        Thu, 30 Jan 2020 14:34:03 +0000 (UTC)
Subject: Re: [PATCH 05/10] tests/acceptance: Remove shebang header
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Max Reitz <mreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200129231402.23384-1-philmd@redhat.com>
 <20200129231402.23384-6-philmd@redhat.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <838bf1fc-d607-7d0f-6d7c-40c4ce0bdba2@redhat.com>
Date:   Thu, 30 Jan 2020 12:34:01 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200129231402.23384-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/29/20 9:13 PM, Philippe Mathieu-Daud=C3=A9 wrote:
> Patch created mechanically by running:
>
>    $ chmod 644 $(git grep -lF '#!/usr/bin/env python' | xargs grep -L '=
if __name__.*__main__')
>    $ sed -i "/^#\!\/usr\/bin\/\(env\ \)\?python.\?$/d" $(git grep -lF '=
#!/usr/bin/env python' | xargs grep -L 'if __name__.*__main__')
>
> Reported-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
> ---
>   tests/acceptance/virtio_seg_max_adjust.py  | 1 -
>   tests/acceptance/x86_cpu_model_versions.py | 1 -
>   2 files changed, 2 deletions(-)
>   mode change 100755 =3D> 100644 tests/acceptance/virtio_seg_max_adjust=
.py


Reviewed-by: Wainer dos Santos Moschetta <wainersm@redhat.com>


>
> diff --git a/tests/acceptance/virtio_seg_max_adjust.py b/tests/acceptan=
ce/virtio_seg_max_adjust.py
> old mode 100755
> new mode 100644
> index 5458573138..8d4f24da49
> --- a/tests/acceptance/virtio_seg_max_adjust.py
> +++ b/tests/acceptance/virtio_seg_max_adjust.py
> @@ -1,4 +1,3 @@
> -#!/usr/bin/env python
>   #
>   # Test virtio-scsi and virtio-blk queue settings for all machine type=
s
>   #
> diff --git a/tests/acceptance/x86_cpu_model_versions.py b/tests/accepta=
nce/x86_cpu_model_versions.py
> index 90558d9a71..01ff614ec2 100644
> --- a/tests/acceptance/x86_cpu_model_versions.py
> +++ b/tests/acceptance/x86_cpu_model_versions.py
> @@ -1,4 +1,3 @@
> -#!/usr/bin/env python
>   #
>   # Basic validation of x86 versioned CPU models and CPU model aliases
>   #

