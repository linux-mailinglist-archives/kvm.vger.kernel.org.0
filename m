Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58F43F86DB
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbhHZMAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:00:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242147AbhHZMAP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629979167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HPR+llgbWzAU7DPHDE6MElS8i/z920HRUiHSJg5v62w=;
        b=UdRJ5ekfBGmUBYnzlEb1RBdZM5wzcXFZCQevWtIee0itPnLiTBa6z2xf5Zp7aOSi1gXQbt
        N5nTJWp+OvnVKtsUkUQ9L8LTmaMoCPT/5gMi7VeWi3KfwpSWOXMRiHQ3WBS9UJvqmwQJEi
        +6a+2Xt236WRfeE+rVE2GmljaIIwpLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-7OSwrG8iPVGjqyllnCqo0w-1; Thu, 26 Aug 2021 07:59:26 -0400
X-MC-Unique: 7OSwrG8iPVGjqyllnCqo0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62841C73A0;
        Thu, 26 Aug 2021 11:59:24 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19A5060C0F;
        Thu, 26 Aug 2021 11:59:18 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 5347B18003AA; Thu, 26 Aug 2021 13:59:17 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:59:17 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [RFC PATCH v2 33/44] qmp: add query-tdx-capabilities query-tdx
 command
Message-ID: <20210826115917.x67c4zjxkd2vw2rz@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <f9391aea17154c05a8d51da8a15b8aec4e2d5873.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9391aea17154c05a8d51da8a15b8aec4e2d5873.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +##
> +# @TDXInfo:
> +#
> +# Information about Trust Domain Extensions (TDX) support
> +#
> +# @enabled: true if TDX is active
> +#
> +##
> +{ 'struct': 'TDXInfo',
> +    'data': { 'enabled': 'bool' },
> +  'if': 'defined(TARGET_I386)'
> +}

I think a generic 'ConfidentialComputing' enum with 'none', 'sev' and
'tdx' would be better.

Hmm, I see sev already has a collection of sev-specific commands, so not
sure whenever going that route now buys us much though ...

take care,
  Gerd

