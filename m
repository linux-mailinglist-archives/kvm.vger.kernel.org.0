Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4AFFDB77
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfKOKgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:36:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbfKOKgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 05:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573814168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H7cmhiVVMIKs39Ls1b6h5NWHtOx/GLrPF0TO2yFJy3E=;
        b=VgFigKMfZTCS8UP4DYZK2K3WhnKieGOQGhUruhCIsKj8953mQ38LwesjQJpxIsyDYq42hU
        +OswKbfZpD5xfwXYoN//rOlrreR9LRLd53cbPzek45BZ5nb+C/qxUU96XbXwSq+AkNG3D9
        42ngaYVSkfk89jQlj5YJA3OMcBTqDbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-Wc0vLy6NP_Ou4lvOTxlCUQ-1; Fri, 15 Nov 2019 05:36:07 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 877D018B9FC1
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 10:36:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01D348918;
        Fri, 15 Nov 2019 10:36:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86/unittests.cfg: Increase the timeout of
 the sieve test to 180s
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20190923111210.9495-1-thuth@redhat.com>
Message-ID: <81a6ed8d-9abe-b42d-add7-be9c909a5134@redhat.com>
Date:   Fri, 15 Nov 2019 11:36:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20190923111210.9495-1-thuth@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Wc0vLy6NP_Ou4lvOTxlCUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2019 13.12, Thomas Huth wrote:
> In the gitlab-CI (where we are running the tests with TCG), the sieve
> test sometimes takes more than 90s to finish, and thus fails due
> to the 90s timeout from scripts/runtime.bash. Increase the timeout
> for this test to make it always succeed.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  See for example this run here where it took more than 90s:
> =20
>   https://gitlab.com/huth/kvm-unit-tests/-/jobs/301407814
> =20
>  If you don't like the change in unittests.cfg, I can also tweak
>  the (global) timeout in .gitlab-ci.yml instead.
>=20
>  x86/unittests.cfg | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 694ee3d..e951629 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -172,6 +172,7 @@ file =3D s3.flat
> =20
>  [sieve]
>  file =3D sieve.flat
> +timeout =3D 180
> =20
>  [syscall]
>  file =3D syscall.flat
>=20

Ping?

 Thomas

