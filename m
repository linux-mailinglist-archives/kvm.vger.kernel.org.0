Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595282B7A8D
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 10:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKRJoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 04:44:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgKRJoI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 04:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605692647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fA/uv3Hjdrhk3aKUn3WiWky/i0MM2N25wbeh6kn1W6k=;
        b=WphL82WgH3JPXCC8wEGbyMj2fFKIijK6EpVx9xeCRg4yyztmgTu3OXFxeuMYfVX0vY4zsG
        2OjT8A+ZFwVB3H48MhoWh4871NzyA7WhE447AavWS+ZXup998VIvxCocshxAV0/7FlBrRv
        5Q4sxiQwTu+Ux0YNPdZPw2bmuFW4v2g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-k-yLt3x_PIWzxv7BhMIZSg-1; Wed, 18 Nov 2020 04:44:06 -0500
X-MC-Unique: k-yLt3x_PIWzxv7BhMIZSg-1
Received: by mail-ej1-f71.google.com with SMTP id yc22so624804ejb.20
        for <kvm@vger.kernel.org>; Wed, 18 Nov 2020 01:44:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=fA/uv3Hjdrhk3aKUn3WiWky/i0MM2N25wbeh6kn1W6k=;
        b=A2muimz+D9vFgNWs61lW0GLTED34ZCGgk6IgGKuvP2o+PQUvNeR5X50LtvqONCyM9r
         IQ7Fc+MPY3sO9UJbJaCqN9Fg2DYwGmNaDKHKiqW6pMSfdh1QQDesPs7tReY4TxFeVCQw
         H3ElVmO/6a4icaZLtjWdmppN7btAbssd9Klzu8InSUHh4i+2EJCKqsOygbUPQ1oQ2DWt
         0JB8/efuvZL8vLpgrDgVPTS6tY5kykW73DnJMbXdqenGmW2zHF5pjWVhX7cuiAp6PyDM
         Hbh0IQFZseggcJPk2ZLsO8hjK8ONQeFhoPac8YrPHaWFn8c1XW9nqZOQglIKYEqGfHaq
         1PUg==
X-Gm-Message-State: AOAM531oqQ309aKlwauNGlySHTh1NQS2boQBAbZvE9IlTvola0J5ul0e
        4J3hSFHTJVfpWUVhYDc4jTX3cz8MxmrWRkysFIqkSBCnaRTbsMbCxkMcqbsn5yrez7eHQErV9B4
        gj2E7OpnQdUnu
X-Received: by 2002:a17:906:9414:: with SMTP id q20mr22568370ejx.384.1605692644808;
        Wed, 18 Nov 2020 01:44:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsKmdm8z4SXFCte0XVnGK04atGnk0hBmcHgofht9Or/GmvOwqRxdiucWLIs0Q/c7jz1wMbIA==
X-Received: by 2002:a17:906:9414:: with SMTP id q20mr22568362ejx.384.1605692644631;
        Wed, 18 Nov 2020 01:44:04 -0800 (PST)
Received: from ?IPv6:2a01:598:928b:d943:5d4a:f70f:928e:3bc9? ([2a01:598:928b:d943:5d4a:f70f:928e:3bc9])
        by smtp.gmail.com with ESMTPSA id e21sm12900276edr.51.2020.11.18.01.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 01:44:03 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 0/2] Fix and MAINTAINER update for 5.10
Date:   Wed, 18 Nov 2020 10:43:58 +0100
Message-Id: <B53D943E-050D-45BD-9847-B8D712577442@redhat.com>
References: <20201118093942.457191-1-borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
In-Reply-To: <20201118093942.457191-1-borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
X-Mailer: iPhone Mail (18A8395)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> Am 18.11.2020 um 10:39 schrieb Christian Borntraeger <borntraeger@de.ibm.c=
om>:
>=20
> =EF=BB=BFConny, David,
>=20
> your chance for quick feedback. I plan to send a pull request for kvm
> master soon.
>=20

LGTM

> I have agreed with Heiko to carry this via the KVM tree as
> this is KVM s390 specific.
>=20
> Christian Borntraeger (2):
>  s390/uv: handle destroy page legacy interface
>  MAINTAINERS: add uv.c also to KVM/s390
>=20
> MAINTAINERS           | 1 +
> arch/s390/kernel/uv.c | 9 ++++++++-
> 2 files changed, 9 insertions(+), 1 deletion(-)
>=20
> --=20
> 2.28.0
>=20

