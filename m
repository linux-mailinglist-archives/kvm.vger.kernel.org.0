Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4868251757
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 13:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgHYLUk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 07:20:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44116 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729698AbgHYLUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 07:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598354436;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7PH/g/qmmHwC1P1FPXIiByjl600OpCg+L9T/HcoPQc=;
        b=YG4KTR4R07Mci6JppwZW+UKEWCawc7C7UTjC11yOQ5Os8mk3qANvoUgBj8JZ8n9uj7wSMX
        cG5vjX7JYCnzKfM1sxgYww0527SboongrUOd3RG0IngAvb1zn8dHmLHzgiTQZb5YEbzHyv
        V05liNyOzfAWoDLxeUzlYx482BLRlM0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-91Pbf2XBOOK899pe8pqaCA-1; Tue, 25 Aug 2020 07:20:34 -0400
X-MC-Unique: 91Pbf2XBOOK899pe8pqaCA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D121189E601;
        Tue, 25 Aug 2020 11:20:33 +0000 (UTC)
Received: from redhat.com (ovpn-114-231.ams2.redhat.com [10.36.114.231])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6074A21E79;
        Tue, 25 Aug 2020 11:20:32 +0000 (UTC)
Date:   Tue, 25 Aug 2020 12:20:29 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 41/58] kvm: Move QOM macros to kvm.h
Message-ID: <20200825112029.GH107278@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20200820001236.1284548-1-ehabkost@redhat.com>
 <20200820001236.1284548-42-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200820001236.1284548-42-ehabkost@redhat.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 19, 2020 at 08:12:19PM -0400, Eduardo Habkost wrote:
> Move QOM macros close to the KVMState typedef.
> 
> This will make future conversion to OBJECT_DECLARE* easier.
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> ---
> Changes series v1 -> v2: new patch in series v2
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: qemu-devel@nongnu.org
> ---
>  include/sysemu/kvm.h     | 6 ++++++
>  include/sysemu/kvm_int.h | 5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

