Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8531F8BC
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 13:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhBSL7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:59:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230144AbhBSL7o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735897;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Oat3ESJK0nJqOq3w4Qti1Q4yrZeJ9Lqn+lQdEnc1XI=;
        b=ZFsCDtKFcMf3IX74CHLMrcUhLnBjGIw8XKuqRBe8HLvONNe62tADNr43C7L4bw3tKvKiLz
        4eZT1HQfZsBdvVE5erUv/6zHx1O+ft7VxHh50RHGzpmqGrfVjHnFBRjk9HGaIA9OCLlDMx
        iqE9vWHtco7qmk+eJA5BpHFsoEgSqao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-Rbk-XNaZOBKnFnbM5wF23Q-1; Fri, 19 Feb 2021 06:58:14 -0500
X-MC-Unique: Rbk-XNaZOBKnFnbM5wF23Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3B0F107ACC7;
        Fri, 19 Feb 2021 11:58:10 +0000 (UTC)
Received: from redhat.com (ovpn-113-184.ams2.redhat.com [10.36.113.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 508F56086F;
        Fri, 19 Feb 2021 11:58:00 +0000 (UTC)
Date:   Fri, 19 Feb 2021 11:57:57 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Thomas Huth <thuth@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?utf-8?B?SGVydsOp?= Poussineau <hpoussin@reactos.org>,
        Leif Lindholm <leif@nuviainc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH 2/7] hw/boards: Introduce 'kvm_supported' field to
 MachineClass
Message-ID: <YC+nxWnB+eaiq736@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20210219114428.1936109-1-philmd@redhat.com>
 <20210219114428.1936109-3-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210219114428.1936109-3-philmd@redhat.com>
User-Agent: Mutt/2.0.5 (2021-01-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 12:44:23PM +0100, Philippe Mathieu-Daudé wrote:
> Introduce the 'kvm_supported' field to express whether
> a machine supports KVM acceleration or not.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/boards.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 68d3d10f6b0..0959aa743ee 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -129,6 +129,8 @@ typedef struct {
>   *    Return the type of KVM corresponding to the kvm-type string option or
>   *    computed based on other criteria such as the host kernel capabilities
>   *    (which can't be negative), or -1 on error.
> + * @kvm_supported:
> + *    true if '-enable-kvm' option is supported and false otherwise.

Is the behaviour reported really related to KVM specifically, as opposed
to all hardware based virt backends ?

eg is it actually a case of some machine types being  "tcg_only" ?



Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

