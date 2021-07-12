Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453613C5A56
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbhGLJwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 05:52:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236147AbhGLJwo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 05:52:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626083396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OM/iwwVYUbe1CyDjJQ54Gx8sBHDi8QnZ+IrtfImXwD4=;
        b=JVdS+FINH8Z5qSXHsGw1gdnCKPfU02Ct+PtRKXWcsbSvoMQfimlayQN5Gac2kZK6oLjpOk
        KV0Le36lI9ZHuVAK/KeFPqe00GTUagWQjiy4NE72b9NM3mvhLas4o3WqKbtyoNWVIRaYy9
        nIJBWrwHdHQEj/eGjnuH6IOtzNUjE9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-BFOy-0--N_qociMcxZyTLg-1; Mon, 12 Jul 2021 05:49:52 -0400
X-MC-Unique: BFOy-0--N_qociMcxZyTLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D7DA802E6C;
        Mon, 12 Jul 2021 09:49:51 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C438860871;
        Mon, 12 Jul 2021 09:49:45 +0000 (UTC)
Message-ID: <d79db3d7c443f392f5a8b3cf631e5607b72b6208.camel@redhat.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     harry harry <hiharryharryharry@gmail.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Date:   Mon, 12 Jul 2021 12:49:44 +0300
In-Reply-To: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
References: <CA+-xGqNUX4dpzFV7coJSoJnPz6cE5gdPy1kzRKsQtGD371hyEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2021-07-11 at 15:13 -0500, harry harry wrote:
> Hi all,
> 
> I hope you are very well! May I know whether it is possible to enable
> two-dimensional page translation (e.g., Intel EPT) mechanisms and
> shadow page table mechanisms in Linux QEMU/KVM at the same time on a
> physical server? For example, if the physical server has 80 cores, is
> it possible to let 40 cores use Intel EPT mechanisms for page
> translation and the other 40 cores use shadow page table mechanisms?
> Thanks!

Nope sadly. EPT/NPT is enabled by a module param.

Best regards,
	Maxim Levitsky

> 
> Best,
> Harry
> 


