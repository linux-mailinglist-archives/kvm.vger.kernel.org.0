Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821F8443DD0
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhKCHtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230352AbhKCHtG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 03:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635925589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WN1L0slggmFkjzS/rilG3P2uzc1iYkWp2z1mw1/gbdU=;
        b=NhF+69Fi7VSEYUiSKn6E5vZ7Rx8NDhxwUdIZtr7tLji3uvimhrbjzLHA/CpWjsNwahEKvY
        tkc1CKoVByj3mv0fHzteTo+UWSqcKq77qhB7+ZSmKMSu3SM7663KY1nxBn23KW2dBBt1fS
        /DUW6yj32d/GOdA/3zzCeex4tcgfiuM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-K3bMiY2CMoq6ezE_IWOcbA-1; Wed, 03 Nov 2021 03:46:28 -0400
X-MC-Unique: K3bMiY2CMoq6ezE_IWOcbA-1
Received: by mail-ed1-f72.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so1668265edv.10
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 00:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WN1L0slggmFkjzS/rilG3P2uzc1iYkWp2z1mw1/gbdU=;
        b=JCzvvpDX0jCh1QaKAIknIiEB3Uk83hK7D5ykn2OYZJQy16fJtud7B0Gba0ciFvcD/i
         72lPeYi6aaF/tiH9JcjvcVT0tjTL+L21OsBJFXwh2Aatw9cwn4vbleyXKYjzOze/yKPh
         +n/TIpsnAkuKmCqMXSWtRztdFCQCZWTMcgAMYbEANVIlViA0iTNa4QmXraz21BntgGlX
         6zrDHLg6rIY+xWDKYLNmgX5EUlWs1/hExKVUHNtaw1nRS4ezx9QpDrJ7fZiMXhVXDH9l
         LCf4TEZBrWPn9wZ8tmUS/zxRCRk8RJBLIMhYdf540bq0ogKMeQ0YNib2fvq8woVZCSkS
         xQnQ==
X-Gm-Message-State: AOAM530UQeHMzF92BU/Z0MtB5um0X2yeC9jAdkN2bzGfCEExvRSCoBpq
        akKrGe2wSUyWTsDa2h00P/zndnfVmYqqWVuxxxmCrxDQQaOH+TY4Fg7/bcZ565/6rscN6dqj90F
        n94HM5qfszCqX
X-Received: by 2002:a50:9d49:: with SMTP id j9mr56876567edk.39.1635925587089;
        Wed, 03 Nov 2021 00:46:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjt0nMu3qRxd9Hx0QylwguGvq7WgRy+n/WzAxY9xsdb3uymyzSGO63zUQSRo7KS1yUeyGztA==
X-Received: by 2002:a50:9d49:: with SMTP id j9mr56876550edk.39.1635925586962;
        Wed, 03 Nov 2021 00:46:26 -0700 (PDT)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id s12sm782592edc.48.2021.11.03.00.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 00:46:26 -0700 (PDT)
Date:   Wed, 3 Nov 2021 08:46:25 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/7] s390x: virtio: CCW transport
 implementation
Message-ID: <20211103074625.4rcnwaor6sofcsdp@gator.home>
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630059440-15586-4-git-send-email-pmorel@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 12:17:16PM +0200, Pierre Morel wrote:
> This is the implementation of the virtio-ccw transport level.
> 
> We only support VIRTIO revision 0.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/virtio-ccw.c | 374 +++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/virtio-ccw.h | 111 ++++++++++++
>  lib/virtio-config.h    |  30 ++++

I'd probably just drop these config defines into lib/virtio.h.

Thanks,
drew

