Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE825DA5D
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 15:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbgIDNsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 09:48:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730667AbgIDNrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 09:47:51 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-LxloLfnDOtyPcAbGDgm41Q-1; Fri, 04 Sep 2020 09:47:48 -0400
X-MC-Unique: LxloLfnDOtyPcAbGDgm41Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2FB98030CB;
        Fri,  4 Sep 2020 13:47:47 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53D135C1DC;
        Fri,  4 Sep 2020 13:47:46 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 05/10] lib: x86: Use portable format
 macros for uint32_t
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-6-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b950ada9-2770-bfcd-ea3d-44acc352ab6a@redhat.com>
Date:   Fri, 4 Sep 2020 15:47:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-6-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/2020 10.50, Roman Bolshakov wrote:
> Compilation of the files fails on ARCH=i386 with i686-elf gcc because
> they use "%x" or "%d" format specifier that does not match the actual
> size of uint32_t:
> 
> x86/s3.c: In function ‘main’:
> x86/s3.c:53:35: error: format ‘%x’ expects argument of type ‘unsigned int’, but argument 2 has type ‘u32’ {aka ‘long unsigned int’}
> [-Werror=format=]
>    53 |  printf("PM1a event registers at %x\n", fadt->pm1a_evt_blk);
>       |                                  ~^     ~~~~~~~~~~~~~~~~~~
>       |                                   |         |
>       |                                   |         u32 {aka long unsigned int}
>       |                                   unsigned int
>       |                                  %lx
> 
> Use PRIx32 instead of "x" and PRId32 instead of "d" to take into account
> u32_long case.
> 
> Cc: Alex Bennée <alex.bennee@linaro.org>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Cameron Esfahani <dirty@apple.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>

Radim does not work at redhat.com anymore, so please remove that line in
case you respin the patch.

> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  lib/pci.c     | 2 +-
>  x86/asyncpf.c | 2 +-
>  x86/msr.c     | 3 ++-
>  x86/s3.c      | 2 +-
>  4 files changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

