Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107152FA3A8
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405150AbhAROwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 09:52:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393055AbhAROwD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 09:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610981436;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KNt8I2KtS8LBHMYY1pg2KMY7mTlm0B681NVj2CsqEyI=;
        b=dNyGh/GQit1y0Yv8p067MJrA02CkN4AfsIRz3NQSZDuGBF4tu97++m8i+WHvjIgLM3U8FE
        xPU4BAMtkJhvGphE7CUsQ6GEeT09+XcVc/PDhDL1gtsieW34LXR0rBu60BwGifLHrpUi/5
        H2mSs/PQiEVWQWIIWEHoqd5A02YGixo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-yO4lwVcOOgCKmKKG_aGz-Q-1; Mon, 18 Jan 2021 09:50:32 -0500
X-MC-Unique: yO4lwVcOOgCKmKKG_aGz-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 326BB107ACE6;
        Mon, 18 Jan 2021 14:50:30 +0000 (UTC)
Received: from redhat.com (ovpn-116-34.ams2.redhat.com [10.36.116.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A9E5722C0;
        Mon, 18 Jan 2021 14:50:19 +0000 (UTC)
Date:   Mon, 18 Jan 2021 14:50:16 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        BALATON Zoltan via <qemu-devel@nongnu.org>,
        Fam Zheng <fam@euphon.net>,
        Laurent Vivier <lvivier@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        kvm@vger.kernel.org,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        Greg Kurz <groug@kaod.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Max Reitz <mreitz@redhat.com>, qemu-ppc@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 9/9] gitlab-ci: Add alpine to pipeline
Message-ID: <20210118145016.GC1799018@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-10-jiaxun.yang@flygoat.com>
 <20210118101159.GC1789637@redhat.com>
 <fb7308f2-ecc7-48b8-9388-91fd30691767@www.fastmail.com>
 <307dea8e-148e-6666-c6f1-5cc66a54a7af@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <307dea8e-148e-6666-c6f1-5cc66a54a7af@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 03:44:49PM +0100, Thomas Huth wrote:
> On 18/01/2021 14.37, Jiaxun Yang wrote:
> > 
> > 
> > On Mon, Jan 18, 2021, at 6:11 PM, Daniel P. Berrangé wrote:
> > > On Mon, Jan 18, 2021 at 02:38:08PM +0800, Jiaxun Yang wrote:
> > > > We only run build test and check-acceptance as their are too many
> > > > failures in checks due to minor string mismatch.
> > > 
> > > Can you give real examples of what's broken here, as that sounds
> > > rather suspicious, and I'm not convinced it should be ignored.
> > 
> > Mostly Input/Output error vs I/O Error.
> 
> Right, out of curiosity, I also gave it a try:
> 
>  https://gitlab.com/huth/qemu/-/jobs/969225330
> 
> Apart from the "I/O Error" vs. "Input/Output Error" difference, there also
> seems to be a problem with "sed" in some of the tests.

The "sed" thing sounds like something that ought to be investigated
from a portability POV rather than ignored.

More worrying is the fact that there's a segv in there too when
running qemu-img, which does not give me confidence in use of
it with musl.



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

