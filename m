Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAF100007
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 09:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfKRIGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 03:06:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30206 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726316AbfKRIGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Nov 2019 03:06:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574064380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNJ55WbT7VycZ8uCkUtv4AEa8qD8C2oOjxRZZ8HXkAA=;
        b=BuabHVxKAAheBX2cnQIm+QkMhFh9r34HD0SrmJ7W+SsQXN8tXUHmpLQy3hFK0hjbmQu/jn
        423swWWCW8FB8qsAACPL/zH8+I+jXp2qonrS3XJct6nsWwNpUSqViGb7Cum8iXzIIOR1Lg
        GF0963Zwz3PTLIDLWyK8iuuIgSe10nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-ab65OHwEMvKV-SjST_EDqw-1; Mon, 18 Nov 2019 03:06:18 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01E1D801FD2;
        Mon, 18 Nov 2019 08:06:17 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D32B10002D0;
        Mon, 18 Nov 2019 08:06:15 +0000 (UTC)
Date:   Mon, 18 Nov 2019 09:06:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kuhn.chenqun@huawei.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        kenny.zhangjun@huawei.com, pannengyuan@huawei.com,
        zhang.zhanghailiang@huawei.com
Subject: Re: [kvm-unit-tests PATCH] arm: Add missing test name prefix for
 pl031 and spinlock
Message-ID: <20191118080612.cudiybi3xlkruc55@kamzik.brq.redhat.com>
References: <20191118022720.17488-1-kuhn.chenqun@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20191118022720.17488-1-kuhn.chenqun@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ab65OHwEMvKV-SjST_EDqw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 18, 2019 at 10:27:20AM +0800, kuhn.chenqun@huawei.com wrote:
> From: Chen Qun <kuhn.chenqun@huawei.com>
>=20
> pl031 and spinlock testcase without prefix, when running
> the unit tests in TAP mode (./run_tests.sh -t), it is
> difficult to the test results.
>=20
> The test results=EF=BC=9A
> ok 13 - Periph/PCell IDs match
> ok 14 - R/O fields are R/O
> ok 15 - RTC ticks at 1HZ
> ok 16 - RTC IRQ not pending yet
> ...
> ok 24 -   RTC IRQ not pending anymore
> ok 25 - CPU1: Done - Errors: 0
> ok 26 - CPU0: Done - Errors: 0
>=20
> It should be like this=EF=BC=9A
> ok 13 - pl031: Periph/PCell IDs match
> ok 14 - pl031: R/O fields are R/O
> ok 15 - pl031: RTC ticks at 1HZ
> ok 16 - pl031: RTC IRQ not pending yet
> ...
> ok 24 - pl031:   RTC IRQ not pending anymore
> ok 25 - spinlock: CPU0: Done - Errors: 0
> ok 26 - spinlock: CPU1: Done - Errors: 0
>=20
> Signed-off-by: Chen Qun <kuhn.chenqun@huawei.com>
> ---
>  arm/pl031.c         | 1 +
>  arm/spinlock-test.c | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/arm/pl031.c b/arm/pl031.c
> index 5672f36..d0c9c10 100644
> --- a/arm/pl031.c
> +++ b/arm/pl031.c
> @@ -252,6 +252,7 @@ int main(int argc, char **argv)
>  =09=09return 0;
>  =09}
> =20
> +=09report_prefix_push("pl031");
>  =09report("Periph/PCell IDs match", !check_id());
>  =09report("R/O fields are R/O", !check_ro());
>  =09report("RTC ticks at 1HZ", !check_rtc_freq());
> diff --git a/arm/spinlock-test.c b/arm/spinlock-test.c
> index d55471b..ff16fb0 100644
> --- a/arm/spinlock-test.c
> +++ b/arm/spinlock-test.c
> @@ -72,6 +72,7 @@ static void test_spinlock(void *data __unused)
> =20
>  int main(int argc, char **argv)
>  {
> +=09report_prefix_push("spinlock");
>  =09if (argc > 1 && strcmp(argv[1], "bad") !=3D 0) {
>  =09=09lock_ops.lock =3D gcc_builtin_lock;
>  =09=09lock_ops.unlock =3D gcc_builtin_unlock;
> --=20
> 2.14.1.windows.1
>=20
>

Queued to https://github.com/rhdrjones/kvm-unit-tests/tree/arm/queue

Thanks,
drew=20

