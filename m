Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19D6455FBA
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhKRPpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:45:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230376AbhKRPpx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 10:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637250172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nEladry2jkqUjymIfPKR6D8O58DrhPs9vbOSU54FFIQ=;
        b=WUAKwL334qzlI6sfJDaYP2LxUyj1DZvlpEYxrijeLrkKkErLsVcvEFea7P9cYy2BawgosL
        BUdW5aqPJv0kDp6AhBP+4Gz8HODimH+VQw/KgvRVRnEIEbRUnBA496os7zPb1nmtFu9qKr
        faJ+Pwv+BS7A7PbFRQkRvQN+ya32FRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-wB_NwY9gM4acnjNTiYz9PQ-1; Thu, 18 Nov 2021 10:42:49 -0500
X-MC-Unique: wB_NwY9gM4acnjNTiYz9PQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5D14102CB77;
        Thu, 18 Nov 2021 15:42:48 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-7.ams2.redhat.com [10.36.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD33F1980E;
        Thu, 18 Nov 2021 15:42:41 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 123C111380A7; Thu, 18 Nov 2021 16:42:40 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH-for-6.2?] docs: Spell QEMU all caps
References: <20211118143401.4101497-1-philmd@redhat.com>
Date:   Thu, 18 Nov 2021 16:42:40 +0100
In-Reply-To: <20211118143401.4101497-1-philmd@redhat.com> ("Philippe
        =?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Thu, 18 Nov 2021 15:34:01
 +0100")
Message-ID: <87h7c9v5an.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> writes:

> Replace Qemu -> QEMU.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Markus Armbruster <armbru@redhat.com>

