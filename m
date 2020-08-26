Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E872528C2
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 10:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHZICX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 04:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbgHZICW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Aug 2020 04:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598428940;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+cLFL8yEdkBH3yow4+6ZbZvxrDo8zepFhkkyNnP2kg=;
        b=OHWxYkgpnOlWnkFU6hQHGgVupgCOdosoESlZJwPML1de7TO7ZCnktXNqebtSH2iXKdhv9W
        BkNOTF0Szc3C4C3/JYdLKpETxG1bn10AHegN8xBzGlcTzi4GB3M5m1n2q1C1TkHvJG1Irq
        RDBNib9GYSTIj8djCrCGtYIZ3gtyH8E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-WAY9MylIMe6iuvDJuap5mA-1; Wed, 26 Aug 2020 04:02:19 -0400
X-MC-Unique: WAY9MylIMe6iuvDJuap5mA-1
Received: by mail-wm1-f72.google.com with SMTP id z25so462509wmk.4
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 01:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+cLFL8yEdkBH3yow4+6ZbZvxrDo8zepFhkkyNnP2kg=;
        b=n7Iq/Vi4i89yzZv2UaFajWJQpt9OoCMcwgHzdxwUN2aJo+ljvC4/P/6SIqKXN+tbmv
         YQnpprMX+VAET9LSbCcHwAdk92X/tRrnNx+ZiL3R7b7Ls2r5yNXakKCFhPjQrrVBrfMn
         ml6ddRIRCTgK7yYBXLFzV0e0ZnrLDIv7bfE1ee92MKOomR9g13LAHiQE3QwkKPXGkxhV
         jephNMqGAdFxhKvgwCRhg3a1PaTbvvwu5GQM/3F2m/+LSgls3tjgKZtGXUs47/ucGnrT
         mrCgI2F+rPHmpgw1k3dpScAXdo7zPwONhgq7LgE7nlOh7b62xR07DDbu1fO+9Bcndfxf
         BmMQ==
X-Gm-Message-State: AOAM533xUVz8PxMv+kzVtCx0KEKI4T4jnFamhRJj4MyGUWlazkBH0le/
        3O2m4eNFm9DTCpoS4R0HFTcOL9rJ/24o4o0Aifis/mwtx4rx45393kOBze4mSLQC9IYyTN1vHZG
        vLpwzFuJSUCW5
X-Received: by 2002:adf:b1cf:: with SMTP id r15mr15309316wra.118.1598428937431;
        Wed, 26 Aug 2020 01:02:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTUhdcIpNRU3VUvS4tp1AIY+Oz9N9C9qsavDdUBCjRbYqMLCYnQmaNkxYRTh7m6m1+LgttHA==
X-Received: by 2002:adf:b1cf:: with SMTP id r15mr15309298wra.118.1598428937244;
        Wed, 26 Aug 2020 01:02:17 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id o2sm3715968wrj.21.2020.08.26.01.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 01:02:16 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
        qemu-arm@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, haxm-team@intel.com
Subject: Re: [PATCH v3 62/74] [automated] Use TYPE_INFO macro
In-Reply-To: <20200825192110.3528606-63-ehabkost@redhat.com> (Eduardo
        Habkost's message of "Tue, 25 Aug 2020 15:20:58 -0400")
References: <20200825192110.3528606-1-ehabkost@redhat.com>
        <20200825192110.3528606-63-ehabkost@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 26 Aug 2020 10:02:15 +0200
Message-ID: <87y2m1ygvs.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eduardo Habkost <ehabkost@redhat.com> wrote:
> Generated using:
>   $ ./scripts/codeconverter/converter.py -i --passes=3D2 \
>     --pattern=3DTypeRegisterCall,TypeInitMacro $(git grep -l TypeInfo -- =
'*.[ch]')
>
> One notable difference is that files declaring multiple types
> will now have multiple separate __construtor__ functions
> declared, instead of one for all types.
>
> Reviewed-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> Changes v2 -> v3:
> * Removed hunks due to rebase conflicts:
>   hw/sd/milkymist-memcard.c hw/sd/pl181.c
> * Reviewed-by line from Daniel was kept, as no additional hunks
>   are introduced in this version
>
> Changes v1 -> v2:
> * Add note about multiple constructor functions to commit message
>   (suggested by Daniel)
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>

[ I removed CC'd people, -ETOOMANYRECIPIENTS]

....

> diff --git a/migration/migration.c b/migration/migration.c
> index dbd4afa1e8..561e2ae697 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -3844,10 +3844,6 @@ static const TypeInfo migration_type =3D {
>      .instance_init =3D migration_instance_init,
>      .instance_finalize =3D migration_instance_finalize,
>  };
> +TYPE_INFO(migration_type)
>=20=20
> -static void register_migration_types(void)
> -{
> -    type_register_static(&migration_type);
> -}
>=20=20
> -type_init(register_migration_types);
> diff --git a/migration/rdma.c b/migration/rdma.c
> index bea6532813..15ad985d26 100644
> --- a/migration/rdma.c
> +++ b/migration/rdma.c
> @@ -3942,13 +3942,9 @@ static const TypeInfo qio_channel_rdma_info =3D {
>      .instance_finalize =3D qio_channel_rdma_finalize,
>      .class_init =3D qio_channel_rdma_class_init,
>  };
> +TYPE_INFO(qio_channel_rdma_info)
>=20=20
> -static void qio_channel_rdma_register_types(void)
> -{
> -    type_register_static(&qio_channel_rdma_info);
> -}
>=20=20
> -type_init(qio_channel_rdma_register_types);
>=20=20
>  static QEMUFile *qemu_fopen_rdma(RDMAContext *rdma, const char *mode)
>  {

For the migration bits.

Reviewed-by: Juan Quintela <quintela@redhat.com>

