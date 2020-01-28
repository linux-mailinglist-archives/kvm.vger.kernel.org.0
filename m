Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF2C14BF5F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgA1SPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:15:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726764AbgA1SPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 13:15:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580235337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ow40xfj0DvRfnkU93Ub6Sc1HeT0s3VDR8qYKBGYD1/4=;
        b=dWtUIegVeY+zafSNAgpZG8Y7O8XBfV/dzZa+JEo5p3IQ7pnF9x48nMWgIgLIKW8exjGP0k
        8/SS6jxSXL8HkXzMaKIFTOkaXxtN1DVXWX6Qeyx5hrnZ8VPt2+jhTF1Ejo9BpGB+OgL7c/
        S/9wZmMNXQjYEimDDaWPaOj9ZTLb7Do=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-SqVLrFxGOwOhvOb0NkwXTQ-1; Tue, 28 Jan 2020 13:15:34 -0500
X-MC-Unique: SqVLrFxGOwOhvOb0NkwXTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5206418C43C0;
        Tue, 28 Jan 2020 18:15:33 +0000 (UTC)
Received: from gondolin (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF14560BE0;
        Tue, 28 Jan 2020 18:15:31 +0000 (UTC)
Date:   Tue, 28 Jan 2020 19:15:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 25/27] docs: kvm: Convert s390-diag.txt to ReST format
Message-ID: <20200128191529.748befed.cohuck@redhat.com>
In-Reply-To: <614882a25b34203f6e1de2982b2d619bf1cfddc1.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
        <614882a25b34203f6e1de2982b2d619bf1cfddc1.1580219586.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jan 2020 14:58:21 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> This file is almost in ReST format. Just one change was
> needed:
> 
>     - Add markups for a literal block and change its indentation.
> 
> While here, use the standard markup for the document title.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/index.rst                      |  1 +
>  .../virt/kvm/{s390-diag.txt => s390-diag.rst}         | 11 ++++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
>  rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (91%)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

