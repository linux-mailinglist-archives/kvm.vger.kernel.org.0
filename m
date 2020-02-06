Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C5015486C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgBFPrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:47:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727484AbgBFPrf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 10:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581004054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5o7VzK3YB2cNDyLSCiswlw0M+bsMwT1Ow82wmetAgA=;
        b=Cjq76PXDMV7r8uYCg3JVCyUJgDq2DXNpakX0Um/UL7PLT04S/rvoTZwRHoQO2HRo613Knt
        1x6Uccau736Vn8l2qTmR9mUX8aAgYrms3kuI5To9TijfL/EVu57/PucfflPlWAbCVMIBJo
        ClVMavMCdKGUnaysA/wyIR7Giz9dwII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-YMY6GAxdN8Cgz_voIOvalw-1; Thu, 06 Feb 2020 10:47:30 -0500
X-MC-Unique: YMY6GAxdN8Cgz_voIOvalw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6368996F85;
        Thu,  6 Feb 2020 15:47:29 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2587B1001B05;
        Thu,  6 Feb 2020 15:47:28 +0000 (UTC)
Date:   Thu, 6 Feb 2020 16:47:25 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 12/27] docs: kvm: convert devices/vcpu.txt to ReST
Message-ID: <20200206164725.4a7914bc.cohuck@redhat.com>
In-Reply-To: <011ccabd61ce299e638a9545adf7f59eead15131.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <011ccabd61ce299e638a9545adf7f59eead15131.1581000481.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 15:50:09 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> - Use title markups;
> - adjust indentation and add blank lines as needed;
> - adjust tables to match ReST accepted formats;
> - use :field: markups;
> - mark code blocks as such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/devices/index.rst |   1 +
>  Documentation/virt/kvm/devices/vcpu.rst  | 114 +++++++++++++++++++++++
>  Documentation/virt/kvm/devices/vcpu.txt  |  76 ---------------
>  3 files changed, 115 insertions(+), 76 deletions(-)
>  create mode 100644 Documentation/virt/kvm/devices/vcpu.rst
>  delete mode 100644 Documentation/virt/kvm/devices/vcpu.txt

Forgot to do a git mv? Makes this a tad hard to review.

(...)

> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> new file mode 100644
> index 000000000000..e4e41b7fcac3
> --- /dev/null
> +++ b/Documentation/virt/kvm/devices/vcpu.rst

(...)

> +2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
> +=================================
> +
> +:Architectures: ARM,ARM64

As you're touching this anyway, add a blank before 'ARM64'?

