Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566273F86B3
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242311AbhHZLvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 07:51:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242114AbhHZLvE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 07:51:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629978616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6f+SFpkHjRPtkesxRZFEuliH8AuQ4OkeQD6uS5L8N9M=;
        b=Vyp9dVlA3cjIrIMrKrvVXq7K2qItvMMvMLY7YmfaI0HBsb/yWl8mBXx4zewa++R4XWRrbN
        7+7xtzv8Q7CKDTc/HxthgJvZFPFK5L8vuv7R/aBYwXOEi66TCAs0JH3P/rQBXZOWJWnmXc
        pgMgY77REFpG9rdLw7B/Jw+Mh9NYgIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-EyeuOODBNGmRSevJcsn_dw-1; Thu, 26 Aug 2021 07:50:12 -0400
X-MC-Unique: EyeuOODBNGmRSevJcsn_dw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B96A94DD4;
        Thu, 26 Aug 2021 11:50:11 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B337E60871;
        Thu, 26 Aug 2021 11:50:07 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 14A4918003AA; Thu, 26 Aug 2021 13:50:06 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:50:06 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 29/44] target/i386: Add machine option to disable
 PIC/8259
Message-ID: <20210826115006.vjmtdubyac5mppou@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <ebe4743d02448808fb0fe9816d474dad697e7794.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebe4743d02448808fb0fe9816d474dad697e7794.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> +    object_class_property_add_bool(oc, PC_MACHINE_PIC,
> +        pc_machine_get_pic, pc_machine_set_pic);

microvm already has such an option.  We should move it from microvm to
the common x86 base type so pc can use it too.

>  #define PC_MACHINE_PIT              "pit"
> +#define PC_MACHINE_PIC              "pic"

Oh, same for pit.  Instead of both pc and microvm having that it
likewise should be a property of the common x86 base machine type.

take care,
  Gerd

