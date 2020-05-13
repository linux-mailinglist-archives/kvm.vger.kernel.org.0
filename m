Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FC61D180D
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389099AbgEMO5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 10:57:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50661 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389006AbgEMO5K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 10:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589381829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Gcyr4Q2r+L7Nwy06uTjGsKakZaGPIrQfNerepT0yZXk=;
        b=YQZPpWbeaOKVmBPg76Q7VA6vsWXPe+OYAYfMiqow3sb/GOEgsHIdn9aukimm5wbxKZNCsa
        zSO3DcfIiDfHsL2qckKErKOGA+CIy8nZTtSLEk3l0mNuhCxTdwq3YFI7N351DueJHaxFCs
        54RrN4z/9i9m6kBYHXHHFA41+x0jQBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-lfhPsMltOLCYmL49wbzAIg-1; Wed, 13 May 2020 10:57:07 -0400
X-MC-Unique: lfhPsMltOLCYmL49wbzAIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A254F19200C0
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 14:57:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-227.ams2.redhat.com [10.36.114.227])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C8E2648DB;
        Wed, 13 May 2020 14:57:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] x86/access: Fix phys-bits parameter
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com
References: <20200513142341.774831-1-mgamal@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d75cf897-194f-f95e-c73d-bac90ca31004@redhat.com>
Date:   Wed, 13 May 2020 16:57:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200513142341.774831-1-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2020 16.23, Mohammed Gamal wrote:
> Some QEMU versions don't support setting phys-bits argument directly.
> This causes breakage to Travis CI. Work around the bug by setting
> host-phys-bits=on
> 
> Fixes: 1a296ac170f ("x86: access: Add tests for reserved bits of guest physical address")
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index bf0d02e..d43cac2 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -116,7 +116,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
>  [access]
>  file = access.flat
>  arch = x86_64
> -extra_params = -cpu host,phys-bits=36
> +extra_params = -cpu host,host-phys-bits=on,phys-bits=36
>  
>  [smap]
>  file = smap.flat
> 

Tested-by: Thomas Huth <thuth@redhat.com>

