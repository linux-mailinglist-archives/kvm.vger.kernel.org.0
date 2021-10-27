Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FA543CD9C
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242808AbhJ0Pfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 11:35:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242783AbhJ0Pfh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 11:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635348791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LbTw5RdCBbk7mSqMfjlgY/jo+9kargrdnPczNL3830=;
        b=jH5zoeRNSw2lxhojSkd7ctHaDa3FyI6Flbwj0/nHVmFo2jJoS1Q3fx0YZ2a9SerNlWWa85
        eEcpCwIvd/tdH/Akk7RPeyn3LFSzC35OO4cxkxSqKozcXHb6rI5CwzjHnhokuN38WVpXFE
        YmvdxzxoKae6HwsvhL8DKacfkdW8w9A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-lo0mzr3GNhy3IegOSgZfZg-1; Wed, 27 Oct 2021 11:33:10 -0400
X-MC-Unique: lo0mzr3GNhy3IegOSgZfZg-1
Received: by mail-wm1-f70.google.com with SMTP id j38-20020a05600c1c2600b0032ccf96ea8eso1271303wms.1
        for <kvm@vger.kernel.org>; Wed, 27 Oct 2021 08:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4LbTw5RdCBbk7mSqMfjlgY/jo+9kargrdnPczNL3830=;
        b=gvx5cnRN1036E1Ril7PhrNJAfQSY/2TWPZN8q9/bzJA2PYPcV8qIx3VN1xb2lXMGPT
         QCIxKQMwB5BelGcXEZWKD/f/5JxP8NfJNQqM0rJA/HI61BqZr61I1ma5e0PTzAymJLmK
         MVk258/KFkaB84+EfAB6qcDYBdH+5M7cQvrbIr0BNL3N6/o03/9hHoMwSUHHFplMy4HJ
         0isCuSYb834btJif8vcv0x2QDU9C9YkGr1aAwCRRuXIRPIjQ8h88HzM0d/Ok+DmJVYvE
         s2vZ73J3gbS4Njy4E68oPbt2bx+ISLGaz0UubjuNO575ZJmwfa3DtMuneKA27LNujhMP
         0YQA==
X-Gm-Message-State: AOAM531QZxwwXQ+r9Cp/oJiXCuRRIf3p9PHEO9W+TN73gPZvJu2OH3eU
        Q+tItY1Uy6EcM5pTg2jhGiA1lzwDhqcu1cjrw56N9vhRekk18GkppZCd/KJGSf+o87v7a9WUFFO
        4nh7NADGc+Av9
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr36722072wrn.291.1635348789084;
        Wed, 27 Oct 2021 08:33:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpQZUP2sBX55AWGDuLgHVqCKu1ZKjs2Z/KakgNx4x2sxb1c8gCRSsxKWcnL4FHm9zGTfYvwQ==
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr36722028wrn.291.1635348788870;
        Wed, 27 Oct 2021 08:33:08 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id r1sm122264wmq.15.2021.10.27.08.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 08:33:08 -0700 (PDT)
Date:   Wed, 27 Oct 2021 11:33:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Hui Zhu <teawater@gmail.com>
Subject: Re: [PATCH v1 02/12] vhost: Return number of free memslots
Message-ID: <20211027113245-mutt-send-email-mst@kernel.org>
References: <20211027124531.57561-1-david@redhat.com>
 <20211027124531.57561-3-david@redhat.com>
 <4ce74e8f-080d-9a0d-1b5b-6f7a7203e2ab@redhat.com>
 <7f1ee7ea-0100-a7ac-4322-316ccc75d85f@redhat.com>
 <8fc703aa-a256-fdef-36a5-6faad3da47d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fc703aa-a256-fdef-36a5-6faad3da47d6@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021 at 04:11:38PM +0200, Philippe Mathieu-Daudé wrote:
> On 10/27/21 16:04, David Hildenbrand wrote:
> > On 27.10.21 15:36, Philippe Mathieu-Daudé wrote:
> >> On 10/27/21 14:45, David Hildenbrand wrote:
> >>> Let's return the number of free slots instead of only checking if there
> >>> is a free slot. Required to support memory devices that consume multiple
> >>> memslots.
> >>>
> >>> Signed-off-by: David Hildenbrand <david@redhat.com>
> >>> ---
> >>>  hw/mem/memory-device.c    | 2 +-
> >>>  hw/virtio/vhost-stub.c    | 2 +-
> >>>  hw/virtio/vhost.c         | 4 ++--
> >>>  include/hw/virtio/vhost.h | 2 +-
> >>>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> >>> -bool vhost_has_free_slot(void)
> >>> +unsigned int vhost_get_free_memslots(void)
> >>>  {
> >>>      return true;
> >>
> >>        return 0;
> > 
> > Oh wait, no. This actually has to be
> > 
> > "return ~0U;" (see real vhost_get_free_memslots())
> > 
> > ... because there is no vhost and consequently no limit applies.
> 
> Indeed.
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

confused. are you acking the theoretical patch with ~0 here?

