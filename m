Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997C0263E4E
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgIJHPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:15:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730373AbgIJHPV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 03:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599722118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NujrVkwgQXomRFqBptCRf8I5qXyjyjT+dpDlxDqalIs=;
        b=DhUCx5sbS11FicIidga+LdQdZ+Yq/JDl8uk3YjUavRmsY7LZ1uvH+/gGzbWwaLgU4iZ8j+
        OiDo02K1dBfg7nyK/matjMkjJvSTXYbCnKm7QXh0y48QCic9E8a1xR5kL+5vwvZd0R9ZQ6
        q8q2NjkPvRI7vg1JSVkJ21sTb3jxe9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-7ObhZB0GNoSSa78vWCPA5A-1; Thu, 10 Sep 2020 03:15:14 -0400
X-MC-Unique: 7ObhZB0GNoSSa78vWCPA5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 191ECEF4EE;
        Thu, 10 Sep 2020 07:15:12 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-86.ams2.redhat.com [10.36.112.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDFEC5D9E8;
        Thu, 10 Sep 2020 07:15:03 +0000 (UTC)
Subject: Re: [PATCH 5/6] hw/pci-host/q35: Rename PCI 'black hole as '(memory)
 hole'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-trivial@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Joel Stanley <joel@jms.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200910070131.435543-1-philmd@redhat.com>
 <20200910070131.435543-6-philmd@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7dbdef90-1ca6-bf27-7084-af0c716d01d9@redhat.com>
Date:   Thu, 10 Sep 2020 09:15:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/2020 09.01, Philippe Mathieu-Daudé wrote:
> In order to use inclusive terminology, rename "blackhole"
> as "(memory)hole".

A black hole is a well-known astronomical term, which is simply named
that way since it absorbes all light. I doubt that anybody could get
upset by this term?

> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  include/hw/pci-host/q35.h |  4 ++--
>  hw/pci-host/q35.c         | 38 +++++++++++++++++++-------------------
>  tests/qtest/q35-test.c    |  2 +-
>  3 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/include/hw/pci-host/q35.h b/include/hw/pci-host/q35.h
> index 070305f83df..0fb90aca18b 100644
> --- a/include/hw/pci-host/q35.h
> +++ b/include/hw/pci-host/q35.h
> @@ -48,8 +48,8 @@ typedef struct MCHPCIState {
>      PAMMemoryRegion pam_regions[13];
>      MemoryRegion smram_region, open_high_smram;
>      MemoryRegion smram, low_smram, high_smram;
> -    MemoryRegion tseg_blackhole, tseg_window;
> -    MemoryRegion smbase_blackhole, smbase_window;
> +    MemoryRegion tseg_hole, tseg_window;
> +    MemoryRegion smbase_hole, smbase_window;

Maybe rather use smbase_memhole and tseg_memhole?

 Thomas

