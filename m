Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD96731E64E
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 07:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBRGZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 01:25:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhBRGWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 01:22:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613629249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ceda60ZZ1y93IVVlA7dMP4wDjb0CKutJ+6zzCPmDfbA=;
        b=UEJvIPZ3SEJEZcdD2lM77InjT5qZ1ICOVplq31WvAQvTKuyIcPge2qCpzhQeQ+X5EuS6Ft
        FdGocRvp16As5BjnZa6x4QNFMwQV0k+E4lYXDJdUu/aXQChYivG5vLQMMs+wUAU0ReZjul
        +Zp434YO+Z6CckGfraXSgrffRqZEGT8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-OuKosV1MPrqO48NtqVu_1A-1; Thu, 18 Feb 2021 01:20:47 -0500
X-MC-Unique: OuKosV1MPrqO48NtqVu_1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 984C0C28A;
        Thu, 18 Feb 2021 06:20:46 +0000 (UTC)
Received: from [10.72.13.28] (ovpn-13-28.pek2.redhat.com [10.72.13.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F5645D9C2;
        Thu, 18 Feb 2021 06:20:41 +0000 (UTC)
Subject: Re: [RESEND RFC v2 1/4] KVM: add initial support for KVM_SET_IOREGION
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
References: <cover.1611850290.git.eafanasova@gmail.com>
 <de84fca7e7ad62943eb15e4e9dd598d4d0f806ef.1611850291.git.eafanasova@gmail.com>
 <a3794e77-54ec-7866-35ba-c3d8a3908aa6@redhat.com>
 <da345926a4689016296970d62d4432bb9abdc7b7.camel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <00a8ab29-1db4-f480-2a69-755bb0525387@redhat.com>
Date:   Thu, 18 Feb 2021 14:20:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <da345926a4689016296970d62d4432bb9abdc7b7.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/11 上午3:31, Elena Afanasova wrote:
>>> +	}
>> I wonder how much value if we stick a check like this here (if our
>> code
>> can gracefully deal with blocking fd).
>>
> Do you think it would be better to remove this check and just mention
> that in a comment or documentation?
>

Yes.

Thanks

