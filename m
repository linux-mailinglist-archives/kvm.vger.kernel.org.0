Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0F33148D7
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 07:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhBIG3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 01:29:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhBIG20 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 01:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612852020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xKrH4tNicKJIEY/gOO9tTLcui+IMvE3ZuTqim4UzCgU=;
        b=EpnwM+H2janoSpYxyUJGU+aPn52NQPIO6teosltR5E0yJL05EAZT+n9c7YfdjjDFVWyWUm
        RkR74NZNJHZCXNIWw453fwxu4QeQU5kXLRv+Sd3Vf0wNy2kQccaaWGG0UDLW7Lnsr0nDbH
        yGTKeHq8gxEOnrXJMpGUXhfaXKmaU7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-ZzXH_5vjMf2y2uc_EyKhoQ-1; Tue, 09 Feb 2021 01:26:58 -0500
X-MC-Unique: ZzXH_5vjMf2y2uc_EyKhoQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DB69393AA;
        Tue,  9 Feb 2021 06:26:57 +0000 (UTC)
Received: from [10.72.13.32] (ovpn-13-32.pek2.redhat.com [10.72.13.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615C510013D7;
        Tue,  9 Feb 2021 06:26:52 +0000 (UTC)
Subject: Re: [RFC v2 2/4] KVM: x86: add support for ioregionfd signal handling
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
References: <cover.1611850290.git.eafanasova@gmail.com>
 <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <556a2367-ef94-ee0f-f52d-219a0caa7bb0@redhat.com>
Date:   Tue, 9 Feb 2021 14:26:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aa049c6e5bade3565c5ffa820bbbb67bd5d1bf4b.1611850291.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/1/29 上午2:32, Elena Afanasova wrote:
> +/* Wire protocol */
> +struct ioregionfd_cmd {
> +	__u32 info;
> +	__u32 padding;
> +	__u64 user_data;
> +	__u64 offset;
> +	__u64 data;
> +};


So I'm still don't understand how the kernel and userspace is 
synchonrized when the fd is being used simultaneously by multiple 
devices/regions.

It might be helpful to document the protocol in api.rst.

Thanks

