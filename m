Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8A817DF3D
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 13:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgCIMAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 08:00:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50246 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725942AbgCIMAw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 08:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583755251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ae/HcGopL4IKgJ0MjwGidc1zloipall9ZQoSMymFcxU=;
        b=XoE6r0JlpXYDExlSbQKev35V4BhH6B8iQTDdtfom/HSXE/i2Kpltd0OyMnUfFl1hsqtZpl
        2W++KUUkW3dV8R5JsHTtIO4Vd5Suj3aPNKO+hwNG1Pd1WG/isq829PgOuCOMppoQjzeIAy
        J0XYotihptwS7scT+bUr0pQDLh8AaSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-eg0LmcZMMIa2ACg13u3Rfw-1; Mon, 09 Mar 2020 08:00:49 -0400
X-MC-Unique: eg0LmcZMMIa2ACg13u3Rfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A62F0107BAFA;
        Mon,  9 Mar 2020 12:00:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F83A9353C;
        Mon,  9 Mar 2020 12:00:14 +0000 (UTC)
Date:   Mon, 9 Mar 2020 13:00:12 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add ITS tests
Message-ID: <20200309120012.xkgmlbvd5trm6ewk@kamzik.brq.redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309115741.6stx5tpkb6s6ejzh@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309115741.6stx5tpkb6s6ejzh@kamzik.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 12:57:51PM +0100, Andrew Jones wrote:
> This looks pretty good to me. It just needs some resquashing cleanups.
> Does Andre plan to review? I've only been reviewing with respect to
> the framework, not ITS. If no other reviews are expected, then I'll
> queue the next version.

Oops, sorry Zenghui, I forgot to ask if you'll be reviewing again as
well.

Thanks,
drew

