Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D3B463FB7
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240473AbhK3VNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:13:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343957AbhK3VMv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 16:12:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638306570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vRB0jIIZXNaYYuntWB3mFkvxtYXPPauos8UWrZOu2Ig=;
        b=NCoeH7f4H9K6kBNL4hQfiyGw5mFhWDc6CroqQYxLjwNkiangp0HidFZx7xMATs7iQTnuyM
        WEk3IgvAkYokLQP4Xkt2G8/QrtFlarMA90+A6yHQD+BAOLXVwD/bvl6po3ic/52ZqufxBi
        pusjyu+2rJXinwp4Suxbf3ZO+HPR1bU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-521-Cy-L5SpqOxWp9ZVsNGWBlA-1; Tue, 30 Nov 2021 16:09:28 -0500
X-MC-Unique: Cy-L5SpqOxWp9ZVsNGWBlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 950E110168DB;
        Tue, 30 Nov 2021 21:09:27 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C52460C0F;
        Tue, 30 Nov 2021 21:09:25 +0000 (UTC)
Message-ID: <160133d3f2760d636414ff067dd4b44b6e311c6f.camel@redhat.com>
Subject: Re: [PATCH] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is
 disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 30 Nov 2021 23:09:24 +0200
In-Reply-To: <YaaKVYnM2hNfI4J6@google.com>
References: <20211130123746.293379-2-pbonzini@redhat.com>
         <YaaKVYnM2hNfI4J6@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-11-30 at 20:32 +0000, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Paolo Bonzini wrote:
> > There is nothing to synchronize if APICv is disabled, since neither
> > other vCPUs nor assigned devices can set PIR.ON.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

