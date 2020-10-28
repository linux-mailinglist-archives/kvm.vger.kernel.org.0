Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD9F29DC52
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 01:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388517AbgJ2AYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 20:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50248 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgJ2AYM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 20:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603931050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arnxCOyMeskaT3QbJhB6l4HlxQ9o/QM2oZKbCmekm8s=;
        b=F9zOQ+I0jnRoub3dadqGLatIq2RbF8C0OysqkAHIrfCjyBMwBCucnTmTuQjq34rIKyHUFH
        0WD4yoL+OaE7DExmRTM/+YGPXhRSLwDSIL/D1Qahh1NH6QL4hqbyoHfn36ku+qswMImA6y
        7dN9GhGk6W0WKzXy2fW/JAsNdLApaVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-NBVW9pcoMfWX4BAZPd5UuA-1; Wed, 28 Oct 2020 04:20:15 -0400
X-MC-Unique: NBVW9pcoMfWX4BAZPd5UuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE99410199AB;
        Wed, 28 Oct 2020 08:20:13 +0000 (UTC)
Received: from gondolin (ovpn-113-192.ams2.redhat.com [10.36.113.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CA816EF5E;
        Wed, 28 Oct 2020 08:20:10 +0000 (UTC)
Date:   Wed, 28 Oct 2020 09:20:08 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     AlexChen <alex.chen@huawei.com>, chenhc@lemote.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-s390x@nongnu.org,
        zhengchuan@huawei.com, zhang.zhanghailiang@huawei.com
Subject: Re: [PATCH 0/4] kvm: Add a --enable-debug-kvm option to configure
Message-ID: <20201028092008.5a5397fc.cohuck@redhat.com>
In-Reply-To: <404f58a5-180d-f3d7-dbcc-b533a29e6a94@redhat.com>
References: <5F97FD61.4060804@huawei.com>
        <5F991998.2020108@huawei.com>
        <404f58a5-180d-f3d7-dbcc-b533a29e6a94@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Oct 2020 08:44:59 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 28/10/20 08:11, AlexChen wrote:
> > The current 'DEBUG_KVM' macro is defined in many files, and turning on
> > the debug switch requires code modification, which is very inconvenient,
> > so this series add an option to configure to support the definition of
> > the 'DEBUG_KVM' macro.
> > In addition, patches 3 and 4 also make printf always compile in debug output
> > which will prevent bitrot of the format strings by referring to the
> > commit(08564ecd: s390x/kvm: make printf always compile in debug output).  
> 
> Mostly we should use tracepoints, but the usefulness of these printf
> statements is often limited (except for s390 that maybe could make them
> unconditional error_reports).  I would leave this as is, maintainers can
> decide which tracepoints they like to have.

Looking at the s390 statements, they look more like something to put
into trace events (the "unimplemented instruction" cases are handled
gracefully, but the information might be interesting when developing.)

