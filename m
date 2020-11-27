Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF7C2C64DA
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 13:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgK0MKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 07:10:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgK0MKj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 07:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606479038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KK/GTOWoXLIXrEPOc/7kQdKJDreya4hc10nWRP8yzTE=;
        b=X43Yg0eYXBbOskWZwXKDsjWdzLOuh51tzXutmTkNih98saUIuSPNcxupBsAKJXhLOlRCTR
        TUHuZvegRdZzOsHCt4uqxceHUj0af4jufXI0oWW+Jt+ZEwka1/KekXMfFzWkB9NG5JJGqv
        U00RMmSgnW312YBv5w7HWMvb0CbIwbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-Valx_87ZP7ijgQySb4eRkQ-1; Fri, 27 Nov 2020 07:10:36 -0500
X-MC-Unique: Valx_87ZP7ijgQySb4eRkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FFB0100C602;
        Fri, 27 Nov 2020 12:10:35 +0000 (UTC)
Received: from gondolin (ovpn-113-65.ams2.redhat.com [10.36.113.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 270E85D6D1;
        Fri, 27 Nov 2020 12:10:20 +0000 (UTC)
Date:   Fri, 27 Nov 2020 13:10:03 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Markus Armbruster <armbru@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: Re: [PATCH v2 3/6] kvm: Remove kvm_available() function
Message-ID: <20201127131003.51abcb53.cohuck@redhat.com>
In-Reply-To: <20201125205636.3305257-4-ehabkost@redhat.com>
References: <20201125205636.3305257-1-ehabkost@redhat.com>
        <20201125205636.3305257-4-ehabkost@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Nov 2020 15:56:33 -0500
Eduardo Habkost <ehabkost@redhat.com> wrote:

> The only caller can use accel_available("kvm") instead.
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> Cc: Markus Armbruster <armbru@redhat.com>
> Cc: qemu-devel@nongnu.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Claudio Fontana <cfontana@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  include/sysemu/arch_init.h | 1 -
>  monitor/qmp-cmds.c         | 2 +-
>  softmmu/arch_init.c        | 9 ---------
>  3 files changed, 1 insertion(+), 11 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

