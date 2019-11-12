Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61A3F8C42
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 10:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfKLJx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 04:53:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725874AbfKLJx6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 04:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573552437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YzcNNJV58iTqOgBH01rAy5fPMf6GrV7WtuvKO0JeSew=;
        b=KS6xtWpcUF5MRep6mf7IgG2h2i32a5IQ3OZdPGbGZYqthe7vF9f/yx7BEwmAHOp2Tzy/Bi
        AKr6+g3zEXk5eNjJEBQc5vIG0kGe1RAluC3JCIRxJQirDjNSLN1KIZfhjxWwcghP12ylCG
        G/MMpLVDzdkfJVY1NR5w0acgcv7q7/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-4sMOUtnMPcuzs1WY-D1Pzw-1; Tue, 12 Nov 2019 04:53:55 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E412F800C72;
        Tue, 12 Nov 2019 09:53:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 075295C1C3;
        Tue, 12 Nov 2019 09:53:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Load reset psw on diag308
 reset
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20191111153345.22505-1-frankja@linux.ibm.com>
 <20191111153345.22505-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <32a85325-26d7-71b1-7ade-9e1cc0c5938d@redhat.com>
Date:   Tue, 12 Nov 2019 10:53:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191111153345.22505-4-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 4sMOUtnMPcuzs1WY-D1Pzw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/2019 16.33, Janosch Frank wrote:
> On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
> without DAT. Also we need to set the short psw indication to be
> compliant with the architecture.
>=20
> Let's therefore define a reset PSW mask with 64 bit addressing and
> short PSW indication that is compliant with architecture and use it.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm-offsets.c  |  1 +
>  lib/s390x/asm/arch_def.h |  3 ++-
>  s390x/cstart64.S         | 24 +++++++++++++++++-------
>  3 files changed, 20 insertions(+), 8 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

