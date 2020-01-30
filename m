Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8891A14D964
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 11:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgA3K66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 05:58:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56722 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726893AbgA3K66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 05:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580381936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UAn/BK9a8a0TPlwxOUlMkc1UiazTkKEzUjQ0RIxKVpY=;
        b=OeHyUUzRlsprFp49LwhidCHtNkJ9h/z0GOgVFvKB72BVg5Q/suBx0Xznu9GWI/8lJM6F3/
        S9PSCOhaDc6V33c92ILRB5bD5r6YO7UU6I+M0qPWqmP1kOb+PP4bQ3WhJJqA05nhH7HCHC
        vsnUC94ZZJkmi+R+MJTm5Wfh6GhHmtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-hYOj0MC_MoqOZLuHm6YUYQ-1; Thu, 30 Jan 2020 05:58:55 -0500
X-MC-Unique: hYOj0MC_MoqOZLuHm6YUYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F18B2800D48;
        Thu, 30 Jan 2020 10:58:53 +0000 (UTC)
Received: from linux.fritz.box (ovpn-117-25.ams2.redhat.com [10.36.117.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3E3977927;
        Thu, 30 Jan 2020 10:58:41 +0000 (UTC)
Date:   Thu, 30 Jan 2020 11:58:39 +0100
From:   Kevin Wolf <kwolf@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        kvm@vger.kernel.org, Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH 10/10] tests/qemu-iotests/check: Update to match Python 3
 interpreter
Message-ID: <20200130105839.GB6438@linux.fritz.box>
References: <20200129231402.23384-1-philmd@redhat.com>
 <20200129231402.23384-11-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20200129231402.23384-11-philmd@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 30.01.2020 um 00:14 hat Philippe Mathieu-Daud=E9 geschrieben:
> All the iotests Python scripts have been converted to search for
> the Python 3 interpreter. Update the ./check script accordingly.
>=20
> Signed-off-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>

> diff --git a/tests/qemu-iotests/check b/tests/qemu-iotests/check
> index 2890785a10..2e7d29d570 100755
> --- a/tests/qemu-iotests/check
> +++ b/tests/qemu-iotests/check
> @@ -825,7 +825,7 @@ do
> =20
>          start=3D$(_wallclock)
> =20
> -        if [ "$(head -n 1 "$source_iotests/$seq")" =3D=3D "#!/usr/bin/=
env python" ]; then
> +        if [ "$(head -n 1 "$source_iotests/$seq")" =3D=3D "#!/usr/bin/=
env python3" ]; then
>              if $python_usable; then
>                  run_command=3D"$PYTHON $seq"
>              else

Changing some test cases in patch 2 and only updating ./check now breaks
bisectability.

I'm not sure why you separated patch 2 and 8. I think the easiest way
would be to change all qemu-iotests cases in the same patch and also
update ./check in that patch.

Otherwise, you'd have to change ./check in patch 2 to accept both
versions and could possibly remove the "python" version again here.

Kevin

