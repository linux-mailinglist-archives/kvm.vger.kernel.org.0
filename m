Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FA11C6987
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 08:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgEFG6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 02:58:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726451AbgEFG6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 02:58:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588748303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0aU0JGmjrzgfyc02yFzQlwfBVChQ4/zMwXewvJV1gk=;
        b=TAX/7Yqeh/V7EFeosF7WLWqNUkQNA+yzlHQgpDUvtF7Nmo5/pHTRs4mvdzRxAgmBTj/Ylm
        yIv2auKp73ECfkcBEdLGpVrhkAz6WekURsVsCFNOKpW/hmqk7nvM5x0o6lIvjo+mxfqbWs
        cHonYi1GNuyUQ2VWdBJa2yAPUTGsfV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-qIezzmFCMHKIsep7CI7t5A-1; Wed, 06 May 2020 02:58:22 -0400
X-MC-Unique: qIezzmFCMHKIsep7CI7t5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53EA31899520
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 06:58:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC4255C1BD;
        Wed,  6 May 2020 06:58:19 +0000 (UTC)
Date:   Wed, 6 May 2020 08:58:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] KVM: VMX: add test for NMI delivery
 during HLT
Message-ID: <20200506065816.tzl4jytqt3oxhfdq@kamzik.brq.redhat.com>
References: <20200505160512.22845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505160512.22845-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 12:05:12PM -0400, Paolo Bonzini wrote:
> From: Cathy Avery <cavery@redhat.com>
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/vmx_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)

Much of this patch is using four space indentation instead of tabs.

Thanks,
drew

