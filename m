Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B01438E2
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 09:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgAUI7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 03:59:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23986 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725789AbgAUI7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 03:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579597155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sjf9FHZtc4VkpjztGyEBsBCj+SJEHoyzJe8IovGrlBw=;
        b=cgwuymq3QKi5HwUzcGCpRAbwP5M/k+1QomCu6ABzf2Gc9Y65S5poeetaiwDQ4cd8NzU1kP
        mABaDqdguUveUEI/rFa/XiWRGGxfwEALMhd+KknX/Ycu7C1ud035+8tSFpMi6v461Z7K9u
        OOc4tIBF3Y1RmJfRvh3Kal59iRtXqRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-45iOZmHOPXiGs_Usm3hO_Q-1; Tue, 21 Jan 2020 03:59:12 -0500
X-MC-Unique: 45iOZmHOPXiGs_Usm3hO_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06CA6107ACC4;
        Tue, 21 Jan 2020 08:59:09 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-116-131.ams2.redhat.com [10.36.116.131])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 009261CB;
        Tue, 21 Jan 2020 08:59:05 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 380161138600; Tue, 21 Jan 2020 09:59:04 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>, qemu-ppc@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 00/15] Replace current_machine by qdev_get_machine()
References: <20200109152133.23649-1-philmd@redhat.com>
Date:   Tue, 21 Jan 2020 09:59:04 +0100
In-Reply-To: <20200109152133.23649-1-philmd@redhat.com> ("Philippe
        =?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Thu, 9 Jan 2020 16:21:18
 +0100")
Message-ID: <87blqxgp7r.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quick pointer to prior discussion:

Message-ID: <87ftqh1ae5.fsf@dusky.pond.sub.org>
https://lists.nongnu.org/archive/html/qemu-devel/2019-04/msg02860.html

