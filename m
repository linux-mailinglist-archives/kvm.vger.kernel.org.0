Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4389C3FE18A
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 19:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344546AbhIARzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 13:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245301AbhIARzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 13:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630518855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zyS4/X7SkzfooDX+6ezhK1nPKORXUK60aBCy8z5/qUE=;
        b=FCSvDqtHr3shSjl96PxA9bB/vaW+qLyjOTqhUB1eMq2KJZoRk/KRKMz7VatD/HgXNIuf+J
        xKcYW0BTBKuaEvusV2GNAUTU6P0qMmA3LdhN+cieTjDCLQREOd084MzN3VyI6b5QHuw8s+
        qoG+7iTgQL5f/Dt5ho01cSBMrNo6H94=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-Nz6y_ZKcPS-t5FYlAF-WRg-1; Wed, 01 Sep 2021 13:54:14 -0400
X-MC-Unique: Nz6y_ZKcPS-t5FYlAF-WRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54CB4107ACCA;
        Wed,  1 Sep 2021 17:54:13 +0000 (UTC)
Received: from localhost (unknown [10.22.8.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21C072C00F;
        Wed,  1 Sep 2021 17:54:13 +0000 (UTC)
Date:   Wed, 1 Sep 2021 13:54:12 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] kvm: x86: Increase MAX_VCPUS to 710
Message-ID: <20210901175412.jmrurcgzxxjcidbi@habkost.net>
References: <20210831204535.1594297-1-ehabkost@redhat.com>
 <87sfyooh9x.fsf@vitty.brq.redhat.com>
 <20210901111326.2efecf6e@redhat.com>
 <87ilzkob6k.fsf@vitty.brq.redhat.com>
 <20210901153615.296486b5@redhat.com>
 <875yvknyrj.fsf@vitty.brq.redhat.com>
 <20210901152525.g5fnf5ketta3fjhl@habkost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210901152525.g5fnf5ketta3fjhl@habkost.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 11:25:25AM -0400, Eduardo Habkost wrote:
> 710 wasn't tested with real VMs yet due to userspace limitations
> that still need to be addressed (specifically, due to SMBIOS 2.1
> table size limits).

Oops, I mean VMs _larger_ than 710 VCPUs weren't tested.  710 was
tested with real VMs, and was the higher we could go before
hitting the SMBIOS 2.1 table size limits.

-- 
Eduardo

