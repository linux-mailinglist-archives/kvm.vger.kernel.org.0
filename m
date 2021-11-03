Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E7D443D58
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhKCGn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:43:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhKCGn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 02:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635921648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Wg7WyYx3TEXNV3kr0Pv8Xc/jePLgTFfEaeeDsKCYVU=;
        b=Z7wgKF6iG4aaJWVyKIyT1kVnDWqlT3D+GXYt1rkzBEumQptLiu6KITMV0sP5Qx+kSgePn/
        ExTqWg1qnJcxc4BQ7fbKibLB9DtR9ZzDE6qCyLX5wIIc1gkCq6K4b+yl85GJwcUINNPjps
        dmwkT4Q+hTNRwKJir4M6k1p+WTgZnKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-ekgkSVzlMnuP3edBMqwO2w-1; Wed, 03 Nov 2021 02:40:45 -0400
X-MC-Unique: ekgkSVzlMnuP3edBMqwO2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CC74871805;
        Wed,  3 Nov 2021 06:40:43 +0000 (UTC)
Received: from [10.39.192.84] (unknown [10.39.192.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC85719723;
        Wed,  3 Nov 2021 06:40:32 +0000 (UTC)
Message-ID: <8af9f8ce-ae47-6be2-12e8-c197894a9109@redhat.com>
Date:   Wed, 3 Nov 2021 07:40:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 2/4] docs: (further) remove non-reference uses of
 single backticks
Content-Language: en-US
To:     John Snow <jsnow@redhat.com>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        Bandan Das <bsd@redhat.com>
References: <20211102184400.1168508-1-jsnow@redhat.com>
 <20211102184400.1168508-3-jsnow@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211102184400.1168508-3-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/11/2021 19.43, John Snow wrote:
> The series rotted already. Here's the new changes.

Please change the patch description for the final commit (looks ugly in the 
git log otherwise)

> Signed-off-by: John Snow <jsnow@redhat.com>
> ---
>   docs/system/i386/sgx.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

