Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA21B1D710E
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 08:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgERGbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 02:31:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726454AbgERGbI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 02:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589783467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=6dlVEUYFcNlE9cDLgKeiDl8r+5tXmvOo+L0M06F/hsM=;
        b=AhunWRtCRwTGCocqt59NGqMM4Vj7roy3sF/73uFQHI6Uw/FPqPAZ0QK5q6jEsMi8GseQJ6
        h1ovSTyttALH7eAZ9zWlre1rfM8BmrMjud4QDLxmXdW+xxqF9YbSZj29riFcONlFlQtb++
        zWdnj+M8iJ7uKdUuAoClU2/P8Utm21I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-9uWgtAhMMym563F0t_IA6A-1; Mon, 18 May 2020 02:31:05 -0400
X-MC-Unique: 9uWgtAhMMym563F0t_IA6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FC9835B40;
        Mon, 18 May 2020 06:31:02 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D09C060BE1;
        Mon, 18 May 2020 06:30:57 +0000 (UTC)
Subject: Re: [PATCH v7 2/3] s390: keep diag 318 variables consistent with the
 rest
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200515221935.18775-1-walling@linux.ibm.com>
 <20200515221935.18775-3-walling@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6f910102-c729-6605-39f7-d22ee8b40b4c@redhat.com>
Date:   Mon, 18 May 2020 08:30:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200515221935.18775-3-walling@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/2020 00.19, Collin Walling wrote:
> Rename diag318 to diag_318 and byte_134 to fac134 in order to keep
> naming schemes consistent with other diags and the read info struct
> and make grepping easier.
> 
> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> ---
>  arch/s390/include/asm/diag.h   | 2 +-
>  arch/s390/include/asm/sclp.h   | 2 +-
>  arch/s390/kernel/setup.c       | 6 +++---
>  drivers/s390/char/sclp.h       | 2 +-
>  drivers/s390/char/sclp_early.c | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
> index ca8f85b53a90..19da822e494c 100644
> --- a/arch/s390/include/asm/diag.h
> +++ b/arch/s390/include/asm/diag.h
> @@ -295,7 +295,7 @@ struct diag26c_mac_resp {
>  } __aligned(8);
>  
>  #define CPNC_LINUX		0x4
> -union diag318_info {
> +union diag_318_info {

$ grep -r diag.*info arch/s390/include/asm/diag.h
struct diag204_info_blk_hdr {
struct diag204_x_info_blk_hdr {
struct diag204_cpu_info {
struct diag204_x_cpu_info {
	struct diag204_x_cpu_info cpus[];
union diag318_info {

... none of these seem to use an underscore between the "diag" and the
number ... so this seems unnecessary to me ... or what do I miss?

 Thomas

