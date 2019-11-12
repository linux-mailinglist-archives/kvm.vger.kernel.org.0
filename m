Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B0F978A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 18:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKLRrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 12:47:31 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726912AbfKLRrb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 12:47:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573580850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+piYLL2xW+37IWL2c870hms7QSEuPOZPZ/EY337Qqs=;
        b=GjbP4IyddgOPYRO+g6el3Y7SVZ1GgRYSefnKKjQ/5xOKOvuzv3wgi6WKTdE8Xtkfs9fWTS
        v/+NSsiWdzUo6f4x2fn6uRBaX1wTcG2Zs2Y+QOmhdIYDLOF2uQLlpUXyvloUOcwAZZ5Gob
        dyH4dLPBboA7lhS68vvqu1JJt+wk+pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-sseFrHuiP0aVOHY8p3m37g-1; Tue, 12 Nov 2019 12:47:26 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40016185557D;
        Tue, 12 Nov 2019 17:47:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-124.ams2.redhat.com [10.36.116.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DD1C60923;
        Tue, 12 Nov 2019 17:47:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: use "-Werror" in cc-option
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com
References: <20191107010844.101059-1-morbo@google.com>
 <20191107010844.101059-2-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <60caf083-5778-0ccd-a11f-613d28514a25@redhat.com>
Date:   Tue, 12 Nov 2019 18:47:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191107010844.101059-2-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: sseFrHuiP0aVOHY8p3m37g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/11/2019 02.08, Bill Wendling wrote:
> The "cc-option" macro should use "-Werror" to determine if a flag is
> supported. Otherwise the test may not return a nonzero result. Also
> conditionalize some of the warning flags which aren't supported by
> clang.
>=20
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  Makefile | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

