Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46682528F2
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHZIJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 04:09:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50844 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726016AbgHZIJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 04:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598429344;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLIsu+nEc3aBl1VyG4Sd867PXkn1bWp9ManfPK6FPHs=;
        b=MtiIGC5xpakt+vCLezguAyGzYKTgG7av4OunG8wUg/e/PjNs/DBIjTUGBpzt1nQlsxhCfH
        YY2A1Cddealf27+vwI8BXdsgSd2A0DezclSI9OLDwdopc9tQxVYoIHIzns42pUIrBvWxBq
        NBV8LjxCGii0vR8q/Awa8x/yR6/1mhI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-FMA81h6PMCKsGY85WJcz0A-1; Wed, 26 Aug 2020 04:09:02 -0400
X-MC-Unique: FMA81h6PMCKsGY85WJcz0A-1
Received: by mail-wm1-f72.google.com with SMTP id r14so473478wmh.1
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 01:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kLIsu+nEc3aBl1VyG4Sd867PXkn1bWp9ManfPK6FPHs=;
        b=k0eGZ4XKYBCY8/lcwP3oJaduioneyq/UKO4bAevyKQtp64kpW38QEnEWW3OMsnhEum
         OgSoTr7sa5Mt13DgNxxnmw5Mv8h78o9krxK1ORH9b+Yu7zVTD+bFImvfBwO6Pximj1zp
         004panvfNtQXN9hrp7s5/ESRIZB6ZK+ujZue8UAsHPy8aGa2nc7sqoU8qJi7X2lo861+
         nQ+cM8tJpWwL/xEqnuwl1tl445bltfzgOWxHFidWUeJOTwMVgaInz/1DmNx22Ld1v3/A
         UBAvW+DBLMTxy39CB7cevOPR+pvinVV3jlcj5GI1Gk7fiQmUJWUJOBLwbrrPJXju8yn7
         52pw==
X-Gm-Message-State: AOAM530F221DdXr+Guw3EXv4IRDI07qHdoziRmIPTuxKQXfHXDiwfH71
        7t82XtK702F0AzyxNTyYh3f4/m/AHZuOiYmVbKJvdx+c9VTFoYfN/8AEtPu5DS9gWP/vZHUIIwA
        o+CQg/uDGMtTa
X-Received: by 2002:adf:9e8d:: with SMTP id a13mr13566873wrf.94.1598429341765;
        Wed, 26 Aug 2020 01:09:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzT9BIXEipC0KHHms1/LKk2MRcW/qT6UlqJ2yHzgxQ4Cz3Ybar/ud7Phbq6goZoBDpiyvRYng==
X-Received: by 2002:adf:9e8d:: with SMTP id a13mr13566848wrf.94.1598429341511;
        Wed, 26 Aug 2020 01:09:01 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id z9sm3613141wmg.46.2020.08.26.01.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 01:09:00 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, qemu-riscv@nongnu.org
Subject: Re: [PATCH v3 66/74] [automated] Use DECLARE_*CHECKER* macros
In-Reply-To: <20200825192110.3528606-67-ehabkost@redhat.com> (Eduardo
        Habkost's message of "Tue, 25 Aug 2020 15:21:02 -0400")
References: <20200825192110.3528606-1-ehabkost@redhat.com>
        <20200825192110.3528606-67-ehabkost@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 26 Aug 2020 10:08:59 +0200
Message-ID: <87ft89ygkk.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> wrote:
>  $ ./scripts/codeconverter/converter.py -i \
>    --pattern=3DTypeCheckMacro $(git grep -l '' -- '*.[ch]')
>
> Reviewed-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> Changes v2 -> v3:
> * Removed hunks due to rebase conflicts:
>   hw/arm/integratorcp.c hw/arm/versatilepb.c hw/sd/pl181.c
>   include/hw/ppc/xive.h
> * Reviewed-by line from Daniel was kept, as no additional hunks
>   are introduced in this version

[Dropeed CC'd]

...

> diff --git a/migration/rdma.c b/migration/rdma.c
> index e3eac913bc..87cb277d05 100644
> --- a/migration/rdma.c
> +++ b/migration/rdma.c
> @@ -399,8 +399,8 @@ typedef struct RDMAContext {
>=20=20
>  #define TYPE_QIO_CHANNEL_RDMA "qio-channel-rdma"
>  typedef struct QIOChannelRDMA QIOChannelRDMA;
> -#define QIO_CHANNEL_RDMA(obj)                                     \
> -    OBJECT_CHECK(QIOChannelRDMA, (obj), TYPE_QIO_CHANNEL_RDMA)
> +DECLARE_INSTANCE_CHECKER(QIOChannelRDMA, QIO_CHANNEL_RDMA,
> +                         TYPE_QIO_CHANNEL_RDMA)
>=20=20
>=20=20
>=20=20

Reviewed-by: Juan Quintela <quintela@redhat.com>

