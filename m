Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D503F8684
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhHZLaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 07:30:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241953AbhHZLaR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 07:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629977370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RKC3j/AevBxySj6l8WQ6EwwIzbrDobzJVhame37QOV8=;
        b=CChGYU9zLnB7nnwNXWdIBzo+6pK/5DcbeFoHf6oZ2+7ZO22LHCeVB4KZLnDDaCiWMI32uj
        lZGMo/nG6AM5M0sNVcbFAXqegQnoGFF5CFuATobnJREnB/JGOvBnnrktLJPDy68GwRjusU
        6vb2sIq/FN7dZ7hJeGT4rV/P5sDIWs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-QuHF8fJMN-imAwK3qWfTTQ-1; Thu, 26 Aug 2021 07:29:29 -0400
X-MC-Unique: QuHF8fJMN-imAwK3qWfTTQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73A3F193F560;
        Thu, 26 Aug 2021 11:29:27 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01131604CC;
        Thu, 26 Aug 2021 11:29:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 44C6018003AA; Thu, 26 Aug 2021 13:29:20 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:29:20 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 21/44] i386/tdx: Create the TD HOB list upon
 machine init done
Message-ID: <20210826112920.yyisifif22uz6fek@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <f2e723916bb2875ae701510d22a8d9896ba15f51.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2e723916bb2875ae701510d22a8d9896ba15f51.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> +static void tdvf_hob_add_memory_resources(TdvfHob *hob)
> +{

> +    /* Copy and sort the e820 tables to add them to the HOB. */
> +    memcpy(e820_entries, e820_table,
> +           nr_e820_entries * sizeof(struct e820_entry));
> +    qsort(e820_entries, nr_e820_entries, sizeof(struct e820_entry),
> +          &tdvf_e820_compare);

I guess patch #19 should make sure the e820 entries stay sorted instead
of sorting them here.

take care,
  Gerd

