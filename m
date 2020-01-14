Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B1613AB01
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 14:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgANN1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 08:27:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32002 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727289AbgANN1q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 08:27:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579008465;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhhtFILhKtdjWEYXn99X1dEASzhcaptVYqZRtT+cK+4=;
        b=gF2gbEXE/SLmtSR+QiFlcJEsaRCUnuCOwSrvWXe4gT3BNDyGJuWLsLKcCmmDr8Oj9+7a3A
        DkMuq37kXBGB0q8HtGSbX7NlpjXuHYLKoq+v/WM4WHl4YqOYkECrzkFj3oefGCTgOifqXW
        xP2je6D/lDEMMmNWcKbFihh0FiVbY24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-K2y3wvQDPTyUR5TpzpjyeA-1; Tue, 14 Jan 2020 08:27:42 -0500
X-MC-Unique: K2y3wvQDPTyUR5TpzpjyeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 205081014DE0;
        Tue, 14 Jan 2020 13:27:40 +0000 (UTC)
Received: from redhat.com (unknown [10.36.118.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CC4160BF1;
        Tue, 14 Jan 2020 13:27:36 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        qemu-ppc@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 06/15] migration/savevm: Replace current_machine by qdev_get_machine()
In-Reply-To: <20200109152133.23649-7-philmd@redhat.com> ("Philippe
        =?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Thu, 9 Jan 2020 16:21:24
 +0100")
References: <20200109152133.23649-1-philmd@redhat.com>
        <20200109152133.23649-7-philmd@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 14 Jan 2020 14:27:34 +0100
Message-ID: <871rs2dv7d.fsf@secure.laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:
> As we want to remove the global current_machine,
> replace MACHINE_GET_CLASS(current_machine) by
> MACHINE_GET_CLASS(qdev_get_machine()).
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Juan Quintela <quintela@redhat.com>

by the migration bits.

